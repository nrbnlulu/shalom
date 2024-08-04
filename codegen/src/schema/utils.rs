use std::rc::Rc;
use crate::schema::context::SchemaContext;

use super::types::GraphQLType;

pub struct TypeRef{
    ctx: Rc<SchemaContext>,
    name: String,

}

impl TypeRef{
    pub fn resolve(&self) -> Option<&dyn GraphQLType>{
        return self.ctx.get_type(&self.name);
    }
}