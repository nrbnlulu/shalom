use anyhow::{Context, Result};
use minijinja::Environment;
use serde::Serialize;
use shalom_parser::schema::context::SharedSchemaContext;

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

pub fn generate_dart_code(schema: SharedSchemaContext, query: &str) -> Result<String> {
    let schema_ast = parse_schema::<String>(schema).context("Failed to parse schema")?;
    let query_ast = parse_query::<String>(query).context("Failed to parse query")?;

    let operation = get_operation(&query_ast)?;
    let query_name = match operation {
        OperationDefinition::Query(q) => q.name.clone().unwrap_or_else(|| "Query".to_string()),
        _ => "Query".to_string(),
    };
    
    let (field_name, return_type, fields) = extract_query_info(operation, &schema_ast)?;

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

fn get_type_info(type_ref: &Type<String>) -> (String, bool) {
    match type_ref {
        Type::NonNullType(inner) => {
            let (type_name, _) = get_type_info(inner);
            (type_name, true)
        }
        Type::NamedType(name) => {
            let dart_type = match name.as_str() {
                "Int" => "int",
                "Float" => "double",
                "String" => "String",
                "Boolean" => "bool",
                "ID" => "String",
                "DateTime" => "DateTime",
                other => panic!("Unsupported type: {}", other),
            };
            (dart_type.to_string(), false)
        }
        Type::ListType(_) => todo!("List types not yet supported"),
    }
}

fn find_type<'a>(schema: &'a graphql_parser::schema::Document<'a, String>, name: &str) -> Option<&'a TypeDefinition<'a, String>> {
    schema.definitions.iter().find_map(|def| {
        if let graphql_parser::schema::Definition::TypeDefinition(type_def) = def {
            match type_def {
                TypeDefinition::Object(obj) if obj.name == name => Some(type_def),
                _ => None,
            }
        } else {
            None
        }
    })
}

fn find_query_type<'a>(schema: &'a graphql_parser::schema::Document<'a, String>) -> Option<&'a TypeDefinition<'a, String>> {
    schema.definitions.iter().find_map(|def| {
        if let graphql_parser::schema::Definition::TypeDefinition(type_def) = def {
            match type_def {
                TypeDefinition::Object(obj) if obj.name == "Query" => Some(type_def),
                _ => None,
            }
        } else {
            None
        }
    })
}

fn extract_fields_from_selection(selection: &QueryField<String>, type_def: &TypeDefinition<String>) -> Result<Vec<Field>> {
    let mut fields = Vec::new();
    
    if let TypeDefinition::Object(obj) = type_def {
        for field_selection in &selection.selection_set.items {
            if let Selection::Field(field) = field_selection {
                if let Some(schema_field) = obj.fields.iter().find(|f| f.name == field.name) {
                    let (type_name, required) = get_type_info(&schema_field.field_type);
                    fields.push(Field {
                        name: field.name.clone(),
                        type_name,
                        required,
                    });
                }
            }
        }
    }

    Ok(fields)
}

fn extract_query_info<'a>(operation: &OperationDefinition<String>, schema: &'a graphql_parser::schema::Document<'a, String>) -> Result<(String, String, Vec<Field>)> {
    let selection_set = match operation {
        OperationDefinition::Query(q) => &q.selection_set,
        _ => anyhow::bail!("Only query operations are supported"),
    };

    let selection = match selection_set.items.first() {
        Some(Selection::Field(field)) => field,
        _ => anyhow::bail!("No field selection found"),
    };

    let query_type = find_query_type(schema)
        .ok_or_else(|| anyhow::anyhow!("Query type not found in schema"))?;

    let field_name = selection.name.clone();
    
    let return_type = if let TypeDefinition::Object(obj) = query_type {
        if let Some(field) = obj.fields.iter().find(|f| f.name == field_name) {
            let (type_name, _) = get_type_info(&field.field_type);
            type_name
        } else {
            anyhow::bail!("Field {} not found in Query type", field_name);
        }
    } else {
        anyhow::bail!("Query type is not an object type");
    };

    let return_type_def = find_type(schema, &return_type)
        .ok_or_else(|| anyhow::anyhow!("Return type {} not found in schema", return_type))?;

    let fields = extract_fields_from_selection(selection, return_type_def)?;

    Ok((field_name, return_type, fields))
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_type_info() {
        use graphql_parser::schema::Type;

        let non_null_int = Type::NonNullType(Box::new(Type::NamedType("Int".to_string())));
        assert_eq!(get_type_info(&non_null_int), ("int".to_string(), true));

        let nullable_string = Type::NamedType("String".to_string());
        assert_eq!(get_type_info(&nullable_string), ("String".to_string(), false));

        let nullable_datetime = Type::NamedType("DateTime".to_string());
        assert_eq!(get_type_info(&nullable_datetime), ("DateTime".to_string(), false));
    }

    #[test]
    fn test_generate_dart_code() {
        let schema = r#"
            scalar DateTime

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
                    age
                    dateOfBirth
                }
            }
        "#;

        let result = generate_dart_code(schema, query);
        assert!(result.is_ok(), "Failed to generate code: {:?}", result.err());
        
        let generated_code = result.unwrap();
        
        // Check class definitions
        assert!(generated_code.contains("class HelloWorldResponse"));
        assert!(generated_code.contains("class HelloWorldData"));
        assert!(generated_code.contains("class Person"));

        // Check field types
        assert!(generated_code.contains("final String? name"));
        assert!(generated_code.contains("final int age"));
        assert!(generated_code.contains("final DateTime dateOfBirth"));

        // Check required fields
        assert!(generated_code.contains("required this.age"));
        assert!(generated_code.contains("required this.dateOfBirth"));
        assert!(!generated_code.contains("required this.name"));

        // Check JSON serialization
        assert!(generated_code.contains("factory Person.fromJson(Map<String, dynamic> json)"));
        assert!(generated_code.contains("Map<String, dynamic> toJson()"));
        assert!(generated_code.contains("DateTime.parse(json['dateOfBirth'] as String)"));
        assert!(generated_code.contains("dateOfBirth?.toIso8601String()"));

        // Check equality operators
        assert!(generated_code.contains("bool operator ==(Object other)"));
        assert!(generated_code.contains("int get hashCode"));
        assert!(generated_code.contains("other is Person"));
        assert!(generated_code.contains("other.name == name"));
        assert!(generated_code.contains("other.age == age"));
        assert!(generated_code.contains("other.dateOfBirth == dateOfBirth"));
    }
}