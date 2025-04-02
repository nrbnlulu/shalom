use std::path::PathBuf;
use std::{collections::HashMap, sync::Arc};

use log::warn;
use serde::Serialize;

use super::types::{FullPathName, ObjectSelection, Selection};
use crate::schema::context::SharedSchemaContext;

#[derive(Debug, Serialize)]
pub struct OperationContext {
    #[serde(skip_serializing)]
    schema: SharedSchemaContext,
    pub file_path: PathBuf,
    type_defs: HashMap<FullPathName, Selection>,
    root_type: Option<Arc<ObjectSelection>>,
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
    pub fn set_root_type(&mut self, root_type: Arc<ObjectSelection>) {
        self.root_type = Some(root_type);
    }

    pub fn get_selection(&self, name: &FullPathName) -> Option<Selection> {
        self.type_defs.get(name).cloned()
    }

    pub fn add_selection(&mut self, name: String, selection: Selection) {
        if !self.type_defs.contains_key(&name) {
            self.type_defs.insert(name, selection);
        } else {
            warn!("Duplicate type definition for {}", name);
        }
    }

    pub fn add_object_selection(&mut self, name: String, object: Arc<ObjectSelection>) {
        if !self.type_defs.contains_key(&name) {
            self.type_defs.insert(name, Selection::Object(object));
        } else {
            warn!("Duplicate type definition for {}", name);
        }
    }
}

pub type SharedOpCtx = Arc<OperationContext>;
