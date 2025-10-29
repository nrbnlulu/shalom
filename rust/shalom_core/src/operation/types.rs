use std::{
    cell::{Cell, RefCell},
    collections::{HashMap, HashSet},
    rc::Rc,
};

use indexmap::IndexMap;

use apollo_compiler::Node;
use serde::{Deserialize, Serialize};

use crate::{
    context::ShalomGlobalContext,
    operation::{context::OperationVariable, fragments::{InlineFragment, SharedFragmentContext}},
    schema::types::{EnumType, InterfaceType, ScalarType, UnionType},
};

/// the name of i.e object in a graphql query based on the parent fields.
pub type FullPathName = String;

/// Helper function to get all selections including fragments, with deduplication by field name.
///
/// This function takes direct selections and recursively expands all fragment selections,
/// ensuring that fields with the same name are not duplicated. This is particularly important
/// when fragments on interfaces and their implementations share field names.
///
/// # Arguments
/// * `direct_selections` - The direct selections from an object or fragment
/// * `fragment_names` - Names of fragments to expand
/// * `ctx` - The global context containing fragment definitions
///
/// # Returns
/// A vector of distinct selections (by field name), preserving the order of first occurrence
pub fn get_selections_with_fragments_distinct(
    direct_selections: Vec<Selection>,
    fragment_names: Vec<FragName>,
    ctx: &ShalomGlobalContext,
) -> Vec<Selection> {
    let mut selections = direct_selections;
    let mut seen_names: HashSet<String> = HashSet::new();

    // Track names from direct selections
    for selection in &selections {
        seen_names.insert(selection.self_selection_name().clone());
    }

    // Process fragments
    let mut fragments = fragment_names;
    while !fragments.is_empty() {
        let fragment = ctx.get_fragment_strict(&fragments.pop().unwrap());
        let fragment_selections = fragment.get_flat_selections(ctx);

        // Only add fragment selections if we haven't seen their name before
        for fragment_selection in fragment_selections {
            let name = fragment_selection.self_selection_name().clone();
            if !seen_names.contains(&name) {
                seen_names.insert(name);
                selections.push(fragment_selection);
            }
        }
    }

    selections
}

#[derive(Debug, Serialize, Deserialize)]
#[serde(tag = "name")]
pub enum OperationType {
    Query,
    Mutation,
    Subscription,
}

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct SelectionCommon {
    pub name: String,
    pub description: Option<String>,
}

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
#[serde(tag = "kind")]
pub enum ArgumentValue {
    // usage of operation variable
    VariableUse(OperationVariable),
    InlineValue {
        #[serde(flatten)]
        value: InlineValueArg,
    },
}

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
#[serde(tag = "value_kind")]
pub enum InlineValueArg {
    Object {
        fields: IndexMap<String, Box<ArgumentValue>>,
        raw: String,
    },
    Scalar {
        value: String,
    },
    List {
        items: Vec<ArgumentValue>,
        raw: String,
    },
    Enum {
        value: String,
    },
}

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct FieldArgument {
    pub name: String,
    pub value: ArgumentValue,
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

    pub fn as_interface_selection(&self) -> Option<&SharedInterfaceSelection> {
        match &self.kind {
            SelectionKind::Interface(selection) => Some(selection),
            _ => None,
        }
    }

    pub fn as_union_selection(&self) -> Option<&SharedUnionSelection> {
        match &self.kind {
            SelectionKind::Union(selection) => Some(selection),
            _ => None,
        }
    }

    pub fn as_object_selection(&self) -> Option<&SharedObjectSelection> {
        match &self.kind {
            SelectionKind::Object(selection) => Some(selection),
            _ => None,
        }
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
    Union(Rc<UnionSelection>),
    Interface(Rc<InterfaceSelection>),
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
type FragName = String;

#[derive(Debug, Serialize, Deserialize)]
pub struct ObjectSelection {
    pub full_name: String,
    pub concrete_typename: String,
    pub is_optional: bool,
    pub selections: RefCell<Vec<Selection>>,
    pub used_fragments: RefCell<Vec<FragName>>,
    pub used_inline_frags: RefCell<Vec<FragName>>,
    pub parent_multitype_fullname: Option<String>,
}

pub type SharedObjectSelection = Rc<ObjectSelection>;

impl ObjectSelection {
    pub fn new(
        is_optional: bool,
        full_name: String,
        concrete_typename: String,
        parent_multitype_fullname: Option<String>,
    ) -> SharedObjectSelection {
        let ret = ObjectSelection {
            full_name,
            concrete_typename,
            is_optional,
            selections: RefCell::new(Vec::new()),
            used_fragments: RefCell::new(Vec::new()),
            used_inline_frags: RefCell::new(Vec::new()),
            parent_multitype_fullname,
        };

        Rc::new(ret)
    }
    pub fn add_selection(&self, selection: Selection) {
        let selection_name = selection.self_selection_name();

        // Check if a selection with this name already exists (for deduplication)
        let already_exists = self
            .selections
            .borrow()
            .iter()
            .any(|s| s.self_selection_name() == selection_name);

        if already_exists {
            // Skip duplicate selections to avoid field conflicts from fragment expansion
            return;
        }
        self.selections.borrow_mut().push(selection);
    }

    pub fn add_used_fragment(&self, name: FragName) {
        self.used_fragments.borrow_mut().push(name);
    }
    pub fn get_used_fragments(&self) -> Vec<FragName> {
        self.used_fragments.borrow().clone()
    }

    /// return all selections for an object including the fragment selections
    /// for the current selection object, with duplicates removed by field name
    pub fn get_all_selections_distinct(&self, ctx: &ShalomGlobalContext) -> Vec<Selection> {
        get_selections_with_fragments_distinct(
            self.selections.borrow().clone(),
            self.used_fragments.borrow().clone(),
            ctx,
        )
    }

    pub fn get_id_selection(&self) -> Option<Selection> {
        self.selections
            .borrow()
            .iter()
            .find(|s| s.self_selection_name() == "id")
            .cloned()
    }

    /// Get the id selection, including those from used fragments
    pub fn get_id_selection_with_fragments(&self, ctx: &ShalomGlobalContext) -> Option<Selection> {
        // First check in direct selections
        if let Some(id_sel) = self.get_id_selection() {
            return Some(id_sel);
        }

        // If not found, check in fragment selections
        let all_selections = self.get_all_selections_distinct(ctx);
        all_selections
            .iter()
            .find(|s| s.self_selection_name() == "id")
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

/// Common fields and behavior shared between Union and Interface selections
#[derive(Debug, Serialize, Deserialize)]
pub struct MultiTypeSelectionCommon {
    pub full_name: String,
    /// name of the union or uniterface
    pub schema_typename: String,
    pub is_optional: bool,
    /// Selections that apply to all types (e.g., __typename)
    pub shared_selections: RefCell<Vec<Selection>>,
    /// Inline fragment selections grouped by type condition
    pub inline_fragments: RefCell<HashMap<String, SharedObjectSelection>>,
    /// Whether to generate a fallback class for uncovered types
    pub needs_fallback: Cell<bool>,
    /// Fragments spreads at the union/interface,
    pub fragment_spreads: RefCell<HashMap<String, Vec<String>>>
}

impl MultiTypeSelectionCommon {
    pub fn new(full_name: String, schema_typename: String, is_optional: bool) -> Self {
        MultiTypeSelectionCommon {
            full_name,
            schema_typename,
            is_optional,
            shared_selections: RefCell::new(Vec::new()),
            inline_fragments: RefCell::new(HashMap::new()),
            needs_fallback: Cell::new(false),
            fragment_spreads: RefCell::new(HashMap::new()),
        }
    }

    pub fn add_shared_selection(&self, selection: Selection) {
        // Check if a selection with this name already exists to avoid duplicates
        let selection_name = selection.self_selection_name();
        let already_exists = self
            .shared_selections
            .borrow()
            .iter()
            .any(|s| s.self_selection_name() == selection_name);

        if !already_exists {
            self.shared_selections.borrow_mut().push(selection);
        }
    }

    pub fn add_inline_fragment(
        &self,
        type_condition: String,
        object_selection: SharedObjectSelection,
    ) {
        self.inline_fragments
            .borrow_mut()
            .insert(type_condition, object_selection);
    }

    pub fn add_fragment_spread(&self, fragment_name: String) {
        self.fragment_spreads.borrow_mut().entry(fragment_name.clone()).or_insert_with(Vec::new).push(fragment_name);
    }

    /// Check if __typename is selected either at the top level or in all inline fragments
    pub fn has_typename_selection(&self) -> bool {
        // Check shared selections for __typename
        let has_shared_typename = self
            .shared_selections
            .borrow()
            .iter()
            .any(|s| s.self_selection_name() == "__typename");

        if has_shared_typename {
            return true;
        }

        // Check if all inline fragments have __typename
        let fragments = self.inline_fragments.borrow();
        if fragments.is_empty() {
            return false;
        }

        fragments.values().all(|obj| {
            obj.selections
                .borrow()
                .iter()
                .any(|s| s.self_selection_name() == "__typename")
        })
    }
}
pub trait MultiTypeSelection {
    /// Get all possible types for this multi-type selection (union members or interface implementations)
    fn get_all_members(&self, ctx: &ShalomGlobalContext) -> Vec<String>;

    /// Check if we need a fallback class by comparing all possible types with covered inline fragments
    fn should_generate_fallback(&self, ctx: &ShalomGlobalContext) -> bool {
        let all_members_set: std::collections::HashSet<String> =
            self.get_all_members(ctx).into_iter().collect();
        let covered_types: std::collections::HashSet<String> = self
            .common()
            .inline_fragments
            .borrow()
            .keys()
            .cloned()
            .collect();

        // If not all multitype members are covered, we need a fallback
        !all_members_set.is_subset(&covered_types)
    }

    /// Get the common fields shared across all types
    fn common(&self) -> &MultiTypeSelectionCommon;
}

#[derive(Debug, Serialize, Deserialize)]
pub struct UnionSelection {
    #[serde(flatten)]
    pub common: MultiTypeSelectionCommon,
    pub union_type: Node<UnionType>,
}

pub type SharedUnionSelection = Rc<UnionSelection>;

impl UnionSelection {
    pub fn new(
        full_name: String,
        schema_typename: String,
        union_type: Node<UnionType>,
        is_optional: bool,
    ) -> SharedUnionSelection {
        Rc::new(UnionSelection {
            common: MultiTypeSelectionCommon::new(full_name, schema_typename, is_optional),
            union_type,
        })
    }
}

impl MultiTypeSelection for UnionSelection {
    fn get_all_members(&self, _ctx: &ShalomGlobalContext) -> Vec<String> {
        self.union_type.members.iter().cloned().collect()
    }

    fn common(&self) -> &MultiTypeSelectionCommon {
        &self.common
    }
}

#[derive(Debug, Serialize, Deserialize)]
pub struct InterfaceSelection {
    #[serde(flatten)]
    pub common: MultiTypeSelectionCommon,
    pub interface_type: Node<InterfaceType>,
}

pub type SharedInterfaceSelection = Rc<InterfaceSelection>;

impl InterfaceSelection {
    pub fn new(
        full_name: String,
        schema_typename: String,
        interface_type: Node<InterfaceType>,
        is_optional: bool,
    ) -> SharedInterfaceSelection {
        Rc::new(InterfaceSelection {
            common: MultiTypeSelectionCommon::new(full_name, schema_typename, is_optional),
            interface_type,
        })
    }
}

impl MultiTypeSelection for InterfaceSelection {
    fn get_all_members(&self, ctx: &ShalomGlobalContext) -> Vec<String> {
        let types = ctx.schema_ctx.schema.types.iter();
        let interface_name = &self.interface_type.name;

        types
            .filter_map(|(name, _type_def)| {
                if ctx
                    .schema_ctx
                    .is_type_implementing_interface(name.as_str(), interface_name.as_str())
                {
                    Some(name.to_string())
                } else {
                    None
                }
            })
            .collect()
    }

    fn common(&self) -> &MultiTypeSelectionCommon {
        &self.common
    }
}

pub fn dart_type_for_scalar(scalar_name: &str) -> String {
    match scalar_name {
        "String" | "ID" => "String".to_string(),
        "Int" => "int".to_string(),
        "Float" => "double".to_string(),
        "Boolean" => "bool".to_string(),
        _ => "dynamic".to_string(),
    }
}
