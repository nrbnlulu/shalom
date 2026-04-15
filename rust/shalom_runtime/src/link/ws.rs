/// Sans-IO implementation of the `graphql-transport-ws` protocol.
///
/// This module contains no sockets, no timers, and no async I/O. It is a pure
/// state machine that:
///   - Parses incoming text frames into typed messages.
///   - Builds outgoing frames (JSON strings) for the caller to send.
///   - Tracks per-operation state and emits `WsEvent` items to the caller.
///
/// Dart's `ws_link.dart` owns the actual WebSocket and calls into this
/// state machine for protocol framing and message parsing.
///
/// # Protocol reference
/// <https://github.com/enisdenjo/graphql-ws/blob/master/PROTOCOL.md>
use std::collections::HashMap;

use serde::Deserialize;
use serde_json::{Map, Value, json};

use crate::link::GraphQLResponse;

// ─── Incoming message types ──────────────────────────────────────────────────

#[derive(Debug, Clone, Deserialize)]
#[serde(tag = "type", rename_all = "snake_case")]
pub enum IncomingMessage {
    ConnectionAck {
        payload: Option<Value>,
    },
    Ping {
        payload: Option<Value>,
    },
    Pong {
        payload: Option<Value>,
    },
    Next {
        id: String,
        payload: Map<String, Value>,
    },
    Error {
        id: String,
        payload: Vec<Map<String, Value>>,
    },
    Complete {
        id: String,
    },
}

// ─── Events emitted to caller ────────────────────────────────────────────────

/// Events that the caller (Dart ws_link) must act on.
#[derive(Debug, Clone)]
pub enum WsEvent {
    /// Connection is acknowledged — flush any queued operations.
    Connected { ack_payload: Option<Value> },

    /// Server sent a Ping; caller must send a Pong frame immediately.
    PingReceived { payload: Option<Value> },

    /// A response payload for a registered operation.
    OperationResponse {
        op_id: String,
        response: GraphQLResponse,
    },

    /// The server has completed an operation (or sent an error that terminates it).
    OperationComplete { op_id: String },

    /// Protocol error: caller should close the WebSocket with `code`.
    ProtocolError { code: u16, reason: String },
}

// ─── State machine ───────────────────────────────────────────────────────────

#[derive(Debug, Clone, PartialEq, Eq)]
enum ConnectionState {
    AwaitingAck,
    Connected,
}

/// Pure state machine for the `graphql-transport-ws` protocol.
///
/// # Usage (from Dart via FRB)
///
/// ```ignore
/// // Create once per WebSocket connection.
/// let mut sm = WsStateMachine::new(None); // None = no connection_init payload
///
/// // After WebSocket is open, send the init frame:
/// ws.send(sm.connection_init_frame());
///
/// // For each text frame received from the server:
/// for event in sm.on_message(raw_text)? {
///     match event {
///         WsEvent::Connected { .. } => { /* send any queued subscribe frames */ }
///         WsEvent::OperationResponse { op_id, response } => { /* feed to HostLink */ }
///         WsEvent::OperationComplete { op_id } => { /* complete_transport(op_id) */ }
///         WsEvent::PingReceived { payload } => { ws.send(sm.pong_frame(payload)); }
///         WsEvent::ProtocolError { code, reason } => { ws.close(code, reason); }
///     }
/// }
///
/// // To start an operation:
/// let frame = sm.subscribe_frame(op_id, query, variables, operation_name)?;
/// ws.send(frame);
///
/// // To cancel an operation:
/// let frame = sm.complete_frame(op_id);
/// ws.send(frame);
/// ```
pub struct WsStateMachine {
    state: ConnectionState,
    connection_params: Option<Value>,
    /// op_id → true means active
    operations: HashMap<String, bool>,
}

impl WsStateMachine {
    pub fn new(connection_params: Option<Value>) -> Self {
        Self {
            state: ConnectionState::AwaitingAck,
            connection_params,
            operations: HashMap::new(),
        }
    }

    /// Reset connection state after a disconnect so the same instance can be reused
    /// for a reconnect. Preserves the active operations list so the caller can
    /// re-subscribe them after the new handshake completes.
    ///
    /// Typical reconnect flow:
    /// ```ignore
    /// sm.reset();
    /// ws.send(sm.connection_init_frame());
    /// // ... wait for WsEvent::Connected, then:
    /// for op_id in sm.active_operation_ids() {
    ///     ws.send(sm.subscribe_frame(op_id, stored_query, stored_vars, stored_name));
    /// }
    /// ```
    pub fn reset(&mut self) {
        self.state = ConnectionState::AwaitingAck;
        // Do NOT clear operations — caller uses active_operation_ids() to re-subscribe.
    }

    /// The `connection_init` frame to send immediately after the WebSocket opens.
    pub fn connection_init_frame(&self) -> String {
        let mut msg = json!({ "type": "connection_init" });
        if let Some(params) = &self.connection_params {
            msg["payload"] = params.clone();
        }
        msg.to_string()
    }

    /// Build a `subscribe` frame for a new operation.
    pub fn subscribe_frame(
        &mut self,
        op_id: String,
        query: String,
        variables: Option<Map<String, Value>>,
        operation_name: Option<String>,
    ) -> String {
        self.operations.insert(op_id.clone(), true);
        let mut payload = json!({ "query": query });
        if let Some(vars) = variables {
            payload["variables"] = Value::Object(vars);
        }
        if let Some(name) = operation_name {
            payload["operationName"] = Value::String(name);
        }
        json!({
            "type": "subscribe",
            "id": op_id,
            "payload": payload,
        })
        .to_string()
    }

    /// Build a `complete` frame to cancel an in-flight operation.
    pub fn complete_frame(&mut self, op_id: &str) -> String {
        self.operations.remove(op_id);
        json!({ "type": "complete", "id": op_id }).to_string()
    }

    /// Build a `pong` frame (response to a server `ping`).
    pub fn pong_frame(&self, payload: Option<Value>) -> String {
        let mut msg = json!({ "type": "pong" });
        if let Some(p) = payload {
            msg["payload"] = p;
        }
        msg.to_string()
    }

    /// Process a raw text frame received from the WebSocket server.
    /// Returns zero or more events for the caller to act on.
    pub fn on_message(&mut self, raw: &str) -> Result<Vec<WsEvent>, WsProtocolError> {
        let msg: IncomingMessage = serde_json::from_str(raw).map_err(|e| WsProtocolError {
            code: 4400,
            reason: format!("invalid message: {e}"),
        })?;

        match msg {
            IncomingMessage::ConnectionAck { payload } => {
                if self.state != ConnectionState::AwaitingAck {
                    return Err(WsProtocolError {
                        code: 4400,
                        reason: "unexpected connection_ack".to_string(),
                    });
                }
                self.state = ConnectionState::Connected;
                Ok(vec![WsEvent::Connected { ack_payload: payload }])
            }

            IncomingMessage::Ping { payload } => {
                Ok(vec![WsEvent::PingReceived { payload }])
            }

            IncomingMessage::Pong { .. } => {
                // Pong received in response to our ping — no action needed from caller.
                Ok(vec![])
            }

            IncomingMessage::Next { id, payload } => {
                if !self.operations.contains_key(&id) {
                    return Err(WsProtocolError {
                        code: 4400,
                        reason: format!("received next for unknown operation {id}"),
                    });
                }
                let response = parse_graphql_payload(payload);
                Ok(vec![WsEvent::OperationResponse {
                    op_id: id,
                    response,
                }])
            }

            IncomingMessage::Error { id, payload } => {
                self.operations.remove(&id);
                Ok(vec![
                    WsEvent::OperationResponse {
                        op_id: id.clone(),
                        response: GraphQLResponse::Error {
                            errors: payload,
                            extensions: None,
                        },
                    },
                    WsEvent::OperationComplete { op_id: id },
                ])
            }

            IncomingMessage::Complete { id } => {
                self.operations.remove(&id);
                Ok(vec![WsEvent::OperationComplete { op_id: id }])
            }
        }
    }

    /// Whether the connection has been acknowledged by the server.
    pub fn is_connected(&self) -> bool {
        self.state == ConnectionState::Connected
    }

    /// All currently active operation ids.
    pub fn active_operation_ids(&self) -> Vec<String> {
        self.operations.keys().cloned().collect()
    }
}

#[derive(Debug, Clone)]
pub struct WsProtocolError {
    pub code: u16,
    pub reason: String,
}

// ─── Helpers ─────────────────────────────────────────────────────────────────

fn parse_graphql_payload(payload: Map<String, Value>) -> GraphQLResponse {
    let data = payload.get("data").and_then(|v| v.as_object()).cloned();
    let errors = payload
        .get("errors")
        .and_then(|v| v.as_array())
        .map(|arr| {
            arr.iter()
                .filter_map(|item| item.as_object().cloned())
                .collect::<Vec<_>>()
        });
    let extensions = payload
        .get("extensions")
        .and_then(|v| v.as_object())
        .cloned();

    match data {
        Some(data) => GraphQLResponse::Data {
            data,
            errors,
            extensions,
        },
        None => {
            if let Some(errors) = errors {
                GraphQLResponse::Error { errors, extensions }
            } else {
                GraphQLResponse::Error {
                    errors: vec![],
                    extensions,
                }
            }
        }
    }
}

// ─── Tests ───────────────────────────────────────────────────────────────────

#[cfg(test)]
mod tests {
    use super::*;
    use serde_json::json;

    fn ack() -> String {
        json!({ "type": "connection_ack" }).to_string()
    }

    #[test]
    fn connection_ack_transitions_to_connected() {
        let mut sm = WsStateMachine::new(None);
        assert!(!sm.is_connected());
        let events = sm.on_message(&ack()).unwrap();
        assert!(matches!(events[0], WsEvent::Connected { .. }));
        assert!(sm.is_connected());
    }

    #[test]
    fn next_message_emits_operation_response() {
        let mut sm = WsStateMachine::new(None);
        sm.on_message(&ack()).unwrap();
        sm.subscribe_frame("op1".to_string(), "query {}".to_string(), None, None);

        let msg = json!({
            "type": "next",
            "id": "op1",
            "payload": { "data": { "value": 42 } }
        })
        .to_string();
        let events = sm.on_message(&msg).unwrap();
        assert!(matches!(
            &events[0],
            WsEvent::OperationResponse { op_id, .. } if op_id == "op1"
        ));
    }

    #[test]
    fn complete_message_emits_operation_complete() {
        let mut sm = WsStateMachine::new(None);
        sm.on_message(&ack()).unwrap();
        sm.subscribe_frame("op1".to_string(), "query {}".to_string(), None, None);

        let msg = json!({ "type": "complete", "id": "op1" }).to_string();
        let events = sm.on_message(&msg).unwrap();
        assert!(matches!(
            &events[0],
            WsEvent::OperationComplete { op_id } if op_id == "op1"
        ));
        assert!(!sm.active_operation_ids().contains(&"op1".to_string()));
    }

    #[test]
    fn duplicate_ack_is_a_protocol_error() {
        let mut sm = WsStateMachine::new(None);
        sm.on_message(&ack()).unwrap();
        assert!(sm.on_message(&ack()).is_err());
    }

    #[test]
    fn ping_emits_ping_received() {
        let mut sm = WsStateMachine::new(None);
        sm.on_message(&ack()).unwrap();
        let ping = json!({ "type": "ping" }).to_string();
        let events = sm.on_message(&ping).unwrap();
        assert!(matches!(&events[0], WsEvent::PingReceived { .. }));
    }

    #[test]
    fn reset_allows_reconnect_while_preserving_operations() {
        let mut sm = WsStateMachine::new(None);
        sm.on_message(&ack()).unwrap();
        sm.subscribe_frame("op1".to_string(), "query {}".to_string(), None, None);
        assert!(sm.is_connected());

        // Simulate disconnect + reconnect
        sm.reset();
        assert!(!sm.is_connected());
        // Active operations are preserved so caller can re-subscribe
        assert!(sm.active_operation_ids().contains(&"op1".to_string()));

        // New ack from server should be accepted
        let events = sm.on_message(&ack()).unwrap();
        assert!(matches!(events[0], WsEvent::Connected { .. }));
        assert!(sm.is_connected());
    }

    #[test]
    fn ack_without_reset_after_connected_is_protocol_error() {
        let mut sm = WsStateMachine::new(None);
        sm.on_message(&ack()).unwrap();
        // Server sends a second ack without us resetting — protocol violation
        assert!(sm.on_message(&ack()).is_err());
    }
}
