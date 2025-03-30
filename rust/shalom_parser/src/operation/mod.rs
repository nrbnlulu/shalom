use std::sync::Arc;

use apollo_compiler::{validation::Valid, ExecutableDocument};

use crate::schema::context::{SchemaContext, SharedSchemaContext};

pub mod resolver;

pub mod types;

struct OperationContext {
    schema: SharedSchemaContext,
    operation: Valid<ExecutableDocument>
}

impl OperationContext {
    pub fn new(schema: SharedSchemaContext, operation: Valid<ExecutableDocument>) -> Self {
        Self { schema, operation }
    }
}

impl OperationContext {

    pub fn operation(&self) -> &Valid<ExecutableDocument> {
        &self.operation
        
    }
}