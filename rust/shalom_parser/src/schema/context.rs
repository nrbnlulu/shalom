use std::{borrow::Borrow, cell::RefCell, collections::HashMap, iter::Map, rc::Rc};
use apollo_compiler::validation::Valid;
use crate::schema::types::GraphQLType;

#[derive(Debug)]
pub struct SchemaContext {
    types: HashMap<String, Box<GraphQLType>>,
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

    pub fn add_type(&mut self, name: String, type_: Box<GraphQLType>) {
        self.types.insert(name, type_);
    }

    pub fn get_type(&self, name: &str) -> Option<&GraphQLType> {
        self.types.get(name).map(|t| t.as_ref())
    }
}
pub type SharedSchemaContext = Rc<RefCell<SchemaContext>>;

