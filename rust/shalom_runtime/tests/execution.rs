use serde_json::json;
use tokio_stream::StreamExt;

use shalom_runtime::link::GraphQLResponse;
use shalom_runtime::link::host::HostLink;
use shalom_runtime::{RuntimeConfig, ShalomRuntime};

#[tokio::test]
async fn request_stream_normalizes_each_response() {
    let schema = r#"
        type Query { value: Int }
    "#;
    let link = HostLink::new();
    let runtime = ShalomRuntime::init(schema, Vec::new(), RuntimeConfig::default(), link.clone())
        .expect("runtime init");
    let mut outgoing = link.take_request_stream().expect("request stream missing");

    let mut responses = runtime
        .request_stream("query TestOp @subscribeable { value }".to_string(), None)
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
    let used_refs = first
        .data
        .get("__used_refs")
        .and_then(|value| value.as_array())
        .expect("used refs missing");
    assert!(used_refs.contains(&json!("ROOT_QUERY_value")));
    assert_eq!(second.data.get("value"), Some(&json!(2)));
}
