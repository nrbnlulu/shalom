use std::{borrow::Borrow, cell::RefCell, collections::HashMap, iter::Map, rc::Rc};
use apollo_compiler::{validation::Valid, Node};
use crate::schema::types::GraphQLType;

use super::types::{EnumType, InputObjectType, ObjectType};

#[derive(Debug)]
pub struct SchemaContext {
    types: HashMap<String, GraphQLType>,
    inputs: HashMap<String, Node<InputObjectType>>,
    object_types: HashMap<String, Node<ObjectType>>,
    enums: HashMap<String, Node<EnumType>>,
    pub schema: Rc<Valid<apollo_compiler::Schema>>,
}

impl SchemaContext {
    pub fn new(
        initial_types: HashMap<String, Box<GraphQLType>>,
        schema: Rc<Valid<apollo_compiler::Schema>>,
    ) -> SchemaContext {
        SchemaContext {
            types: initial_types,
            schema,
        }
    }

    pub fn add_object(&mut self, name: String, type_: Node<ObjectType>) {
        if (self.types.contains_key(&name)){
            panic!("")
        }
        self.types.insert(name.clone(), GraphQLType::Object(type_.clone()));
        self.object_types.insert(name, type_);
    }

    pub fn get_type(&self, name: &str) -> Option<&GraphQLType> {
        self.types.get(name).map(|t| t.as_ref())
    }
}
pub type SharedSchemaContext = Rc<RefCell<SchemaContext>>;

