use crate::api::json::ShalomJsonValue;
use crate::api::runtime::GraphQlResponseInput;
use flutter_rust_bridge::frb;
use serde_json::Value;

use shalom_runtime::sansio_protocols::ws::{WsEvent, WsStateMachine};

/// Dart-facing wrapper around `WsStateMachine`.
///
/// One instance per WebSocket connection. Create on connect, call `reset()`
/// on reconnect (preserves active op ids for re-subscription).
#[frb(opaque)]
pub struct WsSansIo {
    inner: WsStateMachine,
}

// ─── FRB event enum ──────────────────────────────────────────────────────────
// FRB maps this Rust enum to a Dart sealed class hierarchy, giving Dart
// exhaustive pattern matching without any JSON string parsing at dispatch time.
//
/// Events emitted by the sans-IO WebSocket state machine.
#[frb(sync)]
pub enum WsLinkEvent {
    /// Connection acknowledged — safe to flush pending operations.
    Connected,
    /// Server sent a Ping.  Send back the frame from `ws_pong_frame()`.
    PingReceived { payload: Option<ShalomJsonValue> },
    /// Server sent a Pong — typically in response to a caller-initiated
    /// heartbeat `ws_ping_frame()`. Caller should cancel any pending
    /// pong-timeout timer.
    PongReceived { payload: Option<ShalomJsonValue> },
    /// A data / error payload arrived for `op_id`, already parsed by the
    /// `graphql-transport-ws` state machine.
    OperationResponse {
        op_id: String,
        response: GraphQlResponseInput,
    },
    /// The server has finished sending data for `op_id`.
    OperationComplete { op_id: String },
    /// Protocol violation — close the WebSocket with `code`.
    ProtocolError { code: u16, reason: String },
}

impl WsLinkEvent {
    fn from_ws_event(event: WsEvent) -> Self {
        match event {
            WsEvent::Connected { ack_payload } => {
                let _ = ack_payload; // ack payload rarely used; expose if needed later
                Self::Connected
            }
            WsEvent::PingReceived { payload } => Self::PingReceived {
                payload: payload.map(ShalomJsonValue::from),
            },
            WsEvent::PongReceived { payload } => Self::PongReceived {
                payload: payload.map(ShalomJsonValue::from),
            },
            WsEvent::OperationResponse { op_id, response } => Self::OperationResponse {
                op_id,
                response: response.into(),
            },
            WsEvent::OperationComplete { op_id } => Self::OperationComplete { op_id },
            WsEvent::ProtocolError { code, reason } => Self::ProtocolError { code, reason },
        }
    }
}

// ─── FRB API ─────────────────────────────────────────────────────────────────

/// Create a new sans-IO state machine.
///
/// `connection_params` — optional JSON object forwarded as the
/// `connection_init` payload (e.g. `{"Authorization":"Bearer …"}`).
#[frb(sync)]
pub fn create_ws_sans_io(connection_params: Option<ShalomJsonValue>) -> anyhow::Result<WsSansIo> {
    let params = connection_params.map(Value::from);
    Ok(WsSansIo {
        inner: WsStateMachine::new(params),
    })
}

/// The `connection_init` frame to send immediately after the socket opens.
#[frb(sync)]
pub fn ws_connection_init_frame(sansio: &WsSansIo) -> String {
    sansio.inner.connection_init_frame()
}

/// Build a `subscribe` frame for a new operation and register it internally.
///
/// `variables` — optional JSON object of operation variables.
#[frb(sync)]
pub fn ws_subscribe_frame(
    sansio: &mut WsSansIo,
    op_id: String,
    query: String,
    variables: Option<ShalomJsonValue>,
    operation_name: Option<String>,
) -> anyhow::Result<String> {
    let variables = variables
        .map(|value| value.into_object("variables"))
        .transpose()?;
    Ok(sansio
        .inner
        .subscribe_frame(op_id, query, variables, operation_name))
}

/// Build a `complete` frame to cancel an in-flight operation.
#[frb(sync)]
pub fn ws_complete_frame(sansio: &mut WsSansIo, op_id: String) -> String {
    sansio.inner.complete_frame(&op_id)
}

/// Build a `pong` frame in response to a server `ping`.
///
/// `payload` — the payload from the `PingReceived` event, if any.
#[frb(sync)]
pub fn ws_pong_frame(
    sansio: &WsSansIo,
    payload: Option<ShalomJsonValue>,
) -> anyhow::Result<String> {
    let payload = payload.map(Value::from);
    Ok(sansio.inner.pong_frame(payload))
}

/// Build a `ping` frame to send to the server.
#[frb(sync)]
pub fn ws_ping_frame() -> String {
    r#"{"type":"ping"}"#.to_string()
}

/// Process a raw text frame received from the server.
///
/// Returns a list of typed events for Dart to dispatch on.
/// On a protocol error returns `Err` — caller should close the socket.
#[frb(sync)]
pub fn ws_on_message(sansio: &mut WsSansIo, raw: String) -> anyhow::Result<Vec<WsLinkEvent>> {
    let events = sansio
        .inner
        .on_message(&raw)
        .map_err(|e| anyhow::anyhow!("protocol error {}: {}", e.code, e.reason))?;

    Ok(events.into_iter().map(WsLinkEvent::from_ws_event).collect())
}

/// Reset connection state for reconnect. Preserves active operation ids.
#[frb(sync)]
pub fn ws_reset(sansio: &mut WsSansIo) {
    sansio.inner.reset();
}

/// Whether the connection has been acknowledged.
#[frb(sync)]
pub fn ws_is_connected(sansio: &WsSansIo) -> bool {
    sansio.inner.is_connected()
}

/// All currently registered operation ids (active + pending-reconnect).
#[frb(sync)]
pub fn ws_active_operation_ids(sansio: &WsSansIo) -> Vec<String> {
    sansio.inner.active_operation_ids()
}
