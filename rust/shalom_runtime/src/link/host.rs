use std::sync::atomic::{AtomicU64, Ordering};
use std::sync::Mutex;

use dashmap::DashMap;
use serde::{Deserialize, Serialize};
use tokio::sync::mpsc;
use tokio_stream::wrappers::UnboundedReceiverStream;

use crate::link::{GraphQLLink, GraphQLResponse, LinkStream, Request};

pub type OperationId = u64;

/// An outbound request envelope emitted by the runtime towards the host (Dart).
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct RequestEnvelope {
    pub id: OperationId,
    pub request: Request,
}

/// Bidirectional transport bridge between the Rust runtime and the host language
/// (Dart). Rust emits `RequestEnvelope` items outbound; the host feeds
/// `GraphQLResponse` items back per operation id.
///
/// # Design notes
/// - The outbound channel is an *unbounded* SPSC stream. In practice the number
///   of simultaneous in-flight operations is small, so this is safe.
/// - The inbound channels are *bounded* (`RESPONSE_CHANNEL_CAPACITY`) to avoid
///   unbounded memory growth if Dart pushes faster than Rust normalises.
/// - `DashMap` is used for `response_senders` because `push_response` can be
///   called concurrently from Dart for different operation ids (multiple WS
///   subscriptions firing simultaneously). Per-shard locking prevents one
///   operation's response from blocking another's.
pub struct HostLink {
    /// Outbound: Rust → Dart. Emits one `RequestEnvelope` per `execute()` call.
    request_tx: mpsc::UnboundedSender<RequestEnvelope>,
    /// Taken once by `take_request_stream()`; after that this is `None`.
    request_rx: Mutex<Option<mpsc::UnboundedReceiver<RequestEnvelope>>>,

    /// Inbound: per-operation response feeds. Dart calls `send_response()` to
    /// push `GraphQLResponse` chunks; Rust reads them via the stream returned
    /// from `execute()`.
    response_senders: DashMap<OperationId, mpsc::Sender<GraphQLResponse>>,

    next_op_id: AtomicU64,
}

const RESPONSE_CHANNEL_CAPACITY: usize = 50;

impl HostLink {
    pub fn new() -> std::sync::Arc<Self> {
        let (request_tx, request_rx) = mpsc::unbounded_channel();
        std::sync::Arc::new(Self {
            request_tx,
            request_rx: Mutex::new(Some(request_rx)),
            response_senders: DashMap::new(),
            next_op_id: AtomicU64::new(1),
        })
    }

    /// Claim the outbound request stream. May only be called once; returns
    /// `None` if the stream has already been taken (e.g. duplicate init).
    pub fn take_request_stream(
        &self,
    ) -> Option<impl tokio_stream::Stream<Item = RequestEnvelope>> {
        let rx = self
            .request_rx
            .lock()
            .expect("request_rx lock poisoned")
            .take()?;
        Some(UnboundedReceiverStream::new(rx))
    }

    /// Push a response chunk for an in-flight operation. May be called multiple
    /// times for the same `op_id` (e.g. WS subscriptions). Returns `Err` if
    /// the operation is unknown or its channel is full / closed.
    pub fn send_response(
        &self,
        op_id: OperationId,
        response: GraphQLResponse,
    ) -> anyhow::Result<()> {
        let sender = self
            .response_senders
            .get(&op_id)
            .ok_or_else(|| anyhow::anyhow!("no in-flight operation with id {op_id}"))?;
        sender
            .try_send(response)
            .map_err(|e| anyhow::anyhow!("failed to deliver response for op {op_id}: {e}"))
    }

    /// Signal that the host has finished sending responses for `op_id`. This
    /// drops the sender, which closes the corresponding `rx` stream inside
    /// `execute()`, terminating the caller's response stream cleanly.
    pub fn complete(&self, op_id: OperationId) {
        self.response_senders.remove(&op_id);
    }
}

impl GraphQLLink for HostLink {
    fn execute(&self, request: Request) -> LinkStream {
        let op_id = self.next_op_id.fetch_add(1, Ordering::Relaxed);

        let (tx, rx) = mpsc::channel(RESPONSE_CHANNEL_CAPACITY);
        self.response_senders.insert(op_id, tx);

        let envelope = RequestEnvelope { id: op_id, request };
        // If the outbound channel is closed (Dart disposed the runtime), drop
        // the sender so the rx stream ends immediately.
        if self.request_tx.send(envelope).is_err() {
            self.response_senders.remove(&op_id);
        }

        let stream = async_stream::stream! {
            let mut rx = rx;
            while let Some(response) = rx.recv().await {
                yield response;
            }
        };
        Box::pin(stream)
    }
}
