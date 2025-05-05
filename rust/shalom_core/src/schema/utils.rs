use apollo_compiler::Node;

use super::{
    context::SchemaContext,
    types::{
        EnumType, GraphQLAny, InputObjectType, InterfaceType, ObjectType, ScalarType, UnionType,
    },
};
use serde::{Deserialize, Serialize};

#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct TypeRef {
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
    pub fn resolve(&self, ctx: &SchemaContext) -> Option<GraphQLAny> {
        ctx.get_type(&self.name).clone()
    }

    pub fn new(name: String) -> TypeRef {
        TypeRef { name }
    }

    pub fn get_scalar(&self, ctx: &SchemaContext) -> Option<Node<ScalarType>> {
        self.resolve(ctx).and_then(|t| t.scalar())
    }
    pub fn get_object(&self, ctx: &SchemaContext) -> Option<Node<ObjectType>> {
        self.resolve(ctx).and_then(|t| t.object())
    }
    pub fn is_interface(&self, ctx: &SchemaContext) -> Option<Node<InterfaceType>> {
        self.resolve(ctx).and_then(|t| t.interface())
    }
    pub fn is_union(&self, ctx: &SchemaContext) -> Option<Node<UnionType>> {
        self.resolve(ctx).and_then(|t| t.union())
    }
    pub fn is_enum(&self, ctx: &SchemaContext) -> Option<Node<EnumType>> {
        self.resolve(ctx).and_then(|t| t.enum_())
    }
    pub fn is_input_object(&self, ctx: &SchemaContext) -> Option<Node<InputObjectType>> {
        self.resolve(ctx).and_then(|t| t.input_object())
    }
}
