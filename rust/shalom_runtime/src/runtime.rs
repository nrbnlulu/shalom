use std::collections::{HashMap, HashSet, VecDeque};
use std::path::PathBuf;
use std::sync::{Arc, Mutex};

use serde_json::{Map, Value};
use tokio_stream::StreamExt;

use shalom_core::context::SharedShalomGlobalContext;
use shalom_core::entrypoint::{parse_document, parse_schema, register_fragments_from_document};
use shalom_core::operation::context::SharedOpCtx;
use shalom_core::shalom_config::ShalomConfig;

use crate::cache::NormalizedCache;
use crate::execution::ExecutionEngine;
use crate::link::{GraphQLLink, GraphQLResponse, OperationType as LinkOperationType, Request};
use crate::normalization::NormalizationResult;
use crate::read::CacheReader;

#[derive(Debug, Clone, Default)]
pub struct RuntimeConfig;

#[derive(Debug, Clone, Default)]
pub struct RefObject {
    pub refs: HashSet<String>,
}

impl RefObject {
    pub fn from_response(data: &Value) -> Self {
        let mut refs = HashSet::new();
        collect_refs(data, &mut refs);
        Self { refs }
    }
}

#[derive(Debug, Clone)]
pub struct RuntimeResponse {
    pub data: Value,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub struct SubscriptionId(u64);

struct SubscriptionState {
    op_ctx: SharedOpCtx,
    variables: Option<Map<String, Value>>,
    keys: HashSet<String>,
    queue: VecDeque<RuntimeResponse>,
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
        operation_id: &str,
        refs: Vec<String>,
    ) -> anyhow::Result<SubscriptionId> {
        let op_ctx = self.operation_ctx(operation_id)?;
        let variables = self
            .operation_vars
            .lock()
            .expect("operation vars lock poisoned")
            .get(operation_id)
            .cloned();
        Ok(self.subscribe_with_ctx(op_ctx, variables, refs))
    }

    fn subscribe_with_ctx(
        &self,
        op_ctx: SharedOpCtx,
        variables: Option<Map<String, Value>>,
        refs: Vec<String>,
    ) -> SubscriptionId {
        let refs = RefObject {
            refs: refs.into_iter().collect(),
        };
        let mut manager = self
            .subscriptions
            .lock()
            .expect("subscription manager lock poisoned");
        let id = SubscriptionId(manager.next_id);
        manager.next_id += 1;
        manager.subscriptions.insert(
            id,
            SubscriptionState {
                op_ctx,
                variables,
                keys: refs.refs,
                queue: VecDeque::new(),
            },
        );
        id
    }

    pub fn unsubscribe(&self, id: SubscriptionId) {
        let mut manager = self
            .subscriptions
            .lock()
            .expect("subscription manager lock poisoned");
        manager.subscriptions.remove(&id);
    }

    pub fn drain_updates(&self, id: SubscriptionId) -> Vec<RuntimeResponse> {
        let mut manager = self
            .subscriptions
            .lock()
            .expect("subscription manager lock poisoned");
        if let Some(state) = manager.subscriptions.get_mut(&id) {
            state.queue.drain(..).collect()
        } else {
            Vec::new()
        }
    }

    fn notify_subscribers(&self, changed: &HashSet<String>) -> anyhow::Result<()> {
        let affected: Vec<(SubscriptionId, SharedOpCtx, Option<Map<String, Value>>)> = {
            let manager = self
                .subscriptions
                .lock()
                .expect("subscription manager lock poisoned");
            manager
                .subscriptions
                .iter()
                .filter(|(_, state)| state.keys.iter().any(|key| changed.contains(key)))
                .map(|(id, state)| (*id, state.op_ctx.clone(), state.variables.clone()))
                .collect()
        };

        for (id, op_ctx, variables) in affected {
            let response = self.read_from_cache(&op_ctx, variables.as_ref())?;
            let refs = RefObject::from_response(&response.data);
            let mut manager = self
                .subscriptions
                .lock()
                .expect("subscription manager lock poisoned");
            if let Some(state) = manager.subscriptions.get_mut(&id) {
                state.keys = refs.refs;
                state.queue.push_back(response);
            }
        }

        Ok(())
    }

    pub async fn request(
        &self,
        query: String,
        variables: Option<Map<String, Value>>,
    ) -> anyhow::Result<RuntimeResponse> {
        let link = self
            .link
            .as_ref()
            .ok_or_else(|| anyhow::anyhow!("runtime has no root link configured"))?;
        let op_ctx = self.register_operation_from_query(&query)?;
        let operation_name = op_ctx.get_operation_name().to_string();
        let variables_map = variables.clone().unwrap_or_default();
        let request = Request {
            query,
            variables: variables_map,
            operation_name,
            operation_type: to_link_operation_type(op_ctx.op_type()),
        };

        let mut stream = link.execute(request, None);
        match stream.next().await {
            Some(GraphQLResponse::Data { data, .. }) => {
                let result = self.normalize(&op_ctx, Value::Object(data), variables.as_ref())?;
                Ok(RuntimeResponse { data: result.data })
            }
            Some(GraphQLResponse::Error { errors, .. }) => Err(anyhow::anyhow!(
                "graphql errors: {}",
                serde_json::to_string(&errors).unwrap_or_else(|_| "<unserializable>".to_string())
            )),
            Some(GraphQLResponse::TransportError(err)) => Err(anyhow::anyhow!(
                "transport error {}: {}",
                err.code,
                err.message
            )),
            None => Err(anyhow::anyhow!("link stream closed without response")),
        }
    }

    fn read_from_cache(
        &self,
        op_ctx: &SharedOpCtx,
        variables: Option<&Map<String, Value>>,
    ) -> anyhow::Result<RuntimeResponse> {
        let cache = self.cache();
        let cache_guard = cache.lock().expect("normalized cache lock poisoned");
        let reader = CacheReader::new(self.engine.global_ctx(), &cache_guard, variables);
        let data = reader.read_operation(op_ctx)?;
        Ok(RuntimeResponse { data })
    }

    fn remember_operation(&self, op_ctx: &SharedOpCtx, variables: Option<&Map<String, Value>>) {
        let op_id = op_ctx.get_operation_name().to_string();
        self.operations
            .lock()
            .expect("operations lock poisoned")
            .insert(op_id.clone(), op_ctx.clone());
        if let Some(vars) = variables {
            self.operation_vars
                .lock()
                .expect("operation vars lock poisoned")
                .insert(op_id, vars.clone());
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
        if !global_ctx.operation_exists(&name) {
            global_ctx.register_operations(operations.clone());
        }
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

fn collect_refs(value: &Value, refs: &mut HashSet<String>) {
    match value {
        Value::Object(map) => {
            if let Some(meta) = map.get("__ref").and_then(|value| value.as_object()) {
                if let Some(id) = meta.get("id").and_then(|value| value.as_str()) {
                    refs.insert(id.to_string());
                }
                if let Some(path) = meta.get("path").and_then(|value| value.as_str()) {
                    refs.insert(path.to_string());
                }
            }
            for (key, value) in map {
                if key == "__ref" {
                    continue;
                }
                if key.starts_with("__ref_") {
                    if let Some(id) = value.as_str() {
                        refs.insert(id.to_string());
                    }
                    continue;
                }
                if let Value::Array(items) = value {
                    if let Some(list_ref) = map
                        .get(&format!("__ref_{}", key))
                        .and_then(|value| value.as_str())
                    {
                        collect_list_refs(list_ref, items, refs);
                    }
                }
                collect_refs(value, refs);
            }
        }
        Value::Array(items) => {
            for item in items {
                collect_refs(item, refs);
            }
        }
        _ => {}
    }
}

fn collect_list_refs(list_ref: &str, items: &[Value], refs: &mut HashSet<String>) {
    for (idx, item) in items.iter().enumerate() {
        match item {
            Value::Array(inner) => {
                let item_ref = format!("{list_ref}[{idx}]");
                refs.insert(item_ref.clone());
                collect_list_refs(&item_ref, inner, refs);
            }
            Value::Object(_) => {
                collect_refs(item, refs);
            }
            _ => {}
        }
    }
}
