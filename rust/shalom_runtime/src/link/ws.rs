use std::sync::Arc;

use async_trait::async_trait;
use serde_json::{Map, Value};

use crate::link::{GraphQLLink, GraphQLResponse, Headers, LinkStream, Request, TransportError};

#[async_trait]
pub trait WebSocketTransport: Send + Sync {
    async fn connect(
        &self,
        url: &str,
        protocols: &[&str],
        headers: Option<Headers>,
    ) -> Result<TransportHandle, TransportError>;
}

pub struct TransportHandle {
    pub sender: Arc<dyn WebSocketSender>,
    pub stream: LinkStream,
}

#[async_trait]
pub trait WebSocketSender: Send + Sync {
    async fn send(&self, message: Value) -> Result<(), TransportError>;
    async fn close(&self, code: u16, reason: &str) -> Result<(), TransportError>;
}

#[derive(Clone)]
#[allow(dead_code)]
pub struct WebSocketLink {
    transport: Arc<dyn WebSocketTransport>,
    url: String,
    headers: Option<Headers>,
    connection_params: Option<Map<String, Value>>,
}

impl WebSocketLink {
    pub fn new(
        transport: Arc<dyn WebSocketTransport>,
        url: String,
        headers: Option<Headers>,
        connection_params: Option<Map<String, Value>>,
    ) -> Self {
        Self {
            transport,
            url,
            headers,
            connection_params,
        }
    }
}

impl GraphQLLink for WebSocketLink {
    fn execute(&self, _request: Request, _headers: Option<Headers>) -> LinkStream {
        let err = GraphQLResponse::TransportError(TransportError {
            message: "WebSocketLink execution is not implemented yet".to_string(),
            code: "UNSUPPORTED".to_string(),
            details: None,
        });
        Box::pin(tokio_stream::iter(vec![err]))
    }
}
