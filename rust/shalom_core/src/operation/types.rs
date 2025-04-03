use std::{cell::RefCell, rc::Rc, sync::Arc};

use apollo_compiler::Node;
use serde::{Deserialize, Serialize};

use crate::schema::types::ScalarType;

use super::context::OperationContext;

/// the name of i.e object in a graphql query based on the parent fields.
pub type FullPathName = String;

/// common fields for selections
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SelectionCommon {
    pub selection_name: String,
    pub is_optional: bool,
    pub full_name: FullPathName,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(tag = "kind")]
pub enum Selection {
    Scalar(Rc<ScalarSelection>),
    Object(Rc<ObjectSelection>),
}

impl Selection {
    pub fn self_selection_name(&self) -> String {
        match self {
            Selection::Scalar(node) => node.common.selection_name.clone(),
            Selection::Object(obj) => obj.common.selection_name.clone(),
        }
    }
    pub fn self_full_path_name(&self) -> &FullPathName {
        match self {
            Selection::Scalar(node) => &node.common.full_name,
            Selection::Object(obj) => &obj.common.full_name,
        }
    }
}

#[derive(Debug, Serialize, Deserialize)]
pub struct ScalarSelection {
    #[serde(flatten)]
    common: SelectionCommon,
    pub concrete_type: Node<ScalarType>,
}
pub type SharedScalarSelection = Rc<ScalarSelection>;

impl ScalarSelection {
    pub fn new(common: SelectionCommon, concrete_type: Node<ScalarType>) -> SharedScalarSelection {
        Rc::new(ScalarSelection {
            common,
            concrete_type,
        })
    }
}

#[derive(Debug, Serialize, Deserialize)]
pub struct ObjectSelection {
    #[serde(flatten)]
    common: SelectionCommon,
    selections: RefCell<Vec<Selection>>,
}

pub type SharedObjectSelection = Rc<ObjectSelection>;

impl ObjectSelection {
    pub fn new(common: SelectionCommon) -> SharedObjectSelection {
        let ret = ObjectSelection {
            common,
            selections: RefCell::new(Vec::new()),
        };

        Rc::new(ret)
    }
    pub fn add_selection(&self, selection: Selection) {
        self.selections.borrow_mut().push(selection);
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
        self.context.get_selection(&self.name).clone()
    }
}
