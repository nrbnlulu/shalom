use std::{
    collections::HashMap,
    fs,
    io::ErrorKind,
    path::{Path, PathBuf},
};

use apollo_compiler::{validation::Valid, ExecutableDocument};
use log::error;

use crate::{
    context::{
        default_config, load_config_from_yaml_str, ShalomGlobalContext, SharedShalomGlobalContext,
    },
    operation::context::SharedOpCtx,
    schema::{self, context::SharedSchemaContext},
};

pub struct FoundGqlFiles {
    pub schema: PathBuf,
    pub operations: Vec<PathBuf>,
}

pub fn find_graphql_files(pwd: &Path) -> FoundGqlFiles {
    let mut found_files = vec![];
    found_files.extend(
        glob::glob(pwd.join("**/*.graphql").to_str().unwrap())
            .into_iter()
            .flatten(),
    );
    found_files.extend(
        glob::glob(pwd.join("**/*.gql").to_str().unwrap())
            .into_iter()
            .flatten(),
    );
    let mut schema = None;
    let mut operations = vec![];
    for file in found_files {
        let file = file.unwrap();
        let f_name = file.file_name().unwrap().to_str().unwrap();
        if f_name.contains("schema.graphql") || f_name.contains("schema.gql") {
            schema = Some(file);
        } else {
            operations.push(file);
        }
    }
    FoundGqlFiles {
        schema: schema.expect("No schema.graphql file found"),
        operations,
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

pub fn parse_directory(pwd: &Path, strict: bool) -> anyhow::Result<SharedShalomGlobalContext> {
    let files = find_graphql_files(pwd);
    let schema_raw = fs::read_to_string(&files.schema)?;
    let schema_parsed = parse_schema(&schema_raw)?;

    let config_path = pwd.join("shalom.yml");

    let config = match fs::read_to_string(&config_path) {
        Ok(yaml) => load_config_from_yaml_str(&yaml)?,
        Err(e) if e.kind() == ErrorKind::NotFound => {
            log::info!(
                "⚠️  No shalom.yml found in {}. Using default config.",
                config_path.display()
            );
            default_config()
        }
        Err(e) => {
            return Err(anyhow::anyhow!(
                "Failed to read config at {}: {}",
                config_path.display(),
                e
            ))
        }
    };
    let executables = collect_executables(&files.operations, &schema_parsed.schema, strict)?;
    // TODO: collect fragments and add to global context
    // TODO: then you'd need to parse operations 

    let global_ctx = ShalomGlobalContext::new(schema_parsed, config);

    Ok(global_ctx)
}


pub fn collect_executables(files: &Vec<PathBuf>, schema: &Valid<apollo_compiler::Schema>, strict: bool) -> anyhow::Result<Vec<ExecutableDocument>>{
    let mut parser = apollo_compiler::parser::Parser::new();
    let mut ret = Vec::new();
    for file in files {
        let content = fs::read_to_string(&file)?;
        match parser.parse_executable(schema, content, file)
        .map_err(|e| anyhow::anyhow!("Failed to parse document: {}", e)){
            Ok(doc) => {
                ret.push(doc);
            },
            Err(err) => {
                if strict {
                    return Err(err);
                }
                error!("Failed to parse document: {}", err);
            }
        }
        
    }
    Ok(ret)
}