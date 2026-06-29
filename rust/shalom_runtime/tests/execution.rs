use serde_json::{Value, json};
use tokio_stream::StreamExt;

use shalom_runtime::sansio_protocols::host::HostLink;
use shalom_runtime::sansio_protocols::{GraphQLLink, GraphQLResponse, OperationType, Request};
use shalom_runtime::{RuntimeConfig, RuntimeResponseStream, ShalomRuntime, SubscriptionError};

/// Build a `RuntimeResponseStream` wiring `link` to `runtime` for `query`.
/// This mirrors what `RuntimeHandle::request_stream` does in `shalom_dart`.
fn make_request_stream(
    runtime: &ShalomRuntime,
    link: &HostLink,
    query: String,
) -> anyhow::Result<RuntimeResponseStream> {
    let op_ctx = runtime.register_operation(&query)?;
    let operation_name = op_ctx.get_operation_name().to_string();
    let operation_id = operation_name.clone();
    let request = Request {
        query: op_ctx.query.clone(),
        variables: Default::default(),
        operation_name,
        operation_type: OperationType::Query,
        headers: None,
    };

    let runtime = runtime.clone();
    let stream = link.execute(request).map(move |response| match response {
        GraphQLResponse::Data { data, .. } => runtime
            .normalize(&op_ctx, Value::Object(data), None)
            .map(|result| shalom_runtime::RuntimeResponse {
                data: result.data,
                operation_id: Some(operation_id.clone()),
            })
            .map_err(|e| SubscriptionError::Transport {
                message: e.to_string(),
                code: "NORMALIZATION_ERROR".into(),
                details: None,
            }),
        GraphQLResponse::Error { errors, extensions } => {
            Err(SubscriptionError::GraphQL { errors, extensions })
        }
        GraphQLResponse::TransportError(err) => Err(SubscriptionError::Transport {
            message: err.message,
            code: err.code,
            details: err.details,
        }),
    });

    Ok(Box::pin(stream))
}

#[tokio::test]
async fn request_stream_normalizes_each_response() {
    let schema = r#"
        type Query { value: Int }
    "#;
    let link = HostLink::new();
    let runtime = ShalomRuntime::init(schema, Vec::new(), RuntimeConfig).expect("runtime init");
    let mut outgoing = link.take_request_stream().expect("request stream missing");

    let mut responses = make_request_stream(
        &runtime,
        &link,
        "query TestOp @observe { value }".to_string(),
    )
    .expect("request stream");

    let envelope = outgoing.next().await.expect("request missing");
    assert_eq!(envelope.request.operation_name, "TestOp");

    link.send_response(
        envelope.id,
        GraphQLResponse::Data {
            data: json!({ "value": 1 }).as_object().unwrap().clone(),
            errors: None,
            extensions: None,
        },
    )
    .expect("send response");
    link.send_response(
        envelope.id,
        GraphQLResponse::Data {
            data: json!({ "value": 2 }).as_object().unwrap().clone(),
            errors: None,
            extensions: None,
        },
    )
    .expect("send response");

    let first = responses
        .next()
        .await
        .expect("missing response")
        .expect("response error");
    let second = responses
        .next()
        .await
        .expect("missing response")
        .expect("response error");

    assert_eq!(first.data.get("value"), Some(&json!(1)));
    assert_eq!(second.data.get("value"), Some(&json!(2)));
}
