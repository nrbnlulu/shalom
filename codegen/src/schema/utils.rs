use std::rc::Rc;
use crate::schema::context::SchemaContext;

use super::types::GraphQLType;

pub struct TypeRef<T>{
    ctx: Rc<SchemaContext>,
    name: String,

}

impl <T> TypeRef<T>{
    pub fn resolve(&self) -> Option<&T>{
        return self.ctx.get_type(&self.name);
    }
}