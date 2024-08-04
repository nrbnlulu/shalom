use std::{hash::{Hash, Hasher}, rc::Rc};

use super::utils::TypeRef;



pub trait GraphQLType{
    fn name(&self) -> &String;
}

pub struct FieldDef{
    name: String,
    type_: TypeRef,
} 

pub struct ObjectTypeDef {
    name: String,
    fields: Vec<FieldDef>,
}
 impl GraphQLType for ObjectTypeDef{
     fn name(&self) -> &String{
         &self.name
     }
 }

pub struct ScalarTypeDef{
    name: String,
}
impl GraphQLType for ScalarTypeDef{
    fn name(&self) -> &String{
        &self.name
    }
}

pub struct EnumTypeDef{
    name: String,
    values: Vec<String>,
}
impl GraphQLType for EnumTypeDef{
    fn name(&self) -> &String{
        &self.name
    }
}

pub struct InputObjectTypeDef{
    name: String,
    fields: Vec<FieldDef>,
}
impl GraphQLType for InputObjectTypeDef{
    fn name(&self) -> &String{
        &self.name
    }
}
