use anyhow::Result;
use lazy_static::lazy_static;
use log::{error, info};
use minijinja::{context, value::ViaDeserialize, Environment};
use serde::Serialize;
use shalom_core::{
    context::{ShalomGlobalContext, SharedShalomGlobalContext},
    operation::{
        context::SharedOpCtx,
        fragments::SharedFragmentContext,
        parse::ExecutableContext,
        types::{dart_type_for_scalar, has_id_selection, Selection, SelectionKind},
    },
    schema::{
        context::SchemaContext,
        types::{GraphQLAny, InputFieldDefinition, SchemaFieldCommon},
    },
    shalom_config::RuntimeSymbolDefinition,
};

use std::{
    collections::HashMap,
    fs,
    hash::{DefaultHasher, Hash, Hasher},
    path::{Path, PathBuf},
    sync::Arc,
};

lazy_static! {
    static ref DEFAULT_SCALARS_MAP: HashMap<String, String> = HashMap::from([
        ("ID".to_string(), "String".to_string()),
        ("String".to_string(), "String".to_string()),
        ("Int".to_string(), "int".to_string()),
        ("Float".to_string(), "double".to_string()),
        ("Boolean".to_string(), "bool".to_string()),
    ]);
}

#[cfg(windows)]
const LINE_ENDING: &str = "\r\n";
#[cfg(not(windows))]
const LINE_ENDING: &str = "\n";

mod ext_jinja_fns {

    use shalom_core::context::ShalomGlobalContext;

    use super::*;
    fn resolve_scalar_typename(
        scalar_name: &str,
        ctx: &ShalomGlobalContext,
        is_optional: bool,
    ) -> String {
        if let Some(custom_scalar) = ctx.find_custom_scalar(scalar_name) {
            let mut output_typename = custom_scalar.output_type.symbol_fullname();
            if is_optional {
                output_typename.push('?');
            }
            output_typename
        } else {
            let mut resolved = dart_type_for_scalar(scalar_name);
            if is_optional {
                resolved.push('?');
            }
            resolved
        }
    }

    fn type_name_for_kind_impl(ctx: &SharedShalomGlobalContext, kind: &SelectionKind) -> String {
        match kind {
            SelectionKind::List(list) => {
                let inner_type_name = type_name_for_kind_impl(ctx, &list.of_kind);

                if list.is_optional {
                    format!("List<{}>?", inner_type_name)
                } else {
                    format!("List<{}>", inner_type_name)
                }
            }
            SelectionKind::Scalar(scalar) => {
                resolve_scalar_typename(&scalar.concrete_type.name, ctx, scalar.is_optional)
            }

            SelectionKind::Object(object) => {
                if object.is_optional {
                    format!("{}?", object.full_name)
                } else {
                    object.full_name.clone()
                }
            }
            SelectionKind::Enum(enum_) => {
                if enum_.is_optional {
                    format!("{}?", enum_.concrete_type.name)
                } else {
                    enum_.concrete_type.name.clone()
                }
            }
            SelectionKind::Union(union) => {
                if union.common.is_optional {
                    format!("{}?", union.common.full_name)
                } else {
                    union.common.full_name.clone()
                }
            }
            SelectionKind::Interface(interface) => {
                if interface.common.is_optional {
                    format!("{}?", interface.common.full_name)
                } else {
                    interface.common.full_name.clone()
                }
            }
        }
    }

    pub fn type_name_for_selection(
        ctx: &SharedShalomGlobalContext,
        selection: ViaDeserialize<Selection>,
    ) -> String {
        type_name_for_kind_impl(ctx, &selection.0.kind)
    }

    fn resolve_schema_typename(
        ty: &GraphQLAny,
        is_optional: bool,
        ctx: &ShalomGlobalContext,
    ) -> String {
        let mut typename = match &ty {
            GraphQLAny::Scalar(scalar) => resolve_scalar_typename(&scalar.name, ctx, is_optional),
            GraphQLAny::InputObject(obj) => obj.name.clone(),
            GraphQLAny::Enum(enum_) => enum_.name.clone(),
            GraphQLAny::List { of_type } => {
                let inner = resolve_schema_typename(&of_type.ty, of_type.is_optional, ctx);
                format!("List<{inner}>")
            }
            _ => panic!("Unsupported type: {:?}", ty),
        };
        // scalars optionals are handled in `resolve_scalar_typename`
        if is_optional && ty.scalar().is_none() {
            typename.push('?')
        }
        typename
    }

    pub fn type_name_for_input_field(
        ctx: &SharedShalomGlobalContext,
        field: ViaDeserialize<InputFieldDefinition>,
    ) -> String {
        let field = field.0;
        let resolved_type = field.common.unresolved_type.resolve(&ctx.schema_ctx);
        let is_optional = resolved_type.is_optional;
        let res = resolve_schema_typename(&resolved_type.ty, is_optional, ctx);
        if is_optional && field.default_value.is_none() {
            format!("Maybe<{res}>")
        } else {
            res
        }
    }

    pub fn parse_field_default_value(
        schema_ctx: &SchemaContext,
        field: ViaDeserialize<InputFieldDefinition>,
    ) -> String {
        let field = field.0;
        let default_value = field
            .default_value
            .as_ref()
            .expect("cannot parse default value that does not exist")
            .to_string();

        let ty = field.common.resolve_type(schema_ctx);
        if default_value == "null" {
            return default_value;
        }
        match ty.ty {
            GraphQLAny::Enum(enum_) => {
                format!("{}.{}", enum_.name, default_value)
            }
            GraphQLAny::Scalar(scalar) => match scalar.name.as_str() {
                "ID" | "String" | "Int" | "Float" | "Boolean" => default_value,
                _ => {
                    log::warn!(
                        "Unknown scalar type encountered: '{}'. Returning 'null' as default value.",
                        scalar.name
                    );
                    "null".to_string()
                }
            },
            _ => default_value,
        }
    }

    pub fn resolve_field_type(
        schema_ctx: &SchemaContext,
        schema_field: ViaDeserialize<SchemaFieldCommon>,
    ) -> minijinja::value::Value {
        let serialized = serde_json::to_value(schema_field.0.unresolved_type.resolve(schema_ctx))
            .map_err(|e| format!("Failed to serialize field type: {}", e))
            .unwrap();
        minijinja::value::Value::from_serialize(serialized)
    }

    pub fn docstring(value: Option<String>) -> String {
        match value {
            Some(doc) => doc
                .lines()
                .filter(|line| !line.trim().is_empty())
                .map(|line| format!("/// {}", line.trim()))
                .collect::<Vec<_>>()
                .join(LINE_ENDING),
            None => String::new(),
        }
    }

    pub fn custom_scalar_impl_fullname(
        ctx: &SharedShalomGlobalContext,
        scalar_name: String,
    ) -> String {
        let scalar = ctx
            .find_custom_scalar(&scalar_name)
            .expect("Custom scalar not found");
        scalar.impl_symbol.symbol_fullname()
    }

    pub fn is_custom_scalar(ctx: &SharedShalomGlobalContext, scalar_name: &str) -> bool {
        ctx.find_custom_scalar(scalar_name).is_some()
    }

    pub fn dart_type_for_scalar_name(scalar_name: &str) -> String {
        dart_type_for_scalar(scalar_name)
    }

    pub fn is_type_implementing_interface(
        ctx: &SharedShalomGlobalContext,
        type_name: &str,
        interface_name: &str,
    ) -> bool {
        ctx.schema_ctx
            .is_type_implementing_interface(type_name, interface_name)
    }
}

/// takes a number and returns itself as if the abc was 123, i.e 143 would be "adc"
fn number_to_abc(n: u32) -> String {
    let abc = "abcdefghijklmnopqrstuvwxyz";
    let mut result = String::new();
    let mut num = n;
    while num > 0 {
        let index = (num - 1) % 26;
        result.push(abc.chars().nth(index as usize).unwrap());
        num = (num - 1) / 26;
    }
    result
}
trait SymbolName {
    fn symbol_fullname(&self) -> String;
    fn namespace(&self) -> Option<String>;
}
impl SymbolName for RuntimeSymbolDefinition {
    fn namespace(&self) -> Option<String> {
        self.import_path.as_ref().map(|p| {
            let mut hasher: DefaultHasher = DefaultHasher::new();
            p.hash(&mut hasher);
            number_to_abc(hasher.finish() as u32)
        })
    }

    fn symbol_fullname(&self) -> String {
        if let Some(namespace) = self.namespace() {
            format!("{}.{}", namespace, self.symbol_name)
        } else {
            self.symbol_name.clone()
        }
    }
}

struct SchemaEnv<'a> {
    env: Environment<'a>,
}

struct OperationEnv<'a> {
    env: Environment<'a>,
}

struct FragmentEnv<'a> {
    env: Environment<'a>,
}
/// Helper function to find pubspec.yaml and extract package name
fn find_pubspec_and_package_name(start_path: &Path) -> Result<(PathBuf, String), String> {
    let mut current_dir = start_path.parent();

    while let Some(dir) = current_dir {
        let potential_pubspec = dir.join("pubspec.yaml");
        if potential_pubspec.exists() {
            let pubspec_content = fs::read_to_string(&potential_pubspec)
                .map_err(|e| format!("Failed to read pubspec.yaml: {}", e))?;

            let package_name = pubspec_content
                .lines()
                .find(|line| line.trim_start().starts_with("name:"))
                .and_then(|line| line.split(':').nth(1))
                .map(|name| name.trim().to_string())
                .ok_or_else(|| "Could not find 'name:' field in pubspec.yaml".to_string())?;

            return Ok((potential_pubspec, package_name));
        }
        current_dir = dir.parent();
    }

    Err("No pubspec.yaml found".to_string())
}

// TODO: might not be good to create an environment for every operation. as it will recreate templates.
fn register_default_template_fns<'a>(
    env: &mut Environment<'a>,
    ctx: &SharedShalomGlobalContext,
) -> anyhow::Result<()> {
    env.set_undefined_behavior(minijinja::UndefinedBehavior::Strict);
    env.set_debug(true);
    env.add_template(
        "operation",
        include_str!("../templates/operation.dart.jinja"),
    )
    .unwrap();

    env.add_template("schema", include_str!("../templates/schema.dart.jinja"))?;
    env.add_template("fragment", include_str!("../templates/fragment.dart.jinja"))?;
    env.add_template("macros", include_str!("../templates/macros.dart.jinja"))?;
    env.add_template(
        "selection_macros",
        include_str!("../templates/selection_macros.dart.jinja"),
    )?;

    let ctx_clone = ctx.clone();
    env.add_function("type_name_for_selection", move |a: _| {
        ext_jinja_fns::type_name_for_selection(&ctx_clone, a)
    });

    let ctx_clone = ctx.clone();
    env.add_function("type_name_for_input_field", move |a: _| {
        ext_jinja_fns::type_name_for_input_field(&ctx_clone, a)
    });

    let schema_ctx_clone = ctx.schema_ctx.clone();
    env.add_function("parse_field_default_value", move |a: _| {
        ext_jinja_fns::parse_field_default_value(&schema_ctx_clone, a)
    });

    let schema_ctx_clone = ctx.schema_ctx.clone();
    env.add_function("resolve_field_type", move |a: _| {
        ext_jinja_fns::resolve_field_type(&schema_ctx_clone, a)
    });

    let ctx_clone = ctx.clone();
    env.add_function("custom_scalar_impl_fullname", move |a: _| {
        ext_jinja_fns::custom_scalar_impl_fullname(&ctx_clone, a)
    });

    let ctx_clone = ctx.clone();
    env.add_function("is_custom_scalar", move |name: &str| {
        ext_jinja_fns::is_custom_scalar(&ctx_clone, name)
    });

    env.add_function(
        "dart_type_for_scalar_name",
        ext_jinja_fns::dart_type_for_scalar_name,
    );

    env.add_function("docstring", ext_jinja_fns::docstring);
    let ctx_clone = ctx.clone();
    env.add_function(
        "is_type_implementing_interface",
        move |type_name: &str, interface_name: &str| {
            ext_jinja_fns::is_type_implementing_interface(&ctx_clone, type_name, interface_name)
        },
    );

    let schema_ctx = ctx.schema_ctx.clone();
    env.add_function("is_type_implements_node", move |type_name: &str| {
        schema_ctx.is_type_implements_node(type_name)
    });

    let global_ctx = ctx.clone();
    env.add_function(
        "import_path_for_fragment_from_operation",
        move |operation_file_path: String, frag_name: &str| -> Result<String, minijinja::Error> {
            calculate_fragment_import_path(&global_ctx, &operation_file_path, frag_name).map_err(
                |e| minijinja::Error::new(minijinja::ErrorKind::InvalidOperation, e.to_string()),
            )
        },
    );

    env.add_function(
        "get_field_name_with_args",
        |name: &str, args: ViaDeserialize<Vec<shalom_core::operation::types::FieldArgument>>| {
            get_field_name_with_args(name, &args.0)
        },
    );

    Ok(())
}

/// if the operation contains variables and the selection is from this operation
/// i.e not from a fragment returns true.
fn selection_kind_uses_variables<T: ExecutableContext>(
    ctx: &T,
    selection_kind: &shalom_core::operation::types::SelectionKind,
) -> bool {
    use shalom_core::operation::types::SelectionKind;
    if !ctx.has_variables() {
        return false;
    }
    match selection_kind {
        SelectionKind::Object(obj) => ctx.get_object_selection(&obj.full_name).is_some(),
        SelectionKind::List(list) => selection_kind_uses_variables(ctx, &list.of_kind),
        SelectionKind::Union(union) => ctx.get_union_types().contains_key(&union.common.full_name),
        SelectionKind::Interface(interface) => ctx
            .get_interface_types()
            .contains_key(&interface.common.full_name),
        _ => false,
    }
}

fn get_field_name_with_args(
    field_name: &str,
    args: &[shalom_core::operation::types::FieldArgument],
) -> String {
    if args.is_empty() {
        field_name.to_string()
    } else {
        format!("{}_with_args", field_name)
    }
}

impl SchemaEnv<'_> {
    fn new(ctx: &SharedShalomGlobalContext) -> anyhow::Result<Self> {
        let mut env = Environment::new();
        register_default_template_fns(&mut env, ctx)?;
        Ok(Self { env })
    }

    fn render_schema(&self, ctx: &SharedShalomGlobalContext) -> String {
        let template = self.env.get_template("schema").unwrap();

        let mut extra_imports: HashMap<String, String> = HashMap::new();

        for custom_scalar in ctx.get_custom_scalars().values() {
            for symbol in [&custom_scalar.impl_symbol, &custom_scalar.output_type] {
                if let Some(import_path) = &symbol.import_path {
                    let import_path_str = import_path.to_string_lossy().to_string();

                    extra_imports.entry(import_path_str).or_insert_with(|| {
                        let mut hasher: DefaultHasher = DefaultHasher::new();
                        import_path.hash(&mut hasher);
                        number_to_abc(hasher.finish() as u32)
                    });
                }
            }
        }

        let mut context = HashMap::new();
        context.insert("schema", context! { context => &ctx.schema_ctx });
        context.insert("extra_imports", minijinja::Value::from(extra_imports));

        template.render(&context).unwrap()
    }
}

fn register_executable_fns<'a, T>(
    env: &mut Environment<'a>,
    ctx: &SharedShalomGlobalContext,
    executable_ctx: Arc<T>,
) -> anyhow::Result<()>
where
    T: ExecutableContext + 'static,
{
    let ctx_clone1 = ctx.clone();
    let executable_ctx_clone1 = executable_ctx.clone();

    env.add_function("is_type_implements_node", move |full_name: &str| {
        if let Some(selection) =
            executable_ctx_clone1.get_selection(&full_name.to_string(), &ctx_clone1)
        {
            match &selection.kind {
                SelectionKind::Object(object_selection) => ctx_clone1
                    .schema_ctx
                    .is_type_implements_node(&object_selection.concrete_typename),
                _ => false,
            }
        } else {
            false
        }
    });

    let ctx_clone2 = ctx.clone();
    let executable_ctx_clone2 = executable_ctx.clone();
    env.add_function(
        "get_id_selection",
        move |full_name: &str| -> Option<minijinja::Value> {
            let selection =
                executable_ctx_clone2.get_selection(&full_name.to_string(), &ctx_clone2)?;
            match &selection.kind {
                SelectionKind::Object(object_selection) => object_selection
                    .get_id_selection_with_fragments(&ctx_clone2)
                    .map(minijinja::Value::from_serialize),
                _ => None,
            }
        },
    );

    let ctx_clone3 = ctx.clone();
    let executable_ctx_clone3 = executable_ctx.clone();
    env.add_function("get_all_selections_for_object", move |object_name: &str| {
        let object_selection =
            executable_ctx_clone3.get_selection(&object_name.to_string(), &ctx_clone3);
        let selections = match &object_selection.unwrap().kind {
            SelectionKind::Object(object_selection) => {
                object_selection.get_all_selections(&ctx_clone3)
            }
            _ => panic!("Expected object selection"),
        };
        minijinja::Value::from_serialize(selections)
    });

    let executable_ctx_clone3 = executable_ctx.clone();
    env.add_function(
        "selection_kind_uses_variables",
        move |selection: ViaDeserialize<shalom_core::operation::types::SelectionKind>| -> bool {
            selection_kind_uses_variables(executable_ctx_clone3.as_ref(), &selection.0)
        },
    );

    let ctx_clone4 = ctx.clone();
    let executable_ctx_clone4 = executable_ctx.clone();
    env.add_function(
        "has_id_selection",
        move |full_name: &str| -> Option<minijinja::Value> {
            let selection =
                executable_ctx_clone4.get_selection(&full_name.to_string(), &ctx_clone4)?;
            Some(minijinja::Value::from_serialize(has_id_selection(
                &selection,
            )))
        },
    );

    Ok(())
}

impl OperationEnv<'_> {
    fn new(ctx: &SharedShalomGlobalContext, op_ctx: SharedOpCtx) -> anyhow::Result<Self> {
        let mut env = Environment::new();
        register_default_template_fns(&mut env, ctx)?;
        register_executable_fns(&mut env, ctx, op_ctx.clone())?;

        // Override get_id_selection for operations to also search in used fragments
        let ctx_clone = ctx.clone();
        let op_ctx_clone = op_ctx.clone();
        env.add_function(
            "get_id_selection",
            move |full_name: &str| -> Option<minijinja::Value> {
                // First try to find in the operation context
                let selection = op_ctx_clone.get_selection(&full_name.to_string(), &ctx_clone)?;
                match &selection.kind {
                    SelectionKind::Object(object_selection) => object_selection
                        .get_id_selection_with_fragments(&ctx_clone)
                        .map(minijinja::Value::from_serialize),
                    _ => None,
                }
            },
        );

        Ok(OperationEnv { env })
    }

    fn render_operation<S: Serialize, T: Serialize>(
        &self,
        operations_ctx: S,
        schema_ctx: T,
        extra_imports: HashMap<String, String>,
        schema_import_path: String,
    ) -> String {
        let template = self.env.get_template("operation").unwrap();
        let mut context = HashMap::new();

        context.insert("schema", context! { context => schema_ctx });
        context.insert("operation", context! { context => operations_ctx });
        context.insert("extra_imports", minijinja::Value::from(extra_imports));
        context.insert(
            "schema_import_path",
            minijinja::Value::from(schema_import_path),
        );

        template.render(&context).unwrap()
    }
}

impl FragmentEnv<'_> {
    fn new(
        ctx: &SharedShalomGlobalContext,
        fragment_ctx: SharedFragmentContext,
    ) -> anyhow::Result<Self> {
        let mut env = Environment::new();
        register_default_template_fns(&mut env, ctx)?;
        register_executable_fns(&mut env, ctx, fragment_ctx)?;
        Ok(FragmentEnv { env })
    }

    fn render_fragment<S: Serialize, T: Serialize>(
        &self,
        fragment_ctx: S,
        schema_ctx: T,
        extra_imports: HashMap<String, String>,
        schema_path: String,
    ) -> String {
        let template = self.env.get_template("fragment").unwrap();
        let mut context = HashMap::new();

        context.insert("schema", context! { context => schema_ctx });
        context.insert("fragment", context! { context => fragment_ctx });
        context.insert("extra_imports", minijinja::Value::from(extra_imports));
        context.insert("schema_import_path", minijinja::Value::from(schema_path));

        template.render(&context).unwrap()
    }
}

fn create_dir_if_not_exists(path: &Path) {
    if !path.exists() {
        fs::create_dir_all(path).unwrap();
    }
}

static END_OF_FILE: &str = "shalom.dart";
static GRAPHQL_DIRECTORY: &str = "__graphql__";

/// Get the directory where the schema file should be generated
fn get_schema_output_dir(ctx: &ShalomGlobalContext) -> PathBuf {
    if let Some(schema_output_path) = &ctx.config.schema_output_path {
        // Use the configured schema output path (resolve relative to project root)
        let resolved = if schema_output_path.is_absolute() {
            schema_output_path.clone()
        } else {
            ctx.config.project_root.join(schema_output_path)
        };
        resolved
    } else {
        // Default to schema file's parent directory + __graphql__
        ctx.schema_file_path
            .parent()
            .expect("Schema file must have a parent directory")
            .join(GRAPHQL_DIRECTORY)
    }
}

/// Get the full path to the generated schema file
fn get_schema_file_path(ctx: &ShalomGlobalContext) -> PathBuf {
    get_schema_output_dir(ctx).join(format!("schema.{}", END_OF_FILE))
}

fn get_generation_path_for_operation(document_path: &Path, operation_name: &str) -> PathBuf {
    let p = document_path.parent().unwrap().join(GRAPHQL_DIRECTORY);
    create_dir_if_not_exists(&p);
    p.join(format!("{}.{}", operation_name, END_OF_FILE))
}

/// Calculate the import path for a fragment from an operation file
fn calculate_fragment_import_path(
    global_ctx: &SharedShalomGlobalContext,
    operation_file_path: &str,
    frag_name: &str,
) -> anyhow::Result<String> {
    let op_path = PathBuf::from(operation_file_path);
    let fragment = global_ctx
        .get_fragment(frag_name)
        .ok_or_else(|| anyhow::anyhow!("Fragment '{}' not found", frag_name))?;

    // Find pubspec.yaml for both operation and fragment
    let (op_pubspec, _op_package) =
        find_pubspec_and_package_name(&op_path).map_err(|e| anyhow::anyhow!("{}", e))?;
    let (frag_pubspec, frag_package) =
        find_pubspec_and_package_name(&fragment.file_path).map_err(|e| anyhow::anyhow!("{}", e))?;

    // Get the directory containing operation file
    let op_dir = op_path
        .parent()
        .ok_or_else(|| anyhow::anyhow!("Invalid operation file path"))?;

    // Calculate the __graphql__ directory for the operation
    let op_graphql_dir = op_dir.join("__graphql__");

    // Calculate where the fragment will be generated
    let frag_parent_dir = fragment
        .file_path
        .parent()
        .ok_or_else(|| anyhow::anyhow!("Invalid fragment file path"))?;
    let frag_generated_path = frag_parent_dir
        .join("__graphql__")
        .join(format!("{}.shalom.dart", frag_name.to_lowercase()));

    log::debug!(
        "Fragment '{}': op_graphql_dir={:?}, frag_generated_path={:?}",
        frag_name,
        op_graphql_dir,
        frag_generated_path
    );

    // If in the same __graphql__ directory, use relative import
    if op_graphql_dir == frag_parent_dir.join("__graphql__") {
        log::debug!("Same directory, using simple relative import");
        return Ok(format!("{}.shalom.dart", frag_name.to_lowercase()));
    }

    // If in different packages, use package import
    if op_pubspec != frag_pubspec {
        let frag_package_root = frag_pubspec
            .parent()
            .ok_or_else(|| anyhow::anyhow!("Invalid pubspec.yaml path"))?;

        let relative_path = frag_generated_path
            .strip_prefix(frag_package_root)
            .map_err(|e| anyhow::anyhow!("Fragment path is not within package root: {}", e))?;

        return Ok(format!(
            "package:{}/{}",
            frag_package,
            relative_path.to_string_lossy().replace('\\', "/")
        ));
    }

    // Same package, different directories - use relative path from operation __graphql__ dir
    let relative_from_op = pathdiff::diff_paths(&frag_generated_path, &op_graphql_dir)
        .ok_or_else(|| anyhow::anyhow!("Could not calculate relative path"))?;

    let import_path = relative_from_op.to_string_lossy().replace('\\', "/");
    log::debug!(
        "Different directories in same package, using relative import: {}",
        import_path
    );
    Ok(import_path)
}

fn get_schema_import_path(relative_to: &PathBuf, ctx: &ShalomGlobalContext) -> String {
    // Calculate relative path from operation __graphql__ dir to schema file
    let op_dir = relative_to.parent().unwrap();
    let op_graphql_dir = op_dir.join("__graphql__");
    let schema_path = get_schema_file_path(ctx);
    let schema_import_path = pathdiff::diff_paths(&schema_path, &op_graphql_dir)
        .map(|p| p.to_string_lossy().replace('\\', "/"))
        .unwrap_or_else(|| "schema.shalom.dart".to_string());
    schema_import_path
}

fn generate_operations_file(
    ctx: &SharedShalomGlobalContext,
    name: &str,
    operation: SharedOpCtx,
    additional_imports: HashMap<String, String>,
) -> anyhow::Result<()> {
    let op_env = OperationEnv::new(ctx, operation.clone())?;

    let operation_file_path = operation.file_path.clone();
    let generation_target = get_generation_path_for_operation(&operation_file_path, name);

    // Calculate relative path from operation __graphql__ dir to schema file

    let rendered_content = op_env.render_operation(
        operation,
        ctx.schema_ctx.clone(),
        additional_imports,
        get_schema_import_path(&operation_file_path, &ctx),
    );
    fs::write(&generation_target, rendered_content).unwrap();
    info!("Generated {}", generation_target.display());
    Ok(())
}

fn generate_fragment_file(
    ctx: &SharedShalomGlobalContext,
    _pwd: &Path,
    fragment_name: &str,
    fragment_ctx: SharedFragmentContext,
    additional_imports: HashMap<String, String>,
) -> anyhow::Result<()> {
    let fragment_env = FragmentEnv::new(ctx, fragment_ctx.clone())?;
    let generated_content = fragment_env.render_fragment(
        context! { context => fragment_ctx },
        context! { context => &ctx.schema_ctx },
        additional_imports,
        get_schema_import_path(&fragment_ctx.file_path, ctx),
    );

    // Generate fragment in __graphql__ subdirectory relative to where it's defined
    let fragment_source_dir = fragment_ctx.file_path.parent().ok_or_else(|| {
        anyhow::anyhow!("Invalid fragment file path: {:?}", fragment_ctx.file_path)
    })?;
    let generation_dir = fragment_source_dir.join(GRAPHQL_DIRECTORY);
    create_dir_if_not_exists(&generation_dir);
    let generation_path =
        generation_dir.join(format!("{}.{}", fragment_name.to_lowercase(), END_OF_FILE));

    fs::write(&generation_path, generated_content)?;
    info!("Generated fragment file: {}", generation_path.display());
    Ok(())
}

pub fn codegen_entry_point(pwd: &Option<PathBuf>, strict: bool) -> Result<()> {
    let ctx = shalom_core::entrypoint::parse_directory(pwd, strict)?;
    let pwd = &ctx.config.project_root;
    info!("codegen started in working directory {}", pwd.display());

    let template_env = SchemaEnv::new(&ctx)?;

    // Clean up unused operation files
    let existing_op_names =
        glob::glob(pwd.join(format!("**/*.{}", END_OF_FILE)).to_str().unwrap())?;
    for entry in existing_op_names {
        let entry = entry?;
        if entry.is_file() {
            let resolved_name = entry
                .file_name()
                .unwrap()
                .to_str()
                .unwrap()
                .split(format!(".{}", END_OF_FILE).as_str())
                .next()
                .unwrap();
            // Check if it's neither an operation nor a fragment
            if !ctx.operation_exists(resolved_name) && !ctx.fragment_exists(resolved_name) {
                info!("deleting unused file {}", resolved_name);
                fs::remove_file(entry)?;
            }
        }
    }

    generate_schema_file(&template_env, &ctx);
    let mut additional_imports: HashMap<PathBuf, String> = HashMap::new();

    for custom_scalar in ctx.get_custom_scalars().values() {
        for symbol in [&custom_scalar.impl_symbol, &custom_scalar.output_type] {
            if let Some(import_path) = &symbol.import_path {
                if !additional_imports.contains_key(import_path) {
                    let mut hasher: DefaultHasher = DefaultHasher::new();
                    import_path.hash(&mut hasher);
                    additional_imports
                        .insert(import_path.clone(), number_to_abc(hasher.finish() as u32));
                }
            }
        }
    }
    let additional_imports: HashMap<String, String> = additional_imports
        .into_iter()
        .map(|(k, v)| (k.to_string_lossy().to_string(), v))
        .collect();

    // Generate fragment files first (operations might depend on them)
    for (fragment_name, fragment_ctx) in ctx.fragments() {
        let res = generate_fragment_file(
            &ctx,
            pwd,
            &fragment_name,
            fragment_ctx,
            additional_imports.clone(),
        );
        if let Err(err) = res {
            if strict {
                return Err(err);
            }
            error!(
                "Failed to generate fragment '{}' due to: {}",
                fragment_name, err
            );
        }
    }

    // Generate operation files
    for (name, operation) in ctx.operations() {
        let res = generate_operations_file(&ctx, &name, operation, additional_imports.clone());
        if let Err(err) = res {
            if strict {
                return Err(err);
            }
            error!("Failed to generate operation '{}' due to: {}", name, err);
        }
    }

    Ok(())
}

fn generate_schema_file(template_env: &SchemaEnv, ctx: &SharedShalomGlobalContext) {
    info!("rendering schema file");

    let rendered_content = template_env.render_schema(ctx);
    let output_dir = get_schema_output_dir(ctx);
    create_dir_if_not_exists(&output_dir);
    let generation_target = output_dir.join(format!("schema.{}", END_OF_FILE));
    fs::write(&generation_target, rendered_content).unwrap();
    info!("Generated {}", generation_target.display());
}
