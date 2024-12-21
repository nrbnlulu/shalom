use std::cell::RefCell;
use std::collections::{HashMap, HashSet};
use std::rc::Rc;

use super::context::SharedSchemaContext;
use super::types::{FieldDefinition, FieldType, GraphQLType, ScalarType};
use super::{context::SchemaContext, types::ObjectType, utils::TypeRef};
use anyhow::Result;
use apollo_compiler::schema as apollo_schema;
use apollo_compiler::{self};
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
            Box::new(GraphQLType::Scalar(Rc::new(ScalarType {
                name: name.to_string(),
                description: Some(description.to_string()),
            }))),
        );
    }
    let schema_raw = match apollo_compiler::Schema::parse(schema, "schema.graphql") {
        Ok(schema) => schema,
        Err(e) => return Err(anyhow::anyhow!("Error parsing schema: {}", e)),
    };
    let schema = match schema_raw.validate() {
        Ok(schema) => Rc::new(schema),
        Err(e) => return Err(anyhow::anyhow!("Error validating schema: {}", e)),
    };

    
    let ctx = Rc::new(RefCell::new(SchemaContext::new(initial_types, schema.clone())));

    for type_ in &schema.types {
        match type_.1 {
            apollo_schema::ExtendedType::Object(object) => {
                resolve_object(ctx.clone(), type_.0.to_string(), object.clone());
            }
            _ => {}
        }
    }


    Ok(ctx)
}

fn resolve_object(
    context: Rc<RefCell<SchemaContext>>,
    name: String,
    origin: apollo_compiler::Node<apollo_schema::ObjectType>,
) -> TypeRef {
    let mut ctx = context.borrow_mut();
    if let Some(_) = ctx.get_type(&name) {
        return TypeRef::new(context.clone(), name);
    }
    let mut fields = HashSet::new();
    for (name, field) in origin.fields.iter() {
        let name = name.to_string();
        let ty = resolve_type(context.clone(), field.ty.clone());
        let description = field.description.as_ref().map(|v| v.to_string());
        let arguments = vec![];
        fields.insert(FieldDefinition {
            name: name,
            ty: ty,
            description: description,
            arguments: arguments,
        });
    }
    let description = origin.description.as_ref().map(|v| v.to_string());
    let object = Box::new(GraphQLType::Object(Rc::new(ObjectType {
        name: name.clone(),
        description: description,
        fields: fields,
        implements_interfaces: HashSet::new(),
    })));
    ctx.add_type(name.clone(), object);
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
        "#.to_string();
        let parsed = resolve(&schema).unwrap();
        let ctx = parsed.borrow();
        let object = ctx.get_type("Query");
        assert_eq!(object.is_some(), true);
    }
    #[test]
    fn resolve_simple_field_types() {
        let schema = r#"
            type Query{
                hello: String!
                world: Int!
                id: ID!
            }
        "#.to_string();
        let parsed = resolve(&schema).unwrap();
        let ctx = parsed.borrow();
        let object = ctx.get_type("Query").unwrap().object().unwrap();

        let hello_field = object.get_field("hello").unwrap();
        assert_eq!(hello_field.ty.get_scalar().unwrap().is_string(), true);
        
    }   
}
