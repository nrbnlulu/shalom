use std::collections::HashMap;
use std::path::PathBuf;
use std::rc::Rc;

use apollo_compiler::{
    ast::OperationType as ApolloOperationType, executable as apollo_executable, Node,
};
use log::{info, trace};

use crate::context::SharedShalomGlobalContext;
use crate::operation::types::ObjectSelection;
use crate::schema::context::SharedSchemaContext;
use crate::schema::types::{
    EnumType, GraphQLAny, InputFieldDefinition, ScalarType, SchemaFieldCommon,
};

use super::context::{OperationContext, SharedOpCtx};
use super::types::{
    EnumSelection, OperationType, ScalarSelection, Selection, SelectionCommon, SharedEnumSelection,
    SharedObjectSelection, SharedScalarSelection,
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
    #[allow(unused)] parent: &Option<&Selection>,
    op_ctx: &mut OperationContext,
    schema_ctx: &SharedSchemaContext,
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
                let is_optional = match f_type {
                    apollo_compiler::ast::Type::List(_) => true,
                    apollo_compiler::ast::Type::Named(_) => true,
                    apollo_compiler::ast::Type::NonNullList(_) => false,
                    apollo_compiler::ast::Type::NonNullNamed(_) => false,
                };
                let selection_common = SelectionCommon {
                    full_name: full_path_name(&f_name, &Some(&obj_as_selection)),
                    selection_name: f_name.clone(),
                    is_optional,
                };
                let field_selection = parse_selection_set(
                    Some(&obj_as_selection),
                    op_ctx,
                    schema_ctx,
                    selection_common,
                    &field.selection_set,
                );
                obj.add_selection(field_selection);
            }
            _ => todo!("Unsupported selection type {:?}", selection),
        }
    }
    obj
}

fn parse_scalar_selection(
    selection_common: SelectionCommon,
    concrete_type: Node<ScalarType>,
) -> SharedScalarSelection {
    ScalarSelection::new(selection_common, concrete_type)
}

fn parse_selection_set(
    parent: Option<&Selection>,
    op_ctx: &mut OperationContext,
    schema_ctx: &SharedSchemaContext,
    selection_common: SelectionCommon,
    selection_orig: &apollo_compiler::executable::SelectionSet,
) -> Selection {
    let full_name = selection_common.full_name.clone();
    if let Some(selection) = op_ctx.get_selection(&full_name) {
        info!("Selection already exists");
        return selection.clone();
    }
    let schema_type = schema_ctx
        .get_type(selection_orig.ty.to_string().as_str())
        .unwrap();
    let selection: Selection = match schema_type {
        GraphQLAny::Scalar(scalar) => {
            Selection::Scalar(parse_scalar_selection(selection_common, scalar))
        }
        GraphQLAny::Object(_) => Selection::Object(parse_object_selection(
            &parent,
            op_ctx,
            schema_ctx,
            selection_common,
            selection_orig,
        )),
        GraphQLAny::Enum(_enum) => Selection::Enum(parse_enum_selection(selection_common, _enum)),
        _ => todo!("Unsupported type {:?}", schema_type),
    };

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
        let field_definition =
            SchemaFieldCommon::new(global_ctx.schema_ctx.clone(), name.clone(), &raw_type, None);
        let input_definition = InputFieldDefinition {
            field: field_definition,
            is_optional,
            default_value: variable.default_value.clone(),
        };
        ctx.add_variable(name, input_definition);
    }
    let selection_common = SelectionCommon {
        full_name: name.clone(),
        is_optional: false,
        selection_name: name.clone(),
    };
    let root_type = parse_object_selection(
        &None,
        &mut ctx,
        &global_ctx.schema_ctx,
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
        unimplemented!("Anoinymous operations are not supported")
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
