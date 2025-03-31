use std::{borrow::Borrow, cell::RefCell, collections::HashMap, iter::Map, rc::Rc, sync::{Arc, Mutex}};
use apollo_compiler::{validation::Valid, Node};
use log::info;
use crate::schema::types::GraphQLType;

use super::types::{EnumType, InputObjectType, ObjectType};

struct TypesContainer{
    types: HashMap<String, GraphQLType>,
    inputs: HashMap<String, InputObjectType>,
    object_types: HashMap<String, Node<ObjectType>>,
    enums: HashMap<String, EnumType>,
}

#[derive(Debug)]
struct SchemaContext {
    types: Mutex<TypesContainer>,
    pub schema: Valid<apollo_compiler::Schema>,
}

impl SchemaContext {
    pub fn new(
        initial_types: HashMap<String, GraphQLType>,
        schema: Valid<apollo_compiler::Schema>,
    ) -> SchemaContext {
        SchemaContext {
            types: Mutex::new(TypesContainer{
                types: initial_types,
                inputs: HashMap::new(),
                object_types: HashMap::new(),
                enums: HashMap::new(),
            }),
            schema,
        }
    }

    pub fn add_object(&mut self, name: String, type_: ObjectType) {
        let ty_container = &mut self.types.lock().unwrap();
        if ty_container.types.contains_key(&name){
            info!("Object type {} already exists", name);
            return;
        }
        let obj_type = Node::new(type_);
        ty_container.types.insert(name.clone(), GraphQLType::Object(obj_type.clone()));
        ty_container.object_types.insert(name, obj_type);
    }

    pub fn get_type(&self, name: &str) -> Option<GraphQLType> {
        self.types.lock().unwrap().types.get(name).map(|t| t.clone())
    }
}
pub type SharedSchemaContext = Arc<Mutex<SchemaContext>>;

