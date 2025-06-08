use std::{
    collections::HashSet,
    hash::{Hash, Hasher},
    sync::Arc,
};

use apollo_compiler::{ast::Value, Node};
use serde::ser::{SerializeStruct, Serializer};
use serde::{Deserialize, Serialize};
use std::collections::HashMap;

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
    pub fields: HashSet<SchemaObjectField>,
}

impl ObjectType {
    pub fn get_field(&self, name: &str) -> Option<&SchemaObjectField> {
        self.fields.iter().find(|f| f.field.name == name)
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

#[derive(Clone, Debug, Deserialize)]
pub struct FieldDefinition {
    pub name: String,
    pub raw_type: Node<apollo_compiler::schema::Type>,
    pub description: Option<String>,
    #[serde(skip)]
    ctx: sync::Weak<SchemaContext>,
}

impl FieldDefinition {
    pub fn new(
        context: Arc<SchemaContext>,
        name: String,
        raw_type: Node<apollo_compiler::schema::Type>,
        description: Option<String>,
    ) -> Self {
        FieldDefinition {
            name,
            raw_type,
            description,
            ctx: Arc::downgrade(&context),
        }
    }
}

impl FieldDefinition {
    pub fn resolve_type(&self, ctx: &SchemaContext) -> GraphQLAny {
        let gql_ty = ctx
            .get_type(self.raw_type.inner_named_type().as_str())
            .unwrap();
        gql_ty
    }
}

impl Serialize for FieldDefinition {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        let mut s = serializer.serialize_struct("FieldDefinition", 3)?;
        s.serialize_field("name", &self.name)?;
        let gql_ty = self
            .ctx
            .upgrade()
            .unwrap()
            .get_type(self.raw_type.inner_named_type().as_str())
            .unwrap();
        // avoids recursion
        if let GraphQLAny::InputObject(input) = gql_ty {
            let mut input = input.clone();
            input.make_mut().fields = HashMap::new();
            let gql_ty = GraphQLAny::InputObject(input);
            s.serialize_field("ty", &gql_ty)?;
        } else {
            s.serialize_field("ty", &gql_ty)?;
        }
        s.serialize_field("raw_type", &self.raw_type)?;
        s.serialize_field("description", &self.description)?;
        s.end()
    }
}

impl Hash for FieldDefinition {
    fn hash<H: Hasher>(&self, state: &mut H) {
        self.name.hash(state);
    }
}

impl PartialEq for FieldDefinition {
    fn eq(&self, other: &Self) -> bool {
        self.name == other.name
            && self.raw_type == other.raw_type
            && self.description == other.description
    }
}

impl Eq for FieldDefinition {}

#[derive(Clone, Debug, Eq, PartialEq, Hash, Serialize, Deserialize)]
pub struct SchemaObjectField {
    #[serde(skip_serializing)]
    pub arguments: Vec<InputFieldDefinition>,
    #[serde(flatten)]
    pub field: FieldDefinition,
}

#[derive(Clone, Debug, Eq, PartialEq, Hash, Serialize, Deserialize)]
pub struct InputFieldDefinition {
    pub is_optional: bool,
    pub default_value: Option<Node<Value>>,
    #[serde(flatten)]
    pub field: FieldDefinition,
}
