use anyhow::{Context, Result};
use minijinja::{Environment};
use serde::Serialize;
use apollo_compiler::{Schema, ExecutableDocument, validation::Valid, ast::OperationType, executable::Selection, schema::ExtendedType};
use apollo_compiler::executable::Operation;

 

#[derive(Serialize)]
struct Field {
    name: String,
}


#[derive(Serialize)]
struct Enum_ {
    name: String, 
    fields: Vec<Field>
}

#[derive(Serialize)]
struct TemplateContext {
    enums: Vec<Enum_>
}

pub fn generate_dart_code(schema: &str, query: &str) -> Result<String>{
    let schema_obj = Schema::parse_and_validate(schema, "schema.graphql").unwrap();
    //let doc = ExecutableDocument::parse_and_validate(&schema_obj, query, "query.graphql").unwrap();
    let enums = parse_schema(&schema_obj);
    let context = TemplateContext {
        enums
    };
    let mut env = Environment::new();
    env.add_filter("to_snake_case", |s: String| {
        s.chars().enumerate().fold(String::new(), |mut acc, (i, c)| {
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

    let tmpl = env.get_template("schema")
        .context("Failed to get template")?;

    tmpl.render(&context)
        .map_err(|e| anyhow::anyhow!("Failed to render template: {}", e))
}

fn parse_schema(schema: &Valid<Schema>) -> Vec<Enum_> {
    let mut enums = Vec::new(); 
    for extend_type in schema.types.values() {
        if let ExtendedType::Object(obj)  = extend_type {
            let enum_name = obj.name.to_string(); 
            if !(enum_name.starts_with("__")) {
                let fields = obj.fields.values().map(|field| Field {
                    name: field.node.name.to_string()
                }).collect();
                let enum_ = Enum_ {
                    name: enum_name,
                    fields
                };
                enums.push(enum_);
           }
        }
    }
    return enums;
}

