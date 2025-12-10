
use std::sync::Arc;
use std::sync::Mutex;

use crate::cache::Cache;

pub struct ExecutionEngine {
    cache: Arc<Mutex<Cache>>,
}

pub trait Operation {
    fn raw(&self) -> &str;
    
}

impl ExecutionEngine {
    pub fn new(cache: Arc<Mutex<Cache>>) -> Self {
        ExecutionEngine { cache }
    }
    
    
}