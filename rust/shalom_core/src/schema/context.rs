use crate::schema::types::{GraphQLAny, Implementor};
use apollo_compiler::{validation::Valid, Node};
use serde::{Serialize, Serializer};
use std::fmt::Debug;
use std::{
    collections::{HashMap, HashSet},
    sync::{Arc, Mutex, MutexGuard},
};

use super::types::{EnumType, InputObjectType, InterfaceType, ObjectType, ScalarType, UnionType};

fn serialize_schema_types<S>(
    schema_types: &Mutex<SchemaTypesCtx>,
    serializer: S,
) -> Result<S::Ok, S::Error>
where
    S: Serializer,
{
    let schema_types = schema_types.lock().unwrap().clone();
    schema_types.serialize(serializer)
}

#[derive(Debug, Serialize, Clone)]
pub(crate) struct SchemaTypesCtx {
    inputs: HashMap<String, Node<InputObjectType>>,
    objects: HashMap<String, Node<ObjectType>>,
    interfaces: HashMap<String, Node<InterfaceType>>,
    unions: HashMap<String, Node<UnionType>>,
    enums: HashMap<String, Node<EnumType>>,
    scalars: HashMap<String, Node<ScalarType>>,
}
impl SchemaTypesCtx {
    fn new() -> Self {
        Self {
            inputs: HashMap::new(),
            objects: HashMap::new(),
            interfaces: HashMap::new(),
            unions: HashMap::new(),
            enums: HashMap::new(),
            scalars: HashMap::new(),
        }
    }

    pub fn add_any(&mut self, name: String, type_: &GraphQLAny) {
        match type_ {
            GraphQLAny::InputObject(v) => self.add_input(name, v.clone()),
            GraphQLAny::Object(v) => self.add_object(name, v.clone()),
            GraphQLAny::Interface(v) => self.add_interface(name, v.clone()),
            GraphQLAny::Union(v) => self.add_union(name, v.clone()),
            GraphQLAny::Enum(v) => self.add_enum(name, v.clone()),
            GraphQLAny::Scalar(v) => self.add_scalar(name, v.clone()),
            GraphQLAny::List { .. } => todo!("List types not supported in add_any"),
        };
    }

    pub fn add_input(&mut self, name: String, type_: Node<InputObjectType>) {
        self.inputs.insert(name, type_);
    }

    pub fn add_object(&mut self, name: String, type_: Node<ObjectType>) {
        self.objects.insert(name, type_);
    }

    pub fn add_interface(&mut self, name: String, type_: Node<InterfaceType>) {
        self.interfaces.insert(name, type_);
    }

    pub fn add_union(&mut self, name: String, type_: Node<UnionType>) {
        self.unions.insert(name, type_);
    }

    pub fn add_enum(&mut self, name: String, type_: Node<EnumType>) {
        self.enums.insert(name, type_);
    }

    pub fn add_scalar(&mut self, name: String, type_: Node<ScalarType>) {
        self.scalars.insert(name, type_);
    }

    pub fn get_any(&self, name: &String) -> Option<GraphQLAny> {
        if let Some(v) = self.inputs.get(name) {
            return Some(GraphQLAny::InputObject(v.clone()));
        }
        if let Some(v) = self.objects.get(name) {
            return Some(GraphQLAny::Object(v.clone()));
        }
        if let Some(v) = self.interfaces.get(name) {
            return Some(GraphQLAny::Interface(v.clone()));
        }
        if let Some(v) = self.unions.get(name) {
            return Some(GraphQLAny::Union(v.clone()));
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

#[derive(Debug, Serialize)]
pub struct SchemaContext {
    #[serde(serialize_with = "serialize_schema_types")]
    types: Mutex<SchemaTypesCtx>,
    #[serde(skip_serializing)]
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
    pub fn get_type(&self, name: &String) -> Option<GraphQLAny> {
        let types_ctx = self.types.lock().unwrap();
        types_ctx.get_any(name)
    }

    pub fn get_scalar(&self, name: &str) -> Option<Node<ScalarType>> {
        let types_ctx = self.types.lock().unwrap();
        types_ctx.scalars.get(name).cloned()
    }

    pub fn get_interface(&self, name: &str) -> Option<Node<InterfaceType>> {
        let types_ctx = self.types.lock().unwrap();
        types_ctx.interfaces.get(name).cloned()
    }

    pub fn get_union(&self, name: &str) -> Option<Node<UnionType>> {
        let types_ctx = self.types.lock().unwrap();
        types_ctx.unions.get(name).cloned()
    }

    pub fn add_object(&self, name: String, type_: Node<ObjectType>) -> anyhow::Result<()> {
        let mut types_ctx = self
            .types
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;
        types_ctx.add_object(name, type_);
        Ok(())
    }

    fn get_types(&self) -> MutexGuard<'_, SchemaTypesCtx> {
        self.types.lock().unwrap()
    }

    pub fn add_scalar(&self, name: String, type_: Node<ScalarType>) -> anyhow::Result<()> {
        let mut types_ctx = self.get_types();
        types_ctx.add_scalar(name, type_);
        Ok(())
    }

    pub fn add_enum(&self, name: String, type_: Node<EnumType>) -> anyhow::Result<()> {
        let mut types_ctx = self.get_types();
        types_ctx.add_enum(name, type_);
        Ok(())
    }

    pub fn add_input(&self, name: String, type_: Node<InputObjectType>) -> anyhow::Result<()> {
        let mut types_ctx = self.get_types();
        types_ctx.add_input(name, type_);
        Ok(())
    }

    pub fn add_interface(&self, name: String, type_: Node<InterfaceType>) -> anyhow::Result<()> {
        let mut types_ctx = self.get_types();
        types_ctx.add_interface(name, type_);
        Ok(())
    }

    pub fn add_union(&self, name: String, type_: Node<UnionType>) -> anyhow::Result<()> {
        let mut types_ctx = self.get_types();
        types_ctx.add_union(name, type_);
        Ok(())
    }

    pub fn is_type_implementing_interface(&self, type_name: &str, interface_name: &str) -> bool {
        let types_ctx = self.types.lock().unwrap();
        if let Some(obj) = types_ctx.objects.get(type_name) {
            self.check_implements_recursive(obj.as_ref(), interface_name, &types_ctx)
        } else if let Some(iface) = types_ctx.interfaces.get(type_name) {
            if iface.name == interface_name {
                true
            } else {
                self.check_implements_recursive(iface.as_ref(), interface_name, &types_ctx)
            }
        } else {
            false
        }
    }

    pub fn is_type_implements_node(&self, type_name: &str) -> bool {
        self.is_type_implementing_interface(type_name, "Node")
    }

    fn check_implements_recursive<I: Implementor>(
        &self,
        implementor: &I,
        target_interface: &str,
        types_ctx: &SchemaTypesCtx,
    ) -> bool {
        if implementor
            .implements_interfaces()
            .contains(target_interface)
        {
            return true;
        }
        for iface_name in implementor.implements_interfaces() {
            if let Some(iface) = types_ctx.interfaces.get(iface_name) {
                if self.check_implements_recursive(iface.as_ref(), target_interface, types_ctx) {
                    return true;
                }
            }
        }
        false
    }
}
pub type SharedSchemaContext = Arc<SchemaContext>;
