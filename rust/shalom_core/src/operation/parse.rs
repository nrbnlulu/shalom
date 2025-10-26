use std::collections::HashMap;
use std::path::PathBuf;
use std::sync::Arc;

use apollo_compiler::{
    ast::OperationType as ApolloOperationType, executable as apollo_executable, Name, Node, Schema,
};
use log::{info, trace};

use crate::context::{ShalomGlobalContext, SharedShalomGlobalContext};
use crate::operation::context::TypeDefs;
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
fn parse_inline_value<T>(
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

fn parse_field_arguments<T>(
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

fn parse_enum_selection(is_optional: bool, concrete_type: Node<EnumType>) -> SharedEnumSelection {
    EnumSelection::new(is_optional, concrete_type)
}

fn parse_object_selection<T>(
    ctx: &mut T,
    global_ctx: &SharedShalomGlobalContext,
    path: &String,
    is_optional: bool,
    selection_orig: &apollo_compiler::executable::SelectionSet,
    used_fragments: &mut Vec<SharedFragmentContext>,
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
                    &field_path,
                    ctx,
                    global_ctx,
                    selection_common,
                    &field.selection_set,
                    f_type,
                    args,
                    used_fragments,
                );

                obj.add_selection(field_selection);
            }
            apollo_executable::Selection::FragmentSpread(fragment_spread) => {
                let fragment_name = fragment_spread.fragment_name.to_string();
                trace!("Processing fragment spread: {}", fragment_name);

                // all fragments should be already parsed by now.
                let frag = global_ctx.get_fragment_strict(&fragment_name);
                used_fragments.push(frag.clone());
                obj.add_used_fragment(fragment_name.clone());
            }
            apollo_executable::Selection::InlineFragment(inline_fragment) => {
                // Inline fragments are handled in parse_union_selection
                // When we encounter them in an object context, we should expand them inline
                if let Some(type_condition) = &inline_fragment.type_condition {
                    trace!("Processing inline fragment on type: {}", type_condition);
                    // Recursively parse the inline fragment's selection set as an object selection
                    let inline_obj = parse_object_selection(
                        ctx,
                        global_ctx,
                        path,
                        false, // inline fragments in objects inherit the parent's optionality
                        &inline_fragment.selection_set,
                        used_fragments,
                        None, // inline fragments within objects don't have a multi-type parent
                    );
                    // Merge the inline fragment's selections into the parent object
                    for selection in inline_obj.selections.borrow().iter() {
                        obj.add_selection(selection.clone());
                    }
                }
            }
        }
    }
    obj
}

fn parse_scalar_selection(
    ctx: &SharedShalomGlobalContext,
    is_optional: bool,
    concrete_type: Node<ScalarType>,
) -> SharedScalarSelection {
    let scalar_name = concrete_type.name.to_string();
    let is_custom_scalar = ctx.find_custom_scalar(&scalar_name).is_some();

    ScalarSelection::new(is_optional, concrete_type, is_custom_scalar)
}

type FieldTypeOrig = apollo_compiler::ast::Type;

fn parse_union_selection<T>(
    ctx: &mut T,
    global_ctx: &SharedShalomGlobalContext,
    path: &String,
    is_optional: bool,
    selection_set: &apollo_executable::SelectionSet,
    union_type: Node<crate::schema::types::UnionType>,
    used_fragments: &mut Vec<SharedFragmentContext>,
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
                    &field_path,
                    ctx,
                    global_ctx,
                    selection_common,
                    &field.selection_set,
                    f_type,
                    args,
                    used_fragments,
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
                            used_fragments,
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
                                &field_path,
                                ctx,
                                global_ctx,
                                selection_common,
                                &field.selection_set,
                                f_type,
                                args,
                                used_fragments,
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
                used_fragments.push(frag.clone());
                // This is a union-level fragment spread, track it separately
                union_level_fragments.push(fragment_name);
            }
        }
    }

    // Store union-level fragments in the union selection so the template can access them
    for frag_name in &union_level_fragments {
        union_selection
            .common
            .add_shared_fragment(frag_name.clone());

        // Also add the fragment's fields to shared selections so the fallback class has them
        let frag = global_ctx.get_fragment(frag_name).unwrap();
        if let Some(frag_root_type) = frag.get_root_type() {
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

    union_selection.common.has_fallback.set(has_fallback);

    // Register the union type in the context
    ctx.add_union_type(path.clone(), union_selection.clone());

    union_selection
}

fn parse_interface_selection<T>(
    ctx: &mut T,
    global_ctx: &SharedShalomGlobalContext,
    path: &String,
    is_optional: bool,
    selection_set: &apollo_executable::SelectionSet,
    interface_type: Node<crate::schema::types::InterfaceType>,
    used_fragments: &mut Vec<SharedFragmentContext>,
) -> SharedInterfaceSelection
where
    T: ExecutableContext,
{
    trace!("Parsing interface selection {:?}", interface_type.name);

    // Create interface selection with placeholder has_fallback (we'll determine this later)
    let interface_selection = InterfaceSelection::new(
        path.clone(),
        interface_type.name.clone(),
        interface_type.clone(),
        is_optional,
    );

    // Track fragments spread directly at the interface level (not inside inline fragments)
    let mut interface_level_fragments: Vec<String> = Vec::new();

    for selection in selection_set.selections.iter() {
        match selection {
            apollo_executable::Selection::Field(field) => {
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

                let field_selection = parse_selection_set(
                    &field_path,
                    ctx,
                    global_ctx,
                    selection_common,
                    &field.selection_set,
                    f_type,
                    args,
                    used_fragments,
                );
                interface_selection
                    .common
                    .add_shared_selection(field_selection);
            }
            apollo_executable::Selection::InlineFragment(inline_fragment) => {
                if let Some(type_condition) = &inline_fragment.type_condition {
                    let type_condition_str = type_condition.to_string();
                    trace!("Processing inline fragment on type: {}", type_condition_str);

                    // Check if the type_condition is a valid type or interface
                    let is_implementing_type = global_ctx
                        .schema_ctx
                        .is_type_implementing_interface(&type_condition_str, &interface_type.name);

                    let is_interface = global_ctx
                        .schema_ctx
                        .get_interface(&type_condition_str)
                        .is_some();

                    // Verify this type implements the interface, or is itself a valid interface
                    if !is_implementing_type && !is_interface {
                        panic!(
                            "Type '{}' does not implement interface '{}' and is not a valid interface",
                            type_condition_str, interface_type.name
                        );
                    }

                    let fragment_path = format!("{}_{}", path, type_condition_str);
                    let obj = parse_object_selection(
                        ctx,
                        global_ctx,
                        &fragment_path,
                        false, // inline fragments within interfaces are not optional
                        &inline_fragment.selection_set,
                        used_fragments,
                        Some(path.clone()), // Interface member - parent is the interface
                    );
                    interface_selection
                        .common
                        .add_inline_fragment(type_condition_str.clone(), obj.clone());

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
                } else {
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
                                &field_path,
                                ctx,
                                global_ctx,
                                selection_common,
                                &field.selection_set,
                                f_type,
                                args,
                                used_fragments,
                            );

                            interface_selection
                                .common
                                .add_shared_selection(field_selection);
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
                used_fragments.push(frag.clone());
                // This is an interface-level fragment spread, track it separately
                interface_level_fragments.push(fragment_name);
            }
        }
    }

    // Store interface-level fragments in the interface selection so the template can access them
    for frag_name in &interface_level_fragments {
        interface_selection
            .common
            .add_shared_fragment(frag_name.clone());

        // Also add the fragment's fields to shared selections so the fallback class has them
        let frag = global_ctx.get_fragment(frag_name).unwrap();
        if let Some(frag_root_type) = frag.get_root_type() {
            match &frag_root_type.kind {
                SelectionKind::Object(obj) => {
                    for selection in obj.selections.borrow().iter() {
                        interface_selection
                            .common
                            .add_shared_selection(selection.clone());
                    }
                }
                SelectionKind::Interface(iface) => {
                    for selection in iface.common.shared_selections.borrow().iter() {
                        interface_selection
                            .common
                            .add_shared_selection(selection.clone());
                    }
                }
                _ => {}
            }
        }
    }

    // Propagate interface-level fragment spreads to all inline fragment members
    // This ensures that if a fragment is spread on an interface, all concrete types
    // that implement that interface also implement the fragment
    for (_type_name, obj_selection) in interface_selection.common.inline_fragments.borrow().iter() {
        for frag_name in &interface_level_fragments {
            obj_selection.add_used_fragment(frag_name.clone());
        }
    }

    // Determine if we need a fallback class
    let has_fallback = interface_selection.should_generate_fallback(global_ctx);
    interface_selection.common.has_fallback.set(has_fallback);
    ctx.add_interface_type(path.clone(), interface_selection.clone());

    interface_selection
}

pub fn parse_selection_kind<T>(
    ctx: &mut T,
    global_ctx: &SharedShalomGlobalContext,
    path: &String,
    selection_set: &apollo_executable::SelectionSet,
    field_type_orig: &FieldTypeOrig,
    used_fragments: &mut Vec<SharedFragmentContext>,
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
                    used_fragments,
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
                    used_fragments,
                )),
                GraphQLAny::Interface(interface_type) => {
                    // Check if the selection set has inline fragments
                    let has_inline_fragments = selection_set
                        .selections
                        .iter()
                        .any(|sel| matches!(sel, apollo_executable::Selection::InlineFragment(_)));

                    if has_inline_fragments {
                        // Parse as interface selection with type discrimination
                        SelectionKind::Interface(parse_interface_selection(
                            ctx,
                            global_ctx,
                            path,
                            is_optional,
                            selection_set,
                            interface_type,
                            used_fragments,
                        ))
                    } else {
                        // No inline fragments - treat as simple object selection
                        // (all fields are from interface, no type-specific fields)
                        SelectionKind::Object(parse_object_selection(
                            ctx,
                            global_ctx,
                            path,
                            is_optional,
                            selection_set,
                            used_fragments,
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
            let of_kind = parse_selection_kind(
                ctx,
                global_ctx,
                path,
                selection_set,
                of_type,
                used_fragments,
            );

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

// Trait to abstract over OperationContext and FragmentContext
pub trait ExecutableContext: Send + Sync + 'static {
    fn get_used_fragments(
        &self,
        name: &str,
        ctx: &ShalomGlobalContext,
    ) -> &Vec<SharedFragmentContext>;

    fn get_fragment(
        &self,
        name: &str,
        ctx: &ShalomGlobalContext,
    ) -> Option<&SharedFragmentContext> {
        self.get_used_fragments(name, ctx)
            .iter()
            .find(|frag| frag.name() == name)
    }

    fn name(&self) -> &str;

    fn get_selection(&self, name: &String, ctx: &ShalomGlobalContext) -> Option<&Selection> {
        self.get_object_selection(name)
            .or_else(|| self.get_union_selection(name))
            .or_else(|| self.get_interface_selection(name))
            .or_else(|| {
                for frag in self.get_used_fragments(name, ctx) {
                    if let Some(selection) = frag.get_selection(&name.to_string(), ctx) {
                        return Some(selection);
                    }
                }
                None
            })
    }
    fn add_selection(&mut self, name: String, selection: Selection) {
        match selection.kind {
            SelectionKind::Object(_) => self.add_object_selection(name, selection),
            SelectionKind::Interface(_) => self.add_interface_selection(name, selection),
            SelectionKind::Union(_) => self.add_union_selection(name, selection),
            SelectionKind::List(_) => self.add_list_selection(name, selection),
            _ => (),
        }
    }

    fn get_selection_strict(&self, name: &String, ctx: &ShalomGlobalContext) -> &Selection {
        self.get_selection(name, ctx).unwrap_or_else(|| {
            panic!("selection for {name} not found neither in this context nor in its fragments")
        })
    }

    fn typedefs(&self) -> &TypeDefs;
    fn typedefs_mut(&mut self) -> &mut TypeDefs;

    fn get_variable(&self, name: &str) -> Option<&crate::operation::context::OperationVariable>;
    fn has_variables(&self) -> bool;

    fn add_object_selection(&mut self, name: String, object_selection: Selection) {
        self.typedefs_mut()
            .add_object_selection(name, object_selection);
    }
    fn get_object_selection(&self, name: &String) -> Option<&Selection> {
        self.typedefs().get_object_selection(name)
    }
    fn add_union_selection(&mut self, name: String, union_selection: Selection) {
        self.typedefs_mut()
            .add_union_selection(name, union_selection);
    }
    fn get_union_selection(&self, name: &String) -> Option<&Selection> {
        self.typedefs().get_union_selection(name)
    }

    fn add_interface_selection(&mut self, name: String, interface_selection: Selection) {
        self.typedefs_mut()
            .add_interface_selection(name, interface_selection);
    }
    fn get_interface_selection(&self, name: &String) -> Option<&Selection> {
        self.typedefs().get_interface_selection(name)
    }
    fn add_list_selection(&mut self, name: String, list_selection: Selection) {
        self.typedefs_mut().add_list_selection(name, list_selection);
    }
    fn get_list_selection(&self, name: &String) -> Option<&Selection> {
        self.typedefs().get_list_selection(name)
    }

    fn add_union_type(&mut self, name: String, union_selection: SharedUnionSelection);
    fn get_union_types(&self) -> &HashMap<FullPathName, SharedUnionSelection>;
    fn add_interface_type(&mut self, name: String, interface_selection: SharedInterfaceSelection);
    fn get_interface_types(&self) -> &HashMap<FullPathName, SharedInterfaceSelection>;
}

impl ExecutableContext for OperationContext {
    fn name(&self) -> &str {
        self.get_operation_name()
    }
    fn has_variables(&self) -> bool {
        self.has_variables()
    }
    fn typedefs(&self) -> &TypeDefs {
        &self.type_defs
    }
    fn typedefs_mut(&mut self) -> &mut TypeDefs {
        &mut self.type_defs
    }
    fn get_used_fragments(
        &self,
        _name: &str,
        _ctx: &ShalomGlobalContext,
    ) -> &Vec<SharedFragmentContext> {
        self.get_used_fragments()
    }

    fn get_variable(&self, name: &str) -> Option<&crate::operation::context::OperationVariable> {
        self.get_variable(name)
    }

    fn add_union_type(&mut self, name: String, union_selection: SharedUnionSelection) {
        self.add_union_type(name, union_selection)
    }

    fn get_union_types(&self) -> &HashMap<FullPathName, SharedUnionSelection> {
        self.get_union_types()
    }

    fn add_interface_type(&mut self, name: String, interface_selection: SharedInterfaceSelection) {
        self.add_interface_type(name, interface_selection)
    }

    fn get_interface_types(&self) -> &HashMap<FullPathName, SharedInterfaceSelection> {
        self.get_interface_types()
    }
}

impl ExecutableContext for FragmentContext {
    fn name(&self) -> &str {
        self.get_fragment_name()
    }
    fn typedefs(&self) -> &TypeDefs {
        &self.type_defs
    }
    fn typedefs_mut(&mut self) -> &mut TypeDefs {
        &mut self.type_defs
    }

    fn get_used_fragments(
        &self,
        _name: &str,
        _ctx: &ShalomGlobalContext,
    ) -> &Vec<SharedFragmentContext> {
        self.get_used_fragments()
    }

    fn has_variables(&self) -> bool {
        false
    }
    fn get_variable(&self, _name: &str) -> Option<&crate::operation::context::OperationVariable> {
        None // Fragments don't have variables
    }

    fn add_union_type(&mut self, name: String, union_selection: SharedUnionSelection) {
        self.add_union_type(name, union_selection)
    }

    fn get_union_types(&self) -> &HashMap<FullPathName, SharedUnionSelection> {
        self.get_union_types()
    }

    fn add_interface_type(&mut self, name: String, interface_selection: SharedInterfaceSelection) {
        self.add_interface_type(name, interface_selection)
    }

    fn get_interface_types(&self) -> &HashMap<FullPathName, SharedInterfaceSelection> {
        self.get_interface_types()
    }
}

#[allow(clippy::too_many_arguments)]
pub(super) fn parse_selection_set<T>(
    path: &String,
    ctx: &mut T,
    global_ctx: &SharedShalomGlobalContext,
    selection_common: SelectionCommon,
    selection_orig: &apollo_compiler::executable::SelectionSet,
    field_type_orig: &FieldTypeOrig,
    arguments: Vec<crate::operation::types::FieldArgument>,
    used_fragments: &mut Vec<SharedFragmentContext>,
) -> Selection
where
    T: ExecutableContext,
{
    let full_name = path.clone();
    if let Some(selection) = ctx.get_selection(&full_name, global_ctx) {
        info!("Selection already exists");
        return selection.clone();
    }

    let kind = parse_selection_kind(
        ctx,
        global_ctx,
        path,
        selection_orig,
        field_type_orig,
        used_fragments,
    );
    let selection = Selection::new(selection_common, kind, arguments);
    ctx.add_selection(full_name, selection.clone());
    selection
}

fn parse_operation_type(operation_type: ApolloOperationType) -> OperationType {
    match operation_type {
        ApolloOperationType::Query => OperationType::Query,
        ApolloOperationType::Mutation => OperationType::Mutation,
        ApolloOperationType::Subscription => OperationType::Subscription,
    }
}

/// Recursively inject __typename into union and interface selection sets
fn inject_typename_in_selection_set(
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
    let mut used_fragments = Vec::new();
    let root_type = parse_object_selection(
        &mut ctx,
        global_ctx,
        &operation_name,
        false,
        &op.selection_set,
        &mut used_fragments,
        None, // Root operation type, not a multi-type member
    );

    // Add used fragments to operation context
    for fragment in used_fragments {
        ctx.add_used_fragment(fragment);
    }

    // Flatten used fragments to include nested fragments
    ctx.flatten_used_fragments();

    let selection = Selection::new(selection_common, SelectionKind::Object(root_type), vec![]);
    ctx.set_root_type(selection.clone());
    (&mut ctx as &mut dyn ExecutableContext).add_selection(operation_name, selection);
    Ok(Arc::new(ctx))
}

pub(crate) fn parse_document(
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

pub(crate) fn parse_fragment(
    global_ctx: &SharedShalomGlobalContext,
    mut fragment: Node<apollo_compiler::executable::Fragment>,
    fragment_ctx: &mut FragmentContext,
) -> anyhow::Result<()> {
    // Inject __typename into union and interface selections
    let schema = &global_ctx.schema_ctx.schema;
    let fragment_mut = fragment.make_mut();
    inject_typename_in_selection_set(schema, &mut fragment_mut.selection_set, global_ctx);

    let selection_set = &fragment.selection_set;
    let type_name = fragment.type_condition();
    let type_info = global_ctx
        .schema_ctx
        .get_type(&type_name.to_string())
        .unwrap();

    let selection_common = SelectionCommon {
        name: fragment_ctx.get_fragment_name().to_string(),
        description: None,
    };
    let mut used_fragments = Vec::new();

    let root_selection = match type_info {
        crate::schema::types::GraphQLAny::Object(_) => {
            let root_obj = parse_object_selection(
                fragment_ctx,
                global_ctx,
                &fragment_ctx.get_fragment_name().to_string(),
                false,
                selection_set,
                &mut used_fragments,
                None, // Fragment root object, not a multi-type member
            );
            // fragments has no arguments
            Selection::new(selection_common, SelectionKind::Object(root_obj), vec![])
        }
        crate::schema::types::GraphQLAny::Interface(interface_type) => {
            // Check if the selection set has inline fragments
            let has_inline_fragments = selection_set
                .selections
                .iter()
                .any(|sel| matches!(sel, apollo_executable::Selection::InlineFragment(_)));

            if has_inline_fragments {
                // Parse as interface selection with type discrimination
                let root_interface = parse_interface_selection(
                    fragment_ctx,
                    global_ctx,
                    &fragment_ctx.get_fragment_name().to_string(),
                    false,
                    selection_set,
                    interface_type,
                    &mut used_fragments,
                );
                Selection::new(
                    selection_common,
                    SelectionKind::Interface(root_interface),
                    vec![],
                )
            } else {
                // No inline fragments - treat as simple object selection
                let root_obj = parse_object_selection(
                    fragment_ctx,
                    global_ctx,
                    &fragment_ctx.get_fragment_name().to_string(),
                    false,
                    selection_set,
                    &mut used_fragments,
                    None,
                );
                Selection::new(selection_common, SelectionKind::Object(root_obj), vec![])
            }
        }
        _ => {
            return Err(anyhow::anyhow!(
                "Fragment {} type condition {} is not an object or interface type",
                fragment_ctx.get_fragment_name(),
                type_name
            ));
        }
    };

    for frag in used_fragments {
        fragment_ctx.add_used_fragment(frag);
    }

    fragment_ctx.set_root_type(root_selection.clone());
    let frag_name = fragment_ctx.get_fragment_name().to_string();
    (fragment_ctx as &mut dyn ExecutableContext).add_selection(frag_name, root_selection);
    Ok(())
}
