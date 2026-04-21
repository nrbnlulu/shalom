//! Bidirectional host link: forwards Rust-initiated requests to Dart over a
//! channel and routes Dart-supplied responses back into Rust streams.
//!
//! # Flow
//!
//! 1. Dart calls `listen_requests` (FRB) → takes the receiver half of the
//!    request channel and streams serialised [`RequestEnvelope`]s to Dart.
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

use std::sync::atomic::{AtomicU64, Ordering};
use parking_lot::Mutex;

use dashmap::DashMap;
use serde::Serialize;
use tokio::sync::mpsc;
use tokio_stream::wrappers::UnboundedReceiverStream;

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

/// Bidirectional bridge between the Rust runtime and the Dart transport layer.
pub struct HostLink {
    next_id: AtomicU64,
    /// Sender for outgoing request envelopes (consumed by Dart via FRB).
    request_tx: mpsc::UnboundedSender<RequestEnvelope>,
    /// Taken once by `listen_requests` so Dart can own the receiving end.
    request_rx: Mutex<Option<mpsc::UnboundedReceiver<RequestEnvelope>>>,
    /// Per-request senders; each maps a request ID to its response channel.
    response_senders: DashMap<u64, mpsc::UnboundedSender<GraphQLResponse>>,
}

impl HostLink {
    pub fn new() -> Self {
        let (tx, rx) = mpsc::unbounded_channel();
        Self {
            next_id: AtomicU64::new(0),
            request_tx: tx,
            request_rx: Mutex::new(Some(rx)),
            response_senders: DashMap::new(),
        }
    }

    /// Take the request stream once — called by the `listen_requests` FRB fn.
    ///
    /// Returns `None` if the stream has already been taken (i.e. another
    /// `listen_requests` call is already running).
    pub fn take_request_stream(
        &self,
    ) -> Option<impl tokio_stream::Stream<Item = RequestEnvelope>> {
        self.request_rx
            .lock().take()
            .map(UnboundedReceiverStream::new)
    }

    /// Route a response from Dart back to the waiting Rust stream.
    ///
    /// Silently ignores calls for requests that have already been completed
    /// (`complete` was called first). This handles the inherent Dart→Rust
    /// ordering race between `push_response` and `complete_transport` when both
    /// are fire-and-forget from the same `onData`/`onDone` callback pair.
    pub fn send_response(
        &self,
        request_id: u64,
        response: GraphQLResponse,
    ) -> anyhow::Result<()> {
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
        let _ = self.request_tx.send(RequestEnvelope { id, request });
        Box::pin(UnboundedReceiverStream::new(rx))
    }
}
