use std::{
    collections::HashSet,
    hash::{Hash, Hasher},
};

use apollo_compiler::{ast::Value, Node};
use serde::{Deserialize, Serialize};
use std::collections::HashMap;

use super::context::SchemaContext;

pub type GlobalName = String;

#[derive(Clone, Debug, Eq, PartialEq, Hash, Serialize, Deserialize)]
#[serde(tag = "kind")]
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

    pub fn name(&self) -> String {
        match self {
            Self::InputObject(v) => v.name.clone(),
            Self::Object(v) => v.name.clone(),
            Self::Enum(v) => v.name.clone(),
            Self::Scalar(v) => v.name.clone(),
            _ => todo!("Unsupported type"),
        }
    }
}

#[derive(Clone, Debug, Eq, PartialEq, Hash, Serialize, Deserialize)]
#[serde(tag = "kind", content = "value")]
pub enum FieldType {
    Named(GlobalName),
    NonNullNamed(GlobalName),
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

    pub fn get_scalar(&self, ctx: &SchemaContext) -> Option<Node<ScalarType>> {
        match self {
            FieldType::Named(ty) | FieldType::NonNullNamed(ty) => {
                ctx.get_type(ty).and_then(|t| t.scalar())
            }
            _ => None,
        }
    }

    pub fn get_object(&self, ctx: &SchemaContext) -> Option<Node<ObjectType>> {
        match self {
            FieldType::Named(ty) | FieldType::NonNullNamed(ty) => {
                ctx.get_type(ty).and_then(|t| t.object())
            }
            _ => None,
        }
    }

    pub fn name(&self) -> String {
        match self {
            FieldType::Named(ty) => ty.to_string(),
            FieldType::NonNullNamed(ty) => ty.to_string(),
            _ => unimplemented!("lists have not been implemented"),
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

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct ObjectType {
    pub description: Option<String>,
    pub name: String,
    #[serde(skip_serializing)]
    pub implements_interfaces: HashSet<Box<GlobalName>>,
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

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct InterfaceType {
    pub description: Option<String>,

    pub name: String,
    pub implements_interfaces: HashSet<GlobalName>,
    pub fields: HashSet<FieldDefinition>,
}
impl Hash for InterfaceType {
    fn hash<H: Hasher>(&self, state: &mut H) {
        self.name.hash(state);
    }
}

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct UnionType {
    pub description: Option<String>,

    pub name: String,

    /// * Key: name of a member object type
    /// * Value: which union type extension defined this implementation,
    ///   or `None` for the union type definition.
    pub members: HashSet<GlobalName>,
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
    pub members: HashMap<String, EnumValueDefinition>,
}
impl Hash for EnumType {
    fn hash<H: Hasher>(&self, state: &mut H) {
        self.name.hash(state);
    }
}

#[derive(Clone, Debug, Eq, PartialEq, Hash, Serialize, Deserialize)]
pub struct EnumValueDefinition {
    pub description: Option<String>,
    pub value: String,
}

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct InputObjectType {
    pub description: Option<String>,
    pub name: String,
    pub fields: HashMap<String, InputFieldDefinition>,
}
impl Hash for InputObjectType {
    fn hash<H: Hasher>(&self, state: &mut H) {
        self.name.hash(state);
    }
}
#[derive(Clone, Debug, Eq, PartialEq, Hash, Serialize, Deserialize)]
pub struct FieldDefinition {
    pub name: String,
    pub ty: FieldType,
    #[serde(skip_serializing)]
    pub arguments: Vec<InputFieldDefinition>,
    pub description: Option<String>,
}

#[derive(Clone, Debug, Eq, PartialEq, Hash, Serialize, Deserialize)]
pub struct InputFieldDefinition {
    pub name: String,
    pub description: Option<String>,
    pub ty: FieldType,
    pub is_optional: bool,
    pub default_value: Option<Node<Value>>,
}

impl InputFieldDefinition {
    pub fn resolve_type(&self, schema_ctx: &SchemaContext) -> GraphQLAny {
        schema_ctx.get_type(&self.ty.name()).unwrap()
    }
}
