use std::path::PathBuf;
use std::{collections::HashMap, sync::Arc};

use serde::Serialize;

use super::types::{FullPathName, Selection, SharedInterfaceSelection, SharedUnionSelection};

use crate::context::ShalomGlobalContext;
use crate::operation::types::SelectionKind;
use crate::schema::context::SharedSchemaContext;
pub type SharedFragmentContext = Arc<FragmentContext>;

#[derive(Debug, Clone, Serialize)]
pub struct FragmentContext {
    #[serde(skip_serializing)]
    #[allow(unused)]
    schema: SharedSchemaContext,
    name: String,
    pub fragment_raw: String,
    #[serde(skip_serializing)]
    pub file_path: PathBuf,
    type_defs: HashMap<FullPathName, Selection>,
    pub root_type: Option<Selection>,
    pub used_fragments: Vec<SharedFragmentContext>,
    pub type_condition: String,
    union_types: HashMap<FullPathName, SharedUnionSelection>,
    interface_types: HashMap<FullPathName, SharedInterfaceSelection>,
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
            union_types: HashMap::new(),
            interface_types: HashMap::new(),
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
    /// return the selections of this fragment and every fragment that exist in the root selection object.
    pub fn get_flat_selections(&self, global_ctx: &ShalomGlobalContext) -> Vec<Selection> {
        let mut selections = Vec::new();
        if let Some(root_type) = self.root_type.as_ref() {
            if let SelectionKind::Object(obj) = &root_type.kind {
                selections.extend(obj.selections.clone().into_inner());
                for frag_name in obj.get_used_fragments() {
                    let frag = global_ctx.get_fragment(&frag_name).unwrap();
                    selections.extend(frag.get_flat_selections(global_ctx));
                }
            }
        }
        selections
    }

    pub fn add_union_type(&mut self, name: String, union_selection: SharedUnionSelection) {
        self.union_types.entry(name).or_insert(union_selection);
    }

    pub fn get_union_types(&self) -> &HashMap<FullPathName, SharedUnionSelection> {
        &self.union_types
    }

    pub fn add_interface_type(
        &mut self,
        name: String,
        interface_selection: SharedInterfaceSelection,
    ) {
        self.interface_types
            .entry(name)
            .or_insert(interface_selection);
    }

    pub fn get_interface_types(&self) -> &HashMap<FullPathName, SharedInterfaceSelection> {
        &self.interface_types
    }
}

unsafe impl Send for FragmentContext {}
unsafe impl Sync for FragmentContext {}
