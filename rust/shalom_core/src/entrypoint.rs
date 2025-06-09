use std::{
    collections::HashMap,
    fs,
    path::{Path, PathBuf},
};

use crate::{
    context::{load_config_from_yaml, ShalomGlobalContext, SharedShalomGlobalContext},
    operation::context::SharedOpCtx,
    schema::{self, context::SharedSchemaContext},
};

pub struct FoundGqlFiles {
    pub schema: PathBuf,
    pub operations: Vec<PathBuf>,
}

pub fn find_graphql_files(pwd: &Path) -> FoundGqlFiles {
    let graphql_glob = pwd.join("**/*.graphql").to_str().unwrap().to_string();
    let gql_glob = pwd.join("**/*.gql").to_str().unwrap().to_string();

    let mut found_files = vec![];

    found_files.extend(
        glob::glob(&graphql_glob)
            .expect("Invalid glob pattern for .graphql")
            .filter_map(Result::ok),
    );

    found_files.extend(
        glob::glob(&gql_glob)
            .expect("Invalid glob pattern for .gql")
            .filter_map(Result::ok),
    );

    let mut schema = None;
    let mut operations = vec![];

    for file in &found_files {
        let f_name = file.file_name().unwrap().to_str().unwrap();
        if f_name.contains("schema.graphql") || f_name.contains("schema.gql") {
            schema = Some(file.clone());
        } else {
            operations.push(file.clone());
        }
    }

    if let Some(schema) = schema {
        FoundGqlFiles { schema, operations }
    } else {
        let mut msg = format!(
            "No schema.graphql or schema.gql file found in directory: {}",
            pwd.display()
        );
        for file in &found_files {
            msg.push_str(&format!("\n -> Candidate file: {}", file.display()));
        }
        panic!("{}", msg);
    }
}

pub fn parse_schema(schema: &str) -> anyhow::Result<SharedSchemaContext> {
    schema::resolver::resolve(schema)
}

pub fn parse_document(
    global_ctx: &SharedShalomGlobalContext,
    operation: &str,
    source_path: &PathBuf,
) -> anyhow::Result<HashMap<String, SharedOpCtx>> {
    crate::operation::parse::parse_document(global_ctx, operation, source_path)
}

pub fn parse_directory(pwd: &Path) -> anyhow::Result<SharedShalomGlobalContext> {
    let files = find_graphql_files(pwd);
    let schema_raw = fs::read_to_string(&files.schema)?;
    let schema_parsed = parse_schema(&schema_raw)?;

    // Correct relative path for config
    let config_path = pwd.join("shalom.yml");
    let config = load_config_from_yaml(&config_path)
        .map_err(|e| anyhow::anyhow!("Failed to load config at {}: {}", config_path.display(), e))?;

    let global_ctx = ShalomGlobalContext::new(schema_parsed, config);

    for operation in files.operations {
        let content = fs::read_to_string(&operation)?;
        let parsed = parse_document(&global_ctx, &content, &operation)?;
        global_ctx.register_operations(parsed);
    }

    Ok(global_ctx)
}

