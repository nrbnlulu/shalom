use std::collections::{HashMap, HashSet};
use std::path::PathBuf;
use std::pin::Pin;
use std::sync::{Arc, Mutex};

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
use crate::link::{GraphQLLink, GraphQLResponse, OperationType as LinkOperationType, Request};
use crate::normalization::NormalizationResult;
use crate::read::CacheReader;

#[derive(Debug, Clone, Default, serde::Serialize, serde::Deserialize)]
pub struct RuntimeConfig;

#[derive(Debug, Clone, Default)]
pub struct RefObject {
    pub refs: HashSet<String>,
}

impl RefObject {
    pub fn from_response(data: &Value) -> Self {
        match used_refs_from_response(data) {
            Ok(Some(refs)) => Self { refs },
            _ => Self::default(),
        }
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
    link: Option<Arc<dyn GraphQLLink>>,
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
        link: Arc<dyn GraphQLLink>,
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

        let mut runtime = Self::new(global_ctx);
        runtime.link = Some(link);
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
            operations: Arc::new(Mutex::new(HashMap::new())),
            operation_vars: Arc::new(Mutex::new(HashMap::new())),
            link: None,
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

    pub fn subscribe(
        &self,
        subscribeable_id: &str,
        root_ref: Option<String>,
        refs: Vec<String>,
    ) -> anyhow::Result<SubscriptionId> {
        if let Some(root_ref) = root_ref {
            let fragment = self
                .engine
                .global_ctx()
                .get_fragment(subscribeable_id)
                .ok_or_else(|| anyhow::anyhow!("fragment {subscribeable_id} not found"))?;
            return Ok(self.subscribe_with_target(
                SubscriptionTarget::Fragment { fragment, root_ref },
                None,
                refs,
            ));
        }

        let op_ctx = self.operation_ctx(subscribeable_id)?;
        let variables = self
            .operation_vars
            .lock()
            .expect("operation vars lock poisoned")
            .get(subscribeable_id)
            .cloned();
        Ok(self.subscribe_with_target(SubscriptionTarget::Operation(op_ctx), variables, refs))
    }

    fn subscribe_with_target(
        &self,
        target: SubscriptionTarget,
        variables: Option<Map<String, Value>>,
        refs: Vec<String>,
    ) -> SubscriptionId {
        let refs: RefObject = refs.into();
        let keys = refs.refs.clone();
        let (sender, receiver) = mpsc::unbounded_channel();
        let mut manager = self
            .subscriptions
            .lock()
            .expect("subscription manager lock poisoned");
        let id = SubscriptionId(manager.next_id);
        manager.next_id += 1;
        manager.subscriptions.insert(
            id,
            SubscriptionState {
                target,
                variables,
                keys: refs.refs,
                sender,
                receiver: Some(receiver),
            },
        );
        drop(manager);
        self.subscription_tracker
            .lock()
            .expect("subscription tracker lock poisoned")
            .subscribe(keys);
        id
    }

    pub fn unsubscribe(&self, id: SubscriptionId) {
        let keys = {
            let mut manager = self
                .subscriptions
                .lock()
                .expect("subscription manager lock poisoned");
            manager.subscriptions.remove(&id).map(|state| state.keys)
        };
        if let Some(keys) = keys {
            self.subscription_tracker
                .lock()
                .expect("subscription tracker lock poisoned")
                .unsubscribe(keys);
        }
    }

    pub fn collect_garbage(&self) -> Vec<String> {
        let active_keys = self
            .subscription_tracker
            .lock()
            .expect("subscription tracker lock poisoned")
            .active_keys();
        let cache = self.cache();
        let mut cache = cache.lock().expect("normalized cache lock poisoned");
        collect_garbage(&mut cache, &active_keys)
    }

    pub fn subscription_stream(&self, id: SubscriptionId) -> anyhow::Result<RuntimeResponseStream> {
        let receiver = {
            let mut manager = self
                .subscriptions
                .lock()
                .expect("subscription manager lock poisoned");
            manager
                .subscriptions
                .get_mut(&id)
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
            let manager = self
                .subscriptions
                .lock()
                .expect("subscription manager lock poisoned");
            manager
                .subscriptions
                .iter()
                .filter(|(_, state)| state.keys.iter().any(|key| changed.contains(key)))
                .map(|(id, state)| (*id, state.target.clone(), state.variables.clone()))
                .collect()
        };

        for (id, target, variables) in affected {
            let response = match &target {
                SubscriptionTarget::Operation(op_ctx) => {
                    self.read_from_cache(op_ctx, variables.as_ref())?
                }
                SubscriptionTarget::Fragment { fragment, root_ref } => {
                    self.read_fragment_from_cache(fragment, root_ref)?
                }
            };
            let new_refs = used_refs_from_response(&response.data)?;
            let mut old_keys = None;
            let mut removed = false;
            {
                let mut manager = self
                    .subscriptions
                    .lock()
                    .expect("subscription manager lock poisoned");
                if let Some(state) = manager.subscriptions.get_mut(&id) {
                    old_keys = Some(state.keys.clone());
                    if let Some(refs) = new_refs.as_ref() {
                        state.keys = refs.clone();
                    }
                    if state.sender.send(response).is_err() {
                        manager.subscriptions.remove(&id);
                        removed = true;
                    }
                }
            }
            if let Some(old_keys) = old_keys {
                let mut tracker = self
                    .subscription_tracker
                    .lock()
                    .expect("subscription tracker lock poisoned");
                if removed {
                    tracker.unsubscribe(old_keys);
                } else if let Some(refs) = new_refs {
                    tracker.unsubscribe(old_keys);
                    tracker.subscribe(refs);
                }
            }
        }

        Ok(())
    }

    pub async fn request(
        &self,
        query: String,
        variables: Option<Map<String, Value>>,
    ) -> anyhow::Result<RuntimeResponse> {
        let mut stream = self.request_stream(query, variables)?;
        match stream.next().await {
            Some(Ok(response)) => Ok(response),
            Some(Err(err)) => Err(err),
            None => Err(anyhow::anyhow!("link stream closed without response")),
        }
    }

    pub fn request_stream(
        &self,
        query: String,
        variables: Option<Map<String, Value>>,
    ) -> anyhow::Result<RuntimeResponseStream> {
        let link = self
            .link
            .as_ref()
            .ok_or_else(|| anyhow::anyhow!("runtime has no root link configured"))?;
        let op_ctx = self.register_operation_from_query(&query)?;
        let operation_name = op_ctx.get_operation_name().to_string();
        let operation_id = operation_name.clone();
        let variables_map = variables.clone().unwrap_or_default();
        let request = Request {
            query,
            variables: variables_map,
            operation_name,
            operation_type: to_link_operation_type(op_ctx.op_type()),
        };

        let runtime = self.clone();
        let vars = variables.clone();
        let op_ctx = op_ctx.clone();
        let stream = link
            .execute(request, None)
            .map(move |response| match response {
                GraphQLResponse::Data { data, .. } => runtime
                    .normalize(&op_ctx, Value::Object(data), vars.as_ref())
                    .map(|result| RuntimeResponse {
                        data: result.data,
                        operation_id: Some(operation_id.clone()),
                    }),
                GraphQLResponse::Error { errors, .. } => Err(anyhow::anyhow!(
                    "graphql errors: {}",
                    serde_json::to_string(&errors)
                        .unwrap_or_else(|_| "<unserializable>".to_string())
                )),
                GraphQLResponse::TransportError(err) => Err(anyhow::anyhow!(
                    "transport error {}: {}",
                    err.code,
                    err.message
                )),
            });

        Ok(Box::pin(stream))
    }

    fn read_from_cache(
        &self,
        op_ctx: &SharedOpCtx,
        variables: Option<&Map<String, Value>>,
    ) -> anyhow::Result<RuntimeResponse> {
        let cache = self.cache();
        let cache_guard = cache.lock().expect("normalized cache lock poisoned");
        let reader = CacheReader::new(self.engine.global_ctx(), &cache_guard, variables);
        let result = reader.read_operation(op_ctx)?;
        let data = if op_ctx.is_subscribeable() {
            inject_entrypoint_metadata(result.data, &result.used_refs, None)
        } else {
            result.data
        };
        Ok(RuntimeResponse {
            data,
            operation_id: Some(op_ctx.get_operation_name().to_string()),
        })
    }

    fn read_fragment_from_cache(
        &self,
        fragment: &SharedFragmentContext,
        root_ref: &str,
    ) -> anyhow::Result<RuntimeResponse> {
        let cache = self.cache();
        let cache_guard = cache.lock().expect("normalized cache lock poisoned");
        let reader = CacheReader::new(self.engine.global_ctx(), &cache_guard, None);
        let result = reader.read_fragment(fragment, root_ref)?;
        let data = if fragment.is_subscribeable() {
            inject_entrypoint_metadata(result.data, &result.used_refs, Some(root_ref))
        } else {
            result.data
        };
        Ok(RuntimeResponse {
            data,
            operation_id: Some(fragment.get_fragment_name().to_string()),
        })
    }

    fn remember_operation(&self, op_ctx: &SharedOpCtx, variables: Option<&Map<String, Value>>) {
        let op_id = op_ctx.get_operation_name().to_string();
        self.operations
            .lock()
            .expect("operations lock poisoned")
            .insert(op_id.clone(), op_ctx.clone());
        let mut vars_map = self
            .operation_vars
            .lock()
            .expect("operation vars lock poisoned");
        if let Some(vars) = variables {
            vars_map.insert(op_id, vars.clone());
        } else {
            vars_map.remove(&op_id);
        }
    }

    fn operation_ctx(&self, operation_id: &str) -> anyhow::Result<SharedOpCtx> {
        if let Some(op_ctx) = self
            .operations
            .lock()
            .expect("operations lock poisoned")
            .get(operation_id)
            .cloned()
        {
            return Ok(op_ctx);
        }
        let global_ctx = self.engine.global_ctx();
        global_ctx
            .get_operation(operation_id)
            .ok_or_else(|| anyhow::anyhow!("operation {operation_id} not found"))
    }

    fn register_operation_from_query(&self, query: &str) -> anyhow::Result<SharedOpCtx> {
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

fn to_link_operation_type(
    op_type: shalom_core::operation::types::OperationType,
) -> LinkOperationType {
    match op_type {
        shalom_core::operation::types::OperationType::Query => LinkOperationType::Query,
        shalom_core::operation::types::OperationType::Mutation => LinkOperationType::Mutation,
        shalom_core::operation::types::OperationType::Subscription => {
            LinkOperationType::Subscription
        }
    }
}

fn used_refs_from_response(data: &Value) -> anyhow::Result<Option<HashSet<String>>> {
    let map = match data.as_object() {
        Some(map) => map,
        None => return Ok(None),
    };
    let raw = match map.get("__used_refs") {
        Some(value) => value,
        None => return Ok(None),
    };
    let list = raw
        .as_array()
        .ok_or_else(|| anyhow::anyhow!("__used_refs must be a list"))?;
    let mut refs = HashSet::with_capacity(list.len());
    for value in list {
        let value = value
            .as_str()
            .ok_or_else(|| anyhow::anyhow!("__used_refs entries must be strings"))?;
        refs.insert(value.to_string());
    }
    Ok(Some(refs))
}

fn inject_entrypoint_metadata(
    mut data: Value,
    used_refs: &HashSet<String>,
    ref_anchor: Option<&str>,
) -> Value {
    if let Value::Object(map) = &mut data {
        map.insert("__used_refs".to_string(), used_refs_to_value(used_refs));
        if let Some(anchor) = ref_anchor {
            map.insert(
                "__ref_anchor".to_string(),
                Value::String(anchor.to_string()),
            );
        }
    }
    data
}

fn used_refs_to_value(used_refs: &HashSet<String>) -> Value {
    let mut refs: Vec<_> = used_refs.iter().cloned().collect();
    refs.sort();
    Value::Array(refs.into_iter().map(Value::String).collect())
}
