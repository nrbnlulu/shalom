use std::{cell::RefCell, rc::Rc};

use apollo_compiler::Node;
use serde::{Deserialize, Serialize};

use crate::schema::types::{EnumType, ScalarType};

/// the name of i.e object in a graphql query based on the parent fields.
pub type FullPathName = String;

#[derive(Debug, Serialize, Deserialize)]
#[serde(tag = "name")]
pub enum OperationType {
    Query,
    Mutation,
    Subscription,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SelectionCommon {
    pub name: String,
    pub description: Option<String>,
}
#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum ArgumentValue {
    // usage of operation variable
    VariableUse { name: String },
    InlineValue { value: String },
}
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct FieldArgument {
    pub name: String,
    pub value: ArgumentValue,
    pub is_maybe: bool,
    pub default_value: Option<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Selection {
    #[serde(flatten)]
    pub selection_common: SelectionCommon,
    #[serde(flatten)]
    pub kind: SelectionKind,
    pub arguments: Vec<FieldArgument>,
}

impl Selection {
    pub fn new(
        selection_common: SelectionCommon,
        kind: SelectionKind,
        arguments: Vec<FieldArgument>,
    ) -> Self {
        Selection {
            selection_common,
            kind,
            arguments,
        }
    }

    pub fn self_selection_name(&self) -> &String {
        &self.selection_common.name
    }
}
pub type SharedSelection = Rc<Selection>;

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(tag = "kind")]
pub enum SelectionKind {
    Scalar(Rc<ScalarSelection>),
    Object(Rc<ObjectSelection>),
    Enum(Rc<EnumSelection>),
    List(Rc<ListSelection>),
}
impl SelectionKind {
    pub fn new_list(is_optional: bool, of_kind: SelectionKind) -> Self {
        SelectionKind::List(Rc::new(ListSelection {
            is_optional,
            of_kind,
        }))
    }
}

#[derive(Debug, Serialize, Deserialize)]
pub struct ScalarSelection {
    pub is_optional: bool,
    pub concrete_type: Node<ScalarType>,
    pub is_custom_scalar: bool,
}
pub type SharedScalarSelection = Rc<ScalarSelection>;

impl ScalarSelection {
    pub fn new(
        is_optional: bool,
        concrete_type: Node<ScalarType>,
        is_custom_scalar: bool,
    ) -> SharedScalarSelection {
        Rc::new(ScalarSelection {
            is_optional,
            concrete_type,
            is_custom_scalar,
        })
    }
}

#[derive(Debug, Serialize, Deserialize)]
pub struct ObjectSelection {
    pub full_name: String,
    pub concrete_typename: String,
    pub is_optional: bool,
    pub selections: RefCell<Vec<Selection>>,
}

pub type SharedObjectSelection = Rc<ObjectSelection>;

impl ObjectSelection {
    pub fn new(
        is_optional: bool,
        full_name: String,
        concrete_typename: String,
    ) -> SharedObjectSelection {
        let ret = ObjectSelection {
            full_name,
            concrete_typename,
            is_optional,
            selections: RefCell::new(Vec::new()),
        };

        Rc::new(ret)
    }
    pub fn add_selection(&self, selection: Selection) {
        self.selections.borrow_mut().push(selection);
    }

    pub fn get_id_selection(&self) -> Option<Selection> {
        self.selections
            .borrow()
            .iter()
            .find(|s| s.self_selection_name().contains("id"))
            .cloned()
    }
}

#[derive(Debug, Serialize, Deserialize)]
pub struct EnumSelection {
    pub is_optional: bool,
    pub concrete_type: Node<EnumType>,
}

pub type SharedEnumSelection = Rc<EnumSelection>;

impl EnumSelection {
    pub fn new(is_optional: bool, concrete_type: Node<EnumType>) -> SharedEnumSelection {
        Rc::new(EnumSelection {
            is_optional,
            concrete_type,
        })
    }
}

#[derive(Debug, Serialize, Deserialize)]
pub struct ListSelection {
    pub is_optional: bool,
    pub of_kind: SelectionKind,
}

pub type SharedListSelection = Rc<ListSelection>;

pub fn dart_type_for_scalar(scalar_name: &str) -> String {
    match scalar_name {
        "String" | "ID" => "String".to_string(),
        "Int" => "int".to_string(),
        "Float" => "double".to_string(),
        "Boolean" => "bool".to_string(),
        _ => "dynamic".to_string(),
    }
}
