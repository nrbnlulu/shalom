use std::rc::Rc;
use std::{
    collections::HashSet,
    hash::{Hash, Hasher},
};

use super::{context::SchemaContext, utils::TypeRef};
use apollo_compiler::{
    ast::{Field, Value},
    collections::HashMap,
};

struct NamedType {
    name: String,
}

#[derive(Clone, Debug, Eq, PartialEq, Hash)]
/// The definition of a named type, with all information from type extensions folded in.
///
/// The source location is that of the "main" definition.
pub enum GraphQLType {
    Scalar(Rc<ScalarType>),
    Object(Rc<ObjectType>),
    Interface(Rc<InterfaceType>),
    Union(Rc<UnionType>),
    Enum(Rc<EnumType>),
    InputObject(Rc<InputObjectType>),
}

impl GraphQLType {
    pub fn object(&self) -> Option<Rc<ObjectType>> {
        match self {
            GraphQLType::Object(obj) => Some(Rc::clone(obj)),
            _ => None,
        }
    }

    pub fn interface(&self) -> Option<Rc<InterfaceType>> {
        match self {
            GraphQLType::Interface(interface) => Some(Rc::clone(interface)),
            _ => None,
        }
    }

    pub fn union(&self) -> Option<Rc<UnionType>> {
        match self {
            GraphQLType::Union(union) => Some(Rc::clone(union)),
            _ => None,
        }
    }

    pub fn scalar(&self) -> Option<Rc<ScalarType>> {
        match self {
            GraphQLType::Scalar(scalar) => Some(Rc::clone(scalar)),
            _ => None,
        }
    }

    pub fn enum_(&self) -> Option<Rc<EnumType>> {
        match self {
            GraphQLType::Enum(enum_) => Some(Rc::clone(enum_)),
            _ => None,
        }
    }

    pub fn input_object(&self) -> Option<Rc<InputObjectType>> {
        match self {
            GraphQLType::InputObject(input_object) => Some(Rc::clone(input_object)),
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

    pub fn get_list(&self) -> Option<&FieldType> {
        match self {
            FieldType::List(of) | FieldType::NonNullList(of) => Some(of),
            _ => None,
        }
    }

    pub fn get_scalar(&self) -> Option<Rc<ScalarType>> {
        match self {
            FieldType::Named(ty) | FieldType::NonNullNamed(ty) => ty.get_scalar(),
            _ => None,
        }
    }

    pub fn get_object(&self) -> Option<Rc<ObjectType>> {
        match self {
            FieldType::Named(ty) | FieldType::NonNullNamed(ty) => ty.get_object(),
            _ => None,
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq, Hash)]
pub struct ScalarType {
    pub name: String,
    pub description: Option<String>,
}

const DEFAULT_SCALARS: &[&str] = &["String", "Int", "Float", "Boolean", "ID"];

impl ScalarType {
    pub fn is_default_scalar(&self) -> bool {
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
