use apollo_compiler::Node;

use super::{
    context::SharedSchemaContext,
    types::{
        EnumType, GraphQLAny, InputObjectType, InterfaceType, ObjectType, ScalarType, UnionType,
    },
};
use serde::Serialize;

#[derive(Clone, Debug, Serialize)]
pub struct TypeRef {
    #[serde(skip_serializing)]
    #[allow(unused)]
    ctx: SharedSchemaContext,
    pub name: String,
}

impl PartialEq for TypeRef {
    fn eq(&self, other: &Self) -> bool {
        self.name == other.name
    }
}
impl Eq for TypeRef {}

impl std::hash::Hash for TypeRef {
    fn hash<H: std::hash::Hasher>(&self, state: &mut H) {
        self.name.hash(state);
    }
}

impl TypeRef {
    pub fn resolve(&self) -> Option<GraphQLAny> {
        self.ctx.get_type(&self.name).clone()
    }

    pub fn new(ctx: SharedSchemaContext, name: String) -> TypeRef {
        TypeRef { ctx, name }
    }
    pub fn get_scalar(&self) -> Option<Node<ScalarType>> {
        self.resolve().and_then(|t| t.scalar())
    }
    pub fn get_object(&self) -> Option<Node<ObjectType>> {
        self.resolve().and_then(|t| t.object())
    }
    pub fn is_interface(&self) -> Option<Node<InterfaceType>> {
        self.resolve().and_then(|t| t.interface())
    }
    pub fn is_union(&self) -> Option<Node<UnionType>> {
        self.resolve().and_then(|t| t.union())
    }
    pub fn is_enum(&self) -> Option<Node<EnumType>> {
        self.resolve().and_then(|t| t.enum_())
    }
    pub fn is_input_object(&self) -> Option<Node<InputObjectType>> {
        self.resolve().and_then(|t| t.input_object())
    }
}
