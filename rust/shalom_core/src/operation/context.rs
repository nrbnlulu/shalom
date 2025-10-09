use std::collections::HashMap;
use std::path::PathBuf;
use std::sync::Arc;

use apollo_compiler::ast::Type;
use serde::Serialize;

use super::fragments::SharedFragmentContext;
use super::types::{
    FullPathName, OperationType, Selection, SharedInterfaceSelection, SharedUnionSelection,
};
use crate::schema::{context::SharedSchemaContext, types::InputFieldDefinition};
pub type OperationVariable = InputFieldDefinition;



#[derive(Debug, Serialize)]
pub struct TypeDefs{
    selection_objects: HashMap<FullPathName, Selection>,
    union_selections: HashMap<FullPathName, Selection>,
    interface_selections: HashMap<FullPathName, Selection>,
}
impl TypeDefs{
    pub fn new(
    ) -> Self {
        TypeDefs {
            selection_objects: HashMap::new(),
            union_selections: HashMap::new(),
            interface_selections: HashMap::new(),
        }
    }

    pub fn add_object_selection(&mut self, name: String, selection: Selection) {
        self.selection_objects.entry(name.clone()).or_insert(selection);
    }
    
    pub fn get_object_selection(&self, name: &FullPathName) -> Option<&Selection> {
        self.selection_objects.get(name)
    }
    
    pub fn add_union_selection(&mut self, name: String, selection: Selection) {
        self.union_selections.entry(name.clone()).or_insert(selection);
    }
    pub fn get_union_selection(&self, name: &FullPathName) -> Option<&Selection> {
        self.union_selections.get(name)
    }
    
    pub fn add_interface_selection(&mut self, name: String, selection: Selection) {
        self.interface_selections.entry(name.clone()).or_insert(selection);
    }
    pub fn get_interface_selection(&self, name: &FullPathName) -> Option<&Selection> {
        self.interface_selections.get(name)
    }
    
}

#[derive(Debug, Serialize)]
pub struct OperationContext {
    #[serde(skip_serializing)]
    #[allow(unused)]
    schema: SharedSchemaContext,
    operation_name: String,
    pub file_path: PathBuf,
    query: String,
    variables: HashMap<String, OperationVariable>,
    pub type_defs: TypeDefs,
    root_type: Option<Selection>,
    op_ty: OperationType,
    pub used_fragments: Vec<SharedFragmentContext>,
    union_types: HashMap<FullPathName, SharedUnionSelection>,
    interface_types: HashMap<FullPathName, SharedInterfaceSelection>,
}

unsafe impl Send for OperationContext {}
unsafe impl Sync for OperationContext {}

impl OperationContext {
    pub fn new(
        schema: SharedSchemaContext,
        operation_name: String,
        query: String,
        file_path: PathBuf,
        op_ty: OperationType,
    ) -> Self {
        OperationContext {
            schema,
            operation_name,
            file_path,
            query,
            variables: HashMap::new(),
            type_defs: TypeDefs::new(),
            root_type: None,
            op_ty,
            used_fragments: Vec::new(),
            union_types: HashMap::new(),
            interface_types: HashMap::new(),
        }
    }
    pub fn get_operation_name(&self) -> &str {
        &self.operation_name
    }
    pub fn has_variables(&self) -> bool {
        !self.variables.is_empty()
    }

    pub fn set_root_type(&mut self, root_type: Selection) {
        self.root_type = Some(root_type);
    }

    pub fn add_variable(&mut self, name: String, variable: OperationVariable) {
        self.variables.entry(name).or_insert(variable);
    }
    pub fn get_variable(&self, name: &str) -> Option<&OperationVariable> {
        self.variables.get(name)
    }

    pub fn add_used_fragment(&mut self, fragment: SharedFragmentContext) {
        self.used_fragments.push(fragment);
    }

    pub fn get_used_fragments(&self) -> &Vec<SharedFragmentContext> {
        &self.used_fragments
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

pub type SharedOpCtx = Arc<OperationContext>;
