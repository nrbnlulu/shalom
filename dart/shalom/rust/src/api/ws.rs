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
// Complex nested payloads (GraphQL data / errors / extensions, ping payloads)
// are kept as JSON strings because serde_json::Value / Map are not directly
// bridgeable by FRB.

/// Events emitted by the sans-IO WebSocket state machine.
#[frb(sync)]
pub enum WsLinkEvent {
    /// Connection acknowledged — safe to flush pending operations.
    Connected,
    /// Server sent a Ping.  Send back the frame from `ws_pong_frame()`.
    /// `payload_json` is the raw ping payload (JSON object or null string).
    PingReceived { payload_json: Option<String> },
    /// A data / error payload arrived for `op_id`.
    /// `data_json`       — JSON object (`{"field":…}`) or null.
    /// `errors_json`     — JSON array  (`[{"message":…}]`) or null.
    /// `extensions_json` — JSON object or null.
    OperationResponse {
        op_id: String,
        data_json: Option<String>,
        errors_json: Option<String>,
        extensions_json: Option<String>,
    },
    /// The server has finished sending data for `op_id`.
    OperationComplete { op_id: String },
    /// Protocol violation — close the WebSocket with `code`.
    ProtocolError { code: u16, reason: String },
}

fn opt_value_to_json(v: Option<Value>) -> Option<String> {
    v.and_then(|val| serde_json::to_string(&val).ok())
}

impl WsLinkEvent {
    fn from_ws_event(event: WsEvent) -> Self {
        match event {
            WsEvent::Connected { ack_payload } => {
                let _ = ack_payload; // ack payload rarely used; expose if needed later
                Self::Connected
            }
            WsEvent::PingReceived { payload } => Self::PingReceived {
                payload_json: opt_value_to_json(payload),
            },
            WsEvent::OperationResponse { op_id, response } => {
                use shalom_runtime::sansio_protocols::GraphQLResponse;
                match response {
                    GraphQLResponse::Data { data, errors, extensions } => {
                        Self::OperationResponse {
                            op_id,
                            data_json: serde_json::to_string(&data).ok(),
                            errors_json: errors
                                .as_deref()
                                .and_then(|e| serde_json::to_string(e).ok()),
                            extensions_json: extensions
                                .as_ref()
                                .and_then(|e| serde_json::to_string(e).ok()),
                        }
                    }
                    GraphQLResponse::Error { errors, extensions } => Self::OperationResponse {
                        op_id,
                        data_json: None,
                        errors_json: serde_json::to_string(&errors).ok(),
                        extensions_json: extensions
                            .as_ref()
                            .and_then(|e| serde_json::to_string(e).ok()),
                    },
                    GraphQLResponse::TransportError(err) => Self::ProtocolError {
                        code: 4400,
                        reason: format!("{}: {}", err.code, err.message),
                    },
                }
            }
            WsEvent::OperationComplete { op_id } => Self::OperationComplete { op_id },
            WsEvent::ProtocolError { code, reason } => Self::ProtocolError { code, reason },
        }
    }
}

// ─── FRB API ─────────────────────────────────────────────────────────────────

/// Create a new sans-IO state machine.
///
/// `connection_params_json` — optional JSON object forwarded as the
/// `connection_init` payload (e.g. `{"Authorization":"Bearer …"}`).
#[frb(sync)]
pub fn create_ws_sans_io(connection_params_json: Option<String>) -> anyhow::Result<WsSansIo> {
    let params = match connection_params_json {
        Some(s) if !s.trim().is_empty() => {
            Some(serde_json::from_str::<Value>(&s)?)
        }
        _ => None,
    };
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
/// `variables_json` — optional JSON object of operation variables.
#[frb(sync)]
pub fn ws_subscribe_frame(
    sansio: &mut WsSansIo,
    op_id: String,
    query: String,
    variables_json: Option<String>,
    operation_name: Option<String>,
) -> anyhow::Result<String> {
    let variables = match variables_json {
        Some(s) if !s.trim().is_empty() => {
            let v: Value = serde_json::from_str(&s)?;
            v.as_object().cloned()
        }
        _ => None,
    };
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
/// `payload_json` — the payload from the `PingReceived` event, if any.
#[frb(sync)]
pub fn ws_pong_frame(sansio: &WsSansIo, payload_json: Option<String>) -> anyhow::Result<String> {
    let payload = match payload_json {
        Some(s) if !s.trim().is_empty() => Some(serde_json::from_str::<Value>(&s)?),
        _ => None,
    };
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
