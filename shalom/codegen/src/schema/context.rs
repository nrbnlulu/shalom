use std::{borrow::Borrow, cell::RefCell, collections::HashMap, iter::Map, rc::Rc};

use crate::schema::types::GraphQLType;

#[derive(Debug)]
pub struct SchemaContext {
    types: HashMap<String, Box<GraphQLType>>

}

impl SchemaContext{
    pub fn new() -> SchemaContext{
        SchemaContext{
            types: HashMap::new()
        }
    }

    pub fn add_type(&mut self, name: String, type_: Box<GraphQLType>){
        self.types.insert(name, type_);
    }

    pub fn get_type(&self, name: &str) -> Option<&GraphQLType>{
        self.types.get(name).map(|t| t.borrow())
    }
}
pub type SharedSchemaContext = Rc<RefCell<SchemaContext>>;
