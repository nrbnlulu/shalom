use crate::schema::types::SchemaObjectFieldDefinition;

use super::context::{SchemaContext, SharedSchemaContext};
use super::types::{
    EnumType, EnumValueDefinition, GenericResultType, GraphQLAny, InputFieldDefinition,
    InputObjectType, InterfaceType, ObjectType, ScalarType, SchemaFieldCommon, UnionType,
    UnresolvedType,
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

pub(crate) fn resolve(schema: &str, enable_generic_results: bool) -> Result<SharedSchemaContext> {
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
            info!("Parsed schema");
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
                resolve_object(
                    ctx.clone(),
                    name.to_string(),
                    object.clone(),
                    enable_generic_results,
                );
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
    enable_generic_results: bool,
) {
    // Check if the type is already resolved
    if context.get_type(&name).is_some() {
        return;
    }

    // Check for @genericResult directive if the feature is enabled
    if enable_generic_results {
        if let Some(directive) = origin.directives.get("genericResult") {
            resolve_generic_result(context, name, origin.clone(), directive);
            return;
        }
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
    let object = Arc::new(ObjectType {
        name: name.clone(),
        description,
        fields,
        implements_interfaces,
    });
    context.add_object(name.clone(), object).unwrap();
}

fn resolve_generic_result(
    context: SharedSchemaContext,
    name: String,
    origin: apollo_compiler::Node<apollo_schema::ObjectType>,
    directive: &apollo_compiler::Node<apollo_compiler::ast::Directive>,
) {
    use apollo_compiler::ast::Value;

    // Extract directive arguments
    let data_field = directive
        .arguments
        .iter()
        .find(|arg| arg.name.as_str() == "dataField")
        .and_then(|arg| {
            if let Value::String(s) = &*arg.value {
                Some(s.as_str())
            } else {
                None
            }
        })
        .unwrap_or("data")
        .to_string();

    let error_field = directive
        .arguments
        .iter()
        .find(|arg| arg.name.as_str() == "errorField")
        .and_then(|arg| {
            if let Value::String(s) = &*arg.value {
                Some(s.as_str())
            } else {
                None
            }
        })
        .unwrap_or("error")
        .to_string();

    let error_fragment = directive
        .arguments
        .iter()
        .find(|arg| arg.name.as_str() == "errorFragment")
        .and_then(|arg| {
            if let Value::String(s) = &*arg.value {
                Some(s.to_string())
            } else {
                None
            }
        })
        .expect(&format!(
            "@genericResult directive on type '{}' must have errorFragment argument",
            name
        ));

    // Get field types
    let data_field_def = origin.fields.get(data_field.as_str()).expect(&format!(
        "Field '{}' not found on type '{}'",
        data_field, name
    ));
    let error_field_def = origin.fields.get(error_field.as_str()).expect(&format!(
        "Field '{}' not found on type '{}'",
        error_field, name
    ));

    let description = origin.description.as_ref().map(|v| v.to_string());

    let data_type = UnresolvedType::new(&data_field_def.ty);
    let error_type = UnresolvedType::new(&error_field_def.ty);

    let generic_result = Arc::new(GenericResultType {
        description,
        name: name.clone(),
        data_field,
        error_field,
        error_fragment,
        data_type,
        error_type,
    });

    context
        .add_generic_result(name.clone(), generic_result.clone())
        .unwrap();
    // Note: add_type doesn't exist, but add_generic_result already adds it to the types map
    // The SchemaTypesCtx::get_any method will find it through get_generic_result
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
            is_maybe: is_optional && default_value.is_none(),
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
    let mut fields = HashMap::new();
    for (name, field) in origin.fields.iter() {
        let name = name.to_string();
        let description = field.description.as_ref().map(|v| v.to_string());
        let field_definition = SchemaFieldCommon::new(name.clone(), &field.ty, description);
        fields.insert(
            name.to_string(),
            SchemaObjectFieldDefinition {
                arguments: vec![],
                field: field_definition,
            },
        );
    }
    let description = origin.description.as_ref().map(|v| v.to_string());
    let implements_interfaces = origin
        .implements_interfaces
        .iter()
        .map(|iface| iface.to_string())
        .collect::<HashSet<_>>();
    let interface = Arc::new(InterfaceType {
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
        let ctx = resolve(&schema, false).unwrap();

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
