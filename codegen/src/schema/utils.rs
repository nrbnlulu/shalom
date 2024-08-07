use super::{context::SharedSchemaContext, types::GraphQLType};

#[derive(Clone, Debug)]
pub struct TypeRef{
    ctx: SharedSchemaContext,
    name: String,

}

impl PartialEq for TypeRef {
    fn eq(&self, other: &Self) -> bool {
        self.name == other.name
    }
}
impl Eq for TypeRef {}

impl  std::hash::Hash for TypeRef{
    fn hash<H: std::hash::Hasher>(&self, state: &mut H) {
        self.name.hash(state);
    }
}

impl TypeRef{
    pub fn resolve(&self) -> Option<GraphQLType> {
        self.ctx.borrow().get_type(&self.name).cloned()
    }


    pub fn new(ctx: SharedSchemaContext, name: String) -> TypeRef{
        TypeRef{
            ctx: ctx,
            name: name
        }
    }
    
}