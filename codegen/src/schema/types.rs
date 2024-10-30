use std::{
    collections::HashSet,
    hash::{Hash, Hasher},
};

use super::{context::SchemaContext, utils::TypeRef};
use apollo_compiler::{ast::Value, collections::HashMap};

struct NamedType {
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

impl GraphQLType {
    pub fn object(&self) -> Option<&ObjectType> {
        match self {
            GraphQLType::Object(obj) => Some(obj),
            _ => None,
        }
    }

    pub fn interface(&self) -> Option<&InterfaceType> {
        match self {
            GraphQLType::Interface(interface) => Some(interface),
            _ => None,
        }
    }

    pub fn union(&self) -> Option<&UnionType> {
        match self {
            GraphQLType::Union(union) => Some(union),
            _ => None,
        }
    }

    pub fn scalar(&self) -> Option<&ScalarType> {
        match self {
            GraphQLType::Scalar(scalar) => Some(scalar),
            _ => None,
        }
    }

    pub fn enum_(&self) -> Option<&EnumType> {
        match self {
            GraphQLType::Enum(enum_) => Some(enum_),
            _ => None,
        }
    }

    pub fn input_object(&self) -> Option<&InputObjectType> {
        match self {
            GraphQLType::InputObject(input_object) => Some(input_object),
            _ => None,
        }
    }    
}

#[derive(Clone, Debug, Eq, PartialEq, Hash)]
pub enum FieldType {
    Named(TypeRef),
    NonNullNamed(TypeRef),
    List(Box<FieldType>),
    NonNullList(Box<FieldType>),
}

impl FieldType {
    pub fn is_nullable(&self) -> bool {
        match self {
            FieldType::Named(_) | FieldType::List(_) => true,
            FieldType::NonNullNamed(_) | FieldType::NonNullList(_) => false,
        }
    }

    pub fn is_list(&self) -> bool {
        match self {
            FieldType::Named(_) | FieldType::NonNullNamed(_) => false,
            FieldType::List(_) | FieldType::NonNullList(_) => true,
        }
    }
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
    pub implements_interfaces: HashSet<Box<TypeRef>>,
    pub fields: HashSet<FieldDefinition>,
}

impl ObjectType {
   pub fn get_field(&self, name: &str) -> Option<&FieldDefinition> {
        self.fields.iter().find(|f| f.name == name)
    }
}

impl Hash for ObjectType {
    fn hash<H: Hasher>(&self, state: &mut H) {
        self.name.hash(state);
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct InterfaceType {
    pub description: Option<String>,

    pub name: String,
    pub implements_interfaces: HashSet<TypeRef>,
    pub fields: HashSet<FieldDefinition>,
}
impl Hash for InterfaceType {
    fn hash<H: Hasher>(&self, state: &mut H) {
        self.name.hash(state);
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct UnionType {
    pub description: Option<String>,

    pub name: String,

    /// * Key: name of a member object type
    /// * Value: which union type extension defined this implementation,
    ///   or `None` for the union type definition.
    pub members: HashSet<TypeRef>,
}
impl Hash for UnionType {
    fn hash<H: Hasher>(&self, state: &mut H) {
        self.name.hash(state);
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct EnumType {
    pub description: Option<String>,

    pub name: String,
    pub values: HashMap<String, Box<EnumValueDefinition>>,
}
impl Hash for EnumType {
    fn hash<H: Hasher>(&self, state: &mut H) {
        self.name.hash(state);
    }
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
impl Hash for InputObjectType {
    fn hash<H: Hasher>(&self, state: &mut H) {
        self.name.hash(state);
    }
}
#[derive(Clone, Debug, Eq, PartialEq, Hash)]
pub struct FieldDefinition {
    pub name: String,
    pub ty: FieldType,
    pub arguments: Vec<InputValueDefinition>,
    pub description: Option<String>,
}

#[derive(Clone, Debug, Eq, PartialEq, Hash)]
pub struct InputValueDefinition {
    pub description: Option<String>,
    pub name: String,
    pub ty: Box<FieldType>,
    pub default_value: Option<Box<Value>>,
}
