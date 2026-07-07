use std::sync::atomic::{AtomicBool, Ordering};
use std::sync::{Arc, Mutex};
use std::time::Duration;

use serde_json::json;
use tokio::sync::mpsc;
use tokio_stream::wrappers::UnboundedReceiverStream;
use tokio_stream::StreamExt;

use shalom_runtime::sansio_protocols::host::HostLink;
use shalom_runtime::sansio_protocols::{
    GraphQLLink, GraphQLResponse, LinkStream, Request, TransportError,
};
use shalom_runtime::{ExecutionPolicy, RuntimeConfig, ShalomRuntime};

const SCHEMA: &str = r#"
    type Query { value: Int }
"#;

/// A transport error is pushed to the subscription immediately, and — since a
/// retry delay is configured — the whole operation is re-issued afterwards,
/// resuming the subscription once the retry succeeds.
#[tokio::test]
async fn transport_error_retries_and_recovers() {
    let link = Arc::new(HostLink::new());
    let mut outgoing = link.take_request_stream().expect("request stream missing");
    let runtime =
        ShalomRuntime::init(SCHEMA, Vec::new(), RuntimeConfig::default()).expect("runtime init");
    let op_ctx = runtime
        .register_operation("query TestOp @observe { value }")
        .expect("register operation");

    let sub_id = runtime.execute_operation(
        op_ctx,
        None,
        ExecutionPolicy::NetworkFirst,
        link.clone() as Arc<dyn GraphQLLink>,
        Some(Duration::from_millis(20)),
    );
    let mut responses = runtime
        .subscription_stream(&sub_id)
        .expect("subscription stream");

    let first_envelope = outgoing.next().await.expect("first request missing");
    assert_eq!(first_envelope.request.operation_name, "TestOp");
    link.send_response(
        first_envelope.id,
        GraphQLResponse::TransportError(TransportError {
            message: "connection lost".into(),
            code: "NETWORK_ERROR".into(),
            details: None,
        }),
    )
    .expect("send transport error");

    // The transport error is surfaced immediately.
    let first = responses.next().await.expect("missing response");
    assert!(first.is_err());

    // After the retry delay, the same operation is re-issued as a fresh request.
    let retry_envelope = outgoing.next().await.expect("retry request missing");
    assert_eq!(retry_envelope.request.operation_name, "TestOp");
    assert_ne!(retry_envelope.id, first_envelope.id);

    link.send_response(
        retry_envelope.id,
        GraphQLResponse::Data {
            data: json!({ "value": 42 }).as_object().unwrap().clone(),
            errors: None,
            extensions: None,
        },
    )
    .expect("send data");

    let second = responses
        .next()
        .await
        .expect("missing response")
        .expect("retry response should be ok");
    assert_eq!(second.data.get("value"), Some(&json!(42)));
}

/// If the operation didn't opt into auto-retry, a transport error is terminal:
/// it's pushed once and the operation is not re-issued.
#[tokio::test]
async fn transport_error_without_retry_delay_does_not_retry() {
    let link = Arc::new(HostLink::new());
    let mut outgoing = link.take_request_stream().expect("request stream missing");
    let runtime =
        ShalomRuntime::init(SCHEMA, Vec::new(), RuntimeConfig::default()).expect("runtime init");
    let op_ctx = runtime
        .register_operation("query TestOp @observe { value }")
        .expect("register operation");

    let sub_id = runtime.execute_operation(
        op_ctx,
        None,
        ExecutionPolicy::NetworkFirst,
        link.clone() as Arc<dyn GraphQLLink>,
        None,
    );
    let mut responses = runtime
        .subscription_stream(&sub_id)
        .expect("subscription stream");

    let envelope = outgoing.next().await.expect("request missing");
    link.send_response(
        envelope.id,
        GraphQLResponse::TransportError(TransportError {
            message: "connection lost".into(),
            code: "NETWORK_ERROR".into(),
            details: None,
        }),
    )
    .expect("send transport error");

    let first = responses.next().await.expect("missing response");
    assert!(first.is_err());

    // No retry: no second request ever arrives.
    let no_retry = tokio::time::timeout(Duration::from_millis(100), outgoing.next()).await;
    assert!(no_retry.is_err(), "expected no retry request to be sent");
}

/// Unsubscribing before the retry delay elapses cancels the pending retry —
/// the operation is not re-issued after cancellation.
#[tokio::test]
async fn unsubscribing_before_retry_cancels_it() {
    let link = Arc::new(HostLink::new());
    let mut outgoing = link.take_request_stream().expect("request stream missing");
    let runtime =
        ShalomRuntime::init(SCHEMA, Vec::new(), RuntimeConfig::default()).expect("runtime init");
    let op_ctx = runtime
        .register_operation("query TestOp @observe { value }")
        .expect("register operation");

    let sub_id = runtime.execute_operation(
        op_ctx,
        None,
        ExecutionPolicy::NetworkFirst,
        link.clone() as Arc<dyn GraphQLLink>,
        Some(Duration::from_millis(30)),
    );
    let mut responses = runtime
        .subscription_stream(&sub_id)
        .expect("subscription stream");

    let envelope = outgoing.next().await.expect("request missing");
    link.send_response(
        envelope.id,
        GraphQLResponse::TransportError(TransportError {
            message: "connection lost".into(),
            code: "NETWORK_ERROR".into(),
            details: None,
        }),
    )
    .expect("send transport error");

    let first = responses.next().await.expect("missing response");
    assert!(first.is_err());

    // Cancel before the retry delay (30ms) elapses.
    runtime.unsubscribe(&sub_id);

    let no_retry = tokio::time::timeout(Duration::from_millis(100), outgoing.next()).await;
    assert!(
        no_retry.is_err(),
        "expected no retry request after cancellation"
    );
}

/// A [`GraphQLLink`] whose stream never completes and never yields another
/// item (simulating a live, still-open network subscription), instrumented to
/// report when the stream itself is dropped.
struct PendingForeverLink {
    dropped: Arc<AtomicBool>,
    /// Keeps each request's channel sender alive so its receiver stream never
    /// closes on its own — the only way it ends is by being dropped.
    senders: Mutex<Vec<mpsc::UnboundedSender<GraphQLResponse>>>,
}

struct DropFlagStream {
    inner: UnboundedReceiverStream<GraphQLResponse>,
    dropped: Arc<AtomicBool>,
}

impl tokio_stream::Stream for DropFlagStream {
    type Item = GraphQLResponse;
    fn poll_next(
        mut self: std::pin::Pin<&mut Self>,
        cx: &mut std::task::Context<'_>,
    ) -> std::task::Poll<Option<Self::Item>> {
        std::pin::Pin::new(&mut self.inner).poll_next(cx)
    }
}

impl Drop for DropFlagStream {
    fn drop(&mut self) {
        self.dropped.store(true, Ordering::SeqCst);
    }
}

impl GraphQLLink for PendingForeverLink {
    fn execute(&self, _request: Request) -> LinkStream {
        let (tx, rx) = mpsc::unbounded_channel();
        self.senders.lock().unwrap().push(tx);
        Box::pin(DropFlagStream {
            inner: UnboundedReceiverStream::new(rx),
            dropped: self.dropped.clone(),
        })
    }
}

/// A live subscription's in-flight stream must be aborted promptly on
/// `unsubscribe` — not left polling forever until the link happens to produce
/// another item (which, for an open GraphQL subscription, may be never).
#[tokio::test]
async fn unsubscribing_aborts_in_flight_stream_promptly() {
    let dropped = Arc::new(AtomicBool::new(false));
    let link = Arc::new(PendingForeverLink {
        dropped: dropped.clone(),
        senders: Mutex::new(Vec::new()),
    });
    let runtime =
        ShalomRuntime::init(SCHEMA, Vec::new(), RuntimeConfig::default()).expect("runtime init");
    let op_ctx = runtime
        .register_operation("query TestOp @observe { value }")
        .expect("register operation");

    let sub_id = runtime.execute_operation(
        op_ctx,
        None,
        ExecutionPolicy::NetworkFirst,
        link.clone() as Arc<dyn GraphQLLink>,
        None,
    );

    // Give the spawned task a chance to call `link.execute` and start polling.
    tokio::time::sleep(Duration::from_millis(20)).await;
    assert!(
        !dropped.load(Ordering::SeqCst),
        "stream should still be open before unsubscribe"
    );

    runtime.unsubscribe(&sub_id);

    // The in-flight stream should be dropped promptly, not held open
    // indefinitely waiting for a network item that may never come.
    tokio::time::sleep(Duration::from_millis(20)).await;
    assert!(
        dropped.load(Ordering::SeqCst),
        "stream should be aborted promptly after unsubscribe"
    );
}
