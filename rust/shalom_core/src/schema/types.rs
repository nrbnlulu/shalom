use std::{
    collections::HashSet,
    hash::{Hash, Hasher},
};

use super::utils::TypeRef;
use apollo_compiler::{collections::HashMap, Node};
use serde::{Deserialize, Serialize};

#[derive(Clone, Debug, Eq, PartialEq, Hash, Serialize)]
/// The definition of a named type, with all information from type extensions folded in.
///
/// The souNodee location is that of the "main" definition.
pub enum GraphQLAny {
    Scalar(Node<ScalarType>),
    Object(Node<ObjectType>),
    Interface(Node<InterfaceType>),
    Union(Node<UnionType>),
    Enum(Node<EnumType>),
    InputObject(Node<InputObjectType>),
}

impl GraphQLAny {
    pub fn object(&self) -> Option<Node<ObjectType>> {
        match self {
            GraphQLAny::Object(obj) => Some(Node::clone(obj)),
            _ => None,
        }
    }

    pub fn interface(&self) -> Option<Node<InterfaceType>> {
        match self {
            GraphQLAny::Interface(interface) => Some(Node::clone(interface)),
            _ => None,
        }
    }

    pub fn union(&self) -> Option<Node<UnionType>> {
        match self {
            GraphQLAny::Union(union) => Some(Node::clone(union)),
            _ => None,
        }
    }

    pub fn scalar(&self) -> Option<Node<ScalarType>> {
        match self {
            GraphQLAny::Scalar(scalar) => Some(Node::clone(scalar)),
            _ => None,
        }
    }

    pub fn enum_(&self) -> Option<Node<EnumType>> {
        match self {
            GraphQLAny::Enum(enum_) => Some(Node::clone(enum_)),
            _ => None,
        }
    }

    pub fn input_object(&self) -> Option<Node<InputObjectType>> {
        match self {
            GraphQLAny::InputObject(input_object) => Some(Node::clone(input_object)),
            _ => None,
        }
    }
}

#[derive(Clone, Debug, Eq, PartialEq, Hash, Serialize)]
#[serde(tag = "kind")]
pub enum FieldType {
    Named(TypeRef),
    NonNullNamed(TypeRef),
    #[serde(skip_serializing)]
    List(Box<FieldType>),
    #[serde(skip_serializing)]
    NonNullList(Box<FieldType>),
}

impl FieldType {
    pub fn is_nullable(&self) -> bool {
        match self {
            FieldType::Named(_) | FieldType::List(_) => true,
            FieldType::NonNullNamed(_) | FieldType::NonNullList(_) => false,
        }
    }

    pub fn get_list(&self) -> Option<&FieldType> {
        match self {
            FieldType::List(of) | FieldType::NonNullList(of) => Some(of),
            _ => None,
        }
    }

    pub fn get_scalar(&self) -> Option<Node<ScalarType>> {
        match self {
            FieldType::Named(ty) | FieldType::NonNullNamed(ty) => ty.get_scalar(),
            _ => None,
        }
    }

    pub fn get_object(&self) -> Option<Node<ObjectType>> {
        match self {
            FieldType::Named(ty) | FieldType::NonNullNamed(ty) => ty.get_object(),
            _ => None,
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq, Hash, Serialize, Deserialize)]
pub struct ScalarType {
    pub name: String,
    pub description: Option<String>,
}

const DEFAULT_SCALARS: &[&str] = &["String", "Int", "Float", "Boolean", "ID"];

impl ScalarType {
    pub fn is_builtin_scalar(&self) -> bool {
        DEFAULT_SCALARS.contains(&self.name.as_str())
    }
    pub fn is_string(&self) -> bool {
        self.name == "String"
    }
    pub fn is_int(&self) -> bool {
        self.name == "Int"
    }
    pub fn is_float(&self) -> bool {
        self.name == "Float"
    }
    pub fn is_boolean(&self) -> bool {
        self.name == "Boolean"
    }
    pub fn is_id(&self) -> bool {
        self.name == "ID"
    }
}

#[derive(Debug, Clone, PartialEq, Eq, Serialize)]
pub struct ObjectType {
    pub description: Option<String>,
    pub name: String,
    #[serde(skip_serializing)]
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

#[derive(Debug, Clone, PartialEq, Eq, Serialize)]
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

#[derive(Debug, Clone, PartialEq, Eq, Serialize)]
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

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
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

#[derive(Clone, Debug, Eq, PartialEq, Hash, Serialize)]
pub struct EnumValueDefinition {
    pub description: Option<String>,
    pub value: String,
}

#[derive(Debug, Clone, PartialEq, Eq, Serialize)]
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
#[derive(Clone, Debug, Eq, PartialEq, Hash, Serialize)]
pub struct FieldDefinition {
    pub name: String,
    pub ty: FieldType,
    #[serde(skip_serializing)]
    pub arguments: Vec<InputValueDefinition>,
    pub description: Option<String>,
}

#[derive(Clone, Debug, Eq, PartialEq, Hash, Serialize)]
pub struct InputValueDefinition {
    pub description: Option<String>,
    pub name: String,
    pub ty: Box<FieldType>,
    pub default_value: Option<String>,
}
