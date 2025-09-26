use crate::context::{ShalomGlobalContext, SharedShalomGlobalContext};

pub mod context;
pub mod parse;
pub mod fragments;
pub mod types;




pub(crate) fn parse_directory(
    global_ctx: &mut ShalomGlobalContext,
) -> anyhow::Result<()> {
    
    
    Ok(())
}