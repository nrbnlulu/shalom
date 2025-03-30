use std::sync::Arc;
use std::sync::RwLock;
use apollo_compiler::Schema;
use apollo_compiler::{ast, executable::{Operation, Selection}, Node, ExecutableDocument};
use shalom_parser::{schema::context::{SharedSchemaContext, SchemaContext}, GenerationContext, schema::resolver::resolve as schema_resolve, schema::types::{GraphQLType, ObjectType, FieldType}, operation::resolver::resolve as operation_resolve};
use std::collections::HashMap;
use serde::Serialize;
use minijinja::{Environment, context};
use std::fs::File;
use std::io;
use std::io::{Read};


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

pub struct DartCodeGenerator {
   generation_ctx: Arc<GenerationContext>,
   schema_ctx: Arc<RwLock<SchemaContext>>,
   schema_file: String
}

impl DartCodeGenerator {
    pub fn new(schema: &str, query: &str, schema_file: &str) -> anyhow::Result<Self> {
        let schema_context = schema_resolve(&schema.to_string())?;
        let doc = operation_resolve(&query.to_string(), schema_context.clone())?;
        let generation_context = Arc::new(GenerationContext::new(schema_context.clone(), vec![doc])?);   
        Ok(Self {
            generation_ctx: generation_context,
            schema_ctx: schema_context,
            schema_file: schema_file.to_string()
        })
    }

    pub fn generate(
        &self, 
    ) -> anyhow::Result<(String, String)> {
        let schema_content = self.generate_schema()?;
        let operations_content = self.generate_operations()?;
        return Ok((schema_content, operations_content));
    }

    fn generate_schema(&self) -> anyhow::Result<String> {
        let schema_context = self.schema_ctx.read().unwrap();
        let mut objects = Vec::new();
        for (name, _) in &schema_context.schema.types {
        if !name.starts_with("__") {
            let type_ =  schema_context.get_type(name.as_str()); 
            if let Some(type_obj) = type_ {
                match type_obj {
                    GraphQLType::Object(node) => {
                        objects.push(self.parse_object_type(&node));      
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
        let content = self.render_template::<SchemaTemplateContext>(&template_context, "templates/schema.jinja.dart")?;
        Ok(content)
    }

    fn generate_operations(&self) -> anyhow::Result<String> {
        let mut queries = Vec::new();
        for (_, operation) in self.generation_ctx.operations.iter() {
            for selection in  operation.selection_set.selections.iter() {
                match selection {
                    Selection::Field(field) => {
                        if !operation.name.is_some() {
                            continue;
                        }
                        let query_name = operation.name.as_ref().unwrap().to_string();
                        let return_type = self.parse_selection_type(&field.definition.ty); 
                        let field_name = field.name.to_string();
                        let query = Query {
                            query_name, 
                            return_type,
                            field_name
                        };
                        queries.push(query);
                    }   
                    _ => {}
                };
            }
        } 
        let template_context = QueryTemplateContext  {
            queries, 
            schema_file: self.schema_file.clone()
        };
        let content = self.render_template::<QueryTemplateContext>(&template_context, "templates/query.jinja.dart")?;
        Ok(content)
    }

    fn parse_type_name(&self, type_name: &str) -> String {
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
    fn parse_field_type(&self, field_type: &FieldType) -> (String, bool) {
        match field_type {
            FieldType::Named(type_ref) => {
                return (self.parse_type_name(&type_ref.name), false);        
            }
            FieldType::NonNullNamed(type_ref) => {
                return (self.parse_type_name(&type_ref.name), true);
            }
            _ => todo!("lists will be implemnted later") 
        }
    }

    fn parse_selection_type(&self, selection_type: &ast::Type) -> String {
        match selection_type {
            ast::Type::Named(type_ref) => {
                return type_ref.to_string();        
            }
            ast::Type::NonNullNamed(type_ref) => {
                return type_ref.to_string();
            }
            _ => todo!("lists will be implemnted later") 
        }
    }

    fn parse_object_type(&self, object_type: &Node<ObjectType>) -> Object {
        let fields = object_type.fields.iter().map(|field_definition| {
            let field_name = field_definition.name.clone();
            let (type_name,  required) = self.parse_field_type(&field_definition.ty);
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

    fn render_template<T: Serialize>(&self, template_context: &T, tmpl_path: &str) -> anyhow::Result<String> {
        let mut env = Environment::new();     
        let template = self.read_from_file(tmpl_path)?;
        env.add_template("template", &template).unwrap();
        let tmpl = env.get_template("template").unwrap();
        let content = tmpl.render(&template_context).unwrap();
        return Ok(content);
    }

    fn read_from_file(&self, path: &str) -> io::Result<String> {
        let mut file = File::open(path)?;
        let mut contents = String::new();
        file.read_to_string(&mut contents)?;
        Ok(contents)
    }
}