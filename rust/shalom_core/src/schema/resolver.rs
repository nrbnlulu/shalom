use crate::schema::types::SchemaObjectFieldDefinition;

use super::context::{SchemaContext, SharedSchemaContext};
use super::types::{
    EnumType, EnumValueDefinition, GraphQLAny, InputFieldDefinition, InputObjectType,
    InterfaceType, ObjectType, ScalarType, SchemaFieldCommon, UnionType,
};
use anyhow::Result;
use apollo_compiler::{self};
use apollo_compiler::{schema as apollo_schema, Node};
use log::{debug, info};
use std::collections::{HashMap, HashSet};
use std::sync::Arc;

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

pub(crate) fn resolve(schema: &str) -> Result<SharedSchemaContext> {
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
        Ok(schema) => {
            info!(" Parsed schema");
            schema
        }
        Err(e) => return Err(anyhow::anyhow!("Error validating schema: {}", e)),
    };

    let ctx = Arc::new(SchemaContext::new(initial_types, schema.clone()));
    for (name, type_) in &schema.types {
        if name.starts_with("__") {
            continue;
        }
        debug!("Resolving type: {name:?}");
        match type_ {
            apollo_schema::ExtendedType::Object(object) => {
                resolve_object(ctx.clone(), name.to_string(), object.clone());
            }
            apollo_schema::ExtendedType::Scalar(scalar) => {
                let name = scalar.name.to_string();
                let description = scalar.description.as_ref().map(|v| v.to_string());
                ctx.add_scalar(name.clone(), Node::new(ScalarType { name, description }))
                    .unwrap();
            }
            apollo_schema::ExtendedType::Enum(enum_) => {
                resolve_enum(ctx.clone(), name.to_string(), enum_.clone());
            }
            apollo_schema::ExtendedType::InputObject(input) => {
                resolve_input(&ctx, name.to_string(), input);
            }
            apollo_schema::ExtendedType::Interface(interface) => {
                resolve_interface(ctx.clone(), name.to_string(), interface.clone());
            }
            apollo_schema::ExtendedType::Union(union_) => {
                resolve_union(ctx.clone(), name.to_string(), union_.clone());
            }
        }
    }
    Ok(ctx)
}

#[allow(unused)]
fn resolve_scalar(
    context: SharedSchemaContext,
    name: String,
    origin: Node<apollo_schema::ScalarType>,
) {
    // Check if the type is already resolved
    if context.get_type(&name).is_some() {
        return;
    }
    let description = origin.description.as_ref().map(|v| v.to_string());
    let scalar = Node::new(ScalarType {
        name: name.clone(),
        description,
    });
    context.add_scalar(name.clone(), scalar).unwrap();
}

fn resolve_object(
    context: SharedSchemaContext,
    name: String,
    origin: apollo_compiler::Node<apollo_schema::ObjectType>,
) {
    // Check if the type is already resolved
    if context.get_type(&name).is_some() {
        return;
    }
    let mut fields = HashMap::new();
    for (name, field) in origin.fields.iter() {
        let name = name.to_string();
        let description = field.description.as_ref().map(|v| v.to_string());
        let arguments = vec![];
        let field_definition = SchemaFieldCommon::new(name.clone(), &field.ty, description);
        fields.insert(
            name,
            SchemaObjectFieldDefinition {
                field: field_definition,
                arguments,
            },
        );
    }
    let description = origin.description.as_ref().map(|v| v.to_string());
    let implements_interfaces = origin
        .implements_interfaces
        .iter()
        .map(|iface| iface.to_string())
        .collect::<HashSet<_>>();
    let object = Node::new(ObjectType {
        name: name.clone(),
        description,
        fields,
        implements_interfaces,
    });
    context.add_object(name.clone(), object).unwrap();
}

#[allow(unused)]
fn resolve_enum(context: SharedSchemaContext, name: String, origin: Node<apollo_schema::EnumType>) {
    if context.get_type(&name).is_some() {
        return;
    }
    let mut members = HashMap::new();
    for (name, value) in origin.values.iter() {
        let description = value.description.as_ref().map(|v| v.to_string());
        let value = value.value.to_string();
        let enum_value_definition = EnumValueDefinition { description, value };
        members.insert(name.to_string(), enum_value_definition);
    }
    let description = origin.description.as_ref().map(|v| v.to_string());
    let enum_type = EnumType {
        description,
        name: name.clone(),
        members,
    };
    context.add_enum(name.clone(), Node::new(enum_type));
}

fn resolve_input(
    context: &SharedSchemaContext,
    name: String,
    origin: &apollo_schema::InputObjectType,
) {
    if context.get_type(&name).is_some() {
        return;
    }
    let mut fields = HashMap::new();
    for (name, field) in origin.fields.iter() {
        let description = field.description.as_ref().map(|v| v.to_string());
        let is_optional = !field.ty.is_non_null();
        let default_value = field.default_value.clone();
        let name = name.to_string();
        let field_definition = SchemaFieldCommon::new(name.clone(), &field.ty, description);
        let input_field_definition = InputFieldDefinition {
            common: field_definition,
            is_optional,
            default_value,
        };
        fields.insert(name, input_field_definition);
    }
    let description = origin.description.as_ref().map(|v| v.to_string());
    let input_object = InputObjectType {
        description,
        name: name.clone(),
        fields,
    };
    context.add_input(name, Node::new(input_object)).unwrap();
}

fn resolve_interface(
    context: SharedSchemaContext,
    name: String,
    origin: apollo_compiler::Node<apollo_schema::InterfaceType>,
) {
    if context.get_type(&name).is_some() {
        return;
    }
    let mut fields = HashSet::new();
    for (name, field) in origin.fields.iter() {
        let name = name.to_string();
        let description = field.description.as_ref().map(|v| v.to_string());
        let field_definition = SchemaFieldCommon::new(name.clone(), &field.ty, description);
        fields.insert(field_definition);
    }
    let description = origin.description.as_ref().map(|v| v.to_string());
    let implements_interfaces = origin
        .implements_interfaces
        .iter()
        .map(|iface| iface.to_string())
        .collect::<HashSet<_>>();
    let interface = Node::new(InterfaceType {
        name: name.clone(),
        description,
        fields,
        implements_interfaces,
    });
    context.add_interface(name.clone(), interface).unwrap();
}

fn resolve_union(
    context: SharedSchemaContext,
    name: String,
    origin: apollo_compiler::Node<apollo_schema::UnionType>,
) {
    if context.get_type(&name).is_some() {
        return;
    }
    let description = origin.description.as_ref().map(|v| v.to_string());
    let members = origin
        .members
        .iter()
        .map(|member| member.to_string())
        .collect::<HashSet<_>>();
    let union = Node::new(UnionType {
        name: name.clone(),
        description,
        members,
    });
    context.add_union(name.clone(), union).unwrap();
}

#[cfg(test)]
mod tests {
    use super::*;
    fn setup() {
        simple_logger::init().unwrap();
    }
    #[test]
    fn test_query_type_resolve() {
        setup();
        let schema = r#"
            type Query{
                hello: String
            }
        "#
        .to_string();
        let ctx = resolve(&schema).unwrap();

        let object = ctx.get_type(&"Query".to_string());
        assert!(object.is_some());
        let obj = object.unwrap().object();
        assert!(obj.is_some());
        let obj = obj.unwrap();
        assert_eq!(obj.name, "Query");
        assert_eq!(obj.fields.len(), 1);
        let field = obj.get_field("hello");
        assert!(field.is_some());
    }
}
