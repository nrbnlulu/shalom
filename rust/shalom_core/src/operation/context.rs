use std::collections::HashMap;
use std::path::PathBuf;
use std::rc::Rc;

use log::{trace, warn};
use serde::Serialize;

use super::types::{FullPathName, Selection, SharedObjectSelection};
use crate::schema::context::SharedSchemaContext;
#[derive(Debug, Serialize)]
pub struct OperationContext {
    #[serde(skip_serializing)]
    #[allow(unused)]
    schema: SharedSchemaContext,
    pub file_path: PathBuf,
    type_defs: HashMap<FullPathName, Selection>,
    root_type: Option<SharedObjectSelection>,
}

impl OperationContext {
    pub fn new(schema: SharedSchemaContext, file_path: PathBuf) -> Self {
        OperationContext {
            schema,
            file_path,
            type_defs: HashMap::new(),
            root_type: None,
        }
    }

    pub fn set_root_type(&mut self, root_type: SharedObjectSelection) {
        self.root_type = Some(root_type);
    }

    pub fn get_selection(&self, name: &FullPathName) -> Option<Selection> {
        self.type_defs.get(name).cloned()
    }

    pub fn add_selection(&mut self, name: String, selection: Selection) {
        self.type_defs.entry(name.clone()).or_insert_with(|| {
            warn!("Duplicate type definition for {}", name);
            selection
        });
    }

    pub fn add_object_selection(&mut self, name: String, object: SharedObjectSelection) {
        self.type_defs.entry(name.clone()).or_insert_with(|| {
            warn!("Duplicate type definition for {}", name);
            Selection::Object(object)
        });
    }
}

pub type SharedOpCtx = Rc<OperationContext>;
