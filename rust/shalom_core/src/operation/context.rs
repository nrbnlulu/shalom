use std::collections::HashMap;
use std::path::PathBuf;
use std::rc::Rc;

use serde::Serialize;

use super::types::{FullPathName, OperationType, Selection, SharedObjectSelection};
use crate::schema::{context::SharedSchemaContext, types::InputFieldDefinition};
#[derive(Debug, Serialize)]
pub struct OperationContext {
    #[serde(skip_serializing)]
    #[allow(unused)]
    schema: SharedSchemaContext,
    operation_name: String,
    pub file_path: PathBuf,
    query: String,
    variables: HashMap<String, InputFieldDefinition>,
    type_defs: HashMap<FullPathName, Selection>,
    root_type: Option<Selection>,
    op_ty: OperationType,
}

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
            type_defs: HashMap::new(),
            root_type: None,
            op_ty,
        }
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

    pub fn add_variable(&mut self, name: String, variable: InputFieldDefinition) {
        self.variables.entry(name).or_insert(variable);
    }
}

pub type SharedOpCtx = Rc<OperationContext>;
