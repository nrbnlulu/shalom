use parking_lot::Mutex;
use std::collections::HashSet;
use std::pin::Pin;
use std::sync::Arc;

use serde_json::{Map, Value};
use tokio_stream::Stream;

use shalom_core::context::SharedShalomGlobalContext;
use shalom_core::operation::context::SharedOpCtx;
use shalom_core::operation::fragments::SharedFragmentContext;

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
    global_ctx: Arc<Mutex<SharedShalomGlobalContext>>,
    cache: Arc<Mutex<NormalizedCache>>,
}

impl ExecutionEngine {
    pub fn new(global_ctx: SharedShalomGlobalContext, cache: Arc<Mutex<NormalizedCache>>) -> Self {
        Self {
            global_ctx: Arc::new(Mutex::new(global_ctx)),
            cache,
        }
    }

    pub fn global_ctx(&self) -> SharedShalomGlobalContext {
        self.global_ctx.lock().clone()
    }

    pub fn replace_global_ctx(&self, new_ctx: SharedShalomGlobalContext) {
        *self.global_ctx.lock() = new_ctx;
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
        let ctx = self.global_ctx();
        let mut cache = self.cache.lock();
        Normalizer::new(ctx, &mut cache, variables).normalize_operation(op_ctx, data)
    }

    pub fn normalize_fragment_response(
        &self,
        fragment: &SharedFragmentContext,
        entity_key: &str,
        data: Value,
    ) -> anyhow::Result<NormalizationResult> {
        let ctx = self.global_ctx();
        let mut cache = self.cache.lock();
        Normalizer::new(ctx, &mut cache, None).normalize_fragment(fragment, entity_key, data)
    }

    /// Same as `normalize_response` but records the pre-write value of every
    /// top-level cache key it touches.  The snapshot is returned in
    /// `NormalizationResult::snapshot` and is used by optimistic rollback.
    pub fn normalize_response_with_snapshot(
        &self,
        op_ctx: &SharedOpCtx,
        data: Value,
        variables: Option<&Map<String, Value>>,
    ) -> anyhow::Result<NormalizationResult> {
        let ctx = self.global_ctx();
        let mut cache = self.cache.lock();
        Normalizer::new_with_snapshot(ctx, &mut cache, variables).normalize_operation(op_ctx, data)
    }
}
