use std::path::{Path, PathBuf};

use apollo_compiler::validation::Valid;
use apollo_compiler::ExecutableDocument;

use crate::schema::context::SharedSchemaContext;

pub trait OperationsProvider {
    fn get_operations(&self) -> Vec<String>;
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
    fn get_operations(&self) -> Vec<String> {
        let mut operations = Vec::new();
        glob::glob(self.search_path.join("**/*.graphql").to_str().unwrap()).unwrap().for_each(|path| {
            operations.push(path.display().to_string());
        });
        operations
    }
}

fn parse_operation(ctx: SharedSchemaContext, operation: &str) -> anyhow::Result<Valid<ExecutableDocument>> {
    apollo_compiler::ExecutableDocument::parse(ctx.lock().unwrap().schema, source_text, path)
    Ok(Valid::new(document))
}

pub fn parse_operations(ctx: SharedSchemaContext, operations_provider: &dyn OperationsProvider) -> anyhow::Result<Arc<OperationsContext>> {
    let operations = operations_provider.get_operations();
    for operation in operations {
        if operation == *operation {
        }
    }
    Err(anyhow::anyhow!("Operation not found"))
}

