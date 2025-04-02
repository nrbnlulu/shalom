use anyhow::{Context, Result};
use apollo_compiler::{ast::Type, schema::ExtendedType, validation::Valid, Schema};
use minijinja::Environment;
use serde::Serialize;


pub fn generate_dart_code(schema: &str, query: &str) -> Result<String> {
    let schema_obj = Schema::parse_and_validate(schema, "schema.graphql").unwrap();
    //let doc = ExecutableDocument::parse_and_validate(&schema_obj, query, "query.graphql").unwrap();
    let context = TemplateContext { objects };
    let mut env = Environment::new();
    env.add_filter("to_snake_case", |s: String| {
        s.chars()
            .enumerate()
            .fold(String::new(), |mut acc, (i, c)| {
                if i > 0 && c.is_uppercase() {
                    acc.push('_');
                }
                acc.extend(c.to_lowercase());
                acc
            })
    });
    env.add_filter("to_upper_case", |s: String| {
        let mut uppercase_string = String::new();
        for (i, s_char) in s.chars().enumerate() {
            if i == 0 {
                uppercase_string.extend(s_char.to_uppercase())
            } else {
                uppercase_string.push(s_char);
            }
        }
        return uppercase_string;
    });
    env.add_template("schema", include_str!("../templates/schema.jinja.dart"))
        .context("Failed to add template")?;

    let tmpl = env
        .get_template("schema")
        .context("Failed to get template")?;

    tmpl.render(&context)
        .map_err(|e| anyhow::anyhow!("Failed to render template: {}", e))
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

