use std::sync::Arc;

use crate::api::json::ShalomJsonValue;
use crate::frb_generated::StreamSink;
use flutter_rust_bridge::frb;
use tokio_stream::StreamExt;

use shalom_runtime::sansio_protocols::GraphQLResponse;
use shalom_runtime::sansio_protocols::host::HostLink;
use shalom_runtime::{
    ExecutionPolicy, ObservedRef, OptimisticWriteId, RuntimeConfig, ShalomRuntime,
    SubscriptionError, SubscriptionId,
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

/// Dart-facing runtime configuration.
#[frb]
pub struct RuntimeConfigInput {
    /// How often (in milliseconds) the background thread sweeps the cache for
    /// unreferenced entries. Defaults to 2000ms if not set.
    pub gc_interval_ms: Option<u64>,
    /// How long (in milliseconds) a cache key is kept alive via a "fake"
    /// subscriber after its last real subscriber unsubscribes, before it
    /// becomes eligible for GC eviction. Defaults to 0 (no grace period).
    pub retention_grace_ms: Option<u64>,
    /// Default delay (in milliseconds) before retrying an operation after a
    /// transport error, for operations that don't override it via `request`'s
    /// `retry_delay` param. Defaults to no auto-retry.
    pub default_retry_delay_ms: Option<u64>,
}

impl From<RuntimeConfigInput> for RuntimeConfig {
    fn from(value: RuntimeConfigInput) -> Self {
        let default = RuntimeConfig::default();
        Self {
            gc_interval: value
                .gc_interval_ms
                .map(std::time::Duration::from_millis)
                .unwrap_or(default.gc_interval),
            retention_grace: value
                .retention_grace_ms
                .map(std::time::Duration::from_millis)
                .unwrap_or(default.retention_grace),
            default_retry_delay: value
                .default_retry_delay_ms
                .map(std::time::Duration::from_millis)
                .or(default.default_retry_delay),
        }
    }
}

/// Per-call override for an operation's retry-on-transport-error delay.
/// Passed to `request`; defaults to `Inherit` (use `RuntimeConfig::default_retry_delay`).
#[frb]
pub enum RetryDelayInput {
    /// Use the runtime's globally configured default (may itself be "off").
    Inherit,
    /// Disable auto-retry for this operation, regardless of the global default.
    Disabled,
    /// Retry after this many milliseconds, overriding the global default.
    Millis(u64),
}

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

/// FRB-compatible event type for subscription streams. Structured to represent
/// both successful data and explicit error states (GraphQL or transport errors).
#[frb]
pub enum SubscriptionEvent {
    Data {
        data: ShalomJsonValue,
    },
    GraphQlError {
        errors: Vec<ShalomJsonValue>,
        extensions: Option<ShalomJsonValue>,
    },
    TransportError {
        code: String,
        message: String,
        details: Option<ShalomJsonValue>,
    },
}

/// FRB representation of a complete GraphQL response.
///
/// HTTP responses reach the runtime as their raw JSON body and are parsed by
/// [push_response]. WebSocket protocol handling has already parsed a `next`
/// payload, so it uses this type to avoid serialising that response back to
/// JSON before handing it to the runtime.
#[frb]
pub enum GraphQlResponseInput {
    Data {
        data: ShalomJsonValue,
        errors: Option<Vec<ShalomJsonValue>>,
        extensions: Option<ShalomJsonValue>,
    },
    Error {
        errors: Vec<ShalomJsonValue>,
        extensions: Option<ShalomJsonValue>,
    },
    TransportError {
        message: String,
        code: String,
        details: Option<ShalomJsonValue>,
    },
}

impl From<GraphQLResponse> for GraphQlResponseInput {
    fn from(response: GraphQLResponse) -> Self {
        match response {
            GraphQLResponse::Data {
                data,
                errors,
                extensions,
            } => Self::Data {
                data: ShalomJsonValue::from(Value::Object(data)),
                errors: errors.map(|errors| {
                    errors
                        .into_iter()
                        .map(|error| ShalomJsonValue::from(Value::Object(error)))
                        .collect()
                }),
                extensions: extensions
                    .map(|extensions| ShalomJsonValue::from(Value::Object(extensions))),
            },
            GraphQLResponse::Error { errors, extensions } => Self::Error {
                errors: errors
                    .into_iter()
                    .map(|error| ShalomJsonValue::from(Value::Object(error)))
                    .collect(),
                extensions: extensions
                    .map(|extensions| ShalomJsonValue::from(Value::Object(extensions))),
            },
            GraphQLResponse::TransportError(error) => Self::TransportError {
                message: error.message,
                code: error.code,
                details: error.details.map(ShalomJsonValue::from),
            },
        }
    }
}

impl TryFrom<GraphQlResponseInput> for GraphQLResponse {
    type Error = anyhow::Error;

    fn try_from(response: GraphQlResponseInput) -> Result<Self, anyhow::Error> {
        match response {
            GraphQlResponseInput::Data {
                data,
                errors,
                extensions,
            } => Ok(Self::Data {
                data: data.into_object("graphql response data")?,
                errors: errors
                    .map(|errors| {
                        errors
                            .into_iter()
                            .map(|error| error.into_object("graphql response error"))
                            .collect()
                    })
                    .transpose()?,
                extensions: extensions
                    .map(|extensions| extensions.into_object("graphql response extensions"))
                    .transpose()?,
            }),
            GraphQlResponseInput::Error { errors, extensions } => Ok(Self::Error {
                errors: errors
                    .into_iter()
                    .map(|error| error.into_object("graphql response error"))
                    .collect::<anyhow::Result<_>>()?,
                extensions: extensions
                    .map(|extensions| extensions.into_object("graphql response extensions"))
                    .transpose()?,
            }),
            GraphQlResponseInput::TransportError {
                message,
                code,
                details,
            } => Ok(Self::TransportError(
                shalom_runtime::sansio_protocols::TransportError {
                    message,
                    code,
                    details: details.map(Value::from),
                },
            )),
        }
    }
}

/// A runtime request ready for Dart's transport layer.
#[frb]
pub struct RequestEnvelopeInput {
    pub id: u64,
    pub query: String,
    pub variables: ShalomJsonValue,
    pub operation_name: String,
    pub operation_type: String,
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
    let config = config.map(RuntimeConfig::from).unwrap_or_default();
    let link = Arc::new(HostLink::new());
    let runtime = ShalomRuntime::init(&schema_sdl, Vec::new(), config)?;
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
    variables: Option<ShalomJsonValue>,
    execution_policy: ExecutionPolicyInput,
    retry_delay: RetryDelayInput,
    refetch_interval_ms: Option<u64>,
) -> anyhow::Result<u64> {
    let variables = parse_variables(variables)?;
    let op_ctx = handle.runtime.operation_by_name(&name)?;

    let retry_delay = match retry_delay {
        RetryDelayInput::Inherit => handle.runtime.default_retry_delay(),
        RetryDelayInput::Disabled => None,
        RetryDelayInput::Millis(ms) => Some(std::time::Duration::from_millis(ms)),
    };
    let refetch_interval = refetch_interval_ms.map(std::time::Duration::from_millis);

    let sub_id = handle.runtime.execute_operation(
        op_ctx,
        variables,
        execution_policy.into(),
        handle.link.clone(),
        retry_delay,
        refetch_interval,
    );

    Ok(sub_id.into())
}

/// Execute a pre-registered mutation exactly once and return its result
/// directly — no subscription, no stream. The response is still written
/// into the shared entity cache (notifying any other reactive subscriptions
/// watching the same entities), but this call can never itself observe a
/// stale/optimistic value from an unrelated concurrent write, since it
/// isn't registered in the reactive subscription registry.
#[frb]
pub async fn mutate(
    handle: &RuntimeHandle,
    name: String,
    variables: Option<ShalomJsonValue>,
    retry_delay: RetryDelayInput,
) -> anyhow::Result<SubscriptionEvent> {
    let variables = parse_variables(variables)?;
    let op_ctx = handle.runtime.operation_by_name(&name)?;

    let retry_delay = match retry_delay {
        RetryDelayInput::Inherit => handle.runtime.default_retry_delay(),
        RetryDelayInput::Disabled => None,
        RetryDelayInput::Millis(ms) => Some(std::time::Duration::from_millis(ms)),
    };

    let event = match handle
        .runtime
        .execute_mutation(op_ctx, variables, handle.link.clone(), retry_delay)
        .await
    {
        Ok(response) => SubscriptionEvent::Data {
            data: ShalomJsonValue::from(response.data),
        },
        Err(SubscriptionError::GraphQL { errors, extensions }) => SubscriptionEvent::GraphQlError {
            errors: errors
                .into_iter()
                .map(|error| ShalomJsonValue::from(Value::Object(error)))
                .collect(),
            extensions: extensions.map(|value| ShalomJsonValue::from(Value::Object(value))),
        },
        Err(SubscriptionError::Transport {
            message,
            code,
            details,
        }) => SubscriptionEvent::TransportError {
            code,
            message,
            details: details.map(ShalomJsonValue::from),
        },
    };

    Ok(event)
}

// ---------------------------------------------------------------------------
// Optimistic writes
// ---------------------------------------------------------------------------

/// Write `data` to the cache as an optimistic response for the mutation
/// named `op_name`.  Returns an opaque write ID.  Pass this to
/// `rollback_optimistic` to undo the write.
#[frb]
pub async fn write_optimistic(
    handle: &RuntimeHandle,
    op_name: String,
    data: ShalomJsonValue,
) -> anyhow::Result<u64> {
    handle
        .runtime
        .write_optimistic(&op_name, Value::from(data))
        .map(u64::from)
}

/// Undo a previous `write_optimistic` call.  No-op if the ID is not found.
#[frb]
pub async fn rollback_optimistic(handle: &RuntimeHandle, write_id: u64) -> anyhow::Result<()> {
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
#[frb]
pub async fn observe_fragment(
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
#[frb]
pub async fn rebind_subscription(
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

#[frb]
pub async fn unsubscribe(handle: &RuntimeHandle, subscription_id: u64) {
    let id = SubscriptionId::from(subscription_id);
    handle.runtime.unsubscribe(&id);
}

/// Stream cache-update notifications for an existing subscription.
/// Emits structured SubscriptionEvent carrying either data or typed errors.
#[frb]
pub async fn listen_subscription(
    handle: &RuntimeHandle,
    subscription_id: u64,
    sink: StreamSink<SubscriptionEvent>,
) -> anyhow::Result<()> {
    let id = SubscriptionId::from(subscription_id);
    let Ok(mut stream) = handle.runtime.subscription_stream(&id) else {
        return Ok(());
    };
    while let Some(item) = stream.next().await {
        let event = match item {
            Ok(response) => SubscriptionEvent::Data {
                data: ShalomJsonValue::from(response.data),
            },
            Err(err) => match err {
                SubscriptionError::GraphQL { errors, extensions } => {
                    SubscriptionEvent::GraphQlError {
                        errors: errors
                            .into_iter()
                            .map(|error| ShalomJsonValue::from(Value::Object(error)))
                            .collect(),
                        extensions: extensions
                            .map(|value| ShalomJsonValue::from(Value::Object(value))),
                    }
                }
                SubscriptionError::Transport {
                    message,
                    code,
                    details,
                } => SubscriptionEvent::TransportError {
                    code,
                    message,
                    details: details.map(ShalomJsonValue::from),
                },
            },
        };
        if sink.add(event).is_err() {
            break;
        }
    }
    Ok(())
}

// ---------------------------------------------------------------------------
// Host link plumbing (unchanged from V1)
// ---------------------------------------------------------------------------

/// Stream of request envelopes that Dart must execute and respond to.
#[frb]
pub async fn listen_requests(
    handle: &RuntimeHandle,
    sink: StreamSink<RequestEnvelopeInput>,
) -> anyhow::Result<()> {
    let Some(mut stream) = handle.link.take_request_stream() else {
        return Err(anyhow::anyhow!("request stream already taken"));
    };
    while let Some(envelope) = stream.next().await {
        let request = envelope.request;
        let payload = RequestEnvelopeInput {
            id: envelope.id,
            query: request.query,
            variables: ShalomJsonValue::from(Value::Object(request.variables)),
            operation_name: request.operation_name,
            operation_type: match request.operation_type {
                shalom_runtime::sansio_protocols::OperationType::Query => "Query",
                shalom_runtime::sansio_protocols::OperationType::Mutation => "Mutation",
                shalom_runtime::sansio_protocols::OperationType::Subscription => "Subscription",
            }
            .to_string(),
        };
        if sink.add(payload).is_err() {
            break;
        }
    }
    Ok(())
}

#[frb]
pub async fn push_response(
    handle: &RuntimeHandle,
    request_id: u64,
    response_json: String,
) -> anyhow::Result<()> {
    let response = parse_graphql_response(&response_json)?;
    handle.link.send_response(request_id, response)
}

/// Deliver a GraphQL response which was already parsed by a transport
/// protocol implementation (currently `graphql-transport-ws`).
#[frb]
pub async fn push_response_value(
    handle: &RuntimeHandle,
    request_id: u64,
    response: GraphQlResponseInput,
) -> anyhow::Result<()> {
    handle.link.send_response(request_id, response.try_into()?)
}

#[frb]
pub async fn push_graphql_error(
    handle: &RuntimeHandle,
    request_id: u64,
    errors: Vec<ShalomJsonValue>,
    extensions: Option<ShalomJsonValue>,
) -> anyhow::Result<()> {
    let errors = errors
        .into_iter()
        .map(|error| error.into_object("graphql error"))
        .collect::<anyhow::Result<Vec<_>>>()?;
    let extensions = extensions
        .map(|value| value.into_object("graphql extensions"))
        .transpose()?;
    handle
        .link
        .send_response(request_id, GraphQLResponse::Error { errors, extensions })
}

#[frb]
pub async fn push_transport_error(
    handle: &RuntimeHandle,
    request_id: u64,
    message: String,
    code: String,
    details: Option<ShalomJsonValue>,
) -> anyhow::Result<()> {
    let response =
        GraphQLResponse::TransportError(shalom_runtime::sansio_protocols::TransportError {
            message,
            code,
            details: details.map(Value::from),
        });
    handle.link.send_response(request_id, response)
}

/// Signal that all responses for `request_id` have been delivered.
#[frb]
pub async fn complete_transport(handle: &RuntimeHandle, request_id: u64) {
    handle.link.complete(request_id);
}

// ---------------------------------------------------------------------------
// Private helpers
// ---------------------------------------------------------------------------

fn parse_variables(
    variables: Option<ShalomJsonValue>,
) -> anyhow::Result<Option<Map<String, Value>>> {
    let value = match variables {
        Some(value) => value,
        None => return Ok(None),
    };
    let variables = value.into_object("variables")?;
    Ok((!variables.is_empty()).then_some(variables))
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
            ));
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
                        ));
                    }
                }
            }
            Some(parsed)
        }
        Some(Value::Null) | None => None,
        Some(_) => {
            return Err(anyhow::anyhow!(
                "graphql response errors must be an array or null"
            ));
        }
    };

    let extensions = match obj.get("extensions") {
        Some(Value::Object(map)) => Some(map.clone()),
        Some(Value::Null) | None => None,
        Some(_) => {
            return Err(anyhow::anyhow!(
                "graphql response extensions must be an object or null"
            ));
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

// ---------------------------------------------------------------------------
// Cache read / write (Apollo-style cache update API)
// ---------------------------------------------------------------------------

/// Read the current cache for a pre-registered query operation.
///
/// Returns `None` when the data is absent or incomplete (missing refs), so
/// callers don't need to handle partial results.
#[frb]
pub async fn read_operation(
    handle: &RuntimeHandle,
    name: String,
    variables: Option<ShalomJsonValue>,
) -> anyhow::Result<Option<ShalomJsonValue>> {
    let variables = parse_variables(variables)?;
    match handle
        .runtime
        .try_read_operation(&name, variables.as_ref())?
    {
        Some(data) => Ok(Some(ShalomJsonValue::from(data))),
        None => Ok(None),
    }
}

/// Write data to the cache for a pre-registered operation, normalizing it
/// and notifying any active subscribers.
///
/// This is a permanent write — unlike `write_optimistic` it cannot be rolled
/// back.  Use it inside a mutation's `executeWithCacheUpdate` callback to keep
/// cached lists in sync after an add / remove / reorder mutation.
#[frb]
pub async fn write_operation(
    handle: &RuntimeHandle,
    name: String,
    data: ShalomJsonValue,
    variables: Option<ShalomJsonValue>,
) -> anyhow::Result<()> {
    let variables = parse_variables(variables)?;
    handle
        .runtime
        .write_operation(&name, Value::from(data), variables.as_ref())
}

/// Evict a pre-registered operation's cached root field(s) (matched by
/// `variables`) and notify any active subscribers.
///
/// Only unlinks the operation's own root entry — entities it referenced are
/// reclaimed by the next GC sweep if nothing else keeps them reachable.
/// Returns `false` if no matching cache entry existed.
#[frb]
pub async fn evict_operation(
    handle: &RuntimeHandle,
    name: String,
    variables: Option<ShalomJsonValue>,
) -> anyhow::Result<bool> {
    let variables = parse_variables(variables)?;
    handle.runtime.evict_operation(&name, variables.as_ref())
}

/// Read an entity from the cache through a fragment's selection set.
///
/// Returns `null` when the entity is absent or has missing refs.
#[frb]
pub async fn read_fragment(
    handle: &RuntimeHandle,
    fragment_name: String,
    entity_key: String,
) -> anyhow::Result<Option<ShalomJsonValue>> {
    match handle
        .runtime
        .try_read_fragment(&fragment_name, &entity_key)?
    {
        Some(data) => Ok(Some(ShalomJsonValue::from(data))),
        None => Ok(None),
    }
}

/// Write entity data to the cache at [entity_key] using [fragment_name]'s
/// selection set, then notify all affected subscribers.
#[frb]
pub async fn write_fragment(
    handle: &RuntimeHandle,
    fragment_name: String,
    entity_key: String,
    data: ShalomJsonValue,
) -> anyhow::Result<()> {
    handle
        .runtime
        .write_fragment(&fragment_name, &entity_key, Value::from(data))
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

/// Returns a map from each cache key to its active observer count.
///
/// Example: `{"ROOT_QUERY": 2, "User:1": 1}`
#[frb]
pub async fn get_observer_counts(handle: &RuntimeHandle) -> std::collections::HashMap<String, u32> {
    handle
        .runtime
        .subscription_counts()
        .into_iter()
        .map(|(key, count)| (key, count.min(u32::MAX as usize) as u32))
        .collect()
}

/// Returns info about every observer currently watching [key].
#[frb]
pub async fn get_key_observers(handle: &RuntimeHandle, key: String) -> Vec<ObserverInfo> {
    handle
        .runtime
        .key_subscribers(&key)
        .into_iter()
        .map(to_observer_info)
        .collect()
}

/// Returns info about ALL active observers across the entire runtime.
#[frb]
pub async fn get_all_observers(handle: &RuntimeHandle) -> Vec<ObserverInfo> {
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
#[frb]
pub async fn get_cache_keys(handle: &RuntimeHandle) -> Vec<String> {
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
#[frb]
pub async fn get_cache_entry(handle: &RuntimeHandle, key: String) -> Option<String> {
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
