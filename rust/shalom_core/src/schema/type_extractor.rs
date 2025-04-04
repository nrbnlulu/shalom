use std::sync::Arc;
use serde::Serialize;
use apollo_compiler::Node; 
use crate::schema::types::{ObjectType, FieldType, FieldDefinition};




#[derive(Serialize, Debug)]
pub struct Field {
    pub name: String,
    pub type_name: String,  
    pub required: bool
}


#[derive(Serialize, Debug)]
pub struct Object {
    pub name: String, 
    pub fields: Vec<Field>
}

impl Object {
    pub fn new(object_type: &Node<ObjectType>) -> Object {
        let fields = object_type.fields.iter().map(|field_definition| {
            let field_name = field_definition.name.to_string();
            let (type_name,  required) = Object::parse_field_type(&field_definition.ty);
            return Field {
                name: field_name,
                required,
                type_name
            };
        }).collect();
        let object_name = object_type.name.to_string();
        return Self {
            name: object_name,
            fields
        };
    }

    fn parse_type_name(type_name: &str) -> String {
        let parsed_type_name = match type_name {
            "Int" => "int",
            "Float" => "double",
            "String" => "String",
            "Boolean" => "bool",
            "ID" => "String",
            "DateTime" => "DateTime",
            other => other,
        };
        return parsed_type_name.to_string();
    }

    fn parse_field_type(field_type: &FieldType) -> (String, bool) {
        match field_type {
            FieldType::Named(type_ref) => {
                return (Object::parse_type_name(&type_ref.name), false);        
            }
            FieldType::NonNullNamed(type_ref) => {
                return (Object::parse_type_name(&type_ref.name), true);
            }
            _ => todo!("lists will be implemnted later") 
        }
    }
}



