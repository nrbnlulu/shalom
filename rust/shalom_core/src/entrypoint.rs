use std::{
    collections::{HashMap, VecDeque},
    fs,
    path::{Path, PathBuf},
};

use apollo_compiler::{validation::Valid, ExecutableDocument};
use log::{error, info, trace};

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
            .unwrap()
            .flatten(),
    );
    found_files.extend(
        glob::glob(pwd.join("**/*.gql").to_str().unwrap())
            .unwrap()
            .into_iter()
            .flatten(),
    );
    let mut schema = None;
    let mut operations = vec![];
    for file in found_files {
        let f_name = file.file_name().unwrap().to_str().unwrap();
        if let Ok(rel_path) = file.strip_prefix(pwd) {
            if std::process::Command::new("git")
                .args(&["check-ignore", "--quiet", rel_path.to_str().unwrap()])
                .current_dir(pwd)
                .status()
                .map(|s| s.success())
                .unwrap_or(false)
            {
                continue;
            }
        }
        if f_name == "schema.graphql" || f_name == "schema.gql" {
            schema = Some(file);
        } else if f_name.ends_with(".gql") || f_name.ends_with(".graphql") {
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

/// Load configuration from directory or use defaults
fn load_config(pwd: &Option<PathBuf>) -> anyhow::Result<ShalomConfig> {
    match pwd {
        Some(pwd) => {
            let config_path = pwd.join("shalom.yml");
            if config_path.exists() {
                ShalomConfig::from_file(&config_path)
            } else {
                Ok(ShalomConfig {
                    project_root: pwd.clone(),
                    ..Default::default()
                })
            }
        }
        None => ShalomConfig::resolve_or_default(),
    }
}

/// Parse all GraphQL documents without validation
fn parse_documents_unvalidated(
    files: &[PathBuf],
    schema: &Valid<apollo_compiler::Schema>,
    strict: bool,
) -> anyhow::Result<Vec<(ExecutableDocument, PathBuf, String)>> {
    let mut all_parsed_docs = Vec::new();
    let mut parser = apollo_compiler::parser::Parser::new();

    for file in files {
        let content = fs::read_to_string(file)?;
        let res = parser.parse_executable(schema, &content, file);
        match res {
            Ok(doc) => {
                all_parsed_docs.push((doc, file.clone(), content));
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

    Ok(all_parsed_docs)
}

struct FragmentDefInitial {
    ctx: FragmentContext,
    origin: apollo_compiler::Node<apollo_compiler::executable::Fragment>,
    sdl: String,
}
/// Extract all fragment definitions from parsed documents
fn extract_fragment_definitions(
    parsed_docs: &[(ExecutableDocument, PathBuf, String)],
) -> anyhow::Result<HashMap<String, FragmentDefInitial>> {
    let mut all_fragment_defs = HashMap::new();

    for (doc, file, _content) in parsed_docs {
        for (name, fragment_def) in doc.fragments.iter() {
            let fragment_name = name.to_string();
            info!("parsing frag {}", fragment_name);
            let type_condition = fragment_def.type_condition().to_string();

            // Extract fragment SDL for later injection
            let fragment_sdl = format!("{}", fragment_def);

            let frag_ctx = FragmentContext::new(
                fragment_name.clone(),
                fragment_sdl.clone(),
                file.clone(),
                type_condition,
            );

            if all_fragment_defs.contains_key(&fragment_name) {
                return Err(anyhow::anyhow!("Fragment {} already exists", fragment_name));
            }

            all_fragment_defs.insert(
                fragment_name,
                FragmentDefInitial {
                    ctx: frag_ctx,
                    origin: fragment_def.clone(),
                    sdl: fragment_sdl,
                },
            );
        }
    }

    Ok(all_fragment_defs)
}

/// Build fragment dependency tree and return topologically sorted order
fn build_fragment_dependencies(
    fragment_defs: &HashMap<String, FragmentDefInitial>,
) -> anyhow::Result<Vec<String>> {
    let mut dependencies: HashMap<String, Vec<String>> = HashMap::new();
    for (name, def) in fragment_defs {
        let used = crate::operation::parse::get_used_fragments_from_fragment(&def.origin);
        dependencies.insert(name.clone(), used);
    }
    trace!("before topological_sort");
    topological_sort(&dependencies).map_err(|e| {
        anyhow::anyhow!(
            "Fragment dependency cycle detected: {}. Please check your GraphQL fragments for circular references.",
            e
        )
    })
}

/// Get all dependent fragments recursively
fn get_all_dependent_fragments(
    frag_name: &str,
    dependencies: &HashMap<String, Vec<String>>,
    fragment_sdls: &HashMap<String, String>,
    visited: &mut std::collections::HashSet<String>,
) -> String {
    if visited.contains(frag_name) {
        return String::new();
    }
    visited.insert(frag_name.to_string());

    let mut result = String::new();

    // First add dependencies
    if let Some(deps) = dependencies.get(frag_name) {
        for dep in deps {
            result.push_str(&get_all_dependent_fragments(
                dep,
                dependencies,
                fragment_sdls,
                visited,
            ));
        }
    }

    // Then add this fragment
    if let Some(sdl) = fragment_sdls.get(frag_name) {
        result.push_str(sdl);
        result.push_str("\n\n");
    }

    result
}

/// Recursively collect fragment spreads from selection sets
fn collect_fragment_spreads(
    selections: &[apollo_compiler::executable::Selection],
    used_fragments: &mut std::collections::HashSet<String>,
) {
    for selection in selections {
        match selection {
            apollo_compiler::executable::Selection::Field(field) => {
                collect_fragment_spreads(&field.selection_set.selections, used_fragments);
            }
            apollo_compiler::executable::Selection::FragmentSpread(spread) => {
                used_fragments.insert(spread.fragment_name.to_string());
            }
            apollo_compiler::executable::Selection::InlineFragment(inline) => {
                collect_fragment_spreads(&inline.selection_set.selections, used_fragments);
            }
        }
    }
}

/// Validate documents with injected fragments
fn validate_documents_with_fragments(
    parsed_docs: &[(ExecutableDocument, PathBuf, String)],
    dependencies: &HashMap<String, Vec<String>>,
    fragment_sdls: &HashMap<String, String>,
    schema: &Valid<apollo_compiler::Schema>,
    strict: bool,
) -> anyhow::Result<(
    Vec<(Valid<ExecutableDocument>, PathBuf)>,
    HashMap<PathBuf, String>,
)> {
    let mut all_valid_docs = Vec::new();
    let mut augmented_contents: HashMap<PathBuf, String> = HashMap::new();
    let mut parser = apollo_compiler::parser::Parser::new();

    for (doc, file, content) in parsed_docs {
        // Skip validation for fragment-only files (no operations)
        if doc.operations.is_empty() {
            log::debug!(
                "Skipping validation for fragment-only file: {}",
                file.display()
            );
            continue;
        }

        // Find which fragments this document uses (recursively)
        let mut used_fragments = std::collections::HashSet::new();

        // Check operations
        for operation in doc.operations.iter() {
            collect_fragment_spreads(&operation.selection_set.selections, &mut used_fragments);
        }

        // Check fragments defined in this file
        for (_name, fragment_def) in doc.fragments.iter() {
            collect_fragment_spreads(&fragment_def.selection_set.selections, &mut used_fragments);
        }

        // Build augmented document with needed fragments
        let mut augmented_content = String::new();
        let mut visited = std::collections::HashSet::new();
        let mut injected_any = false;

        for frag_name in &used_fragments {
            // Skip if fragment is already defined in this document
            if doc
                .fragments
                .iter()
                .any(|(name, _)| name.as_str() == frag_name)
            {
                continue;
            }

            let deps_sdl =
                get_all_dependent_fragments(frag_name, dependencies, fragment_sdls, &mut visited);
            if !deps_sdl.is_empty() {
                augmented_content.push_str(&deps_sdl);
                injected_any = true;
            }
        }

        // Add original content
        if injected_any {
            augmented_content.push('\n');
        }
        augmented_content.push_str(content);

        // Store the augmented content for later use
        augmented_contents.insert(file.clone(), augmented_content.clone());

        // Parse and validate the augmented document
        let augmented_res = parser.parse_executable(schema, &augmented_content, file);
        match augmented_res {
            Ok(augmented_doc) => {
                let validated = augmented_doc.validate(schema);
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
                let msg = format!(
                    "Failed to parse augmented document at {}: {}",
                    file.display(),
                    e
                );
                if strict {
                    return Err(anyhow::anyhow!(msg));
                } else {
                    log::warn!("{msg}");
                }
            }
        }
    }

    Ok((all_valid_docs, augmented_contents))
}

/// Parse and register all fragments in dependency order
fn parse_and_register_fragments(
    fragment_defs: HashMap<String, FragmentDefInitial>,
    order: Vec<String>,
    global_ctx: &SharedShalomGlobalContext,
) -> anyhow::Result<()> {
    let mut final_fragment_defs: HashMap<
        String,
        (
            FragmentContext,
            apollo_compiler::Node<apollo_compiler::executable::Fragment>,
        ),
    > = HashMap::new();

    // Convert to final format (without SDL)
    for (name, def) in fragment_defs {
        final_fragment_defs.insert(name, (def.ctx, def.origin));
    }

    for name in order {
        if let Some((mut frag_ctx, frag_node)) = final_fragment_defs.remove(&name) {
            crate::operation::parse::parse_fragment(global_ctx, frag_node, &mut frag_ctx)?;
            // Register fragment immediately after parsing so it's available for subsequent fragments
            let mut single_fragment = HashMap::new();
            single_fragment.insert(name, frag_ctx);
            global_ctx.register_fragments(single_fragment)?;
        }
    }
    Ok(())
}

/// Parse and register operations from files
fn parse_and_register_operations(
    files: &[PathBuf],
    parsed_docs: &[(ExecutableDocument, PathBuf, String)],
    augmented_contents: &HashMap<PathBuf, String>,
    global_ctx: &SharedShalomGlobalContext,
) -> anyhow::Result<()> {
    let mut all_operations = HashMap::new();
    for file in files {
        // Check if this file has any operations (skip fragment-only files)
        let has_operations = parsed_docs
            .iter()
            .any(|(doc, f, _)| f == file && !doc.operations.is_empty());

        if !has_operations {
            log::debug!(
                "Skipping fragment-only file in operation parsing: {}",
                file.display()
            );
            continue;
        }

        // Use augmented content if available (with injected fragments), otherwise read from file
        let content = augmented_contents
            .get(file)
            .cloned()
            .unwrap_or_else(|| fs::read_to_string(file).unwrap());

        let operations = crate::operation::parse::parse_document(global_ctx, &content, file)?;
        all_operations.extend(operations);
    }

    // Register operations in global context
    global_ctx.register_operations(all_operations);

    Ok(())
}

pub fn parse_directory(
    pwd: &Option<PathBuf>,
    strict: bool,
) -> anyhow::Result<SharedShalomGlobalContext> {
    // Load configuration
    let config = load_config(pwd)?;
    let pwd = &config.project_root;

    // Find GraphQL files
    let files = find_graphql_files(pwd);

    // Parse schema
    let schema_raw = fs::read_to_string(&files.schema)?;
    let schema_parsed = parse_schema(&schema_raw)?;

    // Create global context
    let global_ctx = ShalomGlobalContext::new(schema_parsed, config);
    let schema = global_ctx.schema_ctx.schema.clone();
    // Parse all documents without validation
    let parsed_docs = parse_documents_unvalidated(&files.operations, &schema, strict)?;

    // Extract all fragment definitions
    let fragment_defs = extract_fragment_definitions(&parsed_docs)?;

    // Build fragment SDL map for injection
    let fragment_sdls: HashMap<String, String> = fragment_defs
        .iter()
        .map(|(name, def)| (name.clone(), def.sdl.clone()))
        .collect();

    // Build dependency map for fragment injection
    let mut dependencies: HashMap<String, Vec<String>> = HashMap::new();
    for (name, def) in &fragment_defs {
        let used = crate::operation::parse::get_used_fragments_from_fragment(&def.origin);
        dependencies.insert(name.clone(), used);
    }

    // Validate documents with injected fragments
    let (_validated_docs, augmented_contents) = validate_documents_with_fragments(
        &parsed_docs,
        &dependencies,
        &fragment_sdls,
        &schema,
        strict,
    )
    .map_err(|e| {
        if strict {
            panic!("failed to validate docs with injected fragments {e}")
        }
        e
    })?;
    info!("calling order");
    // Build fragment dependencies and get topological order
    let order = build_fragment_dependencies(&fragment_defs).map_err(|e| {
        if strict {
            panic!("failed to build frag deps {e}")
        }
        e
    })?;
    info!("order is {:?}", order);
    // Parse and register fragments
    parse_and_register_fragments(fragment_defs, order, &global_ctx).map_err(|e| {
        if strict {
            panic!("failed to build frag deps {e}")
        }
        e
    })?;

    // Parse and register operations
    parse_and_register_operations(
        &files.operations,
        &parsed_docs,
        &augmented_contents,
        &global_ctx,
    )?;

    Ok(global_ctx)
}

fn topological_sort(dependencies: &HashMap<String, Vec<String>>) -> Result<Vec<String>, String> {
    let mut in_degree: HashMap<String, usize> = HashMap::new();
    let mut graph: HashMap<String, Vec<String>> = HashMap::new();

    for (node, deps) in dependencies {
        in_degree.entry(node.clone()).or_insert(0);
        for dep in deps {
            graph.entry(dep.clone()).or_default().push(node.clone());
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
        Ok(result)
    } else {
        let missing: Vec<String> = dependencies
            .keys()
            .filter(|k| !result.contains(k))
            .cloned()
            .collect();
        Err(format!("Fragments involved in cycle: {:?}", missing))
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
        let content = fs::read_to_string(file)?;
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
