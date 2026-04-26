use serde_json::{Value, json};
use tokio_stream::StreamExt;

use shalom_runtime::sansio_protocols::{GraphQLLink, GraphQLResponse, OperationType, Request};
use shalom_runtime::sansio_protocols::host::HostLink;
use shalom_runtime::{RuntimeConfig, RuntimeResponseStream, ShalomRuntime};

/// Build a `RuntimeResponseStream` wiring `link` to `runtime` for `query`.
/// This mirrors what `RuntimeHandle::request_stream` does in `shalom_dart`.
fn make_request_stream(
    runtime: &ShalomRuntime,
    link: &HostLink,
    query: String,
) -> anyhow::Result<RuntimeResponseStream> {
    let op_ctx = runtime.register_operation_from_query(&query)?;
    let operation_name = op_ctx.get_operation_name().to_string();
    let operation_id = operation_name.clone();
    let request = Request {
        query,
        variables: Default::default(),
        operation_name,
        operation_type: OperationType::Query,
        headers: None,
    };

    let runtime = runtime.clone();
    let stream = link
        .execute(request)
        .map(move |response| match response {
            GraphQLResponse::Data { data, .. } => runtime
                .normalize(&op_ctx, Value::Object(data), None)
                .map(|result| shalom_runtime::RuntimeResponse {
                    data: result.data,
                    operation_id: Some(operation_id.clone()),
                }),
            GraphQLResponse::Error { errors, .. } => Err(anyhow::anyhow!(
                "graphql errors: {}",
                serde_json::to_string(&errors).unwrap_or_default()
            )),
            GraphQLResponse::TransportError(err) => {
                Err(anyhow::anyhow!("transport error {}: {}", err.code, err.message))
            }
        });

    Ok(Box::pin(stream))
}

#[tokio::test]
async fn request_stream_normalizes_each_response() {
    let schema = r#"
        type Query { value: Int }
    "#;
    let link = HostLink::new();
    let runtime = ShalomRuntime::init(schema, Vec::new(), RuntimeConfig::default())
        .expect("runtime init");
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
