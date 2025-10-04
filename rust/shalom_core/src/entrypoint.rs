use std::{
    collections::{HashMap, VecDeque},
    fs,
    path::{Path, PathBuf},
};

use apollo_compiler::{validation::Valid, ExecutableDocument};
use log::error;

use crate::{
    context::{ShalomGlobalContext, SharedShalomGlobalContext},
    operation::{context::SharedOpCtx, fragments::FragmentContext},
    schema::{self, context::SharedSchemaContext},
    shalom_config::ShalomConfig,
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

pub fn parse_directory(
    pwd: &Option<PathBuf>,
    strict: bool,
) -> anyhow::Result<SharedShalomGlobalContext> {
    let config = match pwd {
        Some(pwd) => {
            let config_path = pwd.join("shalom.yml");
            if config_path.exists() {
                ShalomConfig::from_file(&config_path).unwrap()
            } else {
                let mut config = ShalomConfig::default();
                config.project_root = pwd.clone();
                config
            }
        }
        None => ShalomConfig::resolve_or_default().unwrap(),
    };
    let pwd = &config.project_root;
    let files = find_graphql_files(pwd);
    let schema_raw = fs::read_to_string(&files.schema)?;
    let schema_parsed = parse_schema(&schema_raw)?;

    let global_ctx = ShalomGlobalContext::new(schema_parsed, config);

    let mut all_valid_docs = Vec::new();
    let schema = global_ctx.schema_ctx.schema.clone();
    let mut parser = apollo_compiler::parser::Parser::new();
    for file in &files.operations {
        let res = parser.parse_executable(&schema, &fs::read_to_string(&file)?, file);
        match res {
            Ok(doc) => {
                let validated = doc.validate(&schema);
                match validated {
                    Ok(valid_doc) => all_valid_docs.push((valid_doc, file.clone())),
                    Err(e) => {
                        let msg =
                            format!("Failed to validate document at {}: {}", file.display(), e);
                        if strict {
                            return Err(anyhow::anyhow!(msg));
                        } else {
                            log::warn!("{msg}");
                        }
                    }
                }
            }
            Err(e) => {
                let msg = format!("Failed to parse document at {}: {}", file.display(), e);
                if strict {
                    return Err(anyhow::anyhow!(msg));
                } else {
                    log::warn!("{msg}");
                }
            }
        }
    }

    let mut all_fragment_defs: HashMap<
        String,
        (
            FragmentContext,
            apollo_compiler::Node<apollo_compiler::executable::Fragment>,
        ),
    > = HashMap::new();
    for (doc, file) in &all_valid_docs {
        let fragments = crate::operation::fragments::get_fragments_from_document(
            &global_ctx,
            doc.clone(),
            file,
        )?;
        for (name, (frag_ctx, frag_node)) in fragments {
            if all_fragment_defs.contains_key(&name) {
                return Err(anyhow::anyhow!("Fragment {} already exists", name));
            }
            all_fragment_defs.insert(name, (frag_ctx, frag_node));
        }
    }

    // Build dependencies
    let mut dependencies: HashMap<String, Vec<String>> = HashMap::new();
    for (name, (_, frag_node)) in &all_fragment_defs {
        let used = crate::operation::parse::get_used_fragments_from_fragment(frag_node);
        dependencies.insert(name.clone(), used);
    }

    let order = topological_sort(&dependencies);

    let mut parsed_fragments: HashMap<String, FragmentContext> = HashMap::new();
    for name in order {
        if let Some((mut frag_ctx, frag_node)) = all_fragment_defs.remove(&name) {
            crate::operation::parse::parse_fragment(&global_ctx, frag_node, &mut frag_ctx)?;
            parsed_fragments.insert(name, frag_ctx);
        }
    }

    // Register fragments in global context
    global_ctx.register_fragments(parsed_fragments);

    // Second pass: collect all operations (now that fragments are available)
    let mut all_operations = HashMap::new();
    for file in &files.operations {
        let content = fs::read_to_string(&file)?;
        let operations = crate::operation::parse::parse_document(&global_ctx, &content, file)?;
        all_operations.extend(operations);
    }

    // Register operations in global context
    global_ctx.register_operations(all_operations);

    Ok(global_ctx)
}

fn topological_sort(dependencies: &HashMap<String, Vec<String>>) -> Vec<String> {
    let mut in_degree: HashMap<String, usize> = HashMap::new();
    let mut graph: HashMap<String, Vec<String>> = HashMap::new();

    for (node, deps) in dependencies {
        in_degree.entry(node.clone()).or_insert(0);
        for dep in deps {
            graph
                .entry(dep.clone())
                .or_insert(Vec::new())
                .push(node.clone());
            *in_degree.entry(node.clone()).or_insert(0) += 1;
        }
    }

    let mut queue: VecDeque<String> = in_degree
        .iter()
        .filter(|(_, &deg)| deg == 0)
        .map(|(k, _)| k.clone())
        .collect();
    let mut result = Vec::new();

    while let Some(node) = queue.pop_front() {
        result.push(node.clone());
        if let Some(neighbors) = graph.get(&node) {
            for neighbor in neighbors {
                if let Some(deg) = in_degree.get_mut(neighbor) {
                    *deg -= 1;
                    if *deg == 0 {
                        queue.push_back(neighbor.clone());
                    }
                }
            }
        }
    }

    if result.len() == dependencies.len() {
        result
    } else {
        panic!("Cycle in fragment dependencies");
    }
}

pub fn collect_executables(
    files: &Vec<PathBuf>,
    schema: &Valid<apollo_compiler::Schema>,
    strict: bool,
) -> anyhow::Result<Vec<ExecutableDocument>> {
    let mut parser = apollo_compiler::parser::Parser::new();
    let mut ret = Vec::new();
    for file in files {
        let content = fs::read_to_string(&file)?;
        match parser
            .parse_executable(schema, content, file)
            .map_err(|e| anyhow::anyhow!("Failed to parse document: {}", e))
        {
            Ok(doc) => {
                ret.push(doc);
            }
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
