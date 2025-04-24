use anyhow::Result;
use lazy_static::lazy_static;
use log::{info, trace};
use minijinja::{context, value::ViaDeserialize, Environment};
use serde::Serialize;
use shalom_core::{
    operation::{context::OperationContext, types::Selection},
    schema::context::SchemaContext,
};
use std::rc::Rc;
use std::sync::Arc;
use std::{
    collections::HashMap,
    fs,
    path::{Path, PathBuf},
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

fn type_name_for_selection(selection: ViaDeserialize<Selection>) -> String {
    match selection.0 {
        Selection::Scalar(scalar) => {
            let resolved = DEFAULT_SCALARS_MAP.get(&scalar.concrete_type.name).unwrap();
            if scalar.common.is_optional {
                format!("{}?", resolved)
            } else {
                resolved.clone()
            }
        }
        Selection::Object(object) => {
            if object.common.is_optional {
                format!("{}?", object.common.full_name)
            } else {
                object.common.full_name.clone()
            }
        }
        Selection::Enum(enum_) => {
            if enum_.common.is_optional {
                format!("{}?", enum_.concrete_type.name)
            } else {
                enum_.concrete_type.name.clone()
            }
        }
    }
}
impl TemplateEnv<'_> {
    fn new() -> Self {
        let mut env = Environment::new();
        env.add_template(
            "operation",
            include_str!("../templates/operation.dart.jinja"),
        )
        .unwrap();
        env.add_template(
            "global_objects",
            include_str!("../templates/global_objects.dart.jinja"),
        )
        .unwrap();
        env.add_function("type_name_for_selection", type_name_for_selection);
        Self { env }
    }

    fn render_operation<S: Serialize, T: Serialize>(
        &self,
        operations_ctx: S,
        schema_ctx: T,
    ) -> String {
        let template = self.env.get_template("operation").unwrap();
        let mut context = HashMap::new();
        context.insert("schema", context! {context => schema_ctx});
        context.insert("operation", context! {context => operations_ctx});
        trace!("resolved operation template; rendering...");
        template.render(&context).unwrap()
    }

    fn render_global_objects<T: Serialize>(&self, schema_ctx: T) -> String {
        let template = self.env.get_template("global_objects").unwrap();
        let mut context = HashMap::new();
        context.insert("schema", context! {context => schema_ctx});
        trace!("resolved global_objects template; rendering...");
        template.render(&context).unwrap()
    }
}

lazy_static! {
    static ref TEMPLATE_ENV: TemplateEnv<'static> = TemplateEnv::new();
}
fn create_dir_if_not_exists(path: &Path) {
    if !path.exists() {
        std::fs::create_dir_all(path).unwrap();
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
    name: &str,
    operation: Rc<OperationContext>,
    schema_ctx: Arc<SchemaContext>,
) {
    info!("rendering operation {}", name);
    let operation_file_path = operation.file_path.clone();
    let rendered_content = TEMPLATE_ENV.render_operation(operation, schema_ctx);
    let generation_target = get_generation_path_for_operation(&operation_file_path, name);
    fs::write(&generation_target, rendered_content).unwrap();
    info!("Generated {}", generation_target.display());
}

fn generate_global_objects_file(path: &Path, schema_ctx: Arc<SchemaContext>) {
    info!("rendering global objects file");
    let rendered_content = TEMPLATE_ENV.render_global_objects(schema_ctx);
    let name = "GlobalObjects";
    let generation_target = path
        .join(GRAPHQL_DIRECTORY)
        .join(format!("{}.{}", name, END_OF_FILE));
    fs::write(&generation_target, rendered_content).unwrap();
    info!("Generated {}", generation_target.display());
}

pub fn codegen_entry_point(pwd: &Path) -> Result<()> {
    info!("codegen started in working directory {}", pwd.display());
    let ctx = shalom_core::entrypoint::parse_directory(pwd)?;
    // find all operation files in the directory
    // and remove operations that are not included in the current codegen session.
    let existing_op_names =
        glob::glob(pwd.join(format!("**/*.{}", END_OF_FILE,)).to_str().unwrap())?;
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
    for (name, operation) in ctx.operations() {
        generate_operations_file(&name, operation, ctx.schema_ctx.clone());
    }
    generate_global_objects_file(pwd, ctx.schema_ctx.clone());
    Ok(())
}
