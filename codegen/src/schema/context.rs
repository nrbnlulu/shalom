use std::{borrow::Borrow, collections::HashMap, iter::Map};

use crate::schema::types::GraphQLType;

pub struct SchemaContext {
    types: HashMap<String, Box<GraphQLType>>

}

impl SchemaContext{
    pub fn new() -> SchemaContext{
        SchemaContext{
            types: HashMap::new()
        }
    }

    pub fn add_type(&mut self, type_: Box<GraphQLType>){
        self.types.insert(type_.name.clone(), type_);
    }

    pub fn get_type(&self, name: &str) -> Option<&GraphQLType>{
        self.types.get(name).map(|t| t.borrow())
    }
}
