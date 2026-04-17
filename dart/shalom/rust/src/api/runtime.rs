use std::sync::Arc;

use crate::frb_generated::StreamSink;
use flutter_rust_bridge::frb;
use tokio_stream::StreamExt;

use shalom_runtime::sansio_protocols::host::HostLink;
use shalom_runtime::sansio_protocols::{
    GraphQLLink, GraphQLResponse, OperationType as LinkOperationType, Request,
};
use shalom_runtime::{
    RuntimeConfig, RuntimeResponse, RuntimeResponseStream, ShalomRuntime, SubscriptionId,
};

// Re-exported so that `frb_generated.rs` (which does `use crate::api::runtime::*`) can
// reference these types by name in the generated codec impls.
pub use serde_json::{Map, Value};

#[frb(opaque)]
pub struct RuntimeHandle {
    runtime: ShalomRuntime,
    link: Arc<HostLink>,
}

impl RuntimeHandle {
    /// Build the stream of normalized responses for a given query+variables.
    /// The link is invoked here, in the handle, rather than inside ShalomRuntime,
    /// so that ShalomRuntime remains transport-agnostic.
    /// Not exposed via FRB — used internally by the `request` function.
    pub(crate) fn request_stream(
        &self,
        query: String,
        variables: Option<Map<String, Value>>,
    ) -> anyhow::Result<RuntimeResponseStream> {
        let op_ctx = self.runtime.register_operation_from_query(&query)?;
        let operation_name = op_ctx.get_operation_name().to_string();
        let operation_id = operation_name.clone();
        let variables_map = variables.clone().unwrap_or_default();
        let request = Request {
            query,
            variables: variables_map,
            operation_name,
            operation_type: to_link_op_type(op_ctx.op_type()),
            headers: None,
        };

        let runtime = self.runtime.clone();
        let vars = variables;
        let op_ctx = op_ctx.clone();
        let stream = self
            .link
            .execute(request)
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
}

fn to_link_op_type(op_type: shalom_core::operation::types::OperationType) -> LinkOperationType {
    match op_type {
        shalom_core::operation::types::OperationType::Query => LinkOperationType::Query,
        shalom_core::operation::types::OperationType::Mutation => LinkOperationType::Mutation,
        shalom_core::operation::types::OperationType::Subscription => {
            LinkOperationType::Subscription
        }
    }
}

#[frb]
pub fn init_runtime(
    schema_sdl: String,
    fragment_sdls: Vec<String>,
    config_json: Option<String>,
) -> anyhow::Result<RuntimeHandle> {
    let link = Arc::new(HostLink::new());
    let config = parse_config(config_json)?;
    let runtime = ShalomRuntime::init(&schema_sdl, fragment_sdls, config)?;
    Ok(RuntimeHandle { runtime, link })
}

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
pub async fn request(
    handle: &RuntimeHandle,
    query: String,
    variables_json: Option<String>,
) -> anyhow::Result<String> {
    let variables = parse_variables(variables_json)?;
    let mut stream = handle.request_stream(query, variables)?;
    let response = match stream.next().await {
        Some(Ok(r)) => r,
        Some(Err(e)) => return Err(e),
        None => return Err(anyhow::anyhow!("link stream closed without response")),
    };
    response_to_json(response)
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
/// Drops the sender, which closes the Rust-side stream for that operation.
#[frb]
pub fn complete_transport(handle: &RuntimeHandle, request_id: u64) {
    handle.link.complete(request_id);
}

#[frb(sync)]
pub fn init_subscription(
    handle: &RuntimeHandle,
    target_id: String,
    root_ref: Option<String>,
    refs: Vec<String>,
) -> anyhow::Result<u64> {
    handle
        .runtime
        .subscribe(&target_id, root_ref, refs)
        .map(|o| o.into())
}

#[frb]
pub async fn subscribe(
    handle: &RuntimeHandle,
    sink: StreamSink<String>,
    subscription_id: u64,
) -> anyhow::Result<()> {
    let mut stream = handle.runtime.subscription_stream(&subscription_id)?;
    let result: anyhow::Result<()> = async {
        while let Some(response) = stream.next().await {
            let response = response?;
            let payload = response_to_json(response)?;
            if sink.add(payload).is_err() {
                break;
            }
        }
        Ok(())
    }
    .await;
    handle.runtime.unsubscribe(&sub_id);
    handle.runtime.collect_garbage();
    result
}

#[frb]
pub fn unsubscribe(handle: &RuntimeHandle, subscription_id: u64) {
    handle
        .runtime
        .unsubscribe(&SubscriptionId::from(subscription_id));
    // Run GC after unsubscribing so cache entries with no active watchers
    // are evicted promptly rather than accumulating.
    handle.runtime.collect_garbage();
}

fn parse_config(config_json: Option<String>) -> anyhow::Result<RuntimeConfig> {
    let json = match config_json {
        Some(json) => json,
        None => return Ok(RuntimeConfig::default()),
    };
    if json.trim().is_empty() {
        return Ok(RuntimeConfig::default());
    }
    serde_json::from_str(&json).map_err(|err| anyhow::anyhow!(err))
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

fn parse_optional_json(details_json: Option<String>) -> anyhow::Result<Option<Value>> {
    let json = match details_json {
        Some(json) => json,
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
    serde_json::to_string(&response).map_err(|err| anyhow::anyhow!(err))
}
