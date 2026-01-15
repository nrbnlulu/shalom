use std::sync::Arc;

use crate::frb_generated::StreamSink;
use flutter_rust_bridge::frb;
use serde_json::{Map, Value};
use tokio_stream::StreamExt;

use shalom_runtime::link::host::HostLink;
use shalom_runtime::link::GraphQLResponse;
use shalom_runtime::{RuntimeConfig, RuntimeResponse, ShalomRuntime, SubscriptionId};

#[frb(opaque)]
pub struct RuntimeHandle {
    runtime: ShalomRuntime,
    link: Arc<HostLink>,
}

#[frb]
pub fn init_runtime(
    schema_sdl: String,
    fragment_sdls: Vec<String>,
    config_json: Option<String>,
) -> anyhow::Result<RuntimeHandle> {
    let link = HostLink::new();
    let config = parse_config(config_json)?;
    let runtime = ShalomRuntime::init(&schema_sdl, fragment_sdls, config, link.clone())?;
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
    let response = handle.runtime.request(query, variables).await?;
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
    let response = GraphQLResponse::TransportError(shalom_runtime::link::TransportError {
        message,
        code,
        details,
    });
    handle.link.send_response(request_id, response)
}

#[frb]
pub fn subscribe(
    handle: &RuntimeHandle,
    target_id: String,
    root_ref: Option<String>,
    refs: Vec<String>,
) -> anyhow::Result<u64> {
    handle
        .runtime
        .subscribe(&target_id, root_ref, refs)
        .map(u64::from)
}

#[frb]
pub async fn listen_updates(
    handle: &RuntimeHandle,
    subscription_id: u64,
    sink: StreamSink<String>,
) -> anyhow::Result<()> {
    let mut stream = handle
        .runtime
        .subscription_stream(SubscriptionId::from(subscription_id))?;
    let result = async {
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
    handle
        .runtime
        .unsubscribe(SubscriptionId::from(subscription_id));
    result
}

#[frb]
pub fn unsubscribe(handle: &RuntimeHandle, subscription_id: u64) {
    handle
        .runtime
        .unsubscribe(SubscriptionId::from(subscription_id))
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
