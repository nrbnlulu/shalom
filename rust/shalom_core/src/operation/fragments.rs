use std::{collections::HashMap, sync::Arc};
use std::path::PathBuf;

use serde::Serialize;

use super::types::{FullPathName, Selection};
use crate::schema::context::SharedSchemaContext;
pub type SharedFragmentContext = Arc<FragmentContext>;

#[derive(Debug, Serialize)]
pub struct FragmentContext {
    #[serde(skip_serializing)]
    #[allow(unused)]
    schema: SharedSchemaContext,
    name: String,
    pub file_path: PathBuf,
    fragment: String,
    type_defs: HashMap<FullPathName, Selection>,
    root_type: Option<Selection>,
    pub used_fragments: Vec<SharedFragmentContext>
}







