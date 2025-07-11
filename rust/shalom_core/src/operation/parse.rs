use std::collections::HashMap;
use std::path::PathBuf;
use std::rc::Rc;

use apollo_compiler::{
    ast::OperationType as ApolloOperationType, executable as apollo_executable, Node,
};
use log::{info, trace};

use crate::context::SharedShalomGlobalContext;
use crate::operation::types::{ObjectSelection, SelectionCommon, SelectionKind};
use crate::schema::types::{
    EnumType, GraphQLAny, InputFieldDefinition, ScalarType, SchemaFieldCommon,
};

use super::context::{OperationContext, SharedOpCtx};
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

fn parse_object_selection(
    op_ctx: &mut OperationContext,
    global_ctx: &SharedShalomGlobalContext,
    path: &String,
    is_optional: bool,
    selection_orig: &apollo_compiler::executable::SelectionSet,
    implements_node_interface: bool,
) -> SharedObjectSelection {
    trace!("Parsing object selection {:?}", selection_orig.ty);
    trace!("Path is {:?}", path);
    assert!(
        !selection_orig.selections.is_empty(),
        "Object selection must have at least one field\n \
         selection was {:?}.",
        selection_orig
    );
    let obj = ObjectSelection::new(is_optional, path.clone(), implements_node_interface);

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
                let selection_common = SelectionCommon {
                    name: f_name.clone(),
                    description,
                };

                let field_selection = parse_selection_set(
                    &field_path,
                    op_ctx,
                    global_ctx,
                    selection_common,
                    &field.selection_set,
                    f_type,
                );

                obj.add_selection(field_selection);
            }
            _ => todo!("Unsupported selection type {:?}", selection),
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

pub fn parse_selection_kind(
    op_ctx: &mut OperationContext,
    global_ctx: &SharedShalomGlobalContext,
    path: &String,
    selection_set: &apollo_executable::SelectionSet,
    field_type_orig: &FieldTypeOrig,
) -> SelectionKind {
    let is_optional = !field_type_orig.is_non_null();
    match field_type_orig {
        FieldTypeOrig::Named(name) | FieldTypeOrig::NonNullNamed(name) => {
            match global_ctx.schema_ctx.get_type(&name.to_string()).unwrap() {
                GraphQLAny::Scalar(scalar) => {
                    SelectionKind::Scalar(parse_scalar_selection(global_ctx, is_optional, scalar))
                }
                GraphQLAny::Object(obj) => SelectionKind::Object(parse_object_selection(
                    op_ctx,
                    global_ctx,
                    path,
                    is_optional,
                    selection_set,
                    global_ctx
                        .schema_ctx
                        .schema
                        .get_object(&obj.name)
                        .unwrap()
                        .implements_interfaces
                        .contains("Node"),
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
            let of_kind = parse_selection_kind(op_ctx, global_ctx, path, selection_set, of_type);
            SelectionKind::new_list(is_optional, of_kind)
        }
    }
}

fn parse_selection_set(
    path: &String,
    op_ctx: &mut OperationContext,
    global_ctx: &SharedShalomGlobalContext,
    selection_common: SelectionCommon,
    selection_orig: &apollo_compiler::executable::SelectionSet,
    field_type_orig: &FieldTypeOrig,
) -> Selection {
    let full_name = path.clone();
    if let Some(selection) = op_ctx.get_selection(&full_name) {
        info!("Selection already exists");
        return selection.clone();
    }
    let kind = parse_selection_kind(op_ctx, global_ctx, path, selection_orig, field_type_orig);
    let selection = Selection::new(selection_common, kind);
    op_ctx.add_selection(full_name, selection.clone());
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
    name: String,
    file_path: PathBuf,
) -> SharedOpCtx {
    let query = op.to_string();
    let operation_name = op
        .name
        .as_ref()
        .unwrap_or_else(|| unimplemented!("Anonymous operations are not supported"))
        .to_string();
    let mut ctx = OperationContext::new(
        global_ctx.schema_ctx.clone(),
        operation_name,
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
            is_optional,
            default_value: variable.default_value.clone(),
        };
        ctx.add_variable(name, input_definition);
    }

    let selection_common = SelectionCommon {
        name: name.clone(),
        description: None,
    };
    let root_type =
        parse_object_selection(&mut ctx, global_ctx, &name, false, &op.selection_set, false);
    ctx.set_root_type(Selection::new(
        selection_common,
        SelectionKind::Object(root_type),
    ));
    Rc::new(ctx)
}

pub(crate) fn parse_document(
    global_ctx: &SharedShalomGlobalContext,
    source: &str,
    doc_path: &PathBuf,
) -> anyhow::Result<HashMap<String, SharedOpCtx>> {
    let mut ret = HashMap::new();
    let mut parser = apollo_compiler::parser::Parser::new();
    let schema = global_ctx.schema_ctx.schema.clone();
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
            parse_operation(global_ctx, op.clone(), name, doc_path.clone()),
        );
    }
    Ok(ret)
}
