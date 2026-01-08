use std::sync::Arc;

use flutter_rust_bridge::frb;
use serde_json::{Map, Value};
use tokio_stream::wrappers::UnboundedReceiverStream;

use shalom_runtime::link::host::{HostLink, RequestEnvelope};
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
    config: RuntimeConfig,
) -> anyhow::Result<RuntimeHandle> {
    let link = HostLink::new();
    let runtime = ShalomRuntime::init(&schema_sdl, fragment_sdls, config, link.clone())?;
    Ok(RuntimeHandle { runtime, link })
}

#[frb]
pub fn take_request_stream(
    handle: &RuntimeHandle,
) -> Option<UnboundedReceiverStream<RequestEnvelope>> {
    handle.link.take_request_stream()
}

#[frb]
pub async fn request(
    handle: &RuntimeHandle,
    query: String,
    variables: Option<Map<String, Value>>,
) -> anyhow::Result<RuntimeResponse> {
    handle.runtime.request(query, variables).await
}

#[frb]
pub fn push_response(
    handle: &RuntimeHandle,
    request_id: u64,
    response: GraphQLResponse,
) -> anyhow::Result<()> {
    handle.link.send_response(request_id, response)
}

#[frb]
pub fn subscribe(
    handle: &RuntimeHandle,
    operation_id: String,
    refs: Vec<String>,
) -> anyhow::Result<u64> {
    handle.runtime.subscribe(&operation_id, refs).map(u64::from)
}

#[frb]
pub fn drain_updates(handle: &RuntimeHandle, subscription_id: u64) -> Vec<RuntimeResponse> {
    handle
        .runtime
        .drain_updates(SubscriptionId::from(subscription_id))
}

#[frb]
pub fn unsubscribe(handle: &RuntimeHandle, subscription_id: u64) {
    handle
        .runtime
        .unsubscribe(SubscriptionId::from(subscription_id))
}
