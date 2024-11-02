

use super::{
    context::SharedSchemaContext,
    types::{GraphQLType, ObjectType, ScalarType, InterfaceType, EnumType, UnionType, InputObjectType},
};
use std::rc::Rc;

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
    pub fn get_scalar(&self) -> Option<Rc<ScalarType>> {
        self.resolve().map_or(None, |t| t.scalar())
    }
    pub fn get_object(&self) -> Option<Rc<ObjectType>> {
        self.resolve().map_or(None, |t| t.object())
    }
    pub fn is_interface(&self) -> Option<Rc<InterfaceType>> {
        self.resolve().map_or(None, |t| t.interface())
    }
    pub fn is_union(&self) -> Option<Rc<UnionType>> {
        self.resolve().map_or(None, |t| t.union())
    }
    pub fn is_enum(&self) -> Option<Rc<EnumType>> {
        self.resolve().map_or(None, |t| t.enum_())
    }
    pub fn is_input_object(&self) -> Option<Rc<InputObjectType>> {
        self.resolve().map_or(None, |t| t.input_object())
    }
}
