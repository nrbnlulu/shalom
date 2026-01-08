use std::collections::HashMap;
use std::sync::atomic::{AtomicU64, Ordering};
use std::sync::{Arc, Mutex};

use tokio::sync::mpsc;
use tokio_stream::wrappers::UnboundedReceiverStream;

use crate::link::{GraphQLLink, GraphQLResponse, Headers, LinkStream, Request};

#[derive(Debug, Clone, serde::Serialize, serde::Deserialize)]
pub struct RequestEnvelope {
    pub id: u64,
    pub request: Request,
}

pub struct HostLink {
    next_id: AtomicU64,
    outgoing_tx: mpsc::UnboundedSender<RequestEnvelope>,
    outgoing_rx: Mutex<Option<mpsc::UnboundedReceiver<RequestEnvelope>>>,
    responses: Mutex<HashMap<u64, mpsc::UnboundedSender<GraphQLResponse>>>,
}

impl HostLink {
    pub fn new() -> Arc<Self> {
        let (tx, rx) = mpsc::unbounded_channel();
        Arc::new(Self {
            next_id: AtomicU64::new(1),
            outgoing_tx: tx,
            outgoing_rx: Mutex::new(Some(rx)),
            responses: Mutex::new(HashMap::new()),
        })
    }

    pub fn take_request_stream(&self) -> Option<UnboundedReceiverStream<RequestEnvelope>> {
        let mut rx = self
            .outgoing_rx
            .lock()
            .expect("host link request receiver lock poisoned");
        rx.take().map(UnboundedReceiverStream::new)
    }

    pub fn send_response(&self, id: u64, response: GraphQLResponse) -> anyhow::Result<()> {
        let mut responses = self
            .responses
            .lock()
            .expect("host link response map lock poisoned");
        if let Some(sender) = responses.get(&id) {
            if sender.send(response).is_err() {
                responses.remove(&id);
            }
            Ok(())
        } else {
            Err(anyhow::anyhow!("unknown request id {id}"))
        }
    }

    fn register_response_stream(&self, id: u64) -> LinkStream {
        let (tx, rx) = mpsc::unbounded_channel();
        self.responses
            .lock()
            .expect("host link response map lock poisoned")
            .insert(id, tx);
        Box::pin(UnboundedReceiverStream::new(rx))
    }
}

impl GraphQLLink for HostLink {
    fn execute(&self, request: Request, _headers: Option<Headers>) -> LinkStream {
        let id = self.next_id.fetch_add(1, Ordering::Relaxed);
        let stream = self.register_response_stream(id);
        let envelope = RequestEnvelope { id, request };
        if self.outgoing_tx.send(envelope).is_err() {
            let (tx, rx) = mpsc::unbounded_channel();
            let _ = tx.send(GraphQLResponse::TransportError(
                crate::link::TransportError {
                    message: "Host transport disconnected".to_string(),
                    code: "host_disconnected".to_string(),
                    details: None,
                },
            ));
            return Box::pin(UnboundedReceiverStream::new(rx));
        }
        stream
    }
}
