use std::collections::{HashMap, HashSet};
use std::path::PathBuf;
use std::sync::Arc;

use apollo_compiler::{
    ast::OperationType as ApolloOperationType, executable as apollo_executable, Name, Node, Schema,
};
use log::{info, trace};

use crate::context::{ShalomGlobalContext, SharedShalomGlobalContext};
use crate::operation::context::ExecutableContext;
use crate::operation::types::{
    FieldArgument, FullPathName, ObjectSelection, SelectionCommon, SelectionKind,
};
use crate::schema::types::{
    EnumType, GraphQLAny, InputFieldDefinition, ScalarType, SchemaFieldCommon,
};

use super::context::{OperationContext, SharedOpCtx};
use super::fragments::{FragmentContext, SharedFragmentContext};
use super::types::{
    EnumSelection, InterfaceSelection, MultiTypeSelection, OperationType, ScalarSelection,
    Selection, SharedEnumSelection, SharedInterfaceSelection, SharedObjectSelection,
    SharedScalarSelection, SharedUnionSelection, UnionSelection,
};

fn full_path_name(this_name: &String, parent_path: &String) -> String {
    format!("{}_{}", parent_path, this_name)
}

/// Parse an inline value into a structured ArgumentValue representation
pub(crate) fn parse_inline_value<T>(
    ctx: &T,
    value: &apollo_executable::Value,
) -> crate::operation::types::ArgumentValue
where
    T: ExecutableContext,
{
    use crate::operation::types::{ArgumentValue, InlineValueArg};
    use indexmap::IndexMap;

    match value {
        apollo_executable::Value::Variable(var_name) => {
            // Variable reference inside an inline object - look it up and create VariableUse
            if let Some(op_var) = ctx.get_variable(var_name) {
                ArgumentValue::VariableUse(op_var.clone())
            } else {
                // Fallback if variable not found (shouldn't happen in valid GraphQL)
                ArgumentValue::InlineValue {
                    value: InlineValueArg::Scalar {
                        value: format!("${}", var_name),
                    },
                }
            }
        }
        apollo_executable::Value::Object(obj) => {
            let mut fields = IndexMap::new();
            for (key, val) in obj.iter() {
                let parsed_val = parse_inline_value(ctx, val);
                fields.insert(key.to_string(), Box::new(parsed_val));
            }
            ArgumentValue::InlineValue {
                value: InlineValueArg::Object {
                    fields,
                    raw: value.to_string(),
                },
            }
        }
        apollo_executable::Value::List(list) => {
            let items: Vec<ArgumentValue> = list
                .iter()
                .map(|item| parse_inline_value(ctx, item))
                .collect();
            ArgumentValue::InlineValue {
                value: InlineValueArg::List {
                    items,
                    raw: value.to_string(),
                },
            }
        }
        apollo_executable::Value::Enum(e) => ArgumentValue::InlineValue {
            value: InlineValueArg::Enum {
                value: e.to_string(),
            },
        },
        _ => {
            // For scalars (String, Int, Float, Boolean, Null)
            ArgumentValue::InlineValue {
                value: InlineValueArg::Scalar {
                    value: value.to_string(),
                },
            }
        }
    }
}

pub(crate) fn parse_field_arguments<T>(
    ctx: &T,
    field: &apollo_executable::Field,
) -> Vec<crate::operation::types::FieldArgument>
where
    T: ExecutableContext,
{
    field
        .arguments
        .iter()
        .map(|arg| match arg.value.as_ref() {
            apollo_executable::Value::Variable(var_name) => {
                let op_var = ctx.get_variable(var_name).unwrap().clone();
                let value = crate::operation::types::ArgumentValue::VariableUse(op_var.clone());
                FieldArgument {
                    name: arg.name.to_string(),
                    value,
                    default_value: op_var.default_value.map(|v| v.to_string()),
                }
            }
            _ => {
                let arg_def = field
                    .definition
                    .arguments
                    .iter()
                    .find(|a| a.name == arg.name);
                // Parse inline value with structured representation
                let inline_val = parse_inline_value(ctx, arg.value.as_ref());
                FieldArgument {
                    name: arg.name.to_string(),
                    value: inline_val,
                    default_value: arg_def
                        .and_then(|def| def.default_value.as_ref().map(|v| v.to_string())),
                }
            }
        })
        .collect()
}

pub(crate) fn parse_enum_selection(
    is_optional: bool,
    concrete_type: Node<EnumType>,
) -> SharedEnumSelection {
    EnumSelection::new(is_optional, concrete_type)
}

pub(crate) fn parse_object_selection<T>(
    ctx: &mut T,
    global_ctx: &SharedShalomGlobalContext,
    path: &String,
    is_optional: bool,
    selection_orig: &apollo_compiler::executable::SelectionSet,

    parent_multitype_fullname: Option<String>,
) -> SharedObjectSelection
where
    T: ExecutableContext,
{
    trace!("Parsing object selection {:?}", selection_orig.ty);
    trace!("Path is {:?}", path);
    assert!(
        !selection_orig.selections.is_empty(),
        "Object selection must have at least one field\n \
         selection was {:?}.",
        selection_orig
    );
    let obj = ObjectSelection::new(
        is_optional,
        path.clone(),
        selection_orig.ty.to_string(),
        parent_multitype_fullname,
    );

    for selection in selection_orig.selections.iter() {
        match selection {
            apollo_executable::Selection::Field(field) => {
                let f_name = field.name.clone().to_string();
                let f_type = field.ty();
                let description = field
                    .definition
                    .description
                    .as_deref()
                    .map(|s| s.to_string());
                let field_path = full_path_name(&f_name, path);
                let args = parse_field_arguments(ctx, field);
                let selection_common = SelectionCommon {
                    name: f_name.clone(),
                    description,
                };

                let field_selection = parse_selection_set(
                    ctx,
                    &field_path,
                    global_ctx,
                    selection_common,
                    &field.selection_set,
                    f_type,
                    args,
                );

                obj.add_selection(field_selection);
            }
            apollo_executable::Selection::FragmentSpread(fragment_spread) => {
                let fragment_name = fragment_spread.fragment_name.to_string();
                trace!("Processing fragment spread: {}", fragment_name);

                // all fragments should be already parsed by now.
                let frag = global_ctx.get_fragment_strict(&fragment_name);
                ctx.typedefs_mut().add_used_fragment(frag.clone());
                obj.add_used_fragment(fragment_name.clone());
            }

            apollo_executable::Selection::InlineFragment(inline_fragment) => {
                // inline fragments should be generated localy in codegens
                // in dart, the generated object class would implement the abstract inline fragment that
                // was generated.
                parse_inline_fragment();
            }
        }
    }
    obj
}

pub(crate) fn parse_scalar_selection(
    ctx: &SharedShalomGlobalContext,
    is_optional: bool,
    concrete_type: Node<ScalarType>,
) -> SharedScalarSelection {
    let scalar_name = concrete_type.name.to_string();
    let is_custom_scalar = ctx.find_custom_scalar(&scalar_name).is_some();

    ScalarSelection::new(is_optional, concrete_type, is_custom_scalar)
}

type FieldTypeOrig = apollo_compiler::ast::Type;

/// Recursively check if a fragment contains type-discriminating selections
/// (inline fragments or spreads of fragments on concrete types)
fn fragment_has_type_discrimination(
    frag: &SharedFragmentContext,
    interface_name: &str,
    global_ctx: &SharedShalomGlobalContext,
    visited: &mut std::collections::HashSet<String>,
) -> bool {
    // Prevent infinite recursion
    if !visited.insert(frag.get_fragment_name().to_string()) {
        return false;
    }

    // Check the fragment's root type
    if let Some(root_type) = frag.get_on_type() {
        // Check if the root is an interface selection with inline fragments
        if let SelectionKind::Interface(iface) = &root_type.kind {
            // If there are any inline fragments, it has type discrimination
            if !iface.common.inline_fragments.borrow().is_empty() {
                return true;
            }
        } else if let SelectionKind::Object(obj) = &root_type.kind {
            // Check if this object has fragment spreads on concrete types
            for used_frag_name in obj.get_used_fragments() {
                if let Some(used_frag) = global_ctx.get_fragment(&used_frag_name) {
                    let used_frag_type_condition = used_frag.get_type_condition();
                    // If the used fragment is on a different type, it's type-discriminating
                    if used_frag_type_condition != interface_name {
                        return true;
                    }
                    // Recursively check the used fragment
                    if fragment_has_type_discrimination(
                        &used_frag,
                        interface_name,
                        global_ctx,
                        visited,
                    ) {
                        return true;
                    }
                }
            }
        }
    }

    false
}

pub(crate) fn parse_union_selection<T>(
    ctx: &mut T,
    global_ctx: &SharedShalomGlobalContext,
    path: &String,
    is_optional: bool,
    selection_set: &apollo_executable::SelectionSet,
    union_type: Node<crate::schema::types::UnionType>,
) -> crate::operation::types::SharedUnionSelection
where
    T: ExecutableContext,
{
    trace!("Parsing union selection {:?}", union_type.name);

    // Create union selection with placeholder has_fallback (we'll determine this later)
    let union_selection = UnionSelection::new(
        path.clone(),
        union_type.name.clone(),
        union_type.clone(),
        is_optional,
    );

    // Track fragments spread directly at the union level (not inside inline fragments)
    let mut union_level_fragments: Vec<String> = Vec::new();

    for selection in selection_set.selections.iter() {
        match selection {
            apollo_executable::Selection::Field(field) => {
                // This is a shared field (like __typename)
                let f_name = field.name.clone().to_string();
                let f_type = field.ty();
                let description = field
                    .definition
                    .description
                    .as_deref()
                    .map(|s| s.to_string());
                let field_path = full_path_name(&f_name, path);
                let args = parse_field_arguments(ctx, field);

                let selection_common = SelectionCommon {
                    name: f_name.clone(),
                    description,
                };

                let field_selection = parse_selection_set(
                    ctx,
                    &field_path,
                    global_ctx,
                    selection_common,
                    &field.selection_set,
                    f_type,
                    args,
                );
                union_selection.common.add_shared_selection(field_selection);
            }
            apollo_executable::Selection::InlineFragment(inline_fragment) => {
                let mut is_common_interface = false;
                if let Some(type_condition) = &inline_fragment.type_condition {
                    let type_condition_str = type_condition.to_string();
                    trace!("Processing inline fragment on type: {}", type_condition_str);

                    if union_type.members.contains(&type_condition_str) {
                        // This is a specific union member type
                        let fragment_path = format!("{}_{}", path, type_condition_str);
                        let obj = parse_object_selection(
                            ctx,
                            global_ctx,
                            &fragment_path,
                            false, // inline fragments within unions are not optional
                            &inline_fragment.selection_set,
                            Some(path.clone()), // Union member - parent is the union
                        );
                        union_selection
                            .common
                            .add_inline_fragment(type_condition_str, obj.clone());

                        let selection_common = SelectionCommon {
                            name: fragment_path.clone(),
                            description: None,
                        };
                        let selection = Selection::new(
                            selection_common,
                            SelectionKind::Object(obj),
                            Default::default(),
                        );

                        ctx.add_selection(fragment_path, selection);
                    } else if let Some(_interface) =
                        global_ctx.schema_ctx.get_interface(&type_condition_str)
                    {
                        // Verify all union members implement this interface
                        for member in union_type.members.iter() {
                            if !global_ctx
                                .schema_ctx
                                .is_type_implementing_interface(member, &type_condition_str)
                            {
                                panic!(
                                        "Type '{}' is not a member of union '{}' and is not a common interface implemented by all members",
                                        type_condition_str, union_type.name
                                    );
                            }
                        }
                        is_common_interface = true;
                    } else {
                        panic!(
                            "Type '{}' is not a member of union '{}' and is not a common interface implemented by all members",
                            type_condition_str, union_type.name
                        );
                    }
                }

                if is_common_interface {
                    // Inline fragment without type condition - fields apply to all types
                    for sel in &inline_fragment.selection_set.selections {
                        if let apollo_executable::Selection::Field(field) = sel {
                            let f_name = field.name.clone().to_string();
                            let f_type = field.ty();
                            let description = field
                                .definition
                                .description
                                .as_deref()
                                .map(|s| s.to_string());
                            let field_path = full_path_name(&f_name, path);
                            let args: Vec<crate::operation::types::FieldArgument> = vec![];

                            let selection_common = SelectionCommon {
                                name: f_name.clone(),
                                description,
                            };

                            let field_selection = parse_selection_set(
                                ctx,
                                &field_path,
                                global_ctx,
                                selection_common,
                                &field.selection_set,
                                f_type,
                                args,
                            );

                            union_selection.common.add_shared_selection(field_selection);
                        }
                    }
                }
            }
            apollo_executable::Selection::FragmentSpread(fragment_spread) => {
                let fragment_name = fragment_spread.fragment_name.to_string();
                trace!("Processing fragment spread: {}", fragment_name);

                let frag = global_ctx
                    .get_fragment(&fragment_name)
                    .unwrap_or_else(|| panic!("Fragment not found: {}", fragment_name));
                ctx.typedefs_mut().add_used_fragment(frag.clone());

                let frag_type_condition = frag.get_type_condition();

                // Check if the fragment is on one of the union's member types
                if union_type
                    .members
                    .contains(&frag_type_condition.to_string())
                {
                    // Fragment is on a specific union member type - treat as inline fragment
                    trace!(
                        "Fragment '{}' is on union member type '{}', treating as inline fragment",
                        fragment_name,
                        frag_type_condition
                    );

                    let fragment_path = format!("{}_{}", path, frag_type_condition);

                    // Check if inline fragment already exists
                    let inline_fragments = union_selection.common.inline_fragments.borrow();
                    let obj_exists = inline_fragments.contains_key(frag_type_condition);
                    drop(inline_fragments);

                    let obj = if !obj_exists {
                        // Create a new object selection for this inline fragment
                        let new_obj = ObjectSelection::new(
                            false, // inline fragments within unions are not optional
                            fragment_path.clone(),
                            frag_type_condition.to_string(),
                            Some(path.clone()), // Union member - parent is the union
                        );
                        union_selection
                            .common
                            .add_inline_fragment(frag_type_condition.to_string(), new_obj.clone());

                        // Register the object selection
                        let selection_common = SelectionCommon {
                            name: fragment_path.clone(),
                            description: None,
                        };
                        let selection = Selection::new(
                            selection_common,
                            SelectionKind::Object(new_obj.clone()),
                            Default::default(),
                        );
                        ctx.add_selection(fragment_path, selection);
                        new_obj
                    } else {
                        // Get existing inline fragment
                        union_selection
                            .common
                            .inline_fragments
                            .borrow()
                            .get(frag_type_condition)
                            .unwrap()
                            .clone()
                    };

                    // Add the fragment to this inline fragment's used_fragments
                    obj.add_used_fragment(fragment_name);
                } else {
                    // Fragment is on a shared type (interface) or unrelated - treat as union-level
                    union_level_fragments.push(fragment_name);
                }
            }
        }
    }

    // Store union-level fragments in the union selection so the template can access them
    for frag_name in &union_level_fragments {
        union_selection
            .common
            .add_fragment_spread(frag_name.clone());

        // Also add the fragment's fields to shared selections so the fallback class has them
        let frag = global_ctx.get_fragment(frag_name).unwrap();
        if let Some(frag_root_type) = frag.get_on_type() {
            match &frag_root_type.kind {
                SelectionKind::Object(obj) => {
                    for selection in obj.selections.borrow().iter() {
                        union_selection
                            .common
                            .add_shared_selection(selection.clone());
                    }
                }
                SelectionKind::Union(union_sel) => {
                    for selection in union_sel.common.shared_selections.borrow().iter() {
                        union_selection
                            .common
                            .add_shared_selection(selection.clone());
                    }
                }
                _ => {}
            }
        }
    }

    // Propagate union-level fragment spreads to all inline fragment members
    // This ensures that if a fragment is spread on a union, all member types
    // of that union also implement the fragment
    for (_type_name, obj_selection) in union_selection.common.inline_fragments.borrow().iter() {
        for frag_name in &union_level_fragments {
            obj_selection.add_used_fragment(frag_name.clone());
        }
    }

    // Determine if we need a fallback class
    let has_fallback = union_selection.should_generate_fallback(global_ctx);

    union_selection.common.needs_fallback.set(has_fallback);
    union_selection
}

#[derive(Clone)]
enum _FragOrInlineFragInternal {
    FragSpread(SharedFragmentContext),
    InlineFragSelections(apollo_executable::SelectionSet),
}

pub(crate) fn parse_interface_selection<T: ExecutableContext>(
    ctx: &mut T,
    global_ctx: &SharedShalomGlobalContext,
    path: &String,
    is_optional: bool,
    selection_set: &apollo_executable::SelectionSet,
    interface_type: Node<crate::schema::types::InterfaceType>,
) -> SharedInterfaceSelection {
    trace!("Parsing interface selection {:?}", interface_type.name);

    // Create interface selection with placeholder has_fallback (we'll determine this later)
    let interface_selection = InterfaceSelection::new(
        path.clone(),
        interface_type.name.clone(),
        interface_type.clone(),
        is_optional,
    );
    // TODO: can this move to a generic `parse_field` fn?
    let parse_shared_field = move |field: &apollo_executable::Field| -> Selection {
        // This is a shared field from the interface
        let f_name = field.name.clone().to_string();
        let f_type = field.ty();
        let description = field
            .definition
            .description
            .as_deref()
            .map(|s| s.to_string());
        let field_path = full_path_name(&f_name, path);
        let args = parse_field_arguments(ctx, field);

        let selection_common = SelectionCommon {
            name: f_name.clone(),
            description,
        };

        parse_selection_set(
            ctx,
            &field_path,
            global_ctx,
            selection_common,
            &field.selection_set,
            f_type,
            args,
        )
    };

    // fields that apply to all memberes
    let mut shared_fields: Vec<Selection> = Vec::new();

    let mut directly_used_frags: HashMap<String, Vec<_FragOrInlineFragInternal>> = HashMap::new();

    for selection in selection_set.selections.iter() {
        match selection {
            apollo_executable::Selection::Field(field) => {
                shared_fields.push(parse_shared_field(field));
            }
            apollo_executable::Selection::InlineFragment(inline_fragment) => {
                if let Some(type_condition) = &inline_fragment.type_condition {
                    let type_condition_str = type_condition.to_string();
                    directly_used_frags
                        .entry(type_condition_str)
                        .or_insert_with(Vec::new)
                        .push(_FragOrInlineFragInternal::InlineFragSelections(
                            inline_fragment.selection_set.clone(),
                        ));
                } else {
                    // Inline fragment without type condition - fields apply to all types
                    for sel in &inline_fragment.selection_set.selections {
                        if let apollo_executable::Selection::Field(field) = sel {
                            shared_fields.push(parse_shared_field(field));
                        }
                    }
                }
            }
            apollo_executable::Selection::FragmentSpread(fragment_spread) => {
                let fragment_name = fragment_spread.fragment_name.to_string();
                trace!("Processing fragment spread: {}", fragment_name);
                let fragment = global_ctx.get_fragment_strict(&fragment_name);
                let type_cond = fragment.type_condition.clone();
                directly_used_frags
                    .entry(type_cond.clone())
                    .or_insert_with(Vec::new)
                    .push(_FragOrInlineFragInternal::FragSpread(fragment));
            }
        }
    }

    // now that we have all type conditions lets extract what we need.

    let mut needs_a_fallback_type = false;
    for member in global_ctx
        .schema_ctx
        .get_interface_direct_members(interface_type.name.clone())
    {
        if !directly_used_frags.contains_key(&member.name) {
            needs_a_fallback_type = true;
            break;
        }
    }
    // shared fragments are fragments that apply to all member thus should the interface itself implements them.
    let mut shared_frags: Vec<String> = Vec::new();
    // we now extract fragments that are either shared for all members or are on the type itself

    for (type_cond, frags) in directly_used_frags {
        for frag in frags {
            match frag {
                _FragOrInlineFragInternal::FragSpread(frag) => {
                    interface_selection.common.add_fragment_spread(frag.name);
                }
                _FragOrInlineFragInternal::InlineFragSelections(selection_set) => {
                    // if this is an inline fragment codegens would need to first
                    // create a fragment type for this subset so we add it as a selection to the context (but not to the current iface selection).
                    let mut this_used_frags: HashMap<String, _FragOrInlineFragInternal> =
                        HashSet::new();
                    let fragment_path = format!("{}_{}", path, type_cond);
                    // merge duplicated inline fragments meaning that
                    // A implements B, Common;
                    // B implements Common;
                    // ```graphql
                    // {... on A {} ... on B {} selection1 selection2}
                    // ```
                    // since A implements B all of B selections should be merged into A
                    // and A should implement the fragment generated for B
                    // also we want inject the common selections inside A and B
                    for (other_tc, _frags) in directly_used_frags {
                        if other_tc == type_cond {
                            // this is the current one..
                            continue;
                        }
                        if global_ctx
                            .schema_ctx
                            .is_type_implementing_interface(&type_cond, &other_tc)
                        {
                            // if the current fragment implements `other_tc`
                            for _frag in _frags {
                                this_used_frags
                                    .entry(other_tc.clone())
                                    .or_insert_with(Vec::new)
                                    .push(_frag.clone());
                            }
                        }
                    }

                    let obj = parse_object_selection(
                        ctx,
                        global_ctx,
                        &fragment_path,
                        is_optional,
                        &selection_set,
                        Some(path.clone()),
                    );
                    interface_selection
                        .common
                        .add_inline_fragment(type_cond.clone(), obj.clone());

                    let selection_common = SelectionCommon {
                        name: fragment_path.clone(),
                        description: None,
                    };
                    let selection = Selection::new(
                        selection_common,
                        SelectionKind::Object(obj),
                        Default::default(),
                    );

                    ctx.add_selection(fragment_path, selection);
                }
            }
        }
    }
    todo!("this")
}

pub(crate) fn parse_selection_kind<T>(
    ctx: &mut T,
    global_ctx: &SharedShalomGlobalContext,
    path: &String,
    selection_set: &apollo_executable::SelectionSet,
    field_type_orig: &FieldTypeOrig,
) -> SelectionKind
where
    T: ExecutableContext,
{
    let is_optional = !field_type_orig.is_non_null();
    match field_type_orig {
        FieldTypeOrig::Named(name) | FieldTypeOrig::NonNullNamed(name) => {
            match global_ctx.schema_ctx.get_type(&name.to_string()).unwrap() {
                GraphQLAny::Scalar(scalar) => {
                    SelectionKind::Scalar(parse_scalar_selection(global_ctx, is_optional, scalar))
                }
                GraphQLAny::Object(_) => SelectionKind::Object(parse_object_selection(
                    ctx,
                    global_ctx,
                    path,
                    is_optional,
                    selection_set,
                    None, // Regular object selection, not a multi-type member
                )),
                GraphQLAny::Enum(_enum) => {
                    SelectionKind::Enum(parse_enum_selection(is_optional, _enum))
                }
                GraphQLAny::Union(union_type) => SelectionKind::Union(parse_union_selection(
                    ctx,
                    global_ctx,
                    path,
                    is_optional,
                    selection_set,
                    union_type,
                )),
                GraphQLAny::Interface(interface_type) => {
                    // Check if the selection set has inline fragments or fragment spreads on concrete types
                    let has_type_discrimination = selection_set.selections.iter().any(|sel| {
                        match sel {
                            apollo_executable::Selection::InlineFragment(_) => true,
                            apollo_executable::Selection::FragmentSpread(spread) => {
                                // Check if the fragment is on a concrete type (not the interface itself)
                                if let Some(frag) =
                                    global_ctx.get_fragment(&spread.fragment_name.to_string())
                                {
                                    let frag_type_condition = frag.get_type_condition();
                                    // Direct type check: if fragment is on a different type, it's type-discriminating
                                    if frag_type_condition != interface_type.name.as_str() {
                                        return true;
                                    }
                                    // Recursive check: if fragment is on the interface but contains type-conditional fragments
                                    let mut visited = std::collections::HashSet::new();
                                    fragment_has_type_discrimination(
                                        &frag,
                                        interface_type.name.as_str(),
                                        global_ctx,
                                        &mut visited,
                                    )
                                } else {
                                    false
                                }
                            }
                            _ => false,
                        }
                    });

                    if has_type_discrimination {
                        // Parse as interface selection with type discrimination
                        SelectionKind::Interface(parse_interface_selection(
                            ctx,
                            global_ctx,
                            path,
                            is_optional,
                            selection_set,
                            interface_type,
                        ))
                    } else {
                        // No type discrimination - treat as simple object selection
                        // (all fields are from interface, no type-specific fields)
                        SelectionKind::Object(parse_object_selection(
                            ctx,
                            global_ctx,
                            path,
                            is_optional,
                            selection_set,
                            None, // Regular object selection, not a multi-type member
                        ))
                    }
                }
                _ => todo!(
                    "Unsupported GraphQL type {:?}",
                    global_ctx.schema_ctx.get_type(&name.to_string())
                ),
            }
        }
        FieldTypeOrig::NonNullList(of_type) | FieldTypeOrig::List(of_type) => {
            let of_kind = parse_selection_kind(ctx, global_ctx, path, selection_set, of_type);

            // Register inner object/union/interface selections so they can be found for code generation
            match &of_kind {
                SelectionKind::Object(_)
                | SelectionKind::Union(_)
                | SelectionKind::Interface(_) => {
                    let selection_common = SelectionCommon {
                        name: path.clone(),
                        description: None,
                    };
                    let inner_selection =
                        Selection::new(selection_common, of_kind.clone(), Default::default());
                    ctx.add_selection(path.clone(), inner_selection);
                }
                _ => {}
            }

            SelectionKind::new_list(is_optional, of_kind)
        }
    }
}

#[allow(clippy::too_many_arguments)]
pub(super) fn parse_selection_set<T: ExecutableContext>(
    ctx: &mut T,
    path: &String,
    global_ctx: &SharedShalomGlobalContext,
    selection_common: SelectionCommon,
    selection_orig: &apollo_compiler::executable::SelectionSet,
    field_type_orig: &FieldTypeOrig,
    arguments: Vec<crate::operation::types::FieldArgument>,
) -> Selection {
    let full_name = path.clone();
    if let Some(selection) = ctx.get_selection(&full_name, global_ctx) {
        info!("Selection already exists");
        return selection.clone();
    }

    let kind = parse_selection_kind(ctx, global_ctx, path, selection_orig, field_type_orig);
    let selection = Selection::new(selection_common, kind, arguments);
    ctx.add_selection(full_name, selection.clone());
    selection
}

pub(crate) fn parse_operation_type(operation_type: ApolloOperationType) -> OperationType {
    match operation_type {
        ApolloOperationType::Query => OperationType::Query,
        ApolloOperationType::Mutation => OperationType::Mutation,
        ApolloOperationType::Subscription => OperationType::Subscription,
    }
}

/// Recursively inject __typename into union and interface selection sets
pub(crate) fn inject_typename_in_selection_set(
    schema: &Schema,
    selection_set: &mut apollo_executable::SelectionSet,
    global_ctx: &ShalomGlobalContext,
) {
    // Check if this selection set is for a union or interface type
    let type_name = selection_set.ty.to_string();
    let type_info = global_ctx.schema_ctx.get_type(&type_name);

    let is_union_or_interface = type_info
        .map(|t| {
            matches!(
                t,
                crate::schema::types::GraphQLAny::Union(_)
                    | crate::schema::types::GraphQLAny::Interface(_)
            )
        })
        .unwrap_or(false);

    if is_union_or_interface {
        // Check if __typename is already selected
        let has_typename = selection_set.selections.iter().any(|sel| {
            if let apollo_executable::Selection::Field(field) = sel {
                field.name.as_str() == "__typename"
            } else {
                false
            }
        });

        // Inject __typename if not present
        if !has_typename {
            trace!("Injecting __typename into {} selection", type_name);
            let typename_name = Name::new("__typename").expect("__typename is a valid field name");
            selection_set
                .new_field(schema, typename_name)
                .expect("Failed to inject __typename");
        }
    }

    // Recursively process all selections
    for selection in selection_set.selections.iter_mut() {
        match selection {
            apollo_executable::Selection::Field(field) => {
                if !field.selection_set.selections.is_empty() {
                    let field_mut = field.make_mut();
                    inject_typename_in_selection_set(
                        schema,
                        &mut field_mut.selection_set,
                        global_ctx,
                    );
                }
            }
            apollo_executable::Selection::InlineFragment(inline_fragment) => {
                let inline_mut = inline_fragment.make_mut();
                inject_typename_in_selection_set(schema, &mut inline_mut.selection_set, global_ctx);
            }
            apollo_executable::Selection::FragmentSpread(_) => {
                // Fragment spreads are handled separately
            }
        }
    }
}

pub(crate) fn get_used_fragments_from_fragment(
    fragment: &Node<apollo_compiler::executable::Fragment>,
) -> Vec<String> {
    let mut used = Vec::new();
    fn visit_selection(selection: &apollo_executable::Selection, used: &mut Vec<String>) {
        match selection {
            apollo_executable::Selection::Field(field) => {
                for sel in &field.selection_set.selections {
                    visit_selection(sel, used);
                }
            }
            apollo_executable::Selection::FragmentSpread(spread) => {
                used.push(spread.fragment_name.to_string());
            }
            apollo_executable::Selection::InlineFragment(inline) => {
                for sel in &inline.selection_set.selections {
                    visit_selection(sel, used);
                }
            }
        }
    }
    for sel in &fragment.selection_set.selections {
        visit_selection(sel, &mut used);
    }
    used
}

fn parse_operation(
    global_ctx: &SharedShalomGlobalContext,
    mut op: Node<apollo_compiler::executable::Operation>,
    operation_name: String,
    file_path: PathBuf,
) -> anyhow::Result<SharedOpCtx> {
    // Inject __typename into union and interface selections
    let schema = &global_ctx.schema_ctx.schema;
    let op_mut = op.make_mut();
    inject_typename_in_selection_set(schema, &mut op_mut.selection_set, global_ctx);

    let query = op.to_string();
    let mut ctx = OperationContext::new(
        global_ctx.schema_ctx.clone(),
        operation_name.clone(),
        query,
        file_path,
        parse_operation_type(op.operation_type),
    );
    for variable in op.variables.iter() {
        let name = variable.name.to_string();
        let raw_type = (*variable.ty).clone();
        let is_optional = !raw_type.is_non_null();
        let field_definition = SchemaFieldCommon::new(name.clone(), &raw_type, None);
        let input_definition = InputFieldDefinition {
            common: field_definition,
            is_maybe: is_optional && variable.default_value.is_none(),
            is_optional,
            default_value: variable.default_value.clone(),
        };
        ctx.add_variable(name, input_definition);
    }

    let first_selection = {
        if op.selection_set.selections.len() > 1 {
            return Err(anyhow::anyhow!(
                "{operation_name} has more than one selection which is not allowed"
            ));
        }
        op.selection_set
            .selections
            .first()
            .unwrap()
            .as_field()
            .unwrap()
    };
    let first_selection_name = first_selection.name.to_string();
    if first_selection_name == operation_name {
        return Err(
            anyhow::anyhow!("{operation_name} operation can't have the same name as its first field due to namespacing issues")
        );
    }
    let selection_common = SelectionCommon {
        name: first_selection_name,
        description: None,
    };
    let root_type = parse_object_selection(
        &mut ctx,
        global_ctx,
        &operation_name,
        false,
        &op.selection_set,
        None, // Root operation type, not a multi-type member
    );
    let selection = Selection::new(selection_common, SelectionKind::Object(root_type), vec![]);
    ctx.set_root_type(selection.clone());
    (&mut ctx as &mut dyn ExecutableContext).add_selection(operation_name, selection);
    Ok(Arc::new(ctx))
}

pub(crate) fn parse_document_impl(
    global_ctx: &SharedShalomGlobalContext,
    source: &str,
    doc_path: &PathBuf,
) -> anyhow::Result<HashMap<String, SharedOpCtx>> {
    let mut ret = HashMap::new();
    let schema = global_ctx.schema_ctx.schema.clone();
    let mut parser = apollo_compiler::parser::Parser::new();
    let doc_orig = parser
        .parse_executable(&schema, source, doc_path)
        .map_err(|e| anyhow::anyhow!("Failed to parse document: {}", e))?;
    let doc_orig = doc_orig.validate(&schema).expect("doc is not valid");
    if doc_orig.operations.anonymous.is_some() {
        unimplemented!("Anonymous operations are not supported")
    }
    for (name, op) in doc_orig.operations.named.iter() {
        let name = name.to_string();
        ret.insert(
            name.clone(),
            parse_operation(global_ctx, op.clone(), name, doc_path.clone())?,
        );
    }
    Ok(ret)
}
