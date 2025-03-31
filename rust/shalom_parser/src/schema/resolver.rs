use std::collections::{HashMap, HashSet};
use std::sync::Arc;

use super::context::{SchemaContext, SharedSchemaContext};
use super::types::{FieldDefinition, FieldType, GraphQLAny, ScalarType};
use super::{types::ObjectType, utils::TypeRef};
use anyhow::Result;
use apollo_compiler::{self};
use apollo_compiler::{schema as apollo_schema, Node};
const DEFAULT_SCALAR_TYPES: [(&str, &str); 8] = [
    ("String", "A UTF‐8 character sequence."),
    ("Int", "A signed 32‐bit integer."),
    ("Float", "A signed double-precision floating-point value."),
    ("Boolean", "true or false."),
    ("ID", "A unique identifier."),
    ("Date", "A date and time."),
    ("DateTime", "A date and time."),
    ("Time", "A time."),
];

pub fn resolve(schema: &String) -> Result<SharedSchemaContext> {
    let mut initial_types = HashMap::new();

    // Add the default scalar types
    for (name, description) in DEFAULT_SCALAR_TYPES.iter() {
        initial_types.insert(
            name.to_string(),
            GraphQLAny::Scalar(Node::new(ScalarType {
                name: name.to_string(),
                description: Some(description.to_string()),
            })),
        );
    }
    let schema_raw = match apollo_compiler::Schema::parse(schema, "schema.graphql") {
        Ok(schema) => schema,
        Err(e) => return Err(anyhow::anyhow!("Error parsing schema: {}", e)),
    };
    let schema = match schema_raw.validate() {
        Ok(schema) => schema,
        Err(e) => return Err(anyhow::anyhow!("Error validating schema: {}", e)),
    };

    let ctx = Arc::new(SchemaContext::new(initial_types, schema.clone()));

    for (name, type_) in &schema.types {
        match type_ {
            apollo_schema::ExtendedType::Object(object) => {
                resolve_object(ctx.clone(), name.to_string(), object.clone());
            }
            _ => todo!("Unsupported type in schema {:?}: {:?}", name.to_string(), type_.name()),
        }
    }

    Ok(ctx)
}

fn resolve_object(
    context: SharedSchemaContext,
    name: String,
    origin: apollo_compiler::Node<apollo_schema::ObjectType>,
) -> TypeRef {
    // Check if the type is already resolved
    if let Some(_) = context.get_type(&name) {
        return TypeRef::new(context.clone(), name);
    }
    let mut fields = HashSet::new();
    for (name, field) in origin.fields.iter() {
        let name = name.to_string();
        let ty = resolve_type(context.clone(), field.ty.clone());
        let description = field.description.as_ref().map(|v| v.to_string());
        let arguments = vec![];
        fields.insert(FieldDefinition {
            name,
            ty,
            description,
            arguments,
        });
    }
    let description = origin.description.as_ref().map(|v| v.to_string());
    let object = Node::new(ObjectType {
        name: name.clone(),
        description,
        fields,
        implements_interfaces: HashSet::new(),
    });
    context.add_object(name.clone(), object);
    TypeRef::new(context.clone(), name)
}

pub fn resolve_type(context: SharedSchemaContext, origin: apollo_schema::Type) -> FieldType {
    match origin {
        apollo_schema::Type::Named(named) => {
            FieldType::Named(TypeRef::new(context, named.to_string()))
        }
        apollo_schema::Type::NonNullNamed(non_null) => {
            FieldType::NonNullNamed(TypeRef::new(context, non_null.as_str().to_string()))
        }
        apollo_schema::Type::List(of_type) => {
            FieldType::List(Box::new(resolve_type(context, *of_type)))
        }
        apollo_schema::Type::NonNullList(of_type) => {
            FieldType::NonNullList(Box::new(resolve_type(context, *of_type)))
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_query_type_resolve() {
        let schema = r#"
            type Query{
                hello: String
            }
        "#
        .to_string();
        let ctx = resolve(&schema).unwrap();

        let object = ctx.get_type("Query");
        assert_eq!(object.is_some(), true);
        let obj = object.unwrap().object();
        assert_eq!(obj.is_some(), true);
        let obj = obj.unwrap();
        assert_eq!(obj.name, "Query");
        assert_eq!(obj.fields.len(), 1);
        let field = obj.get_field("hello");
        assert_eq!(field.is_some(), true);
    }
    #[test]
    fn resolve_simple_field_types() {
        let schema = r#"
            type Query{
                hello: String!
                world: Int!
                id: ID!
                foo: Float
            }
        "#
        .to_string();
        let ctx = resolve(&schema).unwrap();

        let object = ctx.get_type("Query").unwrap().object().unwrap();

        let hello_field = object.get_field("hello").unwrap();
        assert_eq!(hello_field.ty.get_scalar().unwrap().is_string(), true);
        let world_field = object.get_field("world").unwrap();
        assert_eq!(world_field.ty.get_scalar().unwrap().is_int(), true);
        let id_field = object.get_field("id").unwrap();
        assert_eq!(id_field.ty.get_scalar().unwrap().is_id(), true);
        let foo_field = object.get_field("foo").unwrap();
        assert_eq!(foo_field.ty.get_scalar().unwrap().is_float(), true);
        // optional
        assert_eq!(foo_field.ty.is_nullable(), true);
    }
}
