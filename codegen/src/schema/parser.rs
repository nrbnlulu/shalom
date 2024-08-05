use std::borrow::Borrow;
use std::collections::{HashMap, HashSet};
use std::rc::Rc;

use super::types::{FieldDefinition, FieldType};
use super::{context::SchemaContext, types::ObjectType, utils::TypeRef};
use apollo_compiler::{self, Node};
use apollo_compiler::schema as apollo_schema;
use anyhow::Result;


pub fn parse(schema: &String) -> Result<SchemaContext>{
    let ctx = SchemaContext::new();
    let schema =  match (apollo_compiler::Schema::parse(schema, "schema.graphql")) {
        Ok(schema) => schema,
        Err(e) => return Err(anyhow::anyhow!("Error parsing schema: {}", e))
    };
    for type_ in schema.types{
        
    }
}

fn object_def_from_origin(mut context: Rc<SchemaContext>, origin: apollo_compiler::Node<apollo_schema::ObjectType>) -> TypeRef<ObjectType>{
    let name = origin.name.to_string();
    let fields: HashSet<FieldDefinition> = origin.fields.iter().map(|(f_name, field)| {
        let name = field.name.to_string();
        
        FieldDefinition{
            name: name,
            ty: FieldType::from_origin(origin),
            description: field.description.clone(),
            arguments: HashSet::new(), 
        };
    }
        ).collect();

    let object = ObjectType{
        name: name,
        description: origin.description.clone(),
        fields: fields,
        implements_interfaces: HashSet::new(),
    }
    context.add_type(type_)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_parse(){
        let schema = r#"
            type Query{
                hello: String
            }
        "#;
        let ctx = parse(&schema.to_string()).unwrap();
        assert_eq!(ctx.get_type("Query").is_some(), true);
    }
}