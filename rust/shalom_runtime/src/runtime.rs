use std::collections::{HashMap, HashSet};
use std::path::PathBuf;
use std::pin::Pin;
use std::sync::atomic::{AtomicBool, Ordering};
use std::sync::Arc;
use std::time::Duration;

use parking_lot::Mutex;
use serde_json::{Map, Value};
use tokio::sync::mpsc;
use tokio_stream::Stream;
use tokio_stream::wrappers::UnboundedReceiverStream;

use shalom_core::context::SharedShalomGlobalContext;
use shalom_core::entrypoint::{parse_document, parse_schema, register_fragments_from_document};
use shalom_core::operation::context::SharedOpCtx;
use shalom_core::operation::fragments::SharedFragmentContext;
use shalom_core::shalom_config::ShalomConfig;

use crate::cache::NormalizedCache;
use crate::execution::ExecutionEngine;
use crate::gc::{SubscriptionTracker, collect_garbage};
use crate::normalization::NormalizationResult;
use crate::read::CacheReader;

// ---------------------------------------------------------------------------
// Public types
// ---------------------------------------------------------------------------

#[derive(Debug, Clone, Default, serde::Serialize, serde::Deserialize)]
pub struct RuntimeConfig;

#[derive(Debug, Clone, serde::Serialize, serde::Deserialize)]
pub struct RuntimeResponse {
    pub data: Value,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub operation_id: Option<String>,
}

/// An observed reference — identifies a fragment subscription by fragment name
/// and cache anchor (e.g. `"User:1"`).
#[derive(Debug, Clone)]
pub struct ObservedRef {
    pub observable_id: String,
    pub anchor: String,
}

pub type RuntimeResponseStream =
    Pin<Box<dyn Stream<Item = anyhow::Result<RuntimeResponse>> + Send>>;

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub struct SubscriptionId(u64);

impl From<u64> for SubscriptionId {
    fn from(value: u64) -> Self { Self(value) }
}

impl From<SubscriptionId> for u64 {
    fn from(value: SubscriptionId) -> Self { value.0 }
}

// ---------------------------------------------------------------------------
// Internal subscription state
// ---------------------------------------------------------------------------

struct SubscriptionState {
    target: SubscriptionTarget,
    variables: Option<Map<String, Value>>,
    keys: HashSet<String>,
    sender: mpsc::UnboundedSender<anyhow::Result<RuntimeResponse>>,
    receiver: Option<mpsc::UnboundedReceiver<anyhow::Result<RuntimeResponse>>>,
}

#[derive(Clone)]
pub(crate) enum SubscriptionTarget {
    Operation(SharedOpCtx),
    Fragment {
        fragment: SharedFragmentContext,
        anchor: String,
    },
}

#[derive(Default)]
struct SubscriptionManager {
    next_id: u64,
    subscriptions: HashMap<SubscriptionId, SubscriptionState>,
}

// ---------------------------------------------------------------------------
// ShalomRuntime
// ---------------------------------------------------------------------------

#[derive(Clone)]
pub struct ShalomRuntime {
    engine: ExecutionEngine,
    subscriptions: Arc<Mutex<SubscriptionManager>>,
    subscription_tracker: Arc<Mutex<SubscriptionTracker>>,
    /// Variables remembered for each named operation (used to re-read on cache update).
    operation_vars: Arc<Mutex<HashMap<String, Map<String, Value>>>>,
    /// Set to true when the runtime should stop background tasks.
    shutdown: Arc<AtomicBool>,
}

impl Drop for ShalomRuntime {
    fn drop(&mut self) {
        // Only signal shutdown when this is the last clone keeping the
        // shutdown flag alive (strong count reaches 1 = only the Arc itself).
        if Arc::strong_count(&self.shutdown) == 1 {
            self.shutdown.store(true, Ordering::Relaxed);
        }
    }
}

impl ShalomRuntime {
    pub fn new(global_ctx: SharedShalomGlobalContext) -> Self {
        let cache = Arc::new(Mutex::new(NormalizedCache::new()));
        Self::with_cache(global_ctx, cache)
    }

    pub fn init(
        schema_sdl: &str,
        fragments: Vec<String>,
        _config: RuntimeConfig,
    ) -> anyhow::Result<Self> {
        let schema_ctx = parse_schema(schema_sdl)?;
        let config = ShalomConfig::default();
        let global_ctx = shalom_core::context::ShalomGlobalContext::new(
            schema_ctx,
            config,
            PathBuf::from("schema.graphql"),
        );

        for (idx, fragment) in fragments.into_iter().enumerate() {
            let path = PathBuf::from(format!("fragment_{idx}.graphql"));
            register_fragments_ignoring_duplicates(&global_ctx, &fragment, &path)?;
        }

        let runtime = Self::new(global_ctx);

        // Background GC sweep every 2 seconds.
        let runtime_gc = runtime.clone();
        tokio::spawn(async move {
            let mut interval = tokio::time::interval(Duration::from_secs(2));
            loop {
                interval.tick().await;
                if runtime_gc.shutdown.load(Ordering::Relaxed) {
                    break;
                }
                runtime_gc.collect_garbage();
            }
        });

        Ok(runtime)
    }

    pub fn with_cache(
        global_ctx: SharedShalomGlobalContext,
        cache: Arc<Mutex<NormalizedCache>>,
    ) -> Self {
        let engine = ExecutionEngine::new(global_ctx, cache);
        Self {
            engine,
            subscriptions: Arc::new(Mutex::new(SubscriptionManager::default())),
            subscription_tracker: Arc::new(Mutex::new(SubscriptionTracker::new())),
            operation_vars: Arc::new(Mutex::new(HashMap::new())),
            shutdown: Arc::new(AtomicBool::new(false)),
        }
    }

    pub fn cache(&self) -> Arc<Mutex<NormalizedCache>> {
        self.engine.cache()
    }

    // -----------------------------------------------------------------------
    // Registration
    // -----------------------------------------------------------------------

    /// Pre-register an operation SDL by name. Must be called before `request`.
    pub fn register_operation(&self, document: &str) -> anyhow::Result<SharedOpCtx> {
        let path = PathBuf::from("registered.graphql");
        register_fragments_ignoring_duplicates(&self.engine.global_ctx(), document, &path)?;
        let operations = parse_document(&self.engine.global_ctx(), document, &path)?;
        if operations.is_empty() {
            return Err(anyhow::anyhow!("no operations found in document"));
        }
        let mut result = None;
        for (name, op_ctx) in &operations {
            if !self.engine.global_ctx().operation_exists(name) {
                self.engine.global_ctx().register_operations(
                    std::iter::once((name.clone(), op_ctx.clone())).collect(),
                );
            }
            result = Some(op_ctx.clone());
        }
        result.ok_or_else(|| anyhow::anyhow!("no operations registered"))
    }

    /// Pre-register a fragment SDL by name. Must be called before `observe_fragment`.
    pub fn register_fragment(&self, document: &str) -> anyhow::Result<()> {
        let path = PathBuf::from("registered_fragment.graphql");
        register_fragments_ignoring_duplicates(&self.engine.global_ctx(), document, &path)
    }

    // -----------------------------------------------------------------------
    // Subscriptions — V2 API
    // -----------------------------------------------------------------------

    /// Create a cache subscription for a pre-registered operation and return
    /// its ID. The caller (FRB layer) is responsible for also triggering the
    /// network request via the host link.
    pub fn create_operation_subscription(
        &self,
        op_ctx: SharedOpCtx,
        variables: Option<Map<String, Value>>,
    ) -> SubscriptionId {
        self.remember_operation_vars(&op_ctx, variables.as_ref());
        let refs = self
            .read_result_op(&op_ctx, variables.as_ref())
            .map(|r| r.used_refs)
            .unwrap_or_default();
        self.subscribe_with_target(SubscriptionTarget::Operation(op_ctx), variables, refs)
    }

    /// Create a cache subscription for a pre-registered fragment at a specific
    /// cache anchor. Emits the current cached value immediately if available.
    pub fn observe_fragment(&self, observed_ref: ObservedRef) -> anyhow::Result<SubscriptionId> {
        let fragment = self
            .engine
            .global_ctx()
            .get_fragment(&observed_ref.observable_id)
            .ok_or_else(|| {
                anyhow::anyhow!("fragment '{}' not found", observed_ref.observable_id)
            })?;

        let anchor = observed_ref.anchor.clone();
        let refs = self
            .read_result_fragment(&fragment, &anchor)
            .map(|r| r.used_refs)
            .unwrap_or_default();

        let sub_id = self.subscribe_with_target(
            SubscriptionTarget::Fragment {
                fragment: fragment.clone(),
                anchor: anchor.clone(),
            },
            None,
            refs,
        );

        // Emit current cached value immediately if the cache already has data.
        if let Ok(response) = self.read_fragment_from_cache(&fragment, &anchor) {
            let manager = self.subscriptions.lock();
            if let Some(state) = manager.subscriptions.get(&sub_id) {
                let _ = state.sender.send(Ok(response));
            }
        }

        Ok(sub_id)
    }

    /// Rebind an existing fragment subscription to a new `ObservedRef`.
    ///
    /// - Same `observable_id`: fast anchor swap — increments new refs before
    ///   decrementing old ones (no zero-refcount window), then pushes current
    ///   cached value. Returns the SAME subscription ID so the stream stays alive.
    /// - Different `observable_id`: full teardown + new subscription. Returns a
    ///   NEW subscription ID; the Dart side must reconnect `listenSubscription`.
    pub fn rebind_subscription(
        &self,
        id: SubscriptionId,
        new_ref: ObservedRef,
    ) -> anyhow::Result<SubscriptionId> {
        // Snapshot current subscription info under the lock.
        let (old_observable_id, _old_anchor, old_keys) = {
            let manager = self.subscriptions.lock();
            let state = manager
                .subscriptions
                .get(&id)
                .ok_or_else(|| anyhow::anyhow!("subscription {id:?} not found"))?;
            match &state.target {
                SubscriptionTarget::Fragment { fragment, anchor } => (
                    fragment.get_fragment_name().to_string(),
                    anchor.clone(),
                    state.keys.clone(),
                ),
                SubscriptionTarget::Operation(_) => {
                    return Err(anyhow::anyhow!(
                        "rebind_subscription is only valid for fragment subscriptions"
                    ));
                }
            }
        };

        if old_observable_id == new_ref.observable_id {
            // ---- Fast path: same fragment shape, only the anchor changes ----

            let fragment = self
                .engine
                .global_ctx()
                .get_fragment(&new_ref.observable_id)
                .ok_or_else(|| {
                    anyhow::anyhow!("fragment '{}' not found", new_ref.observable_id)
                })?;
            let new_anchor = new_ref.anchor.clone();

            let new_keys = self
                .read_result_fragment(&fragment, &new_anchor)
                .map(|r| r.used_refs)
                .unwrap_or_default();

            // 1. Increment new refs FIRST — no zero-window for shared keys.
            self.subscription_tracker.lock().subscribe(new_keys.clone());

            // 2. Swap the subscription state.
            let sender = {
                let mut manager = self.subscriptions.lock();
                match manager.subscriptions.get_mut(&id) {
                    Some(state) => {
                        state.target = SubscriptionTarget::Fragment {
                            fragment: fragment.clone(),
                            anchor: new_anchor.clone(),
                        };
                        state.keys = new_keys;
                        state.sender.clone()
                    }
                    None => {
                        // Subscription was cancelled between the snapshot and now.
                        self.subscription_tracker.lock().unsubscribe(new_keys);
                        return Err(anyhow::anyhow!("subscription {id:?} cancelled during rebind"));
                    }
                }
            };

            // 3. Decrement old refs SECOND.
            self.subscription_tracker.lock().unsubscribe(old_keys);

            // 4. Push current value for the new anchor.
            if let Ok(response) = self.read_fragment_from_cache(&fragment, &new_anchor) {
                let _ = sender.send(Ok(response));
            }

            Ok(id)
        } else {
            // ---- Slow path: different fragment type, full teardown + rebuild ----
            self.unsubscribe(&id);
            self.observe_fragment(new_ref)
        }
    }

    // -----------------------------------------------------------------------
    // Normalization (called by the FRB request task)
    // -----------------------------------------------------------------------

    pub fn normalize(
        &self,
        op_ctx: &SharedOpCtx,
        data: Value,
        variables: Option<&Map<String, Value>>,
    ) -> anyhow::Result<NormalizationResult> {
        self.remember_operation_vars(op_ctx, variables);
        let result = self.engine.normalize_response(op_ctx, data, variables)?;
        self.notify_subscribers(&result.changed)?;
        Ok(result)
    }

    // -----------------------------------------------------------------------
    // Subscription lifecycle
    // -----------------------------------------------------------------------

    pub fn unsubscribe(&self, id: &SubscriptionId) {
        let keys = {
            let mut manager = self.subscriptions.lock();
            manager.subscriptions.remove(id).map(|state| state.keys)
        };
        if let Some(keys) = keys {
            self.subscription_tracker.lock().unsubscribe(keys);
        }
    }

    pub fn collect_garbage(&self) -> Vec<String> {
        let active_keys = self.subscription_tracker.lock().active_keys();
        let cache = self.cache();
        let mut cache = cache.lock();
        collect_garbage(&mut cache, &active_keys)
    }

    pub fn subscription_stream(
        &self,
        id: &SubscriptionId,
    ) -> anyhow::Result<RuntimeResponseStream> {
        let receiver = {
            let mut manager = self.subscriptions.lock();
            manager
                .subscriptions
                .get_mut(id)
                .and_then(|state| state.receiver.take())
                .ok_or_else(|| {
                    anyhow::anyhow!("subscription {id:?} not found or already streaming")
                })?
        };
        Ok(Box::pin(UnboundedReceiverStream::new(receiver)))
    }

    /// Push a transport/network error to a subscription so the Dart side sees it.
    pub fn push_subscription_error(&self, id: SubscriptionId, err: anyhow::Error) {
        let manager = self.subscriptions.lock();
        if let Some(state) = manager.subscriptions.get(&id) {
            let _ = state.sender.send(Err(err));
        }
    }

    // -----------------------------------------------------------------------
    // Cache read helpers (pub for the FRB layer)
    // -----------------------------------------------------------------------

    pub fn read_from_cache(
        &self,
        op_ctx: &SharedOpCtx,
        variables: Option<&Map<String, Value>>,
    ) -> anyhow::Result<RuntimeResponse> {
        let result = self.read_result_op(op_ctx, variables)?;
        Ok(RuntimeResponse {
            data: result.data,
            operation_id: Some(op_ctx.get_operation_name().to_string()),
        })
    }

    /// Look up a pre-registered (or remembered) operation by name.
    pub fn operation_by_name(&self, name: &str) -> anyhow::Result<SharedOpCtx> {
        self.engine
            .global_ctx()
            .get_operation(name)
            .ok_or_else(|| anyhow::anyhow!("operation '{name}' not registered — call registerOperation first"))
    }

    // -----------------------------------------------------------------------
    // Private helpers
    // -----------------------------------------------------------------------

    fn subscribe_with_target(
        &self,
        target: SubscriptionTarget,
        variables: Option<Map<String, Value>>,
        refs: HashSet<String>,
    ) -> SubscriptionId {
        let keys = refs.clone();
        let (sender, receiver) = mpsc::unbounded_channel();
        let mut manager = self.subscriptions.lock();
        let id = SubscriptionId(manager.next_id);
        manager.next_id += 1;
        manager.subscriptions.insert(
            id,
            SubscriptionState {
                target,
                variables,
                keys: refs,
                sender,
                receiver: Some(receiver),
            },
        );
        drop(manager);
        self.subscription_tracker.lock().subscribe(keys);
        id
    }

    fn notify_subscribers(&self, changed: &HashSet<String>) -> anyhow::Result<()> {
        let affected: Vec<(SubscriptionId, SubscriptionTarget, Option<Map<String, Value>>)> = {
            let manager = self.subscriptions.lock();
            manager
                .subscriptions
                .iter()
                .filter(|(_, state)| {
                    state.keys.is_empty() || state.keys.iter().any(|k| changed.contains(k))
                })
                .map(|(id, state)| (*id, state.target.clone(), state.variables.clone()))
                .collect()
        };

        for (id, target, variables) in affected {
            let (data, new_refs, operation_id) = match &target {
                SubscriptionTarget::Operation(op_ctx) => {
                    let result = self.read_result_op(op_ctx, variables.as_ref())?;
                    (result.data, result.used_refs, op_ctx.get_operation_name().to_string())
                }
                SubscriptionTarget::Fragment { fragment, anchor } => {
                    let result = self.read_result_fragment(fragment, anchor)?;
                    (result.data, result.used_refs, fragment.get_fragment_name().to_string())
                }
            };

            let response = RuntimeResponse {
                data,
                operation_id: Some(operation_id),
            };

            let mut old_keys = None;
            let mut removed = false;

            {
                let mut manager = self.subscriptions.lock();
                if let Some(state) = manager.subscriptions.get_mut(&id) {
                    old_keys = Some(state.keys.clone());
                    state.keys = new_refs.clone();
                    if state.sender.send(Ok(response)).is_err() {
                        manager.subscriptions.remove(&id);
                        removed = true;
                    }
                }
            }

            if let Some(old_keys) = old_keys {
                let mut tracker = self.subscription_tracker.lock();
                if removed {
                    tracker.unsubscribe(old_keys);
                } else {
                    tracker.unsubscribe(old_keys);
                    tracker.subscribe(new_refs);
                }
            }
        }

        Ok(())
    }

    fn read_result_op(
        &self,
        op_ctx: &SharedOpCtx,
        variables: Option<&Map<String, Value>>,
    ) -> anyhow::Result<crate::read::ReadResult> {
        let cache = self.cache();
        let cache_guard = cache.lock();
        let reader = CacheReader::new(self.engine.global_ctx(), &cache_guard, variables);
        reader.read_operation(op_ctx)
    }

    fn read_result_fragment(
        &self,
        fragment: &SharedFragmentContext,
        root_ref: &str,
    ) -> anyhow::Result<crate::read::ReadResult> {
        let cache = self.cache();
        let cache_guard = cache.lock();
        let reader = CacheReader::new(self.engine.global_ctx(), &cache_guard, None);
        reader.read_fragment(fragment, root_ref)
    }

    fn read_fragment_from_cache(
        &self,
        fragment: &SharedFragmentContext,
        root_ref: &str,
    ) -> anyhow::Result<RuntimeResponse> {
        let result = self.read_result_fragment(fragment, root_ref)?;
        Ok(RuntimeResponse {
            data: result.data,
            operation_id: Some(fragment.get_fragment_name().to_string()),
        })
    }

    fn remember_operation_vars(
        &self,
        op_ctx: &SharedOpCtx,
        variables: Option<&Map<String, Value>>,
    ) {
        let op_id = op_ctx.get_operation_name().to_string();
        let mut vars_map = self.operation_vars.lock();
        match variables {
            Some(vars) => {
                vars_map.insert(op_id, vars.clone());
            }
            None => {
                vars_map.remove(&op_id);
            }
        }
    }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

fn register_fragments_ignoring_duplicates(
    global_ctx: &shalom_core::context::SharedShalomGlobalContext,
    sdl: &str,
    path: &PathBuf,
) -> anyhow::Result<()> {
    match register_fragments_from_document(global_ctx, sdl, path) {
        Ok(()) => Ok(()),
        Err(err) => {
            let msg = err.to_string();
            if msg.contains("Fragment with name") && msg.contains("already exists") {
                Ok(())
            } else {
                Err(err)
            }
        }
    }
}
