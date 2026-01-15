use std::sync::{Arc, Mutex};

use async_trait::async_trait;
use serde_json::{Map, Value, json};
use tokio_stream::StreamExt;

use shalom_runtime::link::http::{HttpLink, HttpMethod, HttpTransport};
use shalom_runtime::link::ws::WebSocketLink;
use shalom_runtime::link::{
    GraphQLLink, GraphQLResponse, Headers, OperationType, Request, TransportError,
};

#[derive(Debug, Default, Clone)]
struct CapturedRequest {
    method: Option<HttpMethod>,
    url: Option<String>,
    data: Option<Map<String, Value>>,
    headers: Headers,
}

#[derive(Clone)]
struct DummyTransport {
    captured: Arc<Mutex<CapturedRequest>>,
    response: Map<String, Value>,
}

impl DummyTransport {
    fn new(response: Map<String, Value>) -> Self {
        Self {
            captured: Arc::new(Mutex::new(CapturedRequest::default())),
            response,
        }
    }
}

#[async_trait]
impl HttpTransport for DummyTransport {
    async fn request(
        &self,
        method: HttpMethod,
        url: &str,
        data: Map<String, Value>,
        headers: Headers,
    ) -> Result<Map<String, Value>, TransportError> {
        let mut captured = self.captured.lock().expect("lock");
        captured.method = Some(method);
        captured.url = Some(url.to_string());
        captured.data = Some(data);
        captured.headers = headers;
        Ok(self.response.clone())
    }
}

fn request(operation_type: OperationType) -> Request {
    Request {
        query: "query Test { ok }".to_string(),
        variables: Map::new(),
        operation_name: "Test".to_string(),
        operation_type,
    }
}

#[tokio::test]
async fn http_link_uses_get_for_queries_when_configured() {
    let mut response = Map::new();
    response.insert("data".to_string(), json!({"ok": true}));
    let transport = DummyTransport::new(response);
    let captured = transport.captured.clone();
    let link = HttpLink::new(
        Arc::new(transport),
        "https://example.test/graphql".to_string(),
        true,
        vec![],
    );

    let mut stream = link.execute(request(OperationType::Query), None);
    let _ = stream.next().await;

    let captured = captured.lock().expect("lock");
    assert!(matches!(captured.method, Some(HttpMethod::Get)));
    assert_eq!(
        captured.url.as_deref(),
        Some("https://example.test/graphql")
    );
    let data = captured.data.as_ref().expect("missing data");
    assert!(data.contains_key("query"));
    assert!(data.contains_key("operationName"));
}

#[tokio::test]
async fn http_link_posts_for_mutations_with_json_headers() {
    let mut response = Map::new();
    response.insert("data".to_string(), json!({"ok": true}));
    let transport = DummyTransport::new(response);
    let captured = transport.captured.clone();
    let link = HttpLink::new(
        Arc::new(transport),
        "https://example.test/graphql".to_string(),
        true,
        vec![],
    );

    let mut stream = link.execute(request(OperationType::Mutation), None);
    let _ = stream.next().await;

    let captured = captured.lock().expect("lock");
    assert!(matches!(captured.method, Some(HttpMethod::Post)));
    assert!(
        captured
            .headers
            .iter()
            .any(|(name, _)| name == "Content-Type")
    );
    assert!(captured.headers.iter().any(|(name, _)| name == "Accept"));
}

#[tokio::test]
async fn http_link_parses_error_response() {
    let mut response = Map::new();
    response.insert(
        "errors".to_string(),
        Value::Array(vec![json!({"message": "boom"})]),
    );
    let transport = DummyTransport::new(response);
    let link = HttpLink::new(
        Arc::new(transport),
        "https://example.test/graphql".to_string(),
        false,
        vec![],
    );

    let mut stream = link.execute(request(OperationType::Query), None);
    let message = stream.next().await.expect("missing message");

    match message {
        GraphQLResponse::Error { errors, .. } => {
            assert_eq!(errors.len(), 1);
        }
        other => panic!("unexpected response: {other:?}"),
    }
}

#[tokio::test]
async fn websocket_link_returns_unsupported() {
    let link = WebSocketLink::new(
        Arc::new(DummyWsTransport {}),
        "wss://example.test/graphql".to_string(),
        None,
        None,
    );
    let mut stream = link.execute(request(OperationType::Subscription), None);
    let message = stream.next().await.expect("missing message");
    match message {
        GraphQLResponse::TransportError(err) => {
            assert_eq!(err.code, "UNSUPPORTED");
        }
        other => panic!("unexpected response: {other:?}"),
    }
}

struct DummyWsTransport;

#[async_trait]
impl shalom_runtime::link::ws::WebSocketTransport for DummyWsTransport {
    async fn connect(
        &self,
        _url: &str,
        _protocols: &[&str],
        _headers: Option<Headers>,
    ) -> Result<shalom_runtime::link::ws::TransportHandle, TransportError> {
        Err(TransportError {
            message: "not used".to_string(),
            code: "UNSUPPORTED".to_string(),
            details: None,
        })
    }
}
