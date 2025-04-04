use std::{
    collections::HashMap,
    fs,
    path::{Path, PathBuf},
};

use anyhow::Result;
use lazy_static::lazy_static;
use log::{info, trace};
use minijinja::{context, value::ViaDeserialize, Environment};
use serde::Serialize;
use shalom_core::{operation::types::Selection, schema::{self, types::ObjectType, type_extractor::Object}};

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
                resolved.to_string()
            }
        }
        Selection::Object(object) => {
            let mut name: Vec<char> = object.common.selection_name.clone().chars().collect();
            name[0] = name[0].to_uppercase().nth(0).unwrap();
            let selection_name = name.into_iter().collect();
            return selection_name;
        }
        _ => todo!("unsupported type: {:?}", selection.0),
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
            "objects",
            include_str!("../templates/objects.dart.jinja"),
        )
        .unwrap();
        env.add_function("type_name_for_selection", type_name_for_selection);
        Self { env }
    }

    fn render_operation<S: Serialize>(&self, ctx: S) -> String {
        let template = self.env.get_template("operation").unwrap();
        trace!("resolved operation template; rendering...");
        template.render(context! {context=>ctx}).unwrap()
    }

    fn render_objects<S: Serialize>(&self, ctx: S) -> String {
        let template = self.env.get_template("objects").unwrap();
        trace!("resolved objects template; rendering...");
        template.render(ctx).unwrap()
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
static OBJECTS_FILENAME: &str = "Objects"; 
static GRAPHQL_DIRECTORY: &str = "__graphql__";

#[derive(Serialize)]
pub struct ObjectsCtx {
   objects: Vec<Object>
} 


fn get_generation_path_for_operation(document_path: &Path, operation_name: &str) -> PathBuf {
    let p = document_path.parent().unwrap().join(GRAPHQL_DIRECTORY);
    create_dir_if_not_exists(&p);
    p.join(format!("{}.{}", operation_name, END_OF_FILE))
}

pub fn codegen_entry_point(pwd: &Path) -> Result<()> {
    info!("codegen started in working directory {}", pwd.display());
    let ctx = shalom_core::entrypoint::parse_directory(pwd)?;
    let mut objects_file_path = None; 
    for (name, operation) in ctx.operations() {
        if objects_file_path.is_none() {
            let schema_ctx = ctx.schema_ctx.clone();
            let objects = schema_ctx.get_parsed_objects();
            info!("rendering objects {:?}", objects.iter().map(|object| object.name.clone()).collect::<Vec<String>>());
            let objects_ctx = ObjectsCtx {
                objects
            };
            let generation_target = get_generation_path_for_operation(&operation.file_path, OBJECTS_FILENAME);
            let content =  TEMPLATE_ENV.render_objects(&objects_ctx);
            fs::write(&generation_target, content).unwrap();
            info!("Generated {}", generation_target.display());
            objects_file_path = Some(generation_target);
        }
        let objects_file_path = objects_file_path.as_ref().unwrap();
        info!("rendering operation {}", name);
        let mut file_content = format!("import '{}';", objects_file_path.file_name().unwrap().to_str().unwrap());
        let rendered_content = TEMPLATE_ENV.render_operation(&operation);
        file_content.push_str(&rendered_content); 
        let generation_target = get_generation_path_for_operation(&operation.file_path, &name);
        fs::write(&generation_target, file_content).unwrap();
        info!("Generated {}", generation_target.display());
    }
    Ok(())
}
