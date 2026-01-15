use std::collections::HashMap;
use std::sync::atomic::{AtomicU64, Ordering};
use std::sync::{Arc, Mutex};

use tokio::sync::mpsc;
use tokio_stream::wrappers::{ReceiverStream, UnboundedReceiverStream};

use crate::link::{GraphQLLink, GraphQLResponse, Headers, LinkStream, Request};

#[derive(Debug, Clone, serde::Serialize, serde::Deserialize)]
pub struct RequestEnvelope {
    pub id: u64,
    pub request: Request,
}

pub type OperationId = u64;
pub struct HostLink {
    /// these would be populated whne the runtimes calls link.request(), then
    /// the target language can take the sender for X op id and send the actual
    /// json data here.
    ready_senders: Mutex<HashMap<OperationId, mpsc::Sender<GraphQLResponse>>>,
}

impl HostLink {
    pub fn new() -> Arc<Self> {
        let (tx, rx) = mpsc::unbounded_channel();
        Arc::new(Self {
            ready_senders: Mutex::new(HashMap::new()),
        })
    }
}

impl GraphQLLink for HostLink {
    fn execute(&self, request: Request) -> LinkStream {
        let (tx, rx) = mpsc::channel(50);
        {
            // inject the sender into the ready_senders map
            let mut ready_senders = self.ready_senders.lock().unwrap();
            let id = ready_senders.len() as u64;
            ready_senders.insert(id, tx);
        }
        let ret = async_stream::stream!{
            loop {
                let response = rx.recv().await;
                match response {
                    Some(response) => yield response,
                    None => break,
                }
            }
        };
        ret
    }
}
