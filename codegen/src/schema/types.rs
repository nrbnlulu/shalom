use std::{collections::HashSet, hash::{Hash, Hasher}, rc::Rc};

use apollo_compiler::{ast::Value, collections::HashMap};
use apollo_compiler::schema as appolo_schema;
use super::utils::TypeRef;



struct NamedType{
    name: String,
}

#[derive(Clone, Debug, Eq, PartialEq, Hash)]
/// The definition of a named type, with all information from type extensions folded in.
///
/// The source location is that of the "main" definition.
pub enum GraphQLType {
    Scalar(Box<ScalarType>),
    Object(Box<ObjectType>),
    Interface(Box<InterfaceType>),
    Union(Box<UnionType>),
    Enum(Box<EnumType>),
    InputObject(Box<InputObjectType>),
}


#[derive(Clone, Debug, Eq, PartialEq, Hash)]
pub enum FieldType {
    Named(TypeRef<GraphQLType>),
    NonNullNamed(TypeRef<GraphQLType>),
    List(TypeRef<GraphQLType>),
    NonNullList(TypeRef<GraphQLType>),
}


#[derive(Debug, Clone, PartialEq, Eq, Hash)]
pub struct ScalarType {
    pub description: Option<String>,

    pub name: String,  

}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct ObjectType {
    pub description: Option<String>,

    pub name: String,    
    pub implements_interfaces: HashSet<TypeRef<InterfaceType>>,
    pub fields: HashMap<String, FieldDefinition>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct InterfaceType {
    pub description: Option<String>,

    pub name: String,    
    pub implements_interfaces: HashSet<TypeRef<InterfaceType>>,
    pub fields: HashMap<String, Box<FieldDefinition>>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct UnionType {
    pub description: Option<String>,

    pub name: String,

    /// * Key: name of a member object type
    /// * Value: which union type extension defined this implementation,
    ///   or `None` for the union type definition.
    pub members: HashSet<TypeRef<GraphQLType>>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct EnumType {
    pub description: Option<String>,

    pub name: String,
    pub values: HashMap<String, Box<EnumValueDefinition>>,
}

#[derive(Clone, Debug, Eq, PartialEq, Hash)]
pub struct EnumValueDefinition {
    pub description: Option<String>,
    pub value: String,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct InputObjectType {
    pub description: Option<String>,
    pub name: String,
    pub fields: HashMap<String, Box<InputValueDefinition>>,
}

#[derive(Clone, Debug, Eq, PartialEq, Hash)]
pub struct FieldDefinition {
    pub description: Option<String>,
    pub name: String,
    pub arguments: Vec<Box<InputValueDefinition>>,
    pub ty: FieldType,

}

#[derive(Clone, Debug, Eq, PartialEq, Hash)]
pub struct InputValueDefinition {
    pub description: Option<String>,
    pub name: String,
    pub ty: Box<FieldType>,
    pub default_value: Option<Box<Value>>,
}
