use std::collections::HashSet;

use serde_json::{Map, Value};

use shalom_core::{
    context::SharedShalomGlobalContext,
    operation::types::{ArgumentValue, FieldArgument, FieldSelection, InlineValueArg},
};

pub fn resolve_object_selections(
    object: &shalom_core::operation::types::ObjectLikeCommon,
    ctx: &SharedShalomGlobalContext,
) -> Vec<FieldSelection> {
    object
        .get_all_selections_that_apply_on_this_type_only(ctx)
        .into_iter()
        .collect()
}

pub fn resolve_multitype_selections(
    object: &shalom_core::operation::types::ObjectLikeCommon,
    typename: &str,
    ctx: &SharedShalomGlobalContext,
) -> Vec<FieldSelection> {
    let mut selections = HashSet::new();
    fn collect(
        root_type: &str,
        current_obj: &shalom_core::operation::types::ObjectLikeCommon,
        ctx: &SharedShalomGlobalContext,
        selections: &mut HashSet<FieldSelection>,
    ) {
        let schema_type = ctx.schema_ctx.get_type_strict(&current_obj.schema_typename);
        let include_shared = match schema_type {
            shalom_core::schema::types::GraphQLAny::Union(_) => true,
            _ => ctx
                .schema_ctx
                .is_type_same_or_implementing_interface(root_type, &current_obj.schema_typename),
        };
        if include_shared {
            selections.extend(current_obj.selections.iter().cloned());
        }

        for frag_name in current_obj.used_fragments.iter() {
            let fragment = ctx.get_fragment_strict(frag_name);
            collect(root_type, fragment.get_on_type(), ctx, selections);
        }

        for inline_frag in current_obj.used_inline_frags.values() {
            collect(root_type, &inline_frag.common, ctx, selections);
        }

        if let Some(type_cond) = current_obj.type_cond_selections.get(root_type) {
            collect(root_type, type_cond, ctx, selections);
        }
    }

    collect(typename, object, ctx, &mut selections);
    selections.into_iter().collect()
}

/// Returns the names of all directly-used @observe fragments in this selection.
pub fn selection_get_observed_fragments(
    selection: &FieldSelection,
    ctx: &SharedShalomGlobalContext,
) -> Vec<String> {
    fn collect_observed(
        common: &shalom_core::operation::types::ObjectLikeCommon,
        ctx: &SharedShalomGlobalContext,
        observed: &mut Vec<String>,
    ) {
        for frag_name in &common.used_fragments {
            if let Some(fragment) = ctx.get_fragment(frag_name) {
                if fragment.is_observe() {
                    observed.push(frag_name.clone());
                }
            }
        }
    }

    let mut observed = Vec::new();
    match &selection.kind {
        shalom_core::operation::types::SelectionKind::Object(obj) => {
            collect_observed(&obj.common, ctx, &mut observed)
        }
        shalom_core::operation::types::SelectionKind::Union(union) => {
            collect_observed(&union.common.common, ctx, &mut observed)
        }
        shalom_core::operation::types::SelectionKind::Interface(interface) => {
            collect_observed(&interface.common.common, ctx, &mut observed)
        }
        _ => {}
    }
    observed
}

pub fn selection_has_observed_fragment(
    selection: &FieldSelection,
    ctx: &SharedShalomGlobalContext,
) -> bool {
    !selection_get_observed_fragments(selection, ctx).is_empty()
}

/// Cache key for a field: `fieldName` or `fieldName({"arg":"val",...})` (JSON, sorted keys).
pub fn field_cache_key(
    field_name: &str,
    args: &[FieldArgument],
    vars: Option<&Map<String, Value>>,
) -> String {
    if args.is_empty() {
        return field_name.to_string();
    }
    let mut sorted_args: Vec<(String, Value)> = args
        .iter()
        .map(|arg| (arg.name.clone(), arg_value_to_json(&arg.value, vars)))
        .collect();
    sorted_args.sort_by(|a, b| a.0.cmp(&b.0));
    let obj: serde_json::Map<String, Value> = sorted_args
        .into_iter()
        .map(|(k, v)| (k, sort_json_value(v)))
        .collect();
    format!("{}({})", field_name, serde_json::to_string(&obj).expect("args to json"))
}

/// Path segment for a field — same format as `field_cache_key`.
pub fn field_path_segment(
    field_name: &str,
    args: &[FieldArgument],
    vars: Option<&Map<String, Value>>,
) -> String {
    field_cache_key(field_name, args, vars)
}

fn arg_value_to_json(arg_value: &ArgumentValue, vars: Option<&Map<String, Value>>) -> Value {
    match arg_value {
        ArgumentValue::VariableUse(var) => {
            let name = var.common.name.as_str();
            if let Some(vars) = vars {
                if let Some(val) = vars.get(name) {
                    return val.clone();
                }
            }
            if let Some(default) = &var.default_value {
                return serde_json::from_str::<Value>(&default.to_string())
                    .unwrap_or(Value::Null);
            }
            if var.is_optional {
                Value::Null
            } else {
                Value::Null
            }
        }
        ArgumentValue::InlineValue { value } => match value {
            InlineValueArg::Scalar { value } => {
                serde_json::from_str::<Value>(value).unwrap_or(Value::String(value.clone()))
            }
            InlineValueArg::Enum { value } => Value::String(value.clone()),
            InlineValueArg::List { items, .. } => {
                Value::Array(items.iter().map(|item| arg_value_to_json(item, vars)).collect())
            }
            InlineValueArg::Object { fields, .. } => {
                let map: serde_json::Map<String, Value> = fields
                    .iter()
                    .map(|(k, v)| (k.clone(), arg_value_to_json(v, vars)))
                    .collect();
                Value::Object(map)
            }
        },
    }
}

fn sort_json_value(value: Value) -> Value {
    match value {
        Value::Object(map) => {
            let mut sorted: Vec<(String, Value)> = map.into_iter().collect();
            sorted.sort_by(|a, b| a.0.cmp(&b.0));
            Value::Object(
                sorted
                    .into_iter()
                    .map(|(k, v)| (k, sort_json_value(v)))
                    .collect(),
            )
        }
        Value::Array(items) => Value::Array(items.into_iter().map(sort_json_value).collect()),
        other => other,
    }
}

pub fn serialize_json_value(value: &Value) -> String {
    serde_json::to_string(&sort_json_value(value.clone())).unwrap_or_default()
}
