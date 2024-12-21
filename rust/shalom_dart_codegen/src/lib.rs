use std::sync::Arc;

use apollo_compiler::{executable::Operation, Node};
use shalom_parser::{schema::context::SharedSchemaContext, GenerationContext};

fn generate(
    ctx: Arc<GenerationContext>
) -> anyhow::Result<()> {
    generate_schema(ctx.schema.clone())?;


    Ok(())
}


fn generate_schema(schema: SharedSchemaContext) -> anyhow::Result<()> {
  
    Ok(())
}

fn generate_operation(op: Node<Operation>, ctx: Arc<GenerationContext>) -> anyhow::Result<()> {
    Ok(())
}