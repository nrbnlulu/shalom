use serde_json::{Map, Value};

use shalom_core::context::SharedShalomGlobalContext;
use shalom_core::operation::context::SharedOpCtx;
use shalom_runtime::ShalomRuntime;
use shalom_runtime::normalization::NormalizationResult;

pub struct DartRuntime {
    runtime: ShalomRuntime,
}

impl DartRuntime {
    pub fn new(global_ctx: SharedShalomGlobalContext) -> Self {
        let runtime = ShalomRuntime::new(global_ctx);
        Self { runtime }
    }

    pub fn normalize_response(
        &self,
        op_ctx: &SharedOpCtx,
        data: Value,
        variables: Option<&Map<String, Value>>,
    ) -> anyhow::Result<NormalizationResult> {
        self.runtime.normalize(op_ctx, data, variables)
    }
}
