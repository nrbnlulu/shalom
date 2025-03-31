use std::collections::HashMap;
use std::path::PathBuf;
use std::sync::Arc;

use apollo_compiler::validation::Valid;
use apollo_compiler::{executable as apollo_executable, ExecutableDocument, Node};
use log::info;

use crate::operation::types::ObjectSelection;
use crate::schema::context::SharedSchemaContext;

use super::context::{OperationContext, SharedOpCtx, SharedShalomGlobalContext};
use super::types::{Selection, SharedObjectSelection};

fn parse_object_selection(
    parent: Option<Selection>,
    op_ctx: &SharedOpCtx,
    schema_ctx: &SharedSchemaContext,
    selection_orig: &apollo_compiler::executable::SelectionSet,
    name: String,
) -> SharedObjectSelection {
    assert!(
        !selection_orig.selections.is_empty(),
        "Object selection must have at least one field"
    );
    let obj = ObjectSelection::new(parent, name.clone());
    let obj_as_selection = Selection::Object(obj.clone());

    for selection in selection_orig.selections.iter() {
        match selection {
            apollo_executable::Selection::Field(field) => {
                let f_name = field.name.clone().to_string();
                let field_selection = parse_selection_set(
                    Some(obj_as_selection.clone()),
                    op_ctx,
                    schema_ctx,
                    &field.selection_set,
                    f_name,
                );
                obj.add_selection(field_selection);
            }
            _ => todo!("Unsupported selection type {:?}", selection),
        }
    }
    obj
}

fn parse_selection_set(
    parent: Option<Selection>,
    op_ctx: &SharedOpCtx,
    schema_ctx: &SharedSchemaContext,
    selection_orig: &apollo_compiler::executable::SelectionSet,
    name: String,
) -> Selection {
    let out;
    let full_name = match parent.clone() {
        Some(selection) => selection.combine_full_name(&name),
        _ => name.clone(),
    };
    if let Some(selection) = op_ctx.get_selection(&full_name) {
        info!("Selection already exists");
        return selection.clone();
    }
    // thats a scalar no inner selections
    if selection_orig.selections.is_empty() {
        todo!("parse scalar")
    } else {
        out = Selection::Object(parse_object_selection(
            parent,
            op_ctx,
            schema_ctx,
            selection_orig,
            name.clone(),
        ));
    }
    op_ctx.add_selection(name.clone(), out.clone());
    out
}

fn parse_operation(
    global_ctx: &SharedShalomGlobalContext,
    op: Node<apollo_compiler::executable::Operation>,
    name: String,
    file_path: PathBuf,
) -> SharedOpCtx {
    let selection_set = vec![];
    let ctx = OperationContext::new(global_ctx.schema_ctx.clone(), file_path);
    todo!("")
}

pub(crate) fn parse_document(
    global_ctx: &SharedShalomGlobalContext,
    doc_orig: &Valid<ExecutableDocument>,
) -> HashMap<String, SharedOpCtx> {
    let mut ret = HashMap::new();
    if doc_orig.operations.anonymous.is_some() {
        unimplemented!("Anonymouse operations are not supported")
    }
    for (name, op) in doc_orig.operations.named.iter() {
        let name = name.to_string();
        ret.insert(name.clone(), parse_operation(global_ctx, op.clone(), name));
    }
    ret
}
