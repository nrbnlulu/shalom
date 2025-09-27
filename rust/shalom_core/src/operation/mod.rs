use crate::context::ShalomGlobalContext;

pub mod context;
pub mod fragments;
pub mod parse;
pub mod types;

pub(crate) fn parse_directory(_global_ctx: &mut ShalomGlobalContext) -> anyhow::Result<()> {
    Ok(())
}
