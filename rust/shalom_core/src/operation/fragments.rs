use std::path::PathBuf;
use std::{collections::HashMap, sync::Arc};

use apollo_compiler::{executable as apollo_executable, validation::Valid};
use serde::Serialize;

use super::types::{FullPathName, Selection};
use crate::context::SharedShalomGlobalContext;
use crate::operation::parse::parse_selection_set;
use crate::schema::context::SharedSchemaContext;
pub type SharedFragmentContext = Arc<FragmentContext>;

#[derive(Debug, Clone, Serialize)]
pub struct FragmentContext {
    #[serde(skip_serializing)]
    #[allow(unused)]
    schema: SharedSchemaContext,
    name: String,
    fragment_raw: String,
    #[serde(skip_serializing)]
    pub file_path: PathBuf,
    type_defs: HashMap<FullPathName, Selection>,
    pub root_type: Option<Selection>,
    pub used_fragments: Vec<SharedFragmentContext>,
    pub type_condition: String,
}

impl FragmentContext {
    pub fn new(
        schema: SharedSchemaContext,
        name: String,
        fragment_raw: String,
        file_path: PathBuf,
        type_condition: String,
    ) -> Self {
        FragmentContext {
            schema,
            name,
            file_path,
            fragment_raw,
            type_defs: HashMap::new(),
            root_type: None,
            used_fragments: Vec::new(),
            type_condition,
        }
    }

    pub fn get_fragment_name(&self) -> &str {
        &self.name
    }

    pub fn get_type_condition(&self) -> &str {
        &self.type_condition
    }

    pub fn set_root_type(&mut self, root_type: Selection) {
        self.root_type = Some(root_type);
    }

    pub fn get_selection(&self, name: &FullPathName) -> Option<Selection> {
        self.type_defs.get(name).cloned()
    }

    pub fn add_selection(&mut self, name: String, selection: Selection) {
        self.type_defs.entry(name.clone()).or_insert(selection);
    }

    pub fn add_used_fragment(&mut self, fragment: SharedFragmentContext) {
        self.used_fragments.push(fragment);
    }

    pub fn get_used_fragments(&self) -> &Vec<SharedFragmentContext> {
        &self.used_fragments
    }

    pub fn get_root_type(&self) -> Option<&Selection> {
        self.root_type.as_ref()
    }
}

// Parse fragments from executable document
pub(crate) fn get_fragments_from_document(
    global_ctx: &SharedShalomGlobalContext,
    doc_orig: Valid<apollo_compiler::ExecutableDocument>,
    doc_path: &PathBuf,
) -> anyhow::Result<
    HashMap<
        String,
        (
            FragmentContext,
            apollo_compiler::Node<apollo_executable::Fragment>,
        ),
    >,
> {
    let mut ret = HashMap::new();

    // First pass: Create fragment contexts without processing spreads
    for (name, fragment) in doc_orig.fragments.iter() {
        let fragment_name = name.to_string();
        let fragment_raw = fragment.to_string();
        let type_condition = fragment.type_condition().to_string();

        let ctx = FragmentContext::new(
            global_ctx.schema_ctx.clone(),
            fragment_name.clone(),
            fragment_raw,
            doc_path.clone(),
            type_condition,
        );
        ret.insert(fragment_name.clone(), (ctx, fragment.clone()));
    }

    Ok(ret)
}
