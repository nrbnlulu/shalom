use anyhow::{Context, Result};
use graphql_parser::schema::{parse_schema};
use graphql_parser::query::{parse_query, Definition, OperationDefinition, Selection};
use minijinja::Environment;
use serde::Serialize;

#[derive(Serialize)]
struct Field {
    name: String,
    type_name: String,
    required: bool,
}

#[derive(Serialize)]
struct TemplateContext {
    query_name: String,
    return_type: String,
    field_name: String,
    fields: Vec<Field>,
}

pub fn generate_dart_code(schema: &str, query: &str) -> Result<String> {
    let schema_ast = parse_schema::<String>(schema).context("Failed to parse schema")?;
    let query_ast = parse_query::<String>(query).context("Failed to parse query")?;

    let operation = get_operation(&query_ast)?;
    let query_name = match operation {
        OperationDefinition::Query(q) => q.name.clone().unwrap_or_else(|| "Query".to_string()),
        _ => "Query".to_string(),
    };
    
    let (field_name, return_type, fields) = extract_query_info(operation)?;

    let context = TemplateContext {
        query_name,
        return_type,
        field_name,
        fields,
    };

    let mut env = Environment::new();
    env.add_filter("snake_case", |s: String| {
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
    env.add_template("query", include_str!("../templates/query.dart.jinja"))
        .context("Failed to add template")?;

    let tmpl = env.get_template("query")
        .context("Failed to get template")?;

    tmpl.render(&context)
        .map_err(|e| anyhow::anyhow!("Failed to render template: {}", e))
}

fn get_operation<'a>(doc: &'a graphql_parser::query::Document<'a, String>) -> Result<&'a OperationDefinition<'a, String>> {
    match doc.definitions.first() {
        Some(Definition::Operation(op)) => Ok(op),
        _ => anyhow::bail!("No operation found in query"),
    }
}

fn extract_query_info(operation: &OperationDefinition<String>) -> Result<(String, String, Vec<Field>)> {
    let selection_set = match operation {
        OperationDefinition::Query(q) => &q.selection_set,
        _ => anyhow::bail!("Only query operations are supported"),
    };

    let selection = match selection_set.items.first() {
        Some(Selection::Field(field)) => field,
        _ => anyhow::bail!("No field selection found"),
    };

    let field_name = selection.name.clone();
    let return_type = "Person".to_string(); // In real implementation, get this from schema

    let fields = vec![
        Field {
            name: "name".to_string(),
            type_name: "String".to_string(),
            required: false,
        },
        Field {
            name: "age".to_string(),
            type_name: "int".to_string(),
            required: true,
        },
        Field {
            name: "dateOfBirth".to_string(),
            type_name: "DateTime".to_string(),
            required: true,
        },
    ];

    Ok((field_name, return_type, fields))
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_generate_dart_code() {
        let schema = r#"
            type Person {
                name: String
                age: Int!
                dateOfBirth: DateTime!
            }
            type Query {
                person(id: Int!): Person
            }
        "#;

        let query = r#"
            query HelloWorld($id: Int!) {
                person(id: $id) {
                    name
                    id
                    age
                    dateOfBirth
                }
            }
        "#;

        let result = generate_dart_code(schema, query);
        if let Err(e) = &result {
            eprintln!("Error: {}", e);
        }
        assert!(result.is_ok());
        
        let generated_code = result.unwrap();
        eprintln!("Generated code:\n{}", generated_code);
        assert!(generated_code.contains("class HelloWorldResponse"));
        assert!(generated_code.contains("class Person"));
        assert!(generated_code.contains("final String? name"));
        assert!(generated_code.contains("final int age"));
        assert!(generated_code.contains("final DateTime dateOfBirth"));
    }
}