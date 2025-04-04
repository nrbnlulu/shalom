use std::sync::Arc;
use serde::Serialize;
use apollo_compiler::Node; 
use crate::schema::types::{ObjectType, FieldType, FieldDefinition};


#[derive(Serialize)]
struct SchemaTemplateContext {
    objects: Vec<Object>
}

#[derive(Serialize)]
struct Query {
    query_name: String,
    field_name: String,    
    return_type: String,
}

#[derive(Serialize)]
struct QueryTemplateContext {
    queries: Vec<Query>,
    schema_file: String 
}

#[derive(Serialize)]
struct Field {
    name: String,
    type_name: String,  
    required: bool
}


#[derive(Serialize)]
struct Object {
    name: String, 
    fields: Vec<Field>
}

pub fn parse_object_type(object_type: &Node<ObjectType>) -> Object {
    let fields = object_type.fields.iter().map(|field_definition| {
        let field_name = field_definition.name.to_string();
        let (type_name,  required) = parse_field_type(&field_definition.ty);
        return Field {
            name: field_name,
            required,
            type_name
        };
    }).collect();
    let object_name = object_type.name.to_string();
    let object = Object {
        name: object_name,
        fields
    };
    return object
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
            return (parse_type_name(&type_ref.name), false);        
        }
        FieldType::NonNullNamed(type_ref) => {
            return (parse_type_name(&type_ref.name), true);
        }
        _ => todo!("lists will be implemnted later") 
    }
}

fn parse_selection_type(selection_type: FieldType) -> String {
    match selection_type {
        FieldType::Named(type_ref) => {
            return type_ref.name;        
        }
        FieldType::NonNullNamed(type_ref) => {
            return type_ref.name;
        }
        _ => todo!("lists will be implemnted later") 
    }
}

