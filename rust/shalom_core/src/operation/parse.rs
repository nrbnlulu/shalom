use std::collections::HashMap;
use std::path::PathBuf;
use std::rc::Rc;

use apollo_compiler::{
    ast::OperationType as ApolloOperationType, executable as apollo_executable, Node,
};
use log::{info, trace};

use crate::context::SharedShalomGlobalContext;
use crate::operation::types::ObjectSelection;
use crate::schema::types::{
    EnumType, GraphQLAny, InputFieldDefinition, ScalarType, SchemaFieldCommon,
};

use super::context::{OperationContext, SharedOpCtx};
use super::types::{
    EnumSelection, OperationType, ScalarSelection, Selection, SelectionCommon, SharedEnumSelection,
    SharedObjectSelection, SharedScalarSelection, TypePath,
};

fn full_path_name(this_name: &String, parent: &Option<&Selection>) -> String {
    match parent {
        Some(parent) => format!("{}_{}", parent.self_full_path_name(), this_name),
        None => this_name.clone(),
    }
}

fn parse_enum_selection(
    selection_common: SelectionCommon,
    concrete_type: Node<EnumType>,
) -> SharedEnumSelection {
    EnumSelection::new(selection_common, concrete_type)
}

fn parse_object_selection(
    _parent: &Option<&Selection>,
    op_ctx: &mut OperationContext,
    global_ctx: &SharedShalomGlobalContext,
    selection_common: SelectionCommon,
    selection_orig: &apollo_compiler::executable::SelectionSet,
) -> SharedObjectSelection {
    trace!("Parsing object selection {:?}", selection_common);

    assert!(
        !selection_orig.selections.is_empty(),
        "Object selection must have at least one field\n \
         selection was {:?}.",
        selection_orig
    );
    let obj = ObjectSelection::new(selection_common);
    let obj_as_selection = Selection::Object(obj.clone());

    for selection in selection_orig.selections.iter() {
        match selection {
            apollo_executable::Selection::Field(field) => {
                let f_name = field.name.clone().to_string();
                let f_type = field.ty();

                let is_optional = !f_type.is_non_null();
                let selection_common = SelectionCommon {
                    full_name: full_path_name(&f_name, &Some(&obj_as_selection)),
                    selection_name: f_name.clone(),
                    is_optional,
                    type_path: None, // Will be set in parse_selection_set_with_type
                };

                let field_selection = parse_selection_set_with_type(
                    Some(&obj_as_selection),
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

fn get_base_type_name(ty: &apollo_compiler::ast::Type) -> &str {
    match ty {
        apollo_compiler::ast::Type::Named(name) => name,
        apollo_compiler::ast::Type::NonNullNamed(name) => name,
        apollo_compiler::ast::Type::List(inner_ty) => get_base_type_name(inner_ty),
        apollo_compiler::ast::Type::NonNullList(inner_ty) => get_base_type_name(inner_ty),
    }
}

fn parse_selection_set_with_type(
    parent: Option<&Selection>,
    op_ctx: &mut OperationContext,
    global_ctx: &SharedShalomGlobalContext,
    mut selection_common: SelectionCommon,
    selection_orig: &apollo_compiler::executable::SelectionSet,
    ty: &apollo_compiler::ast::Type,
) -> Selection {
    let full_name = selection_common.full_name.clone();
    if let Some(selection) = op_ctx.get_selection(&full_name) {
        info!("Selection already exists");
        return selection.clone();
    }

    // Add type path information
    selection_common.type_path = extract_type_path(ty);

    let base_type_name = get_base_type_name(ty);

    let schema_type = global_ctx
        .schema_ctx
        .get_type(&base_type_name.to_string())
        .unwrap();

    let selection: Selection = match schema_type {
        GraphQLAny::Scalar(scalar) => {
            Selection::Scalar(parse_scalar_selection(global_ctx, selection_common, scalar))
        }
        GraphQLAny::Object(_) => Selection::Object(parse_object_selection(
            &parent,
            op_ctx,
            global_ctx,
            selection_common,
            selection_orig,
        )),
        GraphQLAny::Enum(_enum) => Selection::Enum(parse_enum_selection(selection_common, _enum)),
        _ => todo!("Unsupported type {:?}", schema_type),
    };

    op_ctx.add_selection(full_name, selection.clone());
    selection
}

fn parse_scalar_selection(
    ctx: &SharedShalomGlobalContext,
    selection_common: SelectionCommon,
    concrete_type: Node<ScalarType>,
) -> SharedScalarSelection {
    let scalar_name = concrete_type.name.to_string();
    let is_custom_scalar = ctx.find_custom_scalar(&scalar_name).is_some();

    ScalarSelection::new(selection_common, concrete_type, is_custom_scalar)
}

fn extract_type_path(ty: &apollo_compiler::ast::Type) -> Option<TypePath> {
    match ty {
        apollo_compiler::ast::Type::List(inner)
        | apollo_compiler::ast::Type::NonNullList(inner) => {
            let item_optional = match inner.as_ref() {
                apollo_compiler::ast::Type::Named(_) => true,
                apollo_compiler::ast::Type::NonNullNamed(_) => false,
                apollo_compiler::ast::Type::List(_)
                | apollo_compiler::ast::Type::NonNullList(_) => {
                    return extract_type_path(inner);
                }
            };
            Some(TypePath {
                is_list: true,
                list_item_optional: Some(item_optional),
            })
        }
        _ => None,
    }
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
        full_name: name.clone(),
        is_optional: false,
        selection_name: name.clone(),
        type_path: None,
    };
    let root_type = parse_object_selection(
        &None,
        &mut ctx,
        global_ctx,
        selection_common,
        &op.selection_set,
    );
    ctx.set_root_type(root_type);
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
