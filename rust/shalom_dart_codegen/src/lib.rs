use std::{fs, path::{Path, PathBuf}};

use anyhow::{Context, Result};
use log::info;
use minijinja::Environment;
use serde::Serialize;
use lazy_static::lazy_static;

struct TemplateEnv<'a>{
    env: Environment<'a>,
}


fn type_name_for_field(field_type: &Type) -> (String, bool) {
    match field_type {
        Type::NonNullNamed(name) => {
            let (type_name, _) = parse_type(&Type::Named(name.clone()));
            (type_name, true)
        }
        Type::Named(name) => {
            let dart_type = match name.as_str() {
                "Int" => "int",
                "Float" => "double",
                "String" => "String",
                "Boolean" => "bool",
                "ID" => "String",
                "DateTime" => "DateTime",
                other => other,
            };
            (dart_type.to_string(), false)
        }
        _ => todo!("List Types are not supported"),
    }
}
impl TemplateEnv<'_> {
    fn new() -> Self {
        let mut env = Environment::new();
        env.add_template("operation", include_str!("../templates/operation.dart.jinja"))
            .context("Failed to add template").expect("operation not found");
        env.add_filter(, f);
        Self { env }
    }
    
    fn render_operation<S: Serialize>(&self, ctx: S) -> String {
        let template = self.env.get_template("operation").unwrap();
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

fn get_generation_path_for_operation(document_path: &Path, operation_name: &str) -> PathBuf {
    let p = document_path.parent().unwrap().join("__graphql__");
    create_dir_if_not_exists(&p);
    p.join(format!("{}.dart", operation_name))
}

pub fn codgen_entry_point(pwd: &Path) -> Result<()>{
    let ctx = shalom_core::entrypoint::parse_directory(pwd)?;
    for (name, operation) in ctx.operations() {
        let content = TEMPLATE_ENV.render_operation(&operation);
        let generation_target =  get_generation_path_for_operation(&operation.file_path, &name);
        fs::write(&generation_target, content).unwrap();
        info!("Generated {}", generation_target.display());
    }
    Ok(())
}




