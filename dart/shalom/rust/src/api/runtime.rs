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

pub use serde_json::{Map, Value};

#[frb(opaque)]
pub struct RuntimeHandle {
    runtime: ShalomRuntime,
    link: Arc<HostLink>,
}

impl RuntimeHandle {
    /// Build the stream of normalized responses for a given query+variables.
    /// Transport-agnostic: the link is invoked here so ShalomRuntime stays pure.
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

fn extract_refs_from_data(data: &Value) -> Vec<String> {
    let Some(map) = data.as_object() else {
        return vec![];
    };
    let Some(Value::Array(arr)) = map.get("__used_refs") else {
        return vec![];
    };
    arr.iter()
        .filter_map(|v| v.as_str().map(str::to_string))
        .collect()
}

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    flutter_rust_bridge::setup_default_user_utils();
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

/// Stream cache-update notifications for an existing subscription.
#[frb]
pub async fn listen_subscription(
    handle: &RuntimeHandle,
    subscription_id: u64,
    sink: StreamSink<String>,
) -> anyhow::Result<()> {
    let id = SubscriptionId::from(subscription_id);
    let mut stream = handle.runtime.subscription_stream(&id)?;
    while let Some(item) = stream.next().await {
        let response = item?;
        let payload = response_to_json(response)?;
        if sink.add(payload).is_err() {
            break;
        }
    }
    Ok(())
}

pub enum NetworkPolicy {
    /// Fetch from network only; no cache subscription is set up.
    NetworkOnly,
    /// Fetch from network, emit the first response, then keep the stream alive
    /// via a cache subscription so subsequent writes to the same refs re-emit.
    NetworkFirst,
    /// Emit cached data immediately (if available), then do a network fetch.
    /// A cache subscription is set up so any future write to those refs re-emits.
    CacheFirst,
}

#[frb]
pub async fn request_op(
    handle: &RuntimeHandle,
    operation: String,
    variables_json: Option<String>,
    network_policy: NetworkPolicy,
    sink: StreamSink<String>,
) -> anyhow::Result<()> {
    let variables = parse_variables(variables_json)?;

    match network_policy {
        NetworkPolicy::NetworkOnly => {
            let mut stream = handle.request_stream(operation, variables)?;
            while let Some(item) = stream.next().await {
                let response = item?;
                if sink.add(response_to_json(response)?).is_err() {
                    break;
                }
            }
        }

        NetworkPolicy::NetworkFirst => {
            let mut stream = handle.request_stream(operation.clone(), variables.clone())?;

            // Emit first network response, then transition to cache subscription.
            let first = match stream.next().await {
                Some(r) => r?,
                None => return Ok(()),
            };
            let refs = extract_refs_from_data(&first.data);
            let op_id = first
                .operation_id
                .clone()
                .unwrap_or_else(|| operation.clone());

            if sink.add(response_to_json(first)?).is_err() {
                return Ok(());
            }

            let sub_id = SubscriptionId::from(
                handle
                    .runtime
                    .subscribe(&op_id, None, refs)
                    .map(u64::from)?,
            );
            let mut sub_stream = handle.runtime.subscription_stream(&sub_id)?;

            while let Some(item) = sub_stream.next().await {
                let response = item?;
                if sink.add(response_to_json(response)?).is_err() {
                    break;
                }
            }
            handle.runtime.unsubscribe(&sub_id);
            handle.runtime.collect_garbage();
        }

        NetworkPolicy::CacheFirst => {
            let op_ctx = handle.runtime.register_operation_from_query(&operation)?;
            let op_id = op_ctx.get_operation_name().to_string();
            let vars_map = variables.clone();

            // Try cache first.
            let maybe_cached = handle
                .runtime
                .read_from_cache(&op_ctx, vars_map.as_ref())
                .ok();

            let initial_refs = maybe_cached
                .as_ref()
                .map(|r| extract_refs_from_data(&r.data))
                .unwrap_or_default();

            let sub_id = SubscriptionId::from(
                handle
                    .runtime
                    .subscribe(&op_id, None, initial_refs)
                    .map(u64::from)?,
            );

            if let Some(cached) = maybe_cached {
                if sink.add(response_to_json(cached)?).is_err() {
                    handle.runtime.unsubscribe(&sub_id);
                    handle.runtime.collect_garbage();
                    return Ok(());
                }
            }

            // Drive the network stream for normalization; deliver via subscription.
            let mut net_stream = handle.request_stream(operation, variables)?;
            let mut sub_stream = handle.runtime.subscription_stream(&sub_id)?;
            let mut net_done = false;

            loop {
                tokio::select! {
                    net_opt = net_stream.next(), if !net_done => {
                        match net_opt {
                            None => net_done = true,
                            Some(Err(e)) => return Err(e),
                            Some(Ok(_)) => {} // normalization is a side effect of request_stream
                        }
                    }
                    sub_opt = sub_stream.next() => {
                        match sub_opt {
                            None => break,
                            Some(Ok(update)) => {
                                if sink.add(response_to_json(update)?).is_err() {
                                    break;
                                }
                            }
                            Some(Err(e)) => return Err(e),
                        }
                    }
                }
            }

            handle.runtime.unsubscribe(&sub_id);
            handle.runtime.collect_garbage();
        }
    }

    Ok(())
}

#[frb]
pub fn unsubscribe(handle: &RuntimeHandle, subscription_id: u64) {
    handle
        .runtime
        .unsubscribe(&SubscriptionId::from(subscription_id));
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
