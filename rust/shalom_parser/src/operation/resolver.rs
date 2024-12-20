use apollo_compiler::executable::Operation;
use apollo_compiler::{schema as apollo_schema, Node};

use crate::schema::context::SharedSchemaContext;


pub fn resolve(operation: &String, ctx: SharedSchemaContext) -> anyhow::Result<&Node<Operation>> {

    let query = apollo_compiler::ExecutableDocument::parse_and_validate(
        &ctx.borrow().schema, operation, "not-used-here.graphql").map_err(|e| anyhow::anyhow!("Error parsing operation: {}", e))?;
        query.operations.iter().next().ok_or_else(|| anyhow::anyhow!("No operations found in query"))


}

