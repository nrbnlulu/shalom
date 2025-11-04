use std::collections::HashMap;
use std::path::PathBuf;
use std::sync::Arc;

use apollo_compiler::{
    ast::OperationType as ApolloOperationType, executable as apollo_executable, Name, Node, Schema,
};
use log::{info, trace};

use crate::context::{ShalomGlobalContext, SharedShalomGlobalContext};
use crate::operation::context::ExecutableContext;
use crate::operation::types::{
    FieldArgument, FieldSelectionCommon, ObjectLikeCommon,
    ObjectSelection, SelectionKind,
};
use crate::schema::types::{
    EnumType, GraphQLAny, InputFieldDefinition, ScalarType, SchemaFieldCommon,
};

use super::context::{OperationContext, SharedOpCtx};
use super::types::{
    EnumSelection, FieldSelection, InterfaceSelection, OperationType,
    ScalarSelection, SharedEnumSelection, SharedInterfaceSelection, SharedObjectSelection,
    SharedScalarSelection, UnionSelection,
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

#[derive(Debug, Hash)]
enum _FieldOrUsedFrag {
    Field(FieldSelection),
    UsedFrag(String),
}

pub(crate) fn parse_selection<T: ExecutableContext>(
    ctx: &mut T,
    global_ctx: &SharedShalomGlobalContext,
    path: &String,
    obj_like: &mut ObjectLikeCommon,
    selection: &apollo_executable::Selection,
    on_condition: &Option<String>,
) {
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
            let selection_common = FieldSelectionCommon {
                name: f_name.clone(),
                description,
            };

            let field_selection = parse_field_selection_set(
                ctx,
                &field_path,
                global_ctx,
                selection_common,
                &field.selection_set,
                f_type,
                args,
            );
            if let Some(on_condition) = &on_condition {
                obj_like
                    .type_cond_selections
                    .entry(on_condition.clone())
                    .or_insert_with(move || {
                        ObjectLikeCommon::new(path.clone(), on_condition.clone())
                    })
                    .add_selection(field_selection);
            } else {
                obj_like.add_selection(field_selection);
            }
        }
        apollo_executable::Selection::FragmentSpread(fragment_spread) => {
            let fragment_name = fragment_spread.fragment_name.to_string();
            trace!("Processing fragment spread: {}", fragment_name);

            // all fragments should be already parsed by now.
            let frag = global_ctx.get_fragment_strict(&fragment_name);
            ctx.typedefs_mut().add_used_fragment(frag.clone());
            if let Some(on_condition) = on_condition {
                obj_like
                    .type_cond_selections
                    .entry(on_condition.clone())
                    .or_insert_with(move || {
                        ObjectLikeCommon::new(path.clone(), on_condition.clone())
                    })
                    .add_used_fragment(frag.name.clone());
            } else {
                obj_like.add_used_fragment(fragment_name.clone());
            }
        }
        apollo_executable::Selection::InlineFragment(inline_fragment) => {
            let is_on_self = inline_fragment
                .type_condition
                .as_ref()
                .is_none_or(|t| t.to_string() == obj_like.schema_typename);
            let type_condition = inline_fragment.type_condition.as_ref().unwrap().to_string();

            if is_on_self {
                // just spread the selections in here.
                for selection in &inline_fragment.selection_set.selections {
                    parse_selection(ctx, global_ctx, path, obj_like, selection, &None)
                }
            } else {
                let type_condition = type_condition.to_string();

                let conditioned_path = format!("{}__{}", path, type_condition);
                let typed_obj = parse_obj_like_from_selection_set(
                    ctx,
                    global_ctx,
                    &conditioned_path,
                    type_condition.clone(),
                    &inline_fragment.selection_set,
                );
                obj_like.merge(typed_obj);
            }
        }
    }
}

pub(crate) fn parse_object_selection<T: ExecutableContext>(
    ctx: &mut T,
    global_ctx: &SharedShalomGlobalContext,
    path: &String,
    is_optional: bool,
    selection_orig: &apollo_compiler::executable::SelectionSet,
) -> SharedObjectSelection {
    trace!("Parsing object selection {:?}", selection_orig.ty);
    trace!("Path is {:?}", path);
    assert!(
        !selection_orig.selections.is_empty(),
        "Object selection must have at least one field\n \
         selection was {:?}.",
        selection_orig
    );

    let schema_typename = selection_orig.ty.to_string();

    let obj_like =
        parse_obj_like_from_selection_set(ctx, global_ctx, path, schema_typename, selection_orig);
    ObjectSelection::new(is_optional, obj_like)
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

    let obj_like = parse_obj_like_from_selection_set(
        ctx,
        global_ctx,
        path,
        union_type.name.clone(),
        selection_set,
    );
    let possible_concretes = global_ctx
        .schema_ctx
        .get_possible_concretes_for_union(&union_type);
    // Determine if we need a fallback class
    
    UnionSelection::new(union_type, obj_like, is_optional, possible_concretes)
}

pub(crate) fn parse_interface_selection<T: ExecutableContext>(
    ctx: &mut T,
    global_ctx: &SharedShalomGlobalContext,
    path: &String,
    is_optional: bool,
    selection_set: &apollo_executable::SelectionSet,
    interface_type: Arc<crate::schema::types::InterfaceType>,
) -> SharedInterfaceSelection {
    trace!("Parsing interface selection {:?}", interface_type.name);

    let obj_like = parse_obj_like_from_selection_set(
        ctx,
        global_ctx,
        path,
        interface_type.name.clone(),
        selection_set,
    );
    let possible_concretes = global_ctx
        .schema_ctx
        .get_concrete_implementors_of_interface(&interface_type.name);
    
    InterfaceSelection::new(interface_type, obj_like, is_optional, possible_concretes)
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
                    // Parse as interface selection with type discrimination
                    SelectionKind::Interface(parse_interface_selection(
                        ctx,
                        global_ctx,
                        path,
                        is_optional,
                        selection_set,
                        interface_type,
                    ))
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
                    let selection_common = FieldSelectionCommon {
                        name: path.clone(),
                        description: None,
                    };
                    let inner_selection =
                        FieldSelection::new(selection_common, of_kind.clone(), Default::default());
                    ctx.add_selection(path.clone(), inner_selection);
                }
                _ => {}
            }

            SelectionKind::new_list(is_optional, of_kind)
        }
    }
}

#[allow(clippy::too_many_arguments)]
pub(super) fn parse_field_selection_set<T: ExecutableContext>(
    ctx: &mut T,
    path: &String,
    global_ctx: &SharedShalomGlobalContext,
    selection_common: FieldSelectionCommon,
    selection_orig: &apollo_compiler::executable::SelectionSet,
    field_type_orig: &FieldTypeOrig,
    arguments: Vec<crate::operation::types::FieldArgument>,
) -> FieldSelection {
    let full_name = path.clone();
    if let Some(selection) = ctx.get_selection(&full_name) {
        info!("Selection already exists");
        return selection.clone();
    }

    let kind = parse_selection_kind(ctx, global_ctx, path, selection_orig, field_type_orig);
    let selection = FieldSelection::new(selection_common, kind, arguments);
    ctx.add_selection(full_name, selection.clone());
    selection
}

pub(crate) fn parse_obj_like_from_selection_set<T: ExecutableContext>(
    ctx: &mut T,
    global_ctx: &SharedShalomGlobalContext,
    path: &String,
    schema_typename: String,
    selection_set: &apollo_compiler::executable::SelectionSet,
) -> ObjectLikeCommon {
    let mut obj_like = ObjectLikeCommon::new(path.clone(), schema_typename);

    for selection in selection_set.selections.iter() {
        parse_selection(ctx, global_ctx, path, &mut obj_like, selection, &None);
    }
    obj_like
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
            let typename_name = Name::new("__typename").unwrap();
            let typename_field = selection_set
                .new_field(schema, typename_name)
                .expect("Failed to inject __typename");

            // Actually push the field to the selection set
            use apollo_executable::Selection;
            selection_set.push(Selection::Field(typename_field.into()));
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
    {
        let op_mut = op.make_mut();
        inject_typename_in_selection_set(schema, &mut op_mut.selection_set, global_ctx);
    }
    let op_type = parse_operation_type(op.operation_type);
    let query = op.to_string();
    let mut ctx = OperationContext::new(
        global_ctx.schema_ctx.clone(),
        operation_name.clone(),
        query,
        file_path,
        op_type,
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
    let object_like = parse_obj_like_from_selection_set(
        &mut ctx,
        global_ctx,
        &operation_name,
        op.operation_type.name().to_string(),
        &op.selection_set,
    );
    ctx.set_root_type(object_like);
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
