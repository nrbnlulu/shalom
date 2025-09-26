use std::collections::HashMap;
use std::path::PathBuf;
use std::rc::Rc;
use std::sync::Arc;

use apollo_compiler::{
    ast::OperationType as ApolloOperationType, executable as apollo_executable, Node,
};
use log::{info, trace};

use crate::context::SharedShalomGlobalContext;
use crate::operation::types::{FieldArgument, ObjectSelection, SelectionCommon, SelectionKind};
use crate::schema::types::{
    EnumType, GraphQLAny, InputFieldDefinition, ScalarType, SchemaFieldCommon,
};

use super::context::{OperationContext, SharedOpCtx};
use super::fragments::{FragmentContext, SharedFragmentContext};
use super::types::{
    EnumSelection, OperationType, ScalarSelection, Selection, SharedEnumSelection,
    SharedObjectSelection, SharedScalarSelection,
};

fn full_path_name(this_name: &String, parent_path: &String) -> String {
    format!("{}_{}", parent_path, this_name)
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
    local_fragments: Option<&HashMap<String, SharedFragmentContext>>,
) -> SharedObjectSelection
where
    T: SelectionContext,
{
    trace!("Parsing object selection {:?}", selection_orig.ty);
    trace!("Path is {:?}", path);
    assert!(
        !selection_orig.selections.is_empty(),
        "Object selection must have at least one field\n \
         selection was {:?}.",
        selection_orig
    );
    let obj = ObjectSelection::new(is_optional, path.clone(), selection_orig.ty.to_string());

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
                let args: Vec<crate::operation::types::FieldArgument> = field
                    .arguments
                    .iter()
                    .map(|arg| match arg.value.as_ref() {
                        apollo_executable::Value::Variable(var_name) => {
                            let op_var = ctx.get_variable(var_name).unwrap().clone();

                            let value =
                                crate::operation::types::ArgumentValue::VariableUse(op_var.clone());
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

                            let inline_val = crate::operation::types::ArgumentValue::InlineValue {
                                value: arg.value.to_string(),
                            };
                            FieldArgument {
                                name: arg.name.to_string(),
                                value: inline_val,
                                default_value: arg_def.and_then(|def| {
                                    def.default_value.as_ref().map(|v| v.to_string())
                                }),
                            }
                        }
                    })
                    .collect();
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
                    local_fragments,
                );

                obj.add_selection(field_selection);
            }
            apollo_executable::Selection::FragmentSpread(fragment_spread) => {
                let fragment_name = fragment_spread.fragment_name.to_string();
                trace!("Processing fragment spread: {}", fragment_name);

                // First try local fragments, then global
                let fragment_found = if let Some(local_fragments) = local_fragments {
                    if let Some(fragment_ctx) = local_fragments.get(&fragment_name) {
                        // Add the fragment's selections to this object
                        if let Some(root_selection) = fragment_ctx.get_root_type() {
                            if let SelectionKind::Object(fragment_obj) = &root_selection.kind {
                                for fragment_selection in fragment_obj.selections.borrow().iter() {
                                    obj.add_selection(fragment_selection.clone());
                                }
                            }
                        }
                        true
                    } else if let Some(fragment_ctx) = global_ctx.get_fragment(&fragment_name) {
                        // Add the fragment's selections to this object
                        if let Some(root_selection) = fragment_ctx.get_root_type() {
                            if let SelectionKind::Object(fragment_obj) = &root_selection.kind {
                                for fragment_selection in fragment_obj.selections.borrow().iter() {
                                    obj.add_selection(fragment_selection.clone());
                                }
                            }
                        }
                        true
                    } else {
                        false
                    }
                } else if let Some(fragment_ctx) = global_ctx.get_fragment(&fragment_name) {
                    // Add the fragment's selections to this object
                    if let Some(root_selection) = fragment_ctx.get_root_type() {
                        if let SelectionKind::Object(fragment_obj) = &root_selection.kind {
                            for fragment_selection in fragment_obj.selections.borrow().iter() {
                                obj.add_selection(fragment_selection.clone());
                            }
                        }
                    }
                    true
                } else {
                    false
                };

                if !fragment_found {
                    // Fragment not found - this might be a forward reference or missing fragment
                    trace!("Fragment {} not found, skipping", fragment_name);
                }
            }
            apollo_executable::Selection::InlineFragment(_inline_fragment) => {
                // TODO: Handle inline fragments
                todo!("Inline fragments not yet supported");
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

pub fn parse_selection_kind<T>(
    ctx: &mut T,
    global_ctx: &SharedShalomGlobalContext,
    path: &String,
    selection_set: &apollo_executable::SelectionSet,
    field_type_orig: &FieldTypeOrig,
    local_fragments: Option<&HashMap<String, SharedFragmentContext>>,
) -> SelectionKind
where
    T: SelectionContext,
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
                    local_fragments,
                )),
                GraphQLAny::Enum(_enum) => {
                    SelectionKind::Enum(parse_enum_selection(is_optional, _enum))
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
                local_fragments,
            );
            SelectionKind::new_list(is_optional, of_kind)
        }
    }
}

// Trait to abstract over OperationContext and FragmentContext
pub trait SelectionContext {
    fn get_selection(&self, name: &str) -> Option<Selection>;
    fn add_selection(&mut self, name: String, selection: Selection);
    fn get_variable(&self, name: &str) -> Option<&crate::operation::context::OperationVariable>;
}

impl SelectionContext for OperationContext {
    fn get_selection(&self, name: &str) -> Option<Selection> {
        self.get_selection(&name.to_string())
    }

    fn add_selection(&mut self, name: String, selection: Selection) {
        self.add_selection(name, selection)
    }

    fn get_variable(&self, name: &str) -> Option<&crate::operation::context::OperationVariable> {
        self.get_variable(name)
    }
}

impl SelectionContext for FragmentContext {
    fn get_selection(&self, name: &str) -> Option<Selection> {
        self.get_selection(&name.to_string())
    }

    fn add_selection(&mut self, name: String, selection: Selection) {
        self.add_selection(name, selection)
    }

    fn get_variable(&self, _name: &str) -> Option<&crate::operation::context::OperationVariable> {
        None // Fragments don't have variables
    }
}

fn parse_selection_set<T>(
    path: &String,
    ctx: &mut T,
    global_ctx: &SharedShalomGlobalContext,
    selection_common: SelectionCommon,
    selection_orig: &apollo_compiler::executable::SelectionSet,
    field_type_orig: &FieldTypeOrig,
    arguments: Vec<crate::operation::types::FieldArgument>,
    local_fragments: Option<&HashMap<String, SharedFragmentContext>>,
) -> Selection
where
    T: SelectionContext,
{
    let full_name = path.clone();
    if let Some(selection) = ctx.get_selection(&full_name) {
        info!("Selection already exists");
        return selection.clone();
    }

    let kind = parse_selection_kind(
        ctx,
        global_ctx,
        path,
        selection_orig,
        field_type_orig,
        local_fragments,
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

fn parse_operation(
    global_ctx: &SharedShalomGlobalContext,
    op: Node<apollo_compiler::executable::Operation>,
    operation_name: String,
    file_path: PathBuf,
) -> anyhow::Result<SharedOpCtx> {
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
        None,
    );
    let selection = Selection::new(selection_common, SelectionKind::Object(root_type), vec![]);
    ctx.set_root_type(selection.clone());
    ctx.add_selection(operation_name, selection);
    Ok(Rc::new(ctx))
}

// Parse fragments from executable document
pub(crate) fn parse_fragments_from_document(
    global_ctx: &SharedShalomGlobalContext,
    source: &str,
    doc_path: &PathBuf,
) -> anyhow::Result<HashMap<String, SharedFragmentContext>> {
    let mut ret = HashMap::new();
    let schema = global_ctx.schema_ctx.schema.clone();
    let mut parser = apollo_compiler::parser::Parser::new();
    let doc_orig = parser
        .parse_executable(&schema, source, doc_path)
        .map_err(|e| anyhow::anyhow!("Failed to parse document: {}", e))?;
    let doc_orig = doc_orig.validate(&schema).expect("doc is not valid");

    // First pass: Create fragment contexts without processing spreads
    let mut fragment_contexts: HashMap<String, FragmentContext> = HashMap::new();
    for (name, fragment) in doc_orig.fragments.iter() {
        let fragment_name = name.to_string();
        let fragment_raw = fragment.to_string();
        let type_condition = fragment.type_condition().to_string();

        let ctx = FragmentContext::new(
            global_ctx.schema_ctx.clone(),
            fragment_name.clone(),
            fragment_raw,
            doc_path.clone(),
            type_condition,
        );
        fragment_contexts.insert(fragment_name, ctx);
    }

    // Create shared references for local cross-referencing
    let local_fragments: HashMap<String, SharedFragmentContext> = fragment_contexts
        .iter()
        .map(|(name, ctx)| (name.clone(), Arc::new(ctx.clone())))
        .collect();

    // Second pass: Process fragment selections with spreads
    for (name, fragment) in doc_orig.fragments.iter() {
        let fragment_name = name.to_string();
        let mut ctx = fragment_contexts.remove(&fragment_name).unwrap();

        // Parse the fragment's selection set as an object, passing local fragments for resolution
        let obj = parse_object_selection(
            &mut ctx,
            global_ctx,
            &fragment_name,
            false,
            &fragment.selection_set,
            Some(&local_fragments),
        );

        let selection_common = SelectionCommon {
            name: fragment_name.clone(),
            description: None,
        };

        let selection = Selection::new(selection_common, SelectionKind::Object(obj), vec![]);
        ctx.set_root_type(selection.clone());
        ctx.add_selection(fragment_name.clone(), selection);

        ret.insert(fragment_name, Arc::new(ctx));
    }

    Ok(ret)
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
