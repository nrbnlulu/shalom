use std::collections::HashMap;
use std::path::PathBuf;

use apollo_compiler::ExecutableDocument;

use crate::schema::context::SharedSchemaContext;

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

fn parse_operation(
    ctx: SharedSchemaContext,
    source_text: &str,
    path: PathBuf,
) -> anyhow::Result<ExecutableDocument> {
    apollo_compiler::ExecutableDocument::parse(&ctx.schema, source_text, path)
        .map_err(|e| anyhow::anyhow!("Error parsing operation: {}", e))
}
