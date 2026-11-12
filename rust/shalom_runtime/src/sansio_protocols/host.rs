//! Bidirectional host link: forwards Rust-initiated requests to Dart over a
//! channel and routes Dart-supplied responses back into Rust streams.
//!
//! # Flow
//!
//! 1. Dart calls `listen_transport_events` (FRB) and consumes ordered
//!    [`HostLinkEvent`] requests and cancellations on one channel.
//! 2. When Rust needs a GraphQL response it calls [`HostLink::execute`], which
//!    creates a per-request response channel, stores the sender, and enqueues a
//!    [`RequestEnvelope`] on the outgoing channel. It returns a [`LinkStream`]
//!    backed by the response channel.
//! 3. Dart receives the envelope, performs the network request, and calls
//!    `push_response` / `push_transport_error` (FRB) for each response item,
//!    routing them via [`HostLink::send_response`].
//! 4. Dart calls `complete_transport` (FRB) when the stream is done, which
//!    calls [`HostLink::complete`] and drops the sender — closing the
//!    receiver-side stream inside Rust.
//! 5. Dropping a Rust response stream removes its sender and queues a cancel
//!    event so Dart releases the corresponding transport subscription.

use parking_lot::Mutex;
use std::pin::Pin;
use std::sync::Arc;
use std::sync::atomic::{AtomicU64, Ordering};
use std::task::{Context, Poll};

use dashmap::DashMap;
use serde::Serialize;
use tokio::sync::mpsc;
use tokio_stream::wrappers::UnboundedReceiverStream;
use tokio_stream::{Stream, StreamExt};

use crate::sansio_protocols::{GraphQLLink, GraphQLResponse, LinkStream, Request};

/// A request envelope sent from Rust to Dart over the host channel.
///
/// Dart's `_RequestEnvelope.fromJson` expects the JSON shape:
/// ```json
/// { "id": 1, "request": { "query": "...", "operation_name": "...",
///                          "operation_type": "Query", "variables": {} } }
/// ```
#[derive(Debug, Clone, Serialize)]
pub struct RequestEnvelope {
    pub id: u64,
    pub request: Request,
}

/// Ordered host transport actions. Cancellation follows its request on the
/// same channel, including when a Rust consumer drops before Dart dispatches.
#[derive(Debug, Serialize)]
pub enum HostLinkEvent {
    Request(RequestEnvelope),
    Cancel { request_id: u64 },
}

struct HostResponseStream {
    request_id: u64,
    responses: UnboundedReceiverStream<GraphQLResponse>,
    response_senders: Arc<DashMap<u64, mpsc::UnboundedSender<GraphQLResponse>>>,
    events: mpsc::UnboundedSender<HostLinkEvent>,
}

impl Stream for HostResponseStream {
    type Item = GraphQLResponse;

    fn poll_next(self: Pin<&mut Self>, cx: &mut Context<'_>) -> Poll<Option<Self::Item>> {
        Pin::new(&mut self.get_mut().responses).poll_next(cx)
    }
}

impl Drop for HostResponseStream {
    fn drop(&mut self) {
        self.response_senders.remove(&self.request_id);
        let _ = self.events.send(HostLinkEvent::Cancel {
            request_id: self.request_id,
        });
    }
}

/// Bidirectional bridge between the Rust runtime and the Dart transport layer.
pub struct HostLink {
    next_id: AtomicU64,
    /// Sender for outgoing request envelopes (consumed by Dart via FRB).
    request_tx: mpsc::UnboundedSender<HostLinkEvent>,
    /// Taken once by `listen_requests` so Dart can own the receiving end.
    request_rx: Mutex<Option<mpsc::UnboundedReceiver<HostLinkEvent>>>,
    /// Per-request senders; each maps a request ID to its response channel.
    response_senders: Arc<DashMap<u64, mpsc::UnboundedSender<GraphQLResponse>>>,
}

impl HostLink {
    pub fn new() -> Self {
        let (tx, rx) = mpsc::unbounded_channel();
        Self {
            next_id: AtomicU64::new(0),
            request_tx: tx,
            request_rx: Mutex::new(Some(rx)),
            response_senders: Arc::new(DashMap::new()),
        }
    }

    /// Take the request stream once — called by the `listen_requests` FRB fn.
    ///
    /// Returns `None` if the stream has already been taken (i.e. another
    /// `listen_requests` call is already running).
    pub fn take_request_stream(&self) -> Option<impl tokio_stream::Stream<Item = RequestEnvelope>> {
        self.take_transport_stream().map(|stream| {
            stream.filter_map(|event| match event {
                HostLinkEvent::Request(request) => Some(request),
                HostLinkEvent::Cancel { .. } => None,
            })
        })
    }

    /// Take requests and cancellations once. Hosts that own persistent network
    /// subscriptions must consume this stream to release canceled transports.
    pub fn take_transport_stream(&self) -> Option<UnboundedReceiverStream<HostLinkEvent>> {
        self.request_rx
            .lock()
            .take()
            .map(UnboundedReceiverStream::new)
    }

    /// Route a response from Dart back to the waiting Rust stream.
    ///
    /// Silently ignores calls for requests that have already been completed
    /// (`complete` was called first). This handles the inherent Dart→Rust
    /// ordering race between `push_response` and `complete_transport` when both
    /// are fire-and-forget from the same `onData`/`onDone` callback pair.
    pub fn send_response(&self, request_id: u64, response: GraphQLResponse) -> anyhow::Result<()> {
        if let Some(sender) = self.response_senders.get(&request_id) {
            // Ignore send errors: the receiver was dropped if request_op
            // exited early (e.g. sink closed by .first cancellation).
            let _ = sender.send(response);
        }
        // Missing entry = request already completed; treat as no-op.
        Ok(())
    }

    /// Signal that all responses for `request_id` have been delivered.
    ///
    /// Removes and drops the sender, which closes the Rust-side response stream.
    pub fn complete(&self, request_id: u64) {
        self.response_senders.remove(&request_id);
    }
}

impl Default for HostLink {
    fn default() -> Self {
        Self::new()
    }
}

impl GraphQLLink for HostLink {
    fn execute(&self, request: Request) -> LinkStream {
        let id = self.next_id.fetch_add(1, Ordering::Relaxed);
        let (tx, rx) = mpsc::unbounded_channel::<GraphQLResponse>();
        self.response_senders.insert(id, tx);
        // Ignore send errors: if Dart hasn't yet called listen_requests the
        // channel is buffered and the envelope will be delivered once it does.
        let _ = self
            .request_tx
            .send(HostLinkEvent::Request(RequestEnvelope { id, request }));
        Box::pin(HostResponseStream {
            request_id: id,
            responses: UnboundedReceiverStream::new(rx),
            response_senders: self.response_senders.clone(),
            events: self.request_tx.clone(),
        })
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::sansio_protocols::OperationType;
    use serde_json::json;
    use std::time::Duration;

    fn request() -> Request {
        Request {
            query: "query Value { value }".into(),
            variables: Default::default(),
            operation_name: "Value".into(),
            operation_type: OperationType::Query,
            headers: None,
        }
    }

    #[tokio::test]
    async fn dropping_before_dispatch_orders_cancellation_after_request() {
        let link = HostLink::new();
        let mut events = link.take_transport_stream().expect("transport stream");
        let responses = link.execute(request());
        assert_eq!(link.response_senders.len(), 1);
        drop(responses);
        assert!(link.response_senders.is_empty());
        assert!(matches!(
            events.next().await,
            Some(HostLinkEvent::Request(RequestEnvelope { id: 0, .. }))
        ));
        assert!(matches!(
            events.next().await,
            Some(HostLinkEvent::Cancel { request_id: 0 })
        ));
        assert!(
            tokio::time::timeout(Duration::from_millis(20), events.next())
                .await
                .is_err()
        );
    }

    #[tokio::test]
    async fn completion_drains_data_and_does_not_cancel_a_later_request() {
        let link = HostLink::new();
        let mut events = link.take_transport_stream().expect("transport stream");
        let mut responses = link.execute(request());
        assert!(matches!(
            events.next().await,
            Some(HostLinkEvent::Request(RequestEnvelope { id: 0, .. }))
        ));
        link.send_response(
            0,
            GraphQLResponse::Data {
                data: json!({"value": 42}).as_object().unwrap().clone(),
                errors: None,
                extensions: None,
            },
        )
        .expect("response");
        link.complete(0);
        assert!(matches!(
            responses.next().await,
            Some(GraphQLResponse::Data { .. })
        ));
        assert!(responses.next().await.is_none());
        drop(responses);
        assert!(matches!(
            events.next().await,
            Some(HostLinkEvent::Cancel { request_id: 0 })
        ));
        let next = link.execute(request());
        link.complete(0);
        assert_eq!(link.response_senders.len(), 1);
        assert!(matches!(
            events.next().await,
            Some(HostLinkEvent::Request(RequestEnvelope { id: 1, .. }))
        ));
        drop(next);
        assert!(matches!(
            events.next().await,
            Some(HostLinkEvent::Cancel { request_id: 1 })
        ));
        assert!(link.response_senders.is_empty());
    }
}
