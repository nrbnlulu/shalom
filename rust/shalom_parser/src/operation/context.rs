use std::path::PathBuf;
use std::sync::{Mutex, MutexGuard};
use std::{collections::HashMap, sync::Arc};

use apollo_compiler::validation::Valid;
use apollo_compiler::ExecutableDocument;
use log::warn;

use super::types::{FullPathName, ObjectSelection, Selection};
use crate::schema::context::SharedSchemaContext;

#[derive(Debug)]
pub struct OperationContext {
    schema: SharedSchemaContext,
    file_path: PathBuf,
    type_defs: Mutex<HashMap<FullPathName, Selection>>,
    root_type: Option<ObjectSelection>,
}

impl OperationContext {
    pub fn new(schema: SharedSchemaContext, file_path: PathBuf) -> Arc<Self> {
        Arc::new(OperationContext {
            schema,
            file_path,
            type_defs: Mutex::new(HashMap::new()),
            root_type: None,
        })
    }
    fn get_type_defs(&self) -> MutexGuard<HashMap<FullPathName, Selection>> {
        self.type_defs.lock().unwrap()
    }
    pub fn get_selection(&self, name: &FullPathName) -> Option<Selection> {
        let td = self.get_type_defs();
        td.get(name).cloned()
    }
    pub fn add_selection(&self, name: String, selection: Selection) {
        let mut td = self.get_type_defs();
        if !td.contains_key(&name) {
            td.insert(name, selection);
        } else {
            warn!("Duplicate type definition for {}", name);
        }
    }

    pub fn add_object_selection(&self, name: String, object: Arc<ObjectSelection>) {
        let mut td = self.get_type_defs();
        if !td.contains_key(&name) {
            td.insert(name, Selection::Object(object));
        } else {
            warn!("Duplicate type definition for {}", name);
        }
    }
}

pub type SharedOpCtx = Arc<OperationContext>;

#[derive(Debug)]
pub(crate) struct ShalomGlobalContext {
    operations: HashMap<String, Arc<OperationContext>>,
    pub schema_ctx: SharedSchemaContext,
}

pub(crate) type SharedShalomGlobalContext = Arc<ShalomGlobalContext>;

pub trait OperationsProvider {
    fn get_operations(&self) -> anyhow::Result<HashMap<PathBuf, String>>;
}

struct FileSystemOperationsProvider {
    search_path: PathBuf,
}

impl FileSystemOperationsProvider {
    pub fn new(search_path: PathBuf) -> Self {
        FileSystemOperationsProvider { search_path }
    }
}

impl OperationsProvider for FileSystemOperationsProvider {
    fn get_operations(&self) -> anyhow::Result<HashMap<PathBuf, String>> {
        glob::glob(self.search_path.join("**/*.graphql").to_str().unwrap())
            .map(|paths| {
                let mut res = HashMap::new();
                for p in paths {
                    if let Ok(path) = p {
                        if path.file_name() == Some("schema.graphql".as_ref()) {
                            continue;
                        }
                        if let Ok(source_text) = std::fs::read_to_string(&path) {
                            res.insert(path.clone(), source_text);
                        }
                    }
                }

                res
            })
            .map_err(|e| anyhow::anyhow!("Error reading operations: {}", e))
    }
}

fn parse_gql_document(
    ctx: SharedSchemaContext,
    source_text: &str,
    path: PathBuf,
) -> anyhow::Result<Valid<ExecutableDocument>> {
    let res = apollo_compiler::ExecutableDocument::parse(&ctx.schema, source_text, path)
        .map_err(|e| anyhow::anyhow!("Error parsing operation: {}", e))
        .and_then(|doc| {
            doc.validate(&ctx.schema)
                .map_err(|e| anyhow::anyhow!("Error validating operation: {:?}", e.errors))
        });
    res
}
