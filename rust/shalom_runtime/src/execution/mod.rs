
use std::pin::Pin;
use std::sync::Arc;
use std::sync::Mutex;

use shalom_core::schema::context::SchemaContext;

use crate::cache::NormalizedCache;






pub enum NextGraphQlMessage{
    Next(serde_json::Value),
    CacheUpdate(serde_json::Value),
}
type ExecutionStream = Pin<Box<dyn tokio_stream::Stream<Item = NextGraphQlMessage>>>;

pub struct ExecutionSession{
    id: u64,
    stream: ExecutionStream,
}


pub struct ExecutionEngine {
    schema: SchemaContext,
    cache: Arc<Mutex<NormalizedCache>>,
    sessions: Arc<Mutex<SessionID,  
}

pub trait Operation {
    fn raw(&self) -> &str;
    
}

impl ExecutionEngine {
    pub fn new(cache: Arc<Mutex<NormalizedCache>>) -> Self {
        ExecutionEngine { cache }
    }
    
    
    pub async fn execute(&self, operation: &str) {
        let stream = 
    }
}