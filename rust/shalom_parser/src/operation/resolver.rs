use apollo_compiler::validation::Valid;
use apollo_compiler::ExecutableDocument;

use crate::schema::context::SharedSchemaContext;


pub fn resolve(operation: &String, ctx: SharedSchemaContext) -> anyhow::Result<Valid<ExecutableDocument>> {

    let doc = apollo_compiler::ExecutableDocument::parse_and_validate(
        &ctx.read().unwrap().schema, operation, "not-used-here.graphql").map_err(|e| anyhow::anyhow!("Error parsing operation: {}", e))?;
        Ok(doc)
}

