use std::collections::HashSet;
use std::pin::Pin;
use std::sync::{Arc, Mutex};

use serde_json::{Map, Value};
use tokio_stream::Stream;

use shalom_core::context::SharedShalomGlobalContext;
use shalom_core::operation::context::SharedOpCtx;

use crate::cache::NormalizedCache;
use crate::normalization::{NormalizationResult, Normalizer};

pub type ExecutionStream = Pin<Box<dyn Stream<Item = ExecutionMessage> + Send>>;

#[derive(Debug, Clone)]
pub struct ExecutionResult {
    pub data: Value,
    pub changed: HashSet<String>,
}

#[derive(Debug, Clone)]
pub enum ExecutionMessage {
    Next(ExecutionResult),
    CacheUpdate(HashSet<String>),
}

#[derive(Clone)]
pub struct ExecutionEngine {
    global_ctx: SharedShalomGlobalContext,
    cache: Arc<Mutex<NormalizedCache>>,
}

impl ExecutionEngine {
    pub fn new(global_ctx: SharedShalomGlobalContext, cache: Arc<Mutex<NormalizedCache>>) -> Self {
        Self { global_ctx, cache }
    }

    pub fn global_ctx(&self) -> SharedShalomGlobalContext {
        self.global_ctx.clone()
    }

    pub fn cache(&self) -> Arc<Mutex<NormalizedCache>> {
        self.cache.clone()
    }

    pub fn normalize_response(
        &self,
        op_ctx: &SharedOpCtx,
        data: Value,
        variables: Option<&Map<String, Value>>,
    ) -> anyhow::Result<NormalizationResult> {
        let mut cache = self.cache.lock().expect("normalized cache lock poisoned");
        Normalizer::new(self.global_ctx.clone(), &mut cache, variables)
            .normalize_operation(op_ctx, data)
    }
}
