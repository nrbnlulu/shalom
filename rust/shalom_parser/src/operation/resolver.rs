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

pub fn resolve(operation: &String, ctx: SharedSchemaContext, operations_provider: &dyn OperationsProvider) -> anyhow::Result<Valid<ExecutableDocument>> {
    let operations = operations_provider.get_operations();
    
    let doc = apollo_compiler::ExecutableDocument::parse_and_validate(
        &ctx.borrow().schema, operation, "not-used-here.graphql").map_err(|e| anyhow::anyhow!("Error parsing operation: {}", e))?;
        
        Ok(doc)
}

