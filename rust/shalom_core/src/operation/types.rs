use std::{cell::RefCell, sync::Arc};

use apollo_compiler::{validation::Valid, Node};
use serde::Serialize;

use crate::schema::{context::SharedSchemaContext, types::ScalarType, utils::TypeRef};

use super::context::OperationContext;

/// the name of i.e object in a graphql query based on the parent fields.
pub type FullPathName = String;

#[derive(Debug, Clone, Serialize)]
pub enum Selection {
    Scalar(Arc<ScalarSelection>),
    Object(Arc<ObjectSelection>),
}

#[derive(Debug, Serialize)]
pub struct ScalarSelection {
    parent_selection: Option<Selection>,
    concrete_type: Node<ScalarType>,
}

#[derive(Debug, Serialize)]
pub struct ObjectSelection {
    parent_selection: Option<Selection>,
    type_name: String,
    selections: RefCell<Vec<Selection>>,
}
pub type SharedObjectSelection = Arc<ObjectSelection>;

impl ObjectSelection {
    pub fn new(parent_selection: Option<Selection>, type_name: String) -> SharedObjectSelection {
        let ret = Arc::new(ObjectSelection {
            parent_selection,
            type_name,
            selections: RefCell::new(Vec::new()),
        });

        ret
    }
    pub fn add_selection(&self, selection: Selection) {
        self.selections.borrow_mut().push(selection);
    }
}

impl Selection {
    fn parent_selection(&self) -> Option<&Selection> {
        match self {
            Selection::Scalar(node) => node.parent_selection.as_ref(),
            Selection::Object(obj) => obj.parent_selection.as_ref(),
        }
    }

    fn self_name(&self) -> String {
        match self {
            Selection::Scalar(node) => node.concrete_type.name.clone(),
            Selection::Object(obj) => obj.type_name.clone(),
        }
    }

    fn full_path_name(&self) -> FullPathName {
        match self.parent_selection() {
            Some(parent) => format!("{}__{}", parent.full_path_name(), self.self_name()),
            None => self.self_name(),
        }
    }

    pub fn combine_full_name(&self, other: &String) -> FullPathName {
        match self.parent_selection() {
            Some(parent) => format!("{}__{}", parent.full_path_name(), other.clone()),
            None => other.clone(),
        }
    }
}

#[derive(Debug, Clone)]
struct OpTypeRef {
    name: FullPathName,
    context: Arc<OperationContext>,
}

impl PartialEq for OpTypeRef {
    fn eq(&self, other: &OpTypeRef) -> bool {
        self.name == other.name
    }
}

impl Eq for OpTypeRef {}

impl std::hash::Hash for OpTypeRef {
    fn hash<H: std::hash::Hasher>(&self, state: &mut H) {
        self.name.hash(state);
    }
}

impl OpTypeRef {
    pub fn new(name: FullPathName, context: Arc<OperationContext>) -> Self {
        OpTypeRef { name, context }
    }
    pub fn resolve(&self) -> Option<Selection> {
        self.context.get_selection(&self.name)
    }
}
