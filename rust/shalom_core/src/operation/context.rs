use super::types::VariableDefinition;
use std::collections::HashMap;
use std::path::PathBuf;
use std::rc::Rc;

use serde::Serialize;

use super::types::{FullPathName, OperationType, Selection, SharedObjectSelection};
use crate::schema::context::SharedSchemaContext;
#[derive(Debug, Serialize)]
pub struct OperationContext {
    #[serde(skip_serializing)]
    #[allow(unused)]
    schema: SharedSchemaContext,
    pub file_path: PathBuf,
    query: String, 
    variables: HashMap<String, VariableDefinition>,
    type_defs: HashMap<FullPathName, Selection>,
    root_type: Option<SharedObjectSelection>,
    op_ty: OperationType,
}

impl OperationContext {
    pub fn new(schema: SharedSchemaContext, query: String, file_path: PathBuf, op_ty: OperationType) -> Self {
        OperationContext {
            schema,
            file_path,
            query,
            variables: HashMap::new(),
            type_defs: HashMap::new(),
            root_type: None,
            op_ty,
        }
    }

    pub fn set_root_type(&mut self, root_type: SharedObjectSelection) {
        self.root_type = Some(root_type);
    }

    pub fn get_selection(&self, name: &FullPathName) -> Option<Selection> {
        self.type_defs.get(name).cloned()
    }

    pub fn add_selection(&mut self, name: String, selection: Selection) {
        self.type_defs.entry(name.clone()).or_insert(selection);
    }

    pub fn add_variable(&mut self, name: String, variable: VariableDefinition) {
        self.variables.entry(name.clone()).or_insert(variable);
    }

    pub fn add_object_selection(&mut self, name: String, object: SharedObjectSelection) {
        self.type_defs
            .entry(name.clone())
            .or_insert(Selection::Object(object));
    }
}

pub type SharedOpCtx = Rc<OperationContext>;
