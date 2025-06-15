use std::{
    collections::HashSet,
    hash::{Hash, Hasher},
    sync::Arc,
};

use apollo_compiler::{
    ast::{Type as RawType, Value},
    Node,
};
use serde::ser::{SerializeStruct, Serializer};
use serde::{Deserialize, Serialize};
use std::collections::HashMap;

use crate::schema::context::SharedSchemaContext;

use super::context::SchemaContext;
use std::sync;

type GlobalName = String;

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
    List {
        of_type: Box<GraphQLAny>,
        is_optional: bool,
    },
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
    pub fields: HashMap<String, SchemaObjectFieldDefinition>,
}

impl ObjectType {
    pub fn get_field(&self, name: &str) -> Option<&SchemaObjectFieldDefinition> {
        self.fields.get(name)
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
    pub fields: HashSet<SchemaFieldCommon>,
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

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub enum UnresolvedTypeKind {
    Named { name: String },
    List { of_type: Box<UnresolvedType> },
}

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct UnresolvedType {
    pub is_optional: bool,
    pub kind: UnresolvedTypeKind,
}

impl UnresolvedType {
    pub fn ty_name(&self) -> String {
        match &self.kind {
            UnresolvedTypeKind::Named { name } => name.clone(),
            _ => {
                unimplemented!("lists have not been implemented")
            }
        }
    }

    pub fn new(ty: &RawType) -> Self {
        let is_optional = !ty.is_non_null();
        let unresolved_kind = match ty {
            RawType::Named(name) => UnresolvedTypeKind::Named {
                name: name.to_string(),
            },
            RawType::NonNullNamed(name) => UnresolvedTypeKind::Named {
                name: name.to_string(),
            },
            _ => unimplemented!("lists have not been implemented"),
        };
        Self {
            is_optional,
            kind: unresolved_kind,
        }
    }
    pub fn resolve(&self, ctx: &SchemaContext) -> ResolvedType {
        match &self.kind {
            UnresolvedTypeKind::Named { name } => {
                return ResolvedType {
                    is_optional: self.is_optional,
                    ty: ctx.get_type(name).unwrap(),
                }
            }
            UnresolvedTypeKind::List { of_type: _ } => {
                unimplemented!("lists are not supported yet")
            }
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq, Serialize)]
pub struct ResolvedType {
    pub is_optional: bool,
    pub ty: GraphQLAny,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SchemaFieldCommon {
    pub name: String,
    #[serde(rename = "type")]
    pub unresolved_type: UnresolvedType,
    pub description: Option<String>,
}

impl SchemaFieldCommon {
    pub fn new(name: String, raw_type: &RawType, description: Option<String>) -> Self {
        let unresolved_type = UnresolvedType::new(raw_type);
        SchemaFieldCommon {
            name,
            unresolved_type,
            description,
        }
    }

    pub fn resolve_type(&self, ctx: &SchemaContext) -> ResolvedType {
        self.unresolved_type.resolve(ctx)
    }
}

impl Hash for SchemaFieldCommon {
    fn hash<H: Hasher>(&self, state: &mut H) {
        self.name.hash(state);
    }
}

impl PartialEq for SchemaFieldCommon {
    fn eq(&self, other: &Self) -> bool {
        self.name == other.name
            && self.unresolved_type == other.unresolved_type
            && self.description == other.description
    }
}

impl Eq for SchemaFieldCommon {}

#[derive(Clone, Debug, Eq, PartialEq, Hash, Serialize, Deserialize)]
pub struct SchemaObjectFieldDefinition {
    #[serde(skip_serializing)]
    pub arguments: Vec<InputFieldDefinition>,
    pub field: SchemaFieldCommon,
}

#[derive(Clone, Debug, Eq, PartialEq, Hash, Serialize, Deserialize)]
pub struct InputFieldDefinition {
    pub is_optional: bool,
    pub default_value: Option<Node<Value>>,
    pub common: SchemaFieldCommon,
}
