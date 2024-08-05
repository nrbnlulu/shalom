use std::rc::Rc;
use crate::schema::context::SchemaContext;

use super::types::GraphQLType;

#[derive(Clone, Debug, Eq, PartialEq, Hash)]
pub struct TypeRef{
    ctx: Rc<SchemaContext>,
    name: String,

}


impl TypeRef{
    pub fn resolve(&self) -> Option<&GraphQLType>{
        return self.ctx.get_type(&self.name);
    }

    pub fn new(ctx: Rc<SchemaContext>, name: String) -> TypeRef{
        TypeRef{
            ctx: ctx,
            name: name
        }
    }
}