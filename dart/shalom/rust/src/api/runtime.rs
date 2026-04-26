use std::sync::Arc;

use crate::frb_generated::StreamSink;
use flutter_rust_bridge::frb;
use tokio_stream::StreamExt;

use shalom_runtime::sansio_protocols::host::HostLink;
use shalom_runtime::sansio_protocols::{
    GraphQLLink, GraphQLResponse, OperationType as LinkOperationType, Request,
};
use shalom_runtime::{
    ObservedRef, RuntimeConfig, RuntimeResponse, ShalomRuntime, SubscriptionId,
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
#[frb]
pub fn init_runtime(
    schema_sdl: String,
    config_json: Option<String>,
) -> anyhow::Result<RuntimeHandle> {
    let link = Arc::new(HostLink::new());
    let config = parse_config(config_json)?;
    let runtime = ShalomRuntime::init(&schema_sdl, Vec::new(), config)?;
    Ok(RuntimeHandle { runtime, link })
}

// ---------------------------------------------------------------------------
// Registration
// ---------------------------------------------------------------------------

/// Pre-register a query/mutation SDL so it can be executed by name via `request`.
#[frb]
pub fn register_operation(
    handle: &RuntimeHandle,
    document: String,
) -> anyhow::Result<()> {
    handle.runtime.register_operation(&document)?;
    Ok(())
}

/// Pre-register a fragment SDL so it can be subscribed to via `observe_fragment`.
#[frb]
pub fn register_fragment(
    handle: &RuntimeHandle,
    document: String,
) -> anyhow::Result<()> {
    handle.runtime.register_fragment(&document)
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
) -> anyhow::Result<u64> {
    let variables = parse_variables(variables_json)?;
    let op_ctx = handle.runtime.operation_by_name(&name)?;
    let sub_id = handle.runtime.create_operation_subscription(op_ctx.clone(), variables.clone());

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
                    let msg = serde_json::to_string(&errors).unwrap_or_else(|_| "graphql errors".into());
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
        let response = item?;
        let payload = response_to_json(response)?;
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

fn parse_config(config_json: Option<String>) -> anyhow::Result<RuntimeConfig> {
    let json = match config_json {
        Some(json) => json,
        None => return Ok(RuntimeConfig::default()),
    };
    if json.trim().is_empty() {
        return Ok(RuntimeConfig::default());
    }
    serde_json::from_str(&json).map_err(|e| anyhow::anyhow!(e))
}

fn parse_variables(
    variables_json: Option<String>,
) -> anyhow::Result<Option<Map<String, Value>>> {
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
        Some(_) => return Err(anyhow::anyhow!("graphql response data must be an object or null")),
    };

    let errors = match obj.get("errors") {
        Some(Value::Array(list)) => {
            let mut parsed = Vec::with_capacity(list.len());
            for item in list {
                match item {
                    Value::Object(map) => parsed.push(map.clone()),
                    _ => return Err(anyhow::anyhow!("graphql response errors must contain objects")),
                }
            }
            Some(parsed)
        }
        Some(Value::Null) | None => None,
        Some(_) => return Err(anyhow::anyhow!("graphql response errors must be an array or null")),
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
        Ok(GraphQLResponse::Data { data, errors, extensions })
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
