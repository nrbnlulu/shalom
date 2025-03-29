

use apollo_compiler::Node;

use super::{
    context::SharedSchemaContext,
    types::{GraphQLType, ObjectType, ScalarType, InterfaceType, EnumType, UnionType, InputObjectType},
};

#[derive(Clone, Debug)]
pub struct TypeRef {
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
    pub fn resolve(&self) -> Option<GraphQLType> {
        self.ctx.borrow().get_type(&self.name).cloned()
    }

    pub fn new(ctx: SharedSchemaContext, name: String) -> TypeRef {
        TypeRef {
            ctx: ctx,
            name: name,
        }
    }
    pub fn get_scalar(&self) -> Option<Node<ScalarType>> {
        self.resolve().map_or(None, |t| t.scalar())
    }
    pub fn get_object(&self) -> Option<Node<ObjectType>> {
        self.resolve().map_or(None, |t| t.object())
    }
    pub fn is_interface(&self) -> Option<Node<InterfaceType>> {
        self.resolve().map_or(None, |t| t.interface())
    }
    pub fn is_union(&self) -> Option<Node<UnionType>> {
        self.resolve().map_or(None, |t| t.union())
    }
    pub fn is_enum(&self) -> Option<Node<EnumType>> {
        self.resolve().map_or(None, |t| t.enum_())
    }
    pub fn is_input_object(&self) -> Option<Node<InputObjectType>> {
        self.resolve().map_or(None, |t| t.input_object())
    }
}
