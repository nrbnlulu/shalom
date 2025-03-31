use std::sync::Arc;

use apollo_compiler::Node;

use crate::schema::{types::ScalarType, utils::TypeRef};

#[derive(Debug)]
pub enum Selection {
    Scalar(Node<ScalarType>),
    Object(Arc<ObjectSelection>),
}

#[derive(Debug)]
pub struct ObjectSelection {
    parent_selection: Option<Selection>,
    type_name: String,
    selections: Vec<Selection>,
}

#[derive(Debug)]
pub struct OperationDefinition {
    name: String,
    selections: Vec<Selection>,
}
