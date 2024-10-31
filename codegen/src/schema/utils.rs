

use super::{
    context::SharedSchemaContext,
    types::{GraphQLType, ObjectType, ScalarType, InterfaceType, EnumType, UnionType, InputObjectType},
};

#[derive(Clone, Debug)]
pub struct TypeRef {
    ctx: SharedSchemaContext,
    name: String,
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
    pub fn get_scalar(&self) -> Option<ScalarType> {
        self.resolve().map_or(None, |t| t.scalar().cloned())
    }
    pub fn get_object(&self) -> Option<ObjectType> {
        self.resolve().map_or(None, |t| t.object().cloned())
    }
    pub fn is_interface(&self) -> Option<InterfaceType> {
        self.resolve().map_or(None, |t| t.interface().cloned())
    }
    pub fn is_union(&self) -> Option<UnionType> {
        self.resolve().map_or(None, |t| t.union().cloned())
    }
    pub fn is_enum(&self) -> Option<EnumType> {
        self.resolve().map_or(None, |t| t.enum_().cloned())
    }
    pub fn is_input_object(&self) -> Option<InputObjectType> {
        self.resolve().map_or(None, |t| t.input_object().cloned())
    }
}
