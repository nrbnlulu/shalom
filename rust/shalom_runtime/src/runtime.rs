use std::collections::{HashMap, HashSet};
use std::path::PathBuf;
use std::pin::Pin;
use std::sync::Arc;
use std::sync::atomic::{AtomicBool, AtomicU64, Ordering};
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

use crate::cache::{CacheRecord, NormalizedCache};
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

/// Structured error from a subscription — either GraphQL-level errors or
/// a transport-layer error. Serializable for bridging to Dart.
#[derive(Debug, Clone, serde::Serialize, serde::Deserialize)]
pub enum SubscriptionError {
    GraphQL {
        errors: Vec<Map<String, Value>>,
        #[serde(skip_serializing_if = "Option::is_none")]
        extensions: Option<Map<String, Value>>,
    },
    Transport {
        message: String,
        code: String,
        #[serde(skip_serializing_if = "Option::is_none")]
        details: Option<Value>,
    },
}

impl std::fmt::Display for SubscriptionError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            SubscriptionError::GraphQL { errors, .. } => {
                write!(
                    f,
                    "GraphQL errors: {}",
                    serde_json::to_string(errors).unwrap_or_default()
                )
            }
            SubscriptionError::Transport { message, code, .. } => {
                write!(f, "Transport error {}: {}", code, message)
            }
        }
    }
}

impl std::error::Error for SubscriptionError {}

/// An observed reference — identifies a fragment subscription by fragment name
/// and cache anchor (e.g. `"User:1"`).
#[derive(Debug, Clone)]
pub struct ObservedRef {
    pub observable_id: String,
    pub anchor: String,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum ExecutionPolicy {
    NetworkFirst,
    CacheFirst,
}

pub type RuntimeResponseStream =
    Pin<Box<dyn Stream<Item = Result<RuntimeResponse, SubscriptionError>> + Send>>;

/// Info about a single active subscription / observer.
#[derive(Debug, Clone)]
pub struct KeySubscriberInfo {
    pub id: u64,
    /// `"operation"` or `"fragment"`
    pub kind: String,
    pub name: String,
    /// For operation observers: `"query"`, `"mutation"`, or `"subscription"`.
    pub op_type: Option<String>,
    /// For fragment observers: the anchor cache key.
    pub anchor: Option<String>,
    /// Serialized JSON of the observer's variables, if any.
    pub variables_json: Option<String>,
    /// All cache keys this observer is currently watching.
    pub watched_keys: Vec<String>,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub struct SubscriptionId(u64);

impl From<u64> for SubscriptionId {
    fn from(value: u64) -> Self {
        Self(value)
    }
}

impl From<SubscriptionId> for u64 {
    fn from(value: SubscriptionId) -> Self {
        value.0
    }
}

/// Opaque handle returned by `write_optimistic`; pass to `rollback_optimistic`
/// to undo the cache write.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub struct OptimisticWriteId(u64);

impl From<u64> for OptimisticWriteId {
    fn from(value: u64) -> Self {
        Self(value)
    }
}

impl From<OptimisticWriteId> for u64 {
    fn from(value: OptimisticWriteId) -> Self {
        value.0
    }
}

struct OptimisticWrite {
    /// Pre-write snapshot: top-level cache key → previous record (None = key was absent).
    snapshot: HashMap<String, Option<CacheRecord>>,
    /// The field-level ref keys that changed when this optimistic write was applied.
    /// Used as the `changed` set when notifying subscribers during rollback.
    changed_refs: HashSet<String>,
}

// ---------------------------------------------------------------------------
// Internal subscription state
// ---------------------------------------------------------------------------

struct SubscriptionState {
    target: SubscriptionTarget,
    variables: Option<Map<String, Value>>,
    keys: HashSet<String>,
    sender: mpsc::UnboundedSender<Result<RuntimeResponse, SubscriptionError>>,
    receiver: Option<mpsc::UnboundedReceiver<Result<RuntimeResponse, SubscriptionError>>>,
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
    /// Pending optimistic writes keyed by their ID.
    optimistic_writes: Arc<Mutex<HashMap<OptimisticWriteId, OptimisticWrite>>>,
    /// Monotonic counter for generating `OptimisticWriteId`s.
    next_optimistic_id: Arc<AtomicU64>,
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
            register_fragments_from_document(&global_ctx, &fragment, &path, true)?;
        }

        let runtime = Self::new(global_ctx);

        // Background GC sweep every 2 seconds on a plain OS thread so it
        // runs regardless of whether a Tokio runtime is active (e.g. during
        // synchronous FRB init).
        let runtime_gc = runtime.clone();
        std::thread::spawn(move || {
            loop {
                std::thread::sleep(Duration::from_secs(2));
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
            optimistic_writes: Arc::new(Mutex::new(HashMap::new())),
            next_optimistic_id: Arc::new(AtomicU64::new(0)),
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
        register_fragments_from_document(&self.engine.global_ctx(), document, &path, true)?;
        let operations = parse_document(&self.engine.global_ctx(), document, &path)?;
        if operations.is_empty() {
            return Err(anyhow::anyhow!("no operations found in document"));
        }
        let is_overwrite = operations
            .keys()
            .any(|name| self.engine.global_ctx().operation_exists(name));
        let mut result = None;
        for (name, op_ctx) in &operations {
            self.engine
                .global_ctx()
                .register_operations(std::iter::once((name.clone(), op_ctx.clone())).collect());
            result = Some(op_ctx.clone());
        }
        if is_overwrite {
            self.invalidate_cache();
        }
        result.ok_or_else(|| anyhow::anyhow!("no operations registered"))
    }

    /// Pre-register a fragment SDL by name. Must be called before `observe_fragment`.
    pub fn register_fragment(&self, document: &str) -> anyhow::Result<()> {
        let path = PathBuf::from("registered_fragment.graphql");
        let is_overwrite = is_fragment_overwrite(&self.engine.global_ctx(), document);
        register_fragments_from_document(&self.engine.global_ctx(), document, &path, true)?;
        if is_overwrite {
            self.invalidate_cache();
        }
        Ok(())
    }

    /// Replace the GraphQL schema with a freshly parsed one.
    ///
    /// Clears all registered operations and fragments (they will be re-registered
    /// by the hot-reload `registerShalomDefinitions` call that follows) and
    /// invalidates the cache so widgets restart with fresh data.
    pub fn reload_schema(&self, schema_sdl: &str) -> anyhow::Result<()> {
        let new_schema_ctx = parse_schema(schema_sdl)?;
        let config = shalom_core::shalom_config::ShalomConfig::default();
        let new_global_ctx = shalom_core::context::ShalomGlobalContext::new(
            new_schema_ctx,
            config,
            std::path::PathBuf::from("schema.graphql"),
        );
        self.engine.replace_global_ctx(new_global_ctx);
        self.invalidate_cache();
        Ok(())
    }

    /// Clear the normalized cache and close all active subscriptions.
    ///
    /// Dropping each `SubscriptionState` drops its sender, which closes the
    /// unbounded channel. The Dart side's `onDone` fires, and generated widgets
    /// call `_subscribe()` again to restart with fresh data.
    pub fn invalidate_cache(&self) {
        self.cache().lock().clear();
        let removed: Vec<SubscriptionState> = {
            let mut manager = self.subscriptions.lock();
            manager.subscriptions.drain().map(|(_, s)| s).collect()
        };
        self.subscription_tracker.lock().clear();
        drop(removed);
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
        execution_policy: ExecutionPolicy,
    ) -> SubscriptionId {
        log::debug!("executing operation: {}", op_ctx.get_operation_name());
        self.remember_operation_vars(&op_ctx, variables.as_ref());
        let initial = self.read_result_op(&op_ctx, variables.as_ref()).ok();
        let refs = initial
            .as_ref()
            .map(subscription_refs_for_result)
            .unwrap_or_default();
        let op_name = op_ctx.get_operation_name().to_string();
        let id = self.subscribe_with_target(SubscriptionTarget::Operation(op_ctx), variables, refs);

        if execution_policy == ExecutionPolicy::CacheFirst
            && let Some(initial) = initial
            && initial.missing_refs.is_empty()
        {
            let response = RuntimeResponse {
                data: initial.data,
                operation_id: Some(op_name),
            };
            let manager = self.subscriptions.lock();
            if let Some(state) = manager.subscriptions.get(&id) {
                let _ = state.sender.send(Ok(response));
            }
        }

        id
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
        // Skip if data is null — cache is empty, widget will wait for the next network push.
        if let Ok(result) = self.read_result_fragment(&fragment, &anchor) {
            if result.data != serde_json::Value::Null && result.missing_refs.is_empty() {
                let response = RuntimeResponse {
                    data: result.data,
                    operation_id: Some(fragment.get_fragment_name().to_string()),
                };
                let manager = self.subscriptions.lock();
                if let Some(state) = manager.subscriptions.get(&sub_id) {
                    let _ = state.sender.send(Ok(response));
                }
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
                .ok_or_else(|| anyhow::anyhow!("fragment '{}' not found", new_ref.observable_id))?;
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
                        return Err(anyhow::anyhow!(
                            "subscription {id:?} cancelled during rebind"
                        ));
                    }
                }
            };

            // 3. Decrement old refs SECOND.
            self.subscription_tracker.lock().unsubscribe(old_keys);

            // 4. Push current value for the new anchor.
            if let Ok(result) = self.read_result_fragment(&fragment, &new_anchor) {
                if result.data != serde_json::Value::Null && result.missing_refs.is_empty() {
                    let response = RuntimeResponse {
                        data: result.data,
                        operation_id: Some(fragment.get_fragment_name().to_string()),
                    };
                    let _ = sender.send(Ok(response));
                }
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
    // Optimistic writes
    // -----------------------------------------------------------------------

    /// Write `data` to the cache as an optimistic response for the mutation
    /// named `op_name`.  Snapshots every top-level cache key before writing so
    /// the change can be undone with `rollback_optimistic`.  Notifies all
    /// affected subscribers immediately so the UI updates before the network
    /// response arrives.
    pub fn write_optimistic(
        &self,
        op_name: &str,
        data: Value,
    ) -> anyhow::Result<OptimisticWriteId> {
        let op_ctx = self.operation_by_name(op_name)?;
        let result = self
            .engine
            .normalize_response_with_snapshot(&op_ctx, data, None)?;
        let id = OptimisticWriteId(self.next_optimistic_id.fetch_add(1, Ordering::Relaxed));
        self.optimistic_writes.lock().insert(
            id,
            OptimisticWrite {
                snapshot: result.snapshot,
                changed_refs: result.changed.clone(),
            },
        );
        self.notify_subscribers(&result.changed)?;
        Ok(id)
    }

    /// Undo a previous `write_optimistic` call: restores all snapshotted cache
    /// keys to their pre-write values and notifies affected subscribers.
    /// No-op if `id` is not found (already rolled back or never written).
    pub fn rollback_optimistic(&self, id: OptimisticWriteId) -> anyhow::Result<()> {
        let write = match self.optimistic_writes.lock().remove(&id) {
            Some(w) => w,
            None => return Ok(()),
        };
        {
            let cache = self.cache();
            let mut cache = cache.lock();
            for (key, maybe_record) in write.snapshot {
                match maybe_record {
                    Some(record) => cache.insert(key, record),
                    None => {
                        cache.remove(&key);
                    }
                }
            }
        }
        self.notify_subscribers(&write.changed_refs)?;
        Ok(())
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

    /// Push a subscription error to a subscription so the Dart side sees it.
    pub fn push_subscription_error(&self, id: SubscriptionId, err: SubscriptionError) {
        let manager = self.subscriptions.lock();
        if let Some(state) = manager.subscriptions.get(&id) {
            let _ = state.sender.send(Err(err));
        }
    }

    // -----------------------------------------------------------------------
    // Debug / inspection helpers (pub for the FRB layer)
    // -----------------------------------------------------------------------

    /// Returns a map of cache-key → active subscriber count.
    pub fn subscription_counts(&self) -> HashMap<String, usize> {
        self.subscription_tracker.lock().counts().clone()
    }

    /// Returns info about every active observer that watches [key].
    pub fn key_subscribers(&self, key: &str) -> Vec<KeySubscriberInfo> {
        let manager = self.subscriptions.lock();
        Self::build_observer_list(
            manager
                .subscriptions
                .iter()
                .filter(|(_, s)| s.keys.contains(key)),
        )
    }

    /// Returns info about every active observer, regardless of which keys it watches.
    pub fn all_observers(&self) -> Vec<KeySubscriberInfo> {
        let manager = self.subscriptions.lock();
        Self::build_observer_list(manager.subscriptions.iter())
    }

    fn build_observer_list<'a>(
        iter: impl Iterator<Item = (&'a SubscriptionId, &'a SubscriptionState)>,
    ) -> Vec<KeySubscriberInfo> {
        iter.map(|(id, state)| {
            let (kind, name, op_type, anchor) = match &state.target {
                SubscriptionTarget::Operation(op_ctx) => {
                    let op_type = match op_ctx.op_type() {
                        shalom_core::operation::types::OperationType::Query => "query",
                        shalom_core::operation::types::OperationType::Mutation => "mutation",
                        shalom_core::operation::types::OperationType::Subscription => {
                            "subscription"
                        }
                    };
                    (
                        "operation",
                        op_ctx.get_operation_name().to_string(),
                        Some(op_type.to_string()),
                        None,
                    )
                }
                SubscriptionTarget::Fragment { fragment, anchor } => (
                    "fragment",
                    fragment.get_fragment_name().to_string(),
                    None,
                    Some(anchor.clone()),
                ),
            };
            let variables_json = state
                .variables
                .as_ref()
                .and_then(|v| serde_json::to_string(v).ok());
            let watched_keys = {
                let mut keys: Vec<String> = state.keys.iter().cloned().collect();
                keys.sort();
                keys
            };
            KeySubscriberInfo {
                id: id.0,
                kind: kind.to_string(),
                name,
                op_type,
                anchor,
                variables_json,
                watched_keys,
            }
        })
        .collect()
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

    /// Read the cache for a named operation. Returns `None` when data is absent
    /// or incomplete (missing refs), so callers don't need to handle partial reads.
    pub fn try_read_query(
        &self,
        op_name: &str,
        variables: Option<&Map<String, Value>>,
    ) -> anyhow::Result<Option<Value>> {
        let op_ctx = self.operation_by_name(op_name)?;
        let result = self.read_result_op(&op_ctx, variables)?;
        if result.missing_refs.is_empty() {
            Ok(Some(result.data))
        } else {
            Ok(None)
        }
    }

    /// Normalize [data] into the cache for [op_name] and notify all affected
    /// subscribers.  Unlike `write_optimistic`, this write is permanent and
    /// cannot be rolled back.
    pub fn write_query(
        &self,
        op_name: &str,
        data: Value,
        variables: Option<&Map<String, Value>>,
    ) -> anyhow::Result<()> {
        let op_ctx = self.operation_by_name(op_name)?;
        let data = self.resolve_observed_fragment_refs(data)?;
        self.normalize(&op_ctx, data, variables)?;
        Ok(())
    }

    /// Look up a pre-registered (or remembered) operation by name.
    pub fn operation_by_name(&self, name: &str) -> anyhow::Result<SharedOpCtx> {
        self.engine.global_ctx().get_operation(name).ok_or_else(|| {
            anyhow::anyhow!("operation '{name}' not registered — call registerOperation first")
        })
    }

    fn fragment_by_name(&self, name: &str) -> anyhow::Result<SharedFragmentContext> {
        self.engine
            .global_ctx()
            .get_fragment(name)
            .ok_or_else(|| anyhow::anyhow!("fragment '{name}' not registered"))
    }

    /// Read the entity at [entity_key] through [fragment_name]'s selection set.
    ///
    /// Returns `None` when the entity is absent or has missing refs.
    pub fn try_read_fragment(
        &self,
        fragment_name: &str,
        entity_key: &str,
    ) -> anyhow::Result<Option<Value>> {
        let fragment = self.fragment_by_name(fragment_name)?;
        let result = self.read_result_fragment(&fragment, entity_key)?;
        if result.missing_refs.is_empty() {
            Ok(Some(result.data))
        } else {
            Ok(None)
        }
    }

    /// Normalize [data] into the cache at [entity_key] using [fragment_name]'s
    /// selection set and notify all affected subscribers.
    pub fn write_fragment(
        &self,
        fragment_name: &str,
        entity_key: &str,
        data: Value,
    ) -> anyhow::Result<()> {
        let fragment = self.fragment_by_name(fragment_name)?;
        let data = self.resolve_observed_fragment_refs(data)?;
        let result = self
            .engine
            .normalize_fragment_response(&fragment, entity_key, data)?;
        self.notify_subscribers(&result.changed)?;
        Ok(())
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
        let affected: Vec<(
            SubscriptionId,
            SubscriptionTarget,
            Option<Map<String, Value>>,
        )> = {
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
            let (result, operation_id) = match &target {
                SubscriptionTarget::Operation(op_ctx) => {
                    let result = self.read_result_op(op_ctx, variables.as_ref())?;
                    (result, op_ctx.get_operation_name().to_string())
                }
                SubscriptionTarget::Fragment { fragment, anchor } => {
                    let result = self.read_result_fragment(fragment, anchor)?;
                    (result, fragment.get_fragment_name().to_string())
                }
            };

            let new_refs = subscription_refs_for_result(&result);
            let response = result.missing_refs.is_empty().then(|| {
                log::debug!("result yielded for: {operation_id}");
                RuntimeResponse {
                    data: result.data,
                    operation_id: Some(operation_id),
                }
            });

            let mut old_keys = None;
            let mut removed = false;

            {
                let mut manager = self.subscriptions.lock();
                if let Some(state) = manager.subscriptions.get_mut(&id) {
                    old_keys = Some(state.keys.clone());
                    state.keys = new_refs.clone();
                    if response
                        .map(|response| state.sender.send(Ok(response)).is_err())
                        .unwrap_or(false)
                    {
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

    fn resolve_observed_fragment_refs(&self, data: Value) -> anyhow::Result<Value> {
        let cache = self.cache();
        let cache_guard = cache.lock();
        let reader = CacheReader::new(self.engine.global_ctx(), &cache_guard, None);
        let mut stack = HashSet::new();
        self.resolve_observed_fragment_refs_with_reader(data, &reader, &mut stack)
    }

    fn resolve_observed_fragment_refs_with_reader(
        &self,
        data: Value,
        reader: &CacheReader<'_>,
        stack: &mut HashSet<(String, String)>,
    ) -> anyhow::Result<Value> {
        match data {
            Value::Array(items) => items
                .into_iter()
                .map(|item| self.resolve_observed_fragment_refs_with_reader(item, reader, stack))
                .collect::<anyhow::Result<Vec<_>>>()
                .map(Value::Array),
            Value::Object(map) => {
                if let Some((observable_id, anchor)) = observed_ref_from_json_object(&map) {
                    let ref_key = (observable_id.clone(), anchor.clone());
                    if !stack.insert(ref_key.clone()) {
                        return Err(anyhow::anyhow!(
                            "cyclic observed fragment reference '{}:{}'",
                            observable_id,
                            anchor
                        ));
                    }
                    let fragment = self
                        .engine
                        .global_ctx()
                        .get_fragment(&observable_id)
                        .ok_or_else(|| anyhow::anyhow!("fragment '{}' not found", observable_id))?;
                    let result = reader.read_fragment(&fragment, &anchor)?;
                    if !result.missing_refs.is_empty() {
                        return Err(anyhow::anyhow!(
                            "observed fragment '{}' at '{}' is incomplete; missing refs: {:?}",
                            observable_id,
                            anchor,
                            result.missing_refs
                        ));
                    }
                    let resolved =
                        self.resolve_observed_fragment_refs_with_reader(result.data, reader, stack);
                    stack.remove(&ref_key);
                    return resolved;
                }

                map.into_iter()
                    .map(|(key, value)| {
                        self.resolve_observed_fragment_refs_with_reader(value, reader, stack)
                            .map(|value| (key, value))
                    })
                    .collect::<anyhow::Result<Map<_, _>>>()
                    .map(Value::Object)
            }
            other => Ok(other),
        }
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

fn observed_ref_from_json_object(map: &Map<String, Value>) -> Option<(String, String)> {
    if map.len() != 1 {
        return None;
    }
    let ref_obj = map.get("__shalom_observed_ref")?.as_object()?;
    let observable_id = ref_obj.get("observable_id")?.as_str()?.to_string();
    let anchor = ref_obj.get("anchor")?.as_str()?.to_string();
    Some((observable_id, anchor))
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Returns true if `document` contains any fragment whose name is already
/// registered in `ctx`.  Used to decide whether to invalidate the cache on
/// hot-reload re-registration.
fn is_fragment_overwrite(
    ctx: &shalom_core::context::SharedShalomGlobalContext,
    document: &str,
) -> bool {
    // Quick text scan: fragment definitions start with `fragment <Name>`.
    // We don't need full parsing here — a false positive (rare) just causes an
    // extra (harmless) cache clear; a false negative would leave stale data.
    for token in document.split_whitespace() {
        if ctx.fragment_exists(token) {
            return true;
        }
    }
    false
}

fn subscription_refs_for_result(result: &crate::read::ReadResult) -> HashSet<String> {
    if result.missing_refs.is_empty() {
        return result.used_refs.clone();
    }

    let mut refs = result.used_refs.clone();
    refs.extend(result.missing_refs.iter().cloned());
    refs
}
