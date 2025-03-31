use crate::schema::types::GraphQLAny;
use apollo_compiler::{validation::Valid, Node};
use std::{
    collections::HashMap,
    sync::{Arc, Mutex},
};

use super::types::{EnumType, InputObjectType, ObjectType, ScalarType};
#[derive(Debug)]
pub(crate) struct SchemaTypesCtx {
    inputs: HashMap<String, Node<InputObjectType>>,
    objects: HashMap<String, Node<ObjectType>>,
    enums: HashMap<String, Node<EnumType>>,
    scalars: HashMap<String, Node<ScalarType>>,
}
impl SchemaTypesCtx {
    fn new() -> Self {
        Self {
            inputs: HashMap::new(),
            objects: HashMap::new(),
            enums: HashMap::new(),
            scalars: HashMap::new(),
        }
    }

    pub fn add_any(&mut self, name: String, type_: &GraphQLAny) {
        match type_ {
            GraphQLAny::InputObject(v) => self.add_input(name, v.clone()),
            GraphQLAny::Object(v) => self.add_object(name, v.clone()),
            GraphQLAny::Enum(v) => self.add_enum(name, v.clone()),
            GraphQLAny::Scalar(v) => self.add_scalar(name, v.clone()),
            _ => todo!("Unsupported type"),
        };
    }

    pub fn add_input(&mut self, name: String, type_: Node<InputObjectType>) {
        self.inputs.insert(name, type_);
    }

    pub fn add_object(&mut self, name: String, type_: Node<ObjectType>) {
        self.objects.insert(name, type_);
    }

    pub fn add_enum(&mut self, name: String, type_: Node<EnumType>) {
        self.enums.insert(name, type_);
    }

    pub fn add_scalar(&mut self, name: String, type_: Node<ScalarType>) {
        self.scalars.insert(name, type_);
    }
    pub fn get_any(&self, name: &str) -> Option<GraphQLAny> {
        if let Some(v) = self.inputs.get(name) {
            return Some(GraphQLAny::InputObject(v.clone()));
        }
        if let Some(v) = self.objects.get(name) {
            return Some(GraphQLAny::Object(v.clone()));
        }
        if let Some(v) = self.enums.get(name) {
            return Some(GraphQLAny::Enum(v.clone()));
        }
        if let Some(v) = self.scalars.get(name) {
            return Some(GraphQLAny::Scalar(v.clone()));
        }
        None
    }
}

#[derive(Debug)]
pub(crate) struct SchemaContext {
    types: Mutex<SchemaTypesCtx>,
    pub schema: Valid<apollo_compiler::Schema>,
}

impl SchemaContext {
    pub fn new(
        initial_types: HashMap<String, GraphQLAny>,
        schema: Valid<apollo_compiler::Schema>,
    ) -> SchemaContext {
        let types_ctx = Mutex::new(SchemaTypesCtx::new());
        {
            let mut types_ctx_g = types_ctx.lock().unwrap();
            for (name, type_) in initial_types {
                types_ctx_g.add_any(name, &type_);
            }
        }
        SchemaContext {
            types: types_ctx,
            schema,
        }
    }
    pub fn get_type(&self, name: &str) -> Option<GraphQLAny> {
        let types_ctx = self.types.lock().unwrap();
        types_ctx.get_any(name)
    }

    pub fn add_object(&self, name: String, type_: Node<ObjectType>) -> anyhow::Result<()> {
        let mut types_ctx = self
            .types
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;
        types_ctx.add_object(name, type_);
        Ok(())
    }
}
pub type SharedSchemaContext = Arc<SchemaContext>;
