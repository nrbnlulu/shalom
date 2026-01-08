use std::sync::Arc;

use async_trait::async_trait;
use serde_json::{Map, Value};

use crate::link::{
    GraphQLLink, GraphQLResponse, Headers, LinkStream, OperationType, Request, TransportError,
};
use tokio::sync::mpsc;
use tokio_stream::wrappers::UnboundedReceiverStream;

#[derive(Debug, Clone, Copy)]
pub enum HttpMethod {
    Get,
    Post,
}

#[async_trait]
pub trait HttpTransport: Send + Sync {
    async fn request(
        &self,
        method: HttpMethod,
        url: &str,
        data: Map<String, Value>,
        headers: Headers,
    ) -> Result<Map<String, Value>, TransportError>;
}

#[derive(Clone)]
pub struct HttpLink {
    transport: Arc<dyn HttpTransport>,
    url: String,
    use_get: bool,
    default_headers: Headers,
}

impl HttpLink {
    pub fn new(
        transport: Arc<dyn HttpTransport>,
        url: String,
        use_get: bool,
        default_headers: Headers,
    ) -> Self {
        Self {
            transport,
            url,
            use_get,
            default_headers,
        }
    }

    fn ensure_accept_header(headers: &mut Headers) {
        let has_accept = headers
            .iter()
            .any(|(name, _)| name.eq_ignore_ascii_case("accept"));
        if !has_accept {
            headers.push((
                "Accept".to_string(),
                "application/graphql-response+json, application/json;q=0.9".to_string(),
            ));
        }
    }

    fn prepare_post_body(request: &Request) -> Map<String, Value> {
        let mut body = Map::new();
        body.insert("query".to_string(), Value::String(request.query.clone()));
        if !request.operation_name.is_empty() {
            body.insert(
                "operationName".to_string(),
                Value::String(request.operation_name.clone()),
            );
        }
        if !request.variables.is_empty() {
            body.insert(
                "variables".to_string(),
                Value::Object(request.variables.clone()),
            );
        }
        body
    }

    fn prepare_get_params(request: &Request) -> Map<String, Value> {
        let mut params = Map::new();
        params.insert("query".to_string(), Value::String(request.query.clone()));
        if !request.operation_name.is_empty() {
            params.insert(
                "operationName".to_string(),
                Value::String(request.operation_name.clone()),
            );
        }
        if !request.variables.is_empty() {
            params.insert(
                "variables".to_string(),
                Value::String(Value::Object(request.variables.clone()).to_string()),
            );
        }
        params
    }

    fn parse_response(response: Map<String, Value>) -> GraphQLResponse {
        let data = response.get("data");
        let errors = response.get("errors");
        let extensions = response.get("extensions");

        let parsed_errors = errors.and_then(|value| value.as_array()).map(|arr| {
            arr.iter()
                .filter_map(|item| item.as_object().cloned())
                .collect::<Vec<_>>()
        });
        let parsed_extensions = extensions.and_then(|value| value.as_object()).cloned();

        match data {
            Some(Value::Object(obj)) => GraphQLResponse::Data {
                data: obj.clone(),
                errors: parsed_errors,
                extensions: parsed_extensions,
            },
            _ => {
                if let Some(errors) = parsed_errors {
                    GraphQLResponse::Error {
                        errors,
                        extensions: parsed_extensions,
                    }
                } else {
                    GraphQLResponse::TransportError(TransportError {
                        message: "Invalid GraphQL response: missing data and errors".to_string(),
                        code: "INVALID_RESPONSE_FORMAT".to_string(),
                        details: Some(Value::Object(response)),
                    })
                }
            }
        }
    }
}

impl GraphQLLink for HttpLink {
    fn execute(&self, request: Request, headers: Option<Headers>) -> LinkStream {
        let transport = self.transport.clone();
        let url = self.url.clone();
        let use_get = self.use_get;
        let mut final_headers = self.default_headers.clone();
        if let Some(extra_headers) = headers {
            final_headers.extend(extra_headers);
        }
        Self::ensure_accept_header(&mut final_headers);

        let method = if use_get && request.operation_type == OperationType::Query {
            HttpMethod::Get
        } else {
            HttpMethod::Post
        };

        let body = match method {
            HttpMethod::Get => Self::prepare_get_params(&request),
            HttpMethod::Post => {
                final_headers.push((
                    "Content-Type".to_string(),
                    "application/json; charset=utf-8".to_string(),
                ));
                Self::prepare_post_body(&request)
            }
        };

        let (tx, rx) = mpsc::unbounded_channel();
        tokio::spawn(async move {
            let message = match transport.request(method, &url, body, final_headers).await {
                Ok(response) => Self::parse_response(response),
                Err(err) => GraphQLResponse::TransportError(err),
            };
            let _ = tx.send(message);
        });

        Box::pin(UnboundedReceiverStream::new(rx))
    }
}
