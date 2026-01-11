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

pub fn selection_has_subscribeable_fragment(
    selection: &FieldSelection,
    ctx: &SharedShalomGlobalContext,
) -> bool {
    fn object_has_subscribeable_fragment(
        common: &shalom_core::operation::types::ObjectLikeCommon,
        ctx: &SharedShalomGlobalContext,
        visited: &mut HashSet<String>,
    ) -> bool {
        for frag_name in &common.used_fragments {
            if !visited.insert(frag_name.clone()) {
                continue;
            }
            if let Some(fragment) = ctx.get_fragment(frag_name) {
                if fragment.is_subscribeable() {
                    return true;
                }
            }
        }

        for inline in common.used_inline_frags.values() {
            if object_has_subscribeable_fragment(&inline.common, ctx, visited) {
                return true;
            }
        }

        for type_cond in common.type_cond_selections.values() {
            if object_has_subscribeable_fragment(type_cond, ctx, visited) {
                return true;
            }
        }

        false
    }

    let mut visited = HashSet::new();
    match &selection.kind {
        shalom_core::operation::types::SelectionKind::Object(obj) => {
            object_has_subscribeable_fragment(&obj.common, ctx, &mut visited)
        }
        shalom_core::operation::types::SelectionKind::Union(union) => {
            object_has_subscribeable_fragment(&union.common.common, ctx, &mut visited)
        }
        shalom_core::operation::types::SelectionKind::Interface(interface) => {
            object_has_subscribeable_fragment(&interface.common.common, ctx, &mut visited)
        }
        _ => false,
    }
}

pub fn field_cache_key(
    field_name: &str,
    args: &[FieldArgument],
    vars: Option<&Map<String, Value>>,
) -> String {
    if args.is_empty() {
        field_name.to_string()
    } else {
        let segments = args
            .iter()
            .map(|arg| {
                format!(
                    "{}:{}",
                    arg.name,
                    serialize_argument_value(&arg.value, vars)
                )
            })
            .collect::<Vec<_>>()
            .join("_");
        format!("{}_{}", field_name, segments)
    }
}

pub fn field_path_segment(
    field_name: &str,
    args: &[FieldArgument],
    vars: Option<&Map<String, Value>>,
) -> String {
    if args.is_empty() {
        field_name.to_string()
    } else {
        let segments = args
            .iter()
            .map(|arg| {
                format!(
                    "{}:{}",
                    arg.name,
                    serialize_argument_value(&arg.value, vars)
                )
            })
            .collect::<Vec<_>>()
            .join("$");
        format!("{}${}", field_name, segments)
    }
}

pub fn serialize_argument_value(
    arg_value: &ArgumentValue,
    vars: Option<&Map<String, Value>>,
) -> String {
    match arg_value {
        ArgumentValue::VariableUse(var) => serialize_variable_value(var, vars),
        ArgumentValue::InlineValue { value } => match value {
            InlineValueArg::Scalar { value } => {
                if let Ok(parsed) = serde_json::from_str::<Value>(value) {
                    serialize_json_value(&parsed)
                } else {
                    value.clone()
                }
            }
            InlineValueArg::Enum { value } => value.clone(),
            InlineValueArg::List { items, .. } => {
                let inner = items
                    .iter()
                    .map(|item| serialize_argument_value(item, vars))
                    .collect::<Vec<_>>()
                    .join(",");
                format!("[{}]", inner)
            }
            InlineValueArg::Object { fields, .. } => {
                let inner = fields
                    .iter()
                    .map(|(name, value)| {
                        format!("{}:{}", name, serialize_argument_value(value, vars))
                    })
                    .collect::<Vec<_>>()
                    .join(",");
                format!("{{{}}}", inner)
            }
        },
    }
}

pub fn serialize_variable_value(
    var: &shalom_core::schema::types::InputFieldDefinition,
    vars: Option<&Map<String, Value>>,
) -> String {
    let name = var.common.name.as_str();
    let entry = vars.and_then(|vars| vars.get(name));
    if entry.is_none() {
        if let Some(default_value) = &var.default_value {
            return default_value.to_string();
        }
        if var.is_maybe {
            return "None".to_string();
        }
        if var.is_optional {
            return "null".to_string();
        }
        return "null".to_string();
    }
    let value = entry.unwrap();
    serialize_json_value(value)
}

pub fn serialize_json_value(value: &Value) -> String {
    match value {
        Value::Null => "null".to_string(),
        Value::Bool(b) => b.to_string(),
        Value::Number(n) => n.to_string(),
        Value::String(s) => s.clone(),
        Value::Array(items) => {
            let inner = items
                .iter()
                .map(serialize_json_value)
                .collect::<Vec<_>>()
                .join(",");
            format!("[{}]", inner)
        }
        Value::Object(map) => {
            let mut keys: Vec<&String> = map.keys().collect();
            keys.sort();
            let inner = keys
                .into_iter()
                .map(|key| format!("{}:{}", key, serialize_json_value(&map[key])))
                .collect::<Vec<_>>()
                .join(",");
            format!("{{{}}}", inner)
        }
    }
}
