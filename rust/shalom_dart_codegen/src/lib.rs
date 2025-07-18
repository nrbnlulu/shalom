use anyhow::Result;
use lazy_static::lazy_static;
use log::info;
use minijinja::{context, value::ViaDeserialize, Environment};
use serde::Serialize;
use shalom_core::operation::types::SelectionKind;
use shalom_core::{
    context::SharedShalomGlobalContext,
    operation::{
        context::OperationContext,
        types::{dart_type_for_scalar, Selection},
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
    rc::Rc,
};

struct TemplateEnv<'a> {
    env: Environment<'a>,
}

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

                let inner_type = inner_type_name.trim_end_matches('?');

                if list.is_optional {
                    format!("List<{}>?", inner_type)
                } else {
                    format!("List<{}>", inner_type)
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
            format!("Option<{res}>")
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

    pub fn value_or_last(value: String, last: String, is_last: bool) -> String {
        if is_last {
            last
        } else {
            value
        }
    }

    pub fn if_not_last(value: String, is_last: bool) -> String {
        if is_last {
            String::new()
        } else {
            value
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

impl TemplateEnv<'_> {
    fn new(ctx: &SharedShalomGlobalContext) -> Self {
        let mut env = Environment::new();
        env.set_undefined_behavior(minijinja::UndefinedBehavior::Strict);
        env.set_debug(true);
        env.add_template(
            "operation",
            include_str!("../templates/operation.dart.jinja"),
        )
        .unwrap();
        env.add_template("schema", include_str!("../templates/schema.dart.jinja"))
            .unwrap();
        env.add_template("macros", include_str!("../templates/macros.dart.jinja"))
            .unwrap();

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
        env.add_function("value_or_last", ext_jinja_fns::value_or_last);
        env.add_filter("if_not_last", ext_jinja_fns::if_not_last);

        Self { env }
    }

    fn render_operation<S: Serialize, T: Serialize>(
        &self,
        operations_ctx: S,
        schema_ctx: T,
        extra_imports: HashMap<String, String>,
    ) -> String {
        let template = self.env.get_template("operation").unwrap();
        let mut context = HashMap::new();

        context.insert("schema", context! { context => schema_ctx });
        context.insert("operation", context! { context => operations_ctx });
        context.insert("extra_imports", minijinja::Value::from(extra_imports));

        template.render(&context).unwrap()
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

fn create_dir_if_not_exists(path: &Path) {
    if !path.exists() {
        fs::create_dir_all(path).unwrap();
    }
}

static END_OF_FILE: &str = "shalom.dart";
static GRAPHQL_DIRECTORY: &str = "__graphql__";

fn get_generation_path_for_operation(document_path: &Path, operation_name: &str) -> PathBuf {
    let p = document_path.parent().unwrap().join(GRAPHQL_DIRECTORY);
    create_dir_if_not_exists(&p);
    p.join(format!("{}.{}", operation_name, END_OF_FILE))
}

fn generate_operations_file(
    template_env: &TemplateEnv,
    ctx: &SharedShalomGlobalContext,
    name: &str,
    operation: Rc<OperationContext>,
    additional_imports: HashMap<String, String>,
) {
    info!("rendering operation {}", name);
    let operation_file_path = operation.file_path.clone();

    let rendered_content =
        template_env.render_operation(operation, ctx.schema_ctx.clone(), additional_imports);
    let generation_target = get_generation_path_for_operation(&operation_file_path, name);
    fs::write(&generation_target, rendered_content).unwrap();
    info!("Generated {}", generation_target.display());
}

fn generate_schema_file(template_env: &TemplateEnv, ctx: &SharedShalomGlobalContext, path: &Path) {
    info!("rendering schema file");

    let rendered_content = template_env.render_schema(ctx);
    let output_dir = path.join(GRAPHQL_DIRECTORY);
    create_dir_if_not_exists(&output_dir);
    let generation_target = output_dir.join(format!("schema.{}", END_OF_FILE));
    fs::write(&generation_target, rendered_content).unwrap();
    info!("Generated {}", generation_target.display());
}

pub fn codegen_entry_point(pwd: &Path) -> Result<()> {
    info!("codegen started in working directory {}", pwd.display());
    let ctx = shalom_core::entrypoint::parse_directory(pwd)?;
    let template_env = TemplateEnv::new(&ctx);

    let existing_op_names =
        glob::glob(pwd.join(format!("**/*.{}", END_OF_FILE)).to_str().unwrap())?;
    for entry in existing_op_names {
        let entry = entry?;
        if entry.is_file() {
            let resolved_op_name = entry
                .file_name()
                .unwrap()
                .to_str()
                .unwrap()
                .split(format!(".{}", END_OF_FILE).as_str())
                .next()
                .unwrap();
            if !ctx.operation_exists(resolved_op_name) {
                info!("deleting unused operation {}", resolved_op_name);
                fs::remove_file(entry)?;
            }
        }
    }

    generate_schema_file(&template_env, &ctx, pwd);
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
    for (name, operation) in ctx.operations() {
        generate_operations_file(
            &template_env,
            &ctx,
            &name,
            operation,
            additional_imports.clone(),
        );
    }

    Ok(())
}
