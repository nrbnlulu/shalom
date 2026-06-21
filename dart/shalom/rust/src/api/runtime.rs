use std::sync::Arc;

use crate::frb_generated::StreamSink;
use flutter_rust_bridge::frb;
use tokio_stream::StreamExt;

use shalom_runtime::sansio_protocols::host::HostLink;
use shalom_runtime::sansio_protocols::{
    GraphQLLink, GraphQLResponse, OperationType as LinkOperationType, Request,
};
use shalom_runtime::{
    ExecutionPolicy, ObservedRef, OptimisticWriteId, RuntimeConfig, RuntimeResponse, ShalomRuntime,
    SubscriptionId,
};

pub use serde_json::{Map, Value};

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

/// Dart-facing representation of an observed fragment reference.
///
/// `observable_id` is the fragment name; `anchor` is the cache key (e.g. `"User:1"`).
#[frb]
pub struct ObservedRefInput {
    pub observable_id: String,
    pub anchor: String,
}

/// Dart-facing runtime configuration.  Empty for now; fields will be added as
/// the runtime gains configurable behaviour (e.g. GC tuning, cache limits).
#[frb]
pub struct RuntimeConfigInput {}

#[frb]
pub enum LogLevel {
    Error,
    Warn,
    Info,
    Debug,
    Trace,
}

impl From<LogLevel> for log::LevelFilter {
    fn from(level: LogLevel) -> Self {
        match level {
            LogLevel::Error => log::LevelFilter::Error,
            LogLevel::Warn => log::LevelFilter::Warn,
            LogLevel::Info => log::LevelFilter::Info,
            LogLevel::Debug => log::LevelFilter::Debug,
            LogLevel::Trace => log::LevelFilter::Trace,
        }
    }
}

/// Set the global log level filter for all Rust-side logging.
#[frb(sync)]
pub fn set_log_level(level: LogLevel) {
    log::set_max_level(level.into());
}

#[frb]
pub enum ExecutionPolicyInput {
    NetworkFirst,
    CacheFirst,
}

impl From<ExecutionPolicyInput> for ExecutionPolicy {
    fn from(value: ExecutionPolicyInput) -> Self {
        match value {
            ExecutionPolicyInput::NetworkFirst => ExecutionPolicy::NetworkFirst,
            ExecutionPolicyInput::CacheFirst => ExecutionPolicy::CacheFirst,
        }
    }
}

impl From<ObservedRefInput> for ObservedRef {
    fn from(r: ObservedRefInput) -> Self {
        ObservedRef {
            observable_id: r.observable_id,
            anchor: r.anchor,
        }
    }
}

#[frb(opaque)]
pub struct RuntimeHandle {
    pub(crate) runtime: ShalomRuntime,
    pub(crate) link: Arc<HostLink>,
}

// ---------------------------------------------------------------------------
// Init
// ---------------------------------------------------------------------------

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    flutter_rust_bridge::setup_default_user_utils();
}

/// Initialise the runtime with the schema SDL.
/// Fragment and operation SDLs are registered separately via
/// `register_operation` / `register_fragment` after init.
#[frb(sync)]
pub fn init_runtime(
    schema_sdl: String,
    config: Option<RuntimeConfigInput>,
) -> anyhow::Result<RuntimeHandle> {
    let _ = config; // no fields yet; reserved for future use
    let link = Arc::new(HostLink::new());
    let runtime = ShalomRuntime::init(&schema_sdl, Vec::new(), RuntimeConfig::default())?;
    Ok(RuntimeHandle { runtime, link })
}

// ---------------------------------------------------------------------------
// Registration
// ---------------------------------------------------------------------------

/// Pre-register a query/mutation SDL so it can be executed by name via `request`.
#[frb(sync)]
pub fn register_operation(handle: &RuntimeHandle, document: String) -> anyhow::Result<()> {
    handle.runtime.register_operation(&document)?;
    Ok(())
}

/// Pre-register a fragment SDL so it can be subscribed to via `observe_fragment`.
#[frb(sync)]
pub fn register_fragment(handle: &RuntimeHandle, document: String) -> anyhow::Result<()> {
    handle.runtime.register_fragment(&document)
}

/// Replace the GraphQL schema with a new SDL string.
///
/// Clears all registered operations/fragments and invalidates the cache.
/// Call this before `registerShalomDefinitions` on hot-reload when the schema
/// file has changed.
#[frb(sync)]
pub fn reload_schema(handle: &RuntimeHandle, schema_sdl: String) -> anyhow::Result<()> {
    handle.runtime.reload_schema(&schema_sdl)
}

// ---------------------------------------------------------------------------
// Operation subscription (network + cache)
// ---------------------------------------------------------------------------

/// Trigger a network request for a pre-registered operation and open a cache
/// subscription. Returns the subscription ID to pass to `listen_subscription`.
///
/// The network request is dispatched through the host link: Dart receives it
/// via `listen_requests`, executes it, and sends the result back via
/// `push_response` / `complete_transport`. Normalization triggers the
/// subscription automatically.
#[frb]
pub async fn request(
    handle: &RuntimeHandle,
    name: String,
    variables_json: Option<String>,
    execution_policy: ExecutionPolicyInput,
) -> anyhow::Result<u64> {
    let variables = parse_variables(variables_json)?;
    let op_ctx = handle.runtime.operation_by_name(&name)?;
    let sub_id = handle.runtime.create_operation_subscription(
        op_ctx.clone(),
        variables.clone(),
        execution_policy.into(),
    );

    // Spawn a task to drive the network round-trip and normalise the response.
    // The normalisation side-effect triggers `notify_subscribers` which pushes
    // data onto the subscription channel opened above.
    let link = handle.link.clone();
    let runtime = handle.runtime.clone();

    tokio::spawn(async move {
        let request = Request {
            query: op_ctx.query.clone(),
            variables: variables.clone().unwrap_or_default(),
            operation_name: op_ctx.get_operation_name().to_string(),
            operation_type: to_link_op_type(op_ctx.op_type()),
            headers: None,
        };

        let mut stream = link.execute(request);
        while let Some(response) = stream.next().await {
            match response {
                GraphQLResponse::Data { data, .. } => {
                    if let Err(e) =
                        runtime.normalize(&op_ctx, Value::Object(data), variables.as_ref())
                    {
                        runtime.push_subscription_error(sub_id, e);
                        break;
                    }
                }
                GraphQLResponse::Error { errors, .. } => {
                    let msg =
                        serde_json::to_string(&errors).unwrap_or_else(|_| "graphql errors".into());
                    runtime.push_subscription_error(sub_id, anyhow::anyhow!("{}", msg));
                    break;
                }
                GraphQLResponse::TransportError(err) => {
                    runtime.push_subscription_error(
                        sub_id,
                        anyhow::anyhow!("{}: {}", err.code, err.message),
                    );
                    break;
                }
            }
        }
    });

    Ok(sub_id.into())
}

// ---------------------------------------------------------------------------
// Optimistic writes
// ---------------------------------------------------------------------------

/// Write `data_json` to the cache as an optimistic response for the mutation
/// named `op_name`.  Returns an opaque write ID.  Pass this to
/// `rollback_optimistic` to undo the write.
#[frb]
pub fn write_optimistic(
    handle: &RuntimeHandle,
    op_name: String,
    data_json: String,
) -> anyhow::Result<u64> {
    let data: Value = serde_json::from_str(&data_json)?;
    handle
        .runtime
        .write_optimistic(&op_name, data)
        .map(u64::from)
}

/// Undo a previous `write_optimistic` call.  No-op if the ID is not found.
#[frb(sync)]
pub fn rollback_optimistic(handle: &RuntimeHandle, write_id: u64) -> anyhow::Result<()> {
    handle
        .runtime
        .rollback_optimistic(OptimisticWriteId::from(write_id))
}

// ---------------------------------------------------------------------------
// Fragment subscription (cache-only)
// ---------------------------------------------------------------------------

/// Open a cache subscription for a pre-registered fragment at the given anchor.
/// Returns the subscription ID to pass to `listen_subscription`.
///
/// Emits the current cached value immediately if available.
#[frb(sync)]
pub fn observe_fragment(
    handle: &RuntimeHandle,
    ref_input: ObservedRefInput,
) -> anyhow::Result<u64> {
    handle
        .runtime
        .observe_fragment(ref_input.into())
        .map(u64::from)
}

/// Rebind an existing fragment subscription to a new `ObservedRefInput`.
///
/// - Same `observable_id`: fast anchor swap, same subscription ID returned.
/// - Different `observable_id`: full teardown + new subscription, new ID returned.
#[frb(sync)]
pub fn rebind_subscription(
    handle: &RuntimeHandle,
    subscription_id: u64,
    new_ref: ObservedRefInput,
) -> anyhow::Result<u64> {
    let id = SubscriptionId::from(subscription_id);
    handle
        .runtime
        .rebind_subscription(id, new_ref.into())
        .map(u64::from)
}

// ---------------------------------------------------------------------------
// Subscription lifecycle
// ---------------------------------------------------------------------------

#[frb(sync)]
pub fn unsubscribe(handle: &RuntimeHandle, subscription_id: u64) {
    let id = SubscriptionId::from(subscription_id);
    handle.runtime.unsubscribe(&id);
}

/// Stream cache-update notifications for an existing subscription.
///
/// Errors from the cache (GraphQL errors, transport errors) are encoded as
/// `{"__error__": "<message>"}` so Dart can route them to `addError` without
/// relying on FRB's unhandled-future propagation path.
#[frb]
pub async fn listen_subscription(
    handle: &RuntimeHandle,
    subscription_id: u64,
    sink: StreamSink<String>,
) -> anyhow::Result<()> {
    let id = SubscriptionId::from(subscription_id);
    let Ok(mut stream) = handle.runtime.subscription_stream(&id) else {
        return Ok(());
    };
    while let Some(item) = stream.next().await {
        let payload = match item {
            Ok(response) => match response_to_json(response) {
                Ok(p) => p,
                Err(e) => serde_json::json!({ "__error__": e.to_string() }).to_string(),
            },
            Err(e) => serde_json::json!({ "__error__": e.to_string() }).to_string(),
        };
        if sink.add(payload).is_err() {
            break;
        }
    }
    Ok(())
}

// ---------------------------------------------------------------------------
// Host link plumbing (unchanged from V1)
// ---------------------------------------------------------------------------

/// Stream of serialised request envelopes that Dart must execute and respond to.
#[frb]
pub async fn listen_requests(
    handle: &RuntimeHandle,
    sink: StreamSink<String>,
) -> anyhow::Result<()> {
    let Some(mut stream) = handle.link.take_request_stream() else {
        return Err(anyhow::anyhow!("request stream already taken"));
    };
    while let Some(envelope) = stream.next().await {
        let payload = serde_json::to_string(&envelope)?;
        if sink.add(payload).is_err() {
            break;
        }
    }
    Ok(())
}

#[frb]
pub fn push_response(
    handle: &RuntimeHandle,
    request_id: u64,
    response_json: String,
) -> anyhow::Result<()> {
    let response = parse_graphql_response(&response_json)?;
    handle.link.send_response(request_id, response)
}

#[frb]
pub fn push_transport_error(
    handle: &RuntimeHandle,
    request_id: u64,
    message: String,
    code: String,
    details_json: Option<String>,
) -> anyhow::Result<()> {
    let details = parse_optional_json(details_json)?;
    let response =
        GraphQLResponse::TransportError(shalom_runtime::sansio_protocols::TransportError {
            message,
            code,
            details,
        });
    handle.link.send_response(request_id, response)
}

/// Signal that all responses for `request_id` have been delivered.
#[frb]
pub fn complete_transport(handle: &RuntimeHandle, request_id: u64) {
    handle.link.complete(request_id);
}

// ---------------------------------------------------------------------------
// Private helpers
// ---------------------------------------------------------------------------

fn to_link_op_type(op_type: shalom_core::operation::types::OperationType) -> LinkOperationType {
    match op_type {
        shalom_core::operation::types::OperationType::Query => LinkOperationType::Query,
        shalom_core::operation::types::OperationType::Mutation => LinkOperationType::Mutation,
        shalom_core::operation::types::OperationType::Subscription => {
            LinkOperationType::Subscription
        }
    }
}

fn parse_variables(variables_json: Option<String>) -> anyhow::Result<Option<Map<String, Value>>> {
    let json = match variables_json {
        Some(json) => json,
        None => return Ok(None),
    };
    if json.trim().is_empty() {
        return Ok(None);
    }
    let value: Value = serde_json::from_str(&json)?;
    match value {
        Value::Object(map) => Ok(Some(map)),
        Value::Null => Ok(None),
        _ => Err(anyhow::anyhow!("variables must be a JSON object or null")),
    }
}

fn parse_optional_json(json: Option<String>) -> anyhow::Result<Option<Value>> {
    let json = match json {
        Some(j) => j,
        None => return Ok(None),
    };
    if json.trim().is_empty() {
        return Ok(None);
    }
    let value: Value = serde_json::from_str(&json)?;
    Ok(Some(value))
}

fn parse_graphql_response(response_json: &str) -> anyhow::Result<GraphQLResponse> {
    let value: Value = serde_json::from_str(response_json)?;
    let obj = value
        .as_object()
        .ok_or_else(|| anyhow::anyhow!("graphql response must be a JSON object"))?;

    let data = match obj.get("data") {
        Some(Value::Object(map)) => Some(map.clone()),
        Some(Value::Null) | None => None,
        Some(_) => {
            return Err(anyhow::anyhow!(
                "graphql response data must be an object or null"
            ))
        }
    };

    let errors = match obj.get("errors") {
        Some(Value::Array(list)) => {
            let mut parsed = Vec::with_capacity(list.len());
            for item in list {
                match item {
                    Value::Object(map) => parsed.push(map.clone()),
                    _ => {
                        return Err(anyhow::anyhow!(
                            "graphql response errors must contain objects"
                        ))
                    }
                }
            }
            Some(parsed)
        }
        Some(Value::Null) | None => None,
        Some(_) => {
            return Err(anyhow::anyhow!(
                "graphql response errors must be an array or null"
            ))
        }
    };

    let extensions = match obj.get("extensions") {
        Some(Value::Object(map)) => Some(map.clone()),
        Some(Value::Null) | None => None,
        Some(_) => {
            return Err(anyhow::anyhow!(
                "graphql response extensions must be an object or null"
            ))
        }
    };

    if let Some(data) = data {
        Ok(GraphQLResponse::Data {
            data,
            errors,
            extensions,
        })
    } else if let Some(errors) = errors {
        Ok(GraphQLResponse::Error { errors, extensions })
    } else {
        Err(anyhow::anyhow!(
            "graphql response must include data or errors"
        ))
    }
}

fn response_to_json(response: RuntimeResponse) -> anyhow::Result<String> {
    serde_json::to_string(&response).map_err(|e| anyhow::anyhow!(e))
}

// ---------------------------------------------------------------------------
// Cache read / write (Apollo-style cache update API)
// ---------------------------------------------------------------------------

/// Read the current cache for a pre-registered query operation.
///
/// Returns `None` when the data is absent or incomplete (missing refs), so
/// callers don't need to handle partial results.  The returned string is a
/// JSON object that matches the operation's selection shape.
#[frb(sync)]
pub fn read_query(
    handle: &RuntimeHandle,
    name: String,
    variables_json: Option<String>,
) -> anyhow::Result<Option<String>> {
    let variables = parse_variables(variables_json)?;
    match handle.runtime.try_read_query(&name, variables.as_ref())? {
        Some(data) => Ok(Some(serde_json::to_string(&data)?)),
        None => Ok(None),
    }
}

/// Write data to the cache for a pre-registered operation, normalizing it
/// and notifying any active subscribers.
///
/// This is a permanent write — unlike `write_optimistic` it cannot be rolled
/// back.  Use it inside a mutation's `executeWithCacheUpdate` callback to keep
/// cached lists in sync after an add / remove / reorder mutation.
#[frb(sync)]
pub fn write_query(
    handle: &RuntimeHandle,
    name: String,
    data_json: String,
    variables_json: Option<String>,
) -> anyhow::Result<()> {
    let variables = parse_variables(variables_json)?;
    let data: Value = serde_json::from_str(&data_json)?;
    handle.runtime.write_query(&name, data, variables.as_ref())
}

/// Read an entity from the cache through a fragment's selection set.
///
/// Returns `null` when the entity is absent or has missing refs.
#[frb(sync)]
pub fn read_fragment(
    handle: &RuntimeHandle,
    fragment_name: String,
    entity_key: String,
) -> anyhow::Result<Option<String>> {
    match handle
        .runtime
        .try_read_fragment(&fragment_name, &entity_key)?
    {
        Some(data) => Ok(Some(serde_json::to_string(&data)?)),
        None => Ok(None),
    }
}

/// Write entity data to the cache at [entity_key] using [fragment_name]'s
/// selection set, then notify all affected subscribers.
#[frb(sync)]
pub fn write_fragment(
    handle: &RuntimeHandle,
    fragment_name: String,
    entity_key: String,
    data_json: String,
) -> anyhow::Result<()> {
    let data: Value = serde_json::from_str(&data_json)?;
    handle
        .runtime
        .write_fragment(&fragment_name, &entity_key, data)
}

// ---------------------------------------------------------------------------
// Debug / cache inspection
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// Subscriber info (FRB-facing DTO)
// ---------------------------------------------------------------------------

/// Info about a single active observer (operation or fragment subscription).
#[frb]
pub struct ObserverInfo {
    pub id: u64,
    /// `"operation"` or `"fragment"`
    pub kind: String,
    pub name: String,
    /// For operation observers: `"query"`, `"mutation"`, or `"subscription"`.
    pub op_type: Option<String>,
    /// For fragment observers: the anchor cache key.
    pub anchor: Option<String>,
    /// Serialised JSON of the observer's variables, if any.
    pub variables_json: Option<String>,
    /// All cache keys this observer is currently watching.
    pub watched_keys: Vec<String>,
}

fn to_observer_info(s: shalom_runtime::KeySubscriberInfo) -> ObserverInfo {
    ObserverInfo {
        id: s.id,
        kind: s.kind,
        name: s.name,
        op_type: s.op_type,
        anchor: s.anchor,
        variables_json: s.variables_json,
        watched_keys: s.watched_keys,
    }
}

/// Returns a JSON object mapping each cache key to its active observer count.
///
/// Example: `{"ROOT_QUERY": 2, "User:1": 1}`
#[frb(sync)]
pub fn get_observer_counts(handle: &RuntimeHandle) -> String {
    let counts = handle.runtime.subscription_counts();
    serde_json::to_string(&counts).unwrap_or_else(|_| "{}".to_string())
}

/// Returns info about every observer currently watching [key].
#[frb(sync)]
pub fn get_key_observers(handle: &RuntimeHandle, key: String) -> Vec<ObserverInfo> {
    handle
        .runtime
        .key_subscribers(&key)
        .into_iter()
        .map(to_observer_info)
        .collect()
}

/// Returns info about ALL active observers across the entire runtime.
#[frb(sync)]
pub fn get_all_observers(handle: &RuntimeHandle) -> Vec<ObserverInfo> {
    handle
        .runtime
        .all_observers()
        .into_iter()
        .map(to_observer_info)
        .collect()
}

// ---------------------------------------------------------------------------
// Cache inspection
// ---------------------------------------------------------------------------

/// Returns all keys currently stored in the normalized cache.
#[frb(sync)]
pub fn get_cache_keys(handle: &RuntimeHandle) -> Vec<String> {
    let cache = handle.runtime.cache();
    let cache = cache.lock();
    let mut keys: Vec<String> = cache.keys().cloned().collect();
    keys.sort();
    keys
}

/// Returns a pretty-printed JSON string for the cache entry at [key],
/// or `None` if the key is not present.
///
/// `CacheValue::Ref` entries are serialised as `{"__ref": "<key>"}`.
#[frb(sync)]
pub fn get_cache_entry(handle: &RuntimeHandle, key: String) -> Option<String> {
    let cache = handle.runtime.cache();
    let cache = cache.lock();
    let record = cache.get(&key)?;
    let json_map: serde_json::Map<String, Value> = record
        .iter()
        .map(|(k, v)| (k.clone(), cache_value_to_json(v)))
        .collect();
    serde_json::to_string_pretty(&Value::Object(json_map)).ok()
}

fn cache_value_to_json(value: &shalom_runtime::cache::CacheValue) -> Value {
    use shalom_runtime::cache::CacheValue;
    match value {
        CacheValue::Scalar(v) => v.clone(),
        CacheValue::List(items) => Value::Array(items.iter().map(cache_value_to_json).collect()),
        CacheValue::Object(record) => {
            let map: serde_json::Map<String, Value> = record
                .iter()
                .map(|(k, v)| (k.clone(), cache_value_to_json(v)))
                .collect();
            Value::Object(map)
        }
        CacheValue::Ref(key) => {
            let mut map = serde_json::Map::new();
            map.insert("__ref".to_string(), Value::String(key.clone()));
            Value::Object(map)
        }
    }
}
