use std::pin::Pin;

use serde::{Deserialize, Serialize};
use serde_json::{Map, Value};
use tokio_stream::Stream;

pub mod host;
pub mod http;
pub mod ws;

/// HTTP / WS header list — same convention as Dart's `HeadersType`.
pub type Headers = Vec<(String, String)>;

/// The stream type returned by [`GraphQLLink::execute`].
pub type LinkStream = Pin<Box<dyn Stream<Item = GraphQLResponse> + Send>>;

/// Transport-agnostic link abstraction.
pub trait GraphQLLink: Send + Sync {
    fn execute(&self, request: Request) -> LinkStream;
}

/// A response coming back through the link.
#[derive(Debug, Clone)]
pub enum GraphQLResponse {
    Data {
        data: Map<String, Value>,
        errors: Option<Vec<Map<String, Value>>>,
        extensions: Option<Map<String, Value>>,
    },
    Error {
        errors: Vec<Map<String, Value>>,
        extensions: Option<Map<String, Value>>,
    },
    TransportError(TransportError),
}

/// A GraphQL request to be executed by a [`GraphQLLink`].
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Request {
    pub query: String,
    pub variables: Map<String, Value>,
    pub operation_name: String,
    pub operation_type: OperationType,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub headers: Option<Headers>,
}

/// A transport-level error from a [`GraphQLLink`].
#[derive(Debug, Clone)]
pub struct TransportError {
    pub message: String,
    pub code: String,
    pub details: Option<Value>,
}

/// GraphQL operation type — serializes as `"Query"` / `"Mutation"` / `"Subscription"`
/// (PascalCase), matching the values the Dart `_parseOperationType` expects.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum OperationType {
    Query,
    Mutation,
    Subscription,
}
