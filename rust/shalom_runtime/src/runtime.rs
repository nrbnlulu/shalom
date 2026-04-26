use std::collections::{HashMap, HashSet};
use std::path::PathBuf;
use std::pin::Pin;
use std::sync::Arc;
use parking_lot::Mutex;

use serde_json::{Map, Value};
use tokio::sync::mpsc;
use tokio_stream::Stream;
use tokio_stream::StreamExt;
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

#[derive(Debug, Clone, Default, serde::Serialize, serde::Deserialize)]
pub struct RuntimeConfig;

#[derive(Debug, Clone, Default)]
pub struct RefObject {
    pub refs: HashSet<String>,
}

impl RefObject {
    pub fn from_response(_data: &Value) -> Self {
        Self::default()
    }
}

impl From<Vec<String>> for RefObject {
    fn from(refs: Vec<String>) -> Self {
        Self {
            refs: refs.into_iter().collect(),
        }
    }
}

impl From<HashSet<String>> for RefObject {
    fn from(refs: HashSet<String>) -> Self {
        Self { refs }
    }
}

#[derive(Debug, Clone, serde::Serialize, serde::Deserialize)]
pub struct RuntimeResponse {
    pub data: Value,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub operation_id: Option<String>,
}

pub type RuntimeResponseStream =
    Pin<Box<dyn Stream<Item = anyhow::Result<RuntimeResponse>> + Send>>;

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

struct SubscriptionState {
    target: SubscriptionTarget,
    variables: Option<Map<String, Value>>,
    keys: HashSet<String>,
    sender: mpsc::UnboundedSender<RuntimeResponse>,
    receiver: Option<mpsc::UnboundedReceiver<RuntimeResponse>>,
}

#[derive(Clone)]
enum SubscriptionTarget {
    Operation(SharedOpCtx),
    Fragment {
        fragment: SharedFragmentContext,
        root_ref: String,
    },
}

#[derive(Default)]
struct SubscriptionManager {
    next_id: u64,
    subscriptions: HashMap<SubscriptionId, SubscriptionState>,
}

#[derive(Clone)]
pub struct ShalomRuntime {
    engine: ExecutionEngine,
    subscriptions: Arc<Mutex<SubscriptionManager>>,
    subscription_tracker: Arc<Mutex<SubscriptionTracker>>,
    operations: Arc<Mutex<HashMap<String, SharedOpCtx>>>,
    operation_vars: Arc<Mutex<HashMap<String, Map<String, Value>>>>,
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
            register_fragments_with_duplicates(&global_ctx, &fragment, &path)?;
        }

        Ok(Self::new(global_ctx))
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
            operations: Arc::new(Mutex::new(HashMap::new())),
            operation_vars: Arc::new(Mutex::new(HashMap::new())),
        }
    }

    pub fn cache(&self) -> Arc<Mutex<NormalizedCache>> {
        self.engine.cache()
    }

    pub fn normalize(
        &self,
        op_ctx: &SharedOpCtx,
        data: Value,
        variables: Option<&Map<String, Value>>,
    ) -> anyhow::Result<NormalizationResult> {
        self.remember_operation(op_ctx, variables);
        let result = self.engine.normalize_response(op_ctx, data, variables)?;
        self.notify_subscribers(&result.changed)?;
        Ok(result)
    }

    pub fn subscribe_fragment(
        &self,
        target_name: &str,
        anchor: Option<String>,
    ) -> anyhow::Result<SubscriptionId> {
        if let Some(root_ref) = anchor {
            let fragment = self
                .engine
                .global_ctx()
                .get_fragment(target_name)
                .ok_or_else(|| anyhow::anyhow!("fragment {target_name} not found"))?;
            let refs = self.read_result_fragment(&fragment, &root_ref)
                .map(|r| r.used_refs)
                .unwrap_or_default();
            return Ok(self.subscribe_with_target(
                SubscriptionTarget::Fragment { fragment, root_ref },
                None,
                refs,
            ));
        }

        let op_ctx = self.operation_ctx(target_name)?;
        let variables = self
            .operation_vars
            .lock().get(target_name)
            .cloned();
        let refs = self.read_result_op(&op_ctx, variables.as_ref())
            .map(|r| r.used_refs)
            .unwrap_or_default();
        Ok(self.subscribe_with_target(SubscriptionTarget::Operation(op_ctx), variables, refs))
    }

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

    pub fn subscription_stream(&self, id: &SubscriptionId) -> anyhow::Result<RuntimeResponseStream> {
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
        let stream = UnboundedReceiverStream::new(receiver).map(Ok);
        Ok(Box::pin(stream))
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
                    state.keys.is_empty() || state.keys.iter().any(|key| changed.contains(key))
                })
                .map(|(id, state)| (*id, state.target.clone(), state.variables.clone()))
                .collect()
        };

        for (id, target, variables) in affected {
            let (data, new_refs, operation_id) = match &target {
                SubscriptionTarget::Operation(op_ctx) => {
                    let result = self.read_result_op(op_ctx, variables.as_ref())?;
                    let op_id = op_ctx.get_operation_name().to_string();
                    (result.data, result.used_refs, op_id)
                }
                SubscriptionTarget::Fragment { fragment, root_ref } => {
                    let result = self.read_result_fragment(fragment, root_ref)?;
                    let frag_id = fragment.get_fragment_name().to_string();
                    (result.data, result.used_refs, frag_id)
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
                    if state.sender.send(response).is_err() {
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

    fn remember_operation(&self, op_ctx: &SharedOpCtx, variables: Option<&Map<String, Value>>) {
        let op_id = op_ctx.get_operation_name().to_string();
        self.operations.lock().insert(op_id.clone(), op_ctx.clone());
        let mut vars_map = self.operation_vars.lock();
        if let Some(vars) = variables {
            vars_map.insert(op_id, vars.clone());
        } else {
            vars_map.remove(&op_id);
        }
    }

    fn operation_ctx(&self, operation_id: &str) -> anyhow::Result<SharedOpCtx> {
        if let Some(op_ctx) = self.operations.lock().get(operation_id).cloned() {
            return Ok(op_ctx);
        }
        let global_ctx = self.engine.global_ctx();
        global_ctx
            .get_operation(operation_id)
            .ok_or_else(|| anyhow::anyhow!("operation {operation_id} not found"))
    }

    pub fn register_operation_from_query(&self, query: &str) -> anyhow::Result<SharedOpCtx> {
        let global_ctx = self.engine.global_ctx();
        let path = PathBuf::from("request.graphql");
        let _ = register_fragments_with_duplicates(&global_ctx, query, &path)?;
        let operations = parse_document(&global_ctx, query, &path)?;
        if operations.len() != 1 {
            return Err(anyhow::anyhow!(
                "expected a single operation per request, found {}",
                operations.len()
            ));
        }
        let (name, op_ctx) = operations
            .iter()
            .next()
            .map(|(name, ctx)| (name.clone(), ctx.clone()))
            .expect("operation missing");
        if global_ctx.operation_exists(&name) {
            let existing = global_ctx
                .get_operation(&name)
                .ok_or_else(|| anyhow::anyhow!("operation {name} not found"))?;
            self.remember_operation(&existing, None);
            return Ok(existing);
        }
        global_ctx.register_operations(operations.clone());
        self.remember_operation(&op_ctx, None);
        Ok(op_ctx)
    }
}

fn register_fragments_with_duplicates(
    global_ctx: &SharedShalomGlobalContext,
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
