pub mod host;
pub mod http;
pub mod ws;

use std::pin::Pin;

use serde::{Deserialize, Serialize};
use serde_json::{Map, Value};
use tokio_stream::Stream;

pub type Headers = Vec<(String, String)>;
pub type LinkStream = Pin<Box<dyn Stream<Item = GraphQLResponse> + Send>>;

#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum OperationType {
    Query,
    Mutation,
    Subscription,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Request {
    pub query: String,
    pub variables: Map<String, Value>,
    pub operation_name: String,
    pub operation_type: OperationType,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct TransportError {
    pub message: String,
    pub code: String,
    pub details: Option<Value>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
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

pub trait GraphQLLink: Send + Sync {
    fn execute(&self, request: Request, headers: Option<Headers>) -> LinkStream;
}
