use std::{
    cell::Cell,
    collections::{HashMap, HashSet},
    hash::Hasher,
    rc::Rc,
    sync::Arc,
};

use indexmap::IndexMap;

use apollo_compiler::Node;
use serde::{Deserialize, Serialize};

use crate::{
    context::ShalomGlobalContext,
    operation::{
        context::OperationVariable,
        fragments::{FragName, InlineFragment},
    },
    schema::types::{EnumType, GraphQLAny, InterfaceType, ScalarType, UnionType},
};

/// the name of i.e object in a graphql query based on the parent fields.
pub type FullPathName = String;

#[derive(Debug, Serialize, Deserialize)]
#[serde(tag = "name")]
pub enum OperationType {
    Query,
    Mutation,
    Subscription,
}

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct FieldSelectionCommon {
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
pub struct FieldSelection {
    #[serde(flatten)]
    pub selection_common: FieldSelectionCommon,
    #[serde(flatten)]
    pub kind: SelectionKind,
    pub arguments: Vec<FieldArgument>,
}

impl std::hash::Hash for FieldSelection {
    fn hash<H: Hasher>(&self, state: &mut H) {
        self.self_selection_name().hash(state);
    }
}
impl std::cmp::PartialEq for FieldSelection {
    fn eq(&self, other: &Self) -> bool {
        self.self_selection_name() == other.self_selection_name()
    }
}

impl std::cmp::Eq for FieldSelection {}

impl FieldSelection {
    pub fn new(
        selection_common: FieldSelectionCommon,
        kind: SelectionKind,
        arguments: Vec<FieldArgument>,
    ) -> Self {
        FieldSelection {
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

pub type SharedSelection = Rc<FieldSelection>;

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

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ObjectLikeCommon {
    /// name that we generate in order to normalize types across the selection tree.
    /// the is usually would be `{parent}_{schema_typename}`
    pub path_name: String,
    pub schema_typename: String,
    /// selections that apply to all types in this object-like
    /// in interfaces / union this can be thought as shared selections
    pub selections: HashSet<FieldSelection>,
    /// fragment spreads
    pub used_fragments: HashSet<FragName>,
    /// inline fragments used in this object-like
    pub used_inline_frags: HashMap<String, InlineFragment>,
    /// type conditioned selections - stores selections for specific types
    pub type_cond_selections: HashMap<String, ObjectLikeCommon>,
}

impl ObjectLikeCommon {
    pub fn new(path_name: String, schema_typename: String) -> Self {
        ObjectLikeCommon {
            path_name,
            schema_typename,
            used_fragments: HashSet::new(),
            used_inline_frags: HashMap::new(),
            type_cond_selections: HashMap::new(),
            selections: HashSet::new(),
        }
    }
    pub fn get_selection(&self, name: &str) -> Option<&FieldSelection> {
        self.selections
            .iter()
            .find(|s| s.self_selection_name() == name)
    }
    pub fn merge(&mut self, other: ObjectLikeCommon) {
        if self.schema_typename == other.schema_typename {
            // the same type just extend selections (HashSet handles deduplication)
            self.used_fragments.extend(other.used_fragments);
            self.used_inline_frags.extend(other.used_inline_frags);
            self.selections.extend(other.selections);
        } else {
            // different type - store as type condition, merge if already exists
            if let Some(existing) = self.type_cond_selections.get_mut(&other.schema_typename) {
                existing.merge(other);
            } else {
                self.type_cond_selections
                    .insert(other.schema_typename.clone(), other);
            }
        }
    }

    pub fn add_selection(&mut self, selection: FieldSelection) {
        // HashSet automatically handles deduplication based on Hash/Eq implementation
        self.selections.insert(selection);
    }
    /// finds a field with a name
    pub fn contains_field(&self, name: &str) -> bool {
        self.selections
            .iter()
            .any(|s| s.self_selection_name() == name)
    }

    /// Check if __typename is selected either at the top level or in all inline fragments
    pub fn has_typename_selection(&self, ctx: &ShalomGlobalContext) -> bool {
        // Check shared selections for __typename
        let has_shared_typename = self.contains_field("__typename");

        if has_shared_typename {
            return true;
        }

        let this_ty = ctx.schema_ctx.get_type_strict(&self.schema_typename);
        for frag in self.used_inline_frags.values() {
            if !frag.common.contains_field("__typename") {
                continue;
            }

            if frag.common.schema_typename == self.schema_typename {
                return true;
            }

            let frag_ty = ctx.schema_ctx.get_type_strict(&frag.common.schema_typename);
            if let GraphQLAny::Interface(_) = frag_ty {
                if this_ty.implements_interface(&frag.common.schema_typename, &ctx.schema_ctx) {
                    return true;
                }
            };
        }
        // now check for frag spreads
        for frag_name in self.used_fragments.iter() {
            let frag = ctx.get_fragment_strict(frag_name);
            let common = frag.get_on_type();
            if !common.contains_field("__typename") {
                continue;
            }

            if common.schema_typename == self.schema_typename {
                return true;
            }

            let frag_ty = ctx.schema_ctx.get_type_strict(&common.schema_typename);
            if let GraphQLAny::Interface(_) = frag_ty {
                if this_ty.implements_interface(&common.schema_typename, &ctx.schema_ctx) {
                    return true;
                }
            };
        }

        false
    }
    pub fn add_used_fragment(&mut self, name: FragName) {
        self.used_fragments.insert(name);
    }
    pub fn get_used_fragments(&self) -> &HashSet<FragName> {
        &self.used_fragments
    }

    pub fn add_inline_fragment(&mut self, frag: InlineFragment) {
        if let Some(exists) = self.used_inline_frags.get_mut(&frag.common.path_name) {
            // merge the exising one with this one
            exists.merge(frag);
        } else {
            self.used_inline_frags
                .insert(frag.common.path_name.clone(), frag);
        }
    }

    /// return all selections for an object including the fragment selections
    /// for the current selection object, with duplicates removed by field name
    pub fn get_all_selections_distinct(&self, ctx: &ShalomGlobalContext) -> HashSet<FieldSelection> {
        // Convert HashSet to Vec for building the final result
        let mut selections = self.selections.clone();

        for frag_name in &self.used_fragments {
            let fragment = ctx.get_fragment_strict(frag_name);
            selections.extend(fragment.get_on_type().get_all_selections_distinct(ctx));
        }
        for inline_frag in self.used_inline_frags.values() {
            selections.extend(inline_frag.common.get_all_selections_distinct(ctx));
        }
        selections
    }

    /// returns all the types that have directly selected by this object-like selections
    /// only valid for multi-types
    fn get_all_directly_selected_typenames(&self, ctx: &ShalomGlobalContext) -> HashSet<String> {
        let mut ret = HashSet::new();
        ret.insert(self.schema_typename.clone());
        for frag_name in &self.used_fragments {
            let frag = ctx.get_fragment(frag_name).unwrap();
            ret.insert(frag.get_on_type().schema_typename.clone());
        }
        ret.extend(self.used_inline_frags.keys().cloned());
        ret
    }
}

#[derive(Debug, Serialize, Deserialize)]
pub struct ObjectSelection {
    pub is_optional: bool,
    #[serde(flatten)]
    pub common: ObjectLikeCommon,
}

pub type SharedObjectSelection = Rc<ObjectSelection>;

impl ObjectSelection {
    pub fn new(is_optional: bool, common: ObjectLikeCommon) -> SharedObjectSelection {
        let ret = ObjectSelection {
            is_optional,
            common,
        };

        Rc::new(ret)
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
    pub is_optional: bool,
    #[serde(flatten)]
    pub common: ObjectLikeCommon,
    pub possible_concrete_types: HashSet<String>,
}

impl MultiTypeSelectionCommon {
    pub fn new(
        is_optional: bool,
        common: ObjectLikeCommon,
        possible_concrete_types: HashSet<String>,
    ) -> Self {
        MultiTypeSelectionCommon {
            is_optional,
            common,
            possible_concrete_types,
        }
    }
}
pub trait MultiTypeSelection {
    /// Get all possible types for this multi-type selection (union members or interface implementations)
    fn get_all_direct_schema_subsets_typenames(&self, ctx: &ShalomGlobalContext) -> Vec<String>;

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
        union_type: Node<UnionType>,
        object_common: ObjectLikeCommon,
        is_optional: bool,
        possible_concrete_types: HashSet<String>,
    ) -> SharedUnionSelection {
        Rc::new(UnionSelection {
            common: MultiTypeSelectionCommon::new(
                is_optional,
                object_common,
                possible_concrete_types,
            ),
            union_type,
        })
    }
}

impl MultiTypeSelection for UnionSelection {
    fn get_all_direct_schema_subsets_typenames(&self, _ctx: &ShalomGlobalContext) -> Vec<String> {
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
    pub interface_type: Arc<InterfaceType>,
}

pub type SharedInterfaceSelection = Rc<InterfaceSelection>;

impl InterfaceSelection {
    pub fn new(
        interface_type: Arc<InterfaceType>,
        object_common: ObjectLikeCommon,
        is_optional: bool,
        possible_concrete_types: HashSet<String>,
    ) -> SharedInterfaceSelection {
        Rc::new(InterfaceSelection {
            common: MultiTypeSelectionCommon::new(
                is_optional,
                object_common,
                possible_concrete_types,
            ),
            interface_type,
        })
    }
}

impl MultiTypeSelection for InterfaceSelection {
    fn get_all_direct_schema_subsets_typenames(&self, ctx: &ShalomGlobalContext) -> Vec<String> {
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
