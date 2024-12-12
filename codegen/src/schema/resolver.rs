use std::cell::RefCell;
use std::collections::HashSet;
use std::rc::Rc;

use super::context::SharedSchemaContext;
use super::types::{FieldDefinition, FieldType, GraphQLType};
use super::{context::SchemaContext, types::ObjectType, utils::TypeRef};
use anyhow::Result;
use apollo_compiler::schema as apollo_schema;
use apollo_compiler::{self};

pub fn resolve(schema: &String) -> Result<SharedSchemaContext> {
    let ctx = Rc::new(RefCell::new(SchemaContext::new()));
    let schema = match (apollo_compiler::Schema::parse(schema, "schema.graphql")) {
        Ok(schema) => schema,
        Err(e) => return Err(anyhow::anyhow!("Error parsing schema: {}", e)),
    };
    for type_ in schema.types {
        match type_.1 {
            apollo_schema::ExtendedType::Object(object) => {
                resolve_object(ctx.clone(), type_.0.to_string(), object);
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

    #[test]
    fn test_resolve_nested_object_types() {
        let schema = r#"
            type Address {
                street: String
                city: String
            }

            type Person {
                name: String
                address: Address
            }

            type Query {
                person: Person
            }
        "#.to_string();
        let parsed = resolve(&schema).unwrap();
        let ctx = parsed.borrow();

        let person_type = ctx.get_type("Person").unwrap().object().unwrap();
        let address_field = person_type.get_field("address").unwrap();
        let address_type = address_field.ty.get_object().unwrap();

        assert_eq!(address_type.name, "Address");
    }

    #[test]
    fn test_resolve_interface_types() {
        let schema = r#"
            interface Character {
                id: ID!
                name: String!
            }

            type Human implements Character {
                id: ID!
                name: String!
                homePlanet: String
            }

            type Droid implements Character {
                id: ID!
                name: String!
                primaryFunction: String
            }

            type Query {
                hero: Character
            }
        "#.to_string();
        let parsed = resolve(&schema).unwrap();
        let ctx = parsed.borrow();

        let character_type = ctx.get_type("Character").unwrap().interface().unwrap();
        assert_eq!(character_type.name, "Character");

        let human_type = ctx.get_type("Human").unwrap().object().unwrap();
        assert!(human_type.implements_interfaces.iter().any(|i| i.name == "Character"));

        let droid_type = ctx.get_type("Droid").unwrap().object().unwrap();
        assert!(droid_type.implements_interfaces.iter().any(|i| i.name == "Character"));
    }

    #[test]
    fn test_resolve_union_types() {
        let schema = r#"
            type Human {
                id: ID!
                name: String!
                homePlanet: String
            }

            type Droid {
                id: ID!
                name: String!
                primaryFunction: String
            }

            union SearchResult = Human | Droid

            type Query {
                search: [SearchResult]
            }
        "#.to_string();
        let parsed = resolve(&schema).unwrap();
        let ctx = parsed.borrow();

        let search_result_type = ctx.get_type("SearchResult").unwrap().union().unwrap();
        assert_eq!(search_result_type.name, "SearchResult");

        let human_type = ctx.get_type("Human").unwrap().object().unwrap();
        assert!(search_result_type.members.iter().any(|m| m.name == human_type.name));

        let droid_type = ctx.get_type("Droid").unwrap().object().unwrap();
        assert!(search_result_type.members.iter().any(|m| m.name == droid_type.name));
    }
}
