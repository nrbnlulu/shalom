use std::{fs, path::Path};

use anyhow::{Context, Result};
use minijinja::Environment;
use serde::Serialize;
use lazy_static::lazy_static;

struct TemplateEnv<'a>{
    env: Environment<'a>,
}
impl TemplateEnv<'_> {
    fn new() -> Self {
        let mut env = Environment::new();
        env.add_template("schema", include_str!("../templates/schema.jinja.dart"))
            .context("Failed to add template").expect("schema not found");
        Self { env }
    }
    
    fn render_schema<S: Serialize>(&self, ctx: S) -> String {
        let template = self.env.get_template("schema").unwrap();
        template.render(ctx).unwrap()
    }
    
    
}

lazy_static! {
    static ref TEMPLATE_ENV: TemplateEnv<'static> = TemplateEnv::new();
}

pub fn codgen_entry_point(pwd: &Path) -> Result<()>{
    let ctx = shalom_core::entrypoint::parse_directory(pwd)?;
    
    let schema = TEMPLATE_ENV.render_schema();
    
    Ok(())
}



fn parse_type(field_type: &Type) -> (String, bool) {
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

