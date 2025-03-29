use std::sync::Arc;
use std::sync::RwLock;
use apollo_compiler::Schema;
use apollo_compiler::{executable::Operation, Node, ExecutableDocument};
use shalom_parser::{schema::context::{SharedSchemaContext, SchemaContext}, GenerationContext, schema::resolver::resolve, schema::types::{GraphQLType, ObjectType, FieldType}};
use std::collections::HashMap;
use serde::Serialize;
use minijinja::{Environment, context};
use std::fs::File;
use std::io;
use std::io::{Read};


#[derive(Serialize)]
pub struct SchemaTemplateContext {
    objects: Vec<Object>
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

pub fn generate_dart_code(schema: &str, query: &str) -> anyhow::Result<String> {
    let schema_context = resolve(&schema.to_string())?;
    //let doc = ExecutableDocument::parse_and_validate(&schema_context.borrow().schema, query, "query.graphql").unwrap();
    let generation_context = Arc::new(GenerationContext::new(schema_context.clone(), vec![])?);   
    let dart_code = generate(generation_context.clone())?;
    return Ok(dart_code); 
}

fn generate(
    ctx: Arc<GenerationContext>
) -> anyhow::Result<String> {
    let schema_content = generate_schema(ctx.schema.clone())?;
    Ok(schema_content)
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
fn parse_object_type(object_type: &Node<ObjectType>) -> Object {
    let fields = object_type.fields.iter().map(|field_definition| {
        let field_name = field_definition.name.clone();
        let (type_name,  required) = parse_field_type(&field_definition.ty);
        return Field {
            name: field_name,
            required,
            type_name
        };
    }).collect();
    let object_name = object_type.name.clone();
    let object = Object {
        name: object_name,
        fields
    };
    return object
}
fn generate_schema(schema: SharedSchemaContext) -> anyhow::Result<String> {
    let schema_context = schema.read().unwrap();
    let mut objects = Vec::new();
    for (name, _) in &schema_context.schema.types {
       if !name.starts_with("__") {
        let type_ =  schema_context.get_type(name.as_str()); 
        if let Some(type_obj) = type_ {
            match type_obj {
                GraphQLType::Object(node) => {
                    objects.push(parse_object_type(&node));      
                }
                GraphQLType::Scalar(_) => {}
                _ => todo!("other types will be implemented soon")
            }
        }
      }
    }
    let template_context = SchemaTemplateContext {
           objects 
       };
    let content = render_template::<SchemaTemplateContext>(&template_context, "templates/schema.jinja.dart")?;
    Ok(content)
}


fn render_template<T: Serialize>(template_context: &T, tmpl_path: &str) -> anyhow::Result<String> {
    let mut env = Environment::new();     
    let template = read_from_file(tmpl_path)?;
    env.add_template("template", &template).unwrap();
    let tmpl = env.get_template("template").unwrap();
    let content = tmpl.render(&template_context).unwrap();
    return Ok(content);
}

fn read_from_file(path: &str) -> io::Result<String> {
    let mut file = File::open(path)?;
    let mut contents = String::new();
    file.read_to_string(&mut contents)?;
    Ok(contents)
}

fn generate_operation(op: Node<Operation>, ctx: Arc<GenerationContext>) -> anyhow::Result<()> {
    Ok(())
}
