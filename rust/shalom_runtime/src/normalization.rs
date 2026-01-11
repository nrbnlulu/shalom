use std::collections::HashSet;

use serde_json::{Map, Value};

use shalom_core::{
    context::SharedShalomGlobalContext,
    operation::{
        context::{ExecutableContext, SharedOpCtx},
        types::{FieldSelection, SelectionKind},
    },
};

use crate::cache::{CacheKey, CacheLocator, CacheRecord, CacheValue, NormalizedCache};
use crate::selection::{
    field_cache_key, field_path_segment, resolve_multitype_selections, resolve_object_selections,
};

#[derive(Debug, Default)]
pub struct NormalizationResult {
    pub data: Value,
    pub changed: HashSet<CacheKey>,
}

pub struct Normalizer<'a> {
    global_ctx: SharedShalomGlobalContext,
    cache: &'a mut NormalizedCache,
    variables: Option<&'a Map<String, Value>>,
    changed: HashSet<CacheKey>,
}

impl<'a> Normalizer<'a> {
    pub fn new(
        global_ctx: SharedShalomGlobalContext,
        cache: &'a mut NormalizedCache,
        variables: Option<&'a Map<String, Value>>,
    ) -> Self {
        Self {
            global_ctx,
            cache,
            variables,
            changed: HashSet::new(),
        }
    }

    pub fn normalize_operation(
        mut self,
        op_ctx: &SharedOpCtx,
        data: Value,
    ) -> anyhow::Result<NormalizationResult> {
        let root_key = match op_ctx.op_type() {
            shalom_core::operation::types::OperationType::Query => "ROOT_QUERY",
            shalom_core::operation::types::OperationType::Mutation => "ROOT_MUTATION",
            shalom_core::operation::types::OperationType::Subscription => "ROOT_SUBSCRIPTION",
        }
        .to_string();

        let raw_obj = data
            .as_object()
            .ok_or_else(|| anyhow::anyhow!("operation data is not an object"))?;

        let cached_root = self.cache.get(&root_key).cloned().unwrap_or_default();
        let mut next_root = cached_root.clone();
        let selections = resolve_object_selections(op_ctx.get_root(), &self.global_ctx);
        let mut output = Map::new();
        let root_locator = CacheLocator::root(root_key.clone());

        for selection in selections {
            let field_name = selection.self_selection_name().clone();
            let raw_value = raw_obj.get(&field_name).cloned().unwrap_or(Value::Null);
            let field_cache_key =
                field_cache_key(&field_name, &selection.arguments, self.variables);
            let field_segment =
                field_path_segment(&field_name, &selection.arguments, self.variables);
            let field_ref_key = format!("{}_{}", root_key, field_segment);
            let cached_value = cached_root.get(&field_cache_key);
            let field_locator = root_locator.child_field(field_cache_key.clone());

            let normalized = self.normalize_field(
                &selection,
                &raw_value,
                cached_value,
                &mut next_root,
                &root_key,
                &field_segment,
                &field_ref_key,
                raw_obj.contains_key(&field_name),
                &field_cache_key,
                &field_locator,
            )?;

            output.insert(field_name.clone(), normalized);
            if field_name != "__typename" {
                output.insert(
                    format!("__ref_{}", field_name),
                    Value::String(field_ref_key),
                );
            }
        }

        self.cache.insert(root_key, next_root);

        Ok(NormalizationResult {
            data: Value::Object(output),
            changed: self.changed,
        })
    }

    fn normalize_field(
        &mut self,
        selection: &FieldSelection,
        raw_value: &Value,
        cached_value: Option<&CacheValue>,
        parent_record: &mut CacheRecord,
        parent_ref_key: &str,
        field_segment: &str,
        field_ref_key: &str,
        has_field: bool,
        field_cache_key: &str,
        field_locator: &CacheLocator,
    ) -> anyhow::Result<Value> {
        match &selection.kind {
            SelectionKind::Scalar(_) | SelectionKind::Enum(_) => {
                let changed = has_field
                    && match cached_value {
                        Some(CacheValue::Scalar(prev)) => prev != raw_value,
                        Some(_) => true,
                        None => true,
                    };
                if changed && selection.self_selection_name() != "__typename" {
                    self.changed.insert(field_ref_key.to_string());
                }
                parent_record.insert(
                    field_cache_key.to_string(),
                    CacheValue::Scalar(raw_value.clone()),
                );
                Ok(raw_value.clone())
            }
            SelectionKind::List(list_sel) => {
                if raw_value.is_null() {
                    let changed = has_field
                        && !matches!(cached_value, Some(CacheValue::Scalar(v)) if v.is_null());
                    if changed {
                        self.changed.insert(field_ref_key.to_string());
                    }
                    parent_record
                        .insert(field_cache_key.to_string(), CacheValue::Scalar(Value::Null));
                    return Ok(Value::Null);
                }

                let list_value = {
                    let raw_list = raw_value.as_array().ok_or_else(|| {
                        anyhow::anyhow!(
                            "expected list for field {}",
                            selection.self_selection_name()
                        )
                    })?;
                    let cached_list = cached_value.and_then(|v| match v {
                        CacheValue::List(items) => Some(items.as_slice()),
                        _ => None,
                    });
                    let normalized = self.normalize_list(
                        list_sel,
                        raw_list,
                        cached_list,
                        parent_ref_key,
                        field_segment,
                        field_ref_key,
                        field_locator,
                    )?;
                    parent_record.insert(
                        field_cache_key.to_string(),
                        CacheValue::List(normalized.cache),
                    );
                    Value::Array(normalized.output)
                };
                Ok(list_value)
            }
            SelectionKind::Object(_) | SelectionKind::Union(_) | SelectionKind::Interface(_) => {
                if raw_value.is_null() {
                    let changed = has_field
                        && !matches!(cached_value, Some(CacheValue::Scalar(v)) if v.is_null());
                    if changed {
                        self.changed.insert(field_ref_key.to_string());
                    }
                    parent_record
                        .insert(field_cache_key.to_string(), CacheValue::Scalar(Value::Null));
                    return Ok(Value::Null);
                }

                let raw_obj = raw_value.as_object().ok_or_else(|| {
                    anyhow::anyhow!(
                        "expected object for field {}",
                        selection.self_selection_name()
                    )
                })?;

                let (value, cache_value, object_ref_key, entity_key, is_union_interface) = self
                    .normalize_object_field(
                        selection,
                        raw_obj,
                        cached_value,
                        parent_ref_key,
                        field_segment,
                        field_locator.clone(),
                    )?;

                let had_value = matches!(
                    cached_value,
                    Some(CacheValue::Ref(_) | CacheValue::Object(_))
                );
                let ref_changed = match cached_value {
                    Some(CacheValue::Ref(prev)) => match &cache_value {
                        CacheValue::Ref(next) => prev != next,
                        _ => true,
                    },
                    Some(CacheValue::Object(_)) => matches!(cache_value, CacheValue::Ref(_)),
                    Some(CacheValue::Scalar(v)) if v.is_null() => true,
                    Some(_) => true,
                    None => true,
                };

                if (has_field && ref_changed) || (!had_value && has_field) {
                    self.changed.insert(field_ref_key.to_string());
                }

                if is_union_interface {
                    let prev_typename = cached_value.and_then(cached_typename_from_value);
                    let new_typename = raw_obj
                        .get("__typename")
                        .and_then(|v| v.as_str())
                        .map(|s| s.to_string());
                    if prev_typename != new_typename {
                        self.changed.insert(object_ref_key.clone());
                        if let Some(entity_key) = entity_key.clone() {
                            self.changed.insert(entity_key);
                        }
                    }
                }

                parent_record.insert(field_cache_key.to_string(), cache_value);
                Ok(value)
            }
        }
    }

    fn normalize_list(
        &mut self,
        list_sel: &shalom_core::operation::types::ListSelection,
        raw_list: &[Value],
        cached_list: Option<&[CacheValue]>,
        parent_ref_key: &str,
        field_segment: &str,
        field_ref_key: &str,
        list_locator: &CacheLocator,
    ) -> anyhow::Result<ListNormalization> {
        let mut out = Vec::with_capacity(raw_list.len());
        let mut new_cache_list = Vec::with_capacity(raw_list.len());

        for (idx, raw_item) in raw_list.iter().enumerate() {
            let item_segment = format!("{}[{}]", field_segment, idx);
            let item_cached = cached_list.and_then(|items| items.get(idx));
            let item_locator = list_locator.child_index(idx);
            let item_value = match &list_sel.of_kind {
                SelectionKind::Scalar(_) | SelectionKind::Enum(_) => {
                    new_cache_list.push(CacheValue::Scalar(raw_item.clone()));
                    raw_item.clone()
                }
                SelectionKind::Object(_)
                | SelectionKind::Union(_)
                | SelectionKind::Interface(_) => {
                    if raw_item.is_null() {
                        new_cache_list.push(CacheValue::Scalar(Value::Null));
                        Value::Null
                    } else {
                        let raw_obj = raw_item.as_object().ok_or_else(|| {
                            anyhow::anyhow!("expected object for list item at {idx}")
                        })?;
                        let (value, cache_value, _object_ref_key, _entity_key, _is_union_interface) =
                            self.normalize_object_field(
                                &FieldSelection::new(
                                    selection_common_for_list_item(),
                                    list_sel.of_kind.clone(),
                                    Vec::new(),
                                ),
                                raw_obj,
                                item_cached,
                                parent_ref_key,
                                &item_segment,
                                item_locator.clone(),
                            )?;
                        new_cache_list.push(cache_value);
                        value
                    }
                }
                SelectionKind::List(inner_list) => {
                    if raw_item.is_null() {
                        new_cache_list.push(CacheValue::Scalar(Value::Null));
                        Value::Null
                    } else {
                        let inner_raw = raw_item.as_array().ok_or_else(|| {
                            anyhow::anyhow!("expected nested list for item at {idx}")
                        })?;
                        let inner_cached = item_cached.and_then(|val| match val {
                            CacheValue::List(items) => Some(items.as_slice()),
                            _ => None,
                        });
                        let item_ref_key = format!("{}_{}", parent_ref_key, item_segment);
                        let normalized = self.normalize_list(
                            inner_list,
                            inner_raw,
                            inner_cached,
                            parent_ref_key,
                            &item_segment,
                            &item_ref_key,
                            &item_locator,
                        )?;
                        new_cache_list.push(CacheValue::List(normalized.cache));
                        Value::Array(normalized.output)
                    }
                }
            };
            out.push(item_value);
        }

        let structural_changed = match cached_list {
            Some(prev) => list_structure_changed(prev, &new_cache_list),
            None => true,
        };

        if structural_changed {
            self.changed.insert(field_ref_key.to_string());
        }

        Ok(ListNormalization {
            output: out,
            cache: new_cache_list,
        })
    }

    fn normalize_object_field(
        &mut self,
        selection: &FieldSelection,
        raw_obj: &Map<String, Value>,
        cached_value: Option<&CacheValue>,
        parent_ref_key: &str,
        field_segment: &str,
        object_locator: CacheLocator,
    ) -> anyhow::Result<(Value, CacheValue, CacheKey, Option<CacheKey>, bool)> {
        let (typename, selections, is_union_interface) = match &selection.kind {
            SelectionKind::Object(obj) => (
                obj.common.schema_typename.clone(),
                resolve_object_selections(&obj.common, &self.global_ctx),
                false,
            ),
            SelectionKind::Union(union) => {
                let typename = raw_obj
                    .get("__typename")
                    .and_then(|v| v.as_str())
                    .ok_or_else(|| anyhow::anyhow!("union selection missing __typename"))?
                    .to_string();
                (
                    typename.clone(),
                    resolve_multitype_selections(&union.common.common, &typename, &self.global_ctx),
                    true,
                )
            }
            SelectionKind::Interface(interface) => {
                let typename = raw_obj
                    .get("__typename")
                    .and_then(|v| v.as_str())
                    .ok_or_else(|| anyhow::anyhow!("interface selection missing __typename"))?
                    .to_string();
                (
                    typename.clone(),
                    resolve_multitype_selections(
                        &interface.common.common,
                        &typename,
                        &self.global_ctx,
                    ),
                    true,
                )
            }
            _ => return Err(anyhow::anyhow!("expected object-like selection")),
        };

        let id_value = raw_obj.get("id").and_then(coerce_id);
        let entity_key = id_value.map(|id| format!("{typename}:{id}"));
        let path_key = format!("{}_{}", parent_ref_key, field_segment);
        let object_ref_key = if is_union_interface || entity_key.is_none() {
            path_key.clone()
        } else {
            entity_key.clone().unwrap_or(path_key.clone())
        };

        if is_union_interface || entity_key.is_none() {
            self.cache
                .record_ref(object_ref_key.clone(), object_locator.clone());
        }

        let cached_record = match cached_value {
            Some(CacheValue::Ref(key)) => {
                if entity_key.as_ref() == Some(key) {
                    self.cache.get(key).cloned()
                } else {
                    None
                }
            }
            Some(CacheValue::Object(record)) => Some(record.clone()),
            _ => None,
        };

        let mut next_record = cached_record.clone().unwrap_or_default();
        let mut output = Map::new();

        let mut ref_meta = Map::new();
        if is_union_interface || entity_key.is_none() {
            ref_meta.insert("path".to_string(), Value::String(object_ref_key.clone()));
        } else {
            ref_meta.insert("id".to_string(), Value::String(object_ref_key.clone()));
        }
        output.insert("__ref".to_string(), Value::Object(ref_meta));

        let record_locator = if let Some(entity_key) = &entity_key {
            CacheLocator::root(entity_key.clone())
        } else {
            object_locator.clone()
        };

        for selection in selections {
            let field_name = selection.self_selection_name().clone();
            let raw_value = raw_obj.get(&field_name).cloned().unwrap_or(Value::Null);
            let field_cache_key =
                field_cache_key(&field_name, &selection.arguments, self.variables);
            let field_segment =
                field_path_segment(&field_name, &selection.arguments, self.variables);
            let field_ref_key = format!("{}_{}", object_ref_key, field_segment);
            let cached_value = cached_record.as_ref().and_then(|r| r.get(&field_cache_key));
            let field_locator = record_locator.child_field(field_cache_key.clone());

            let normalized = self.normalize_field(
                &selection,
                &raw_value,
                cached_value,
                &mut next_record,
                &object_ref_key,
                &field_segment,
                &field_ref_key,
                raw_obj.contains_key(&field_name),
                &field_cache_key,
                &field_locator,
            )?;

            output.insert(field_name.clone(), normalized);
            if field_name != "__typename" {
                output.insert(
                    format!("__ref_{}", field_name),
                    Value::String(field_ref_key),
                );
            }
        }

        let cache_value = if let Some(entity_key) = entity_key.clone() {
            self.cache.insert(entity_key.clone(), next_record);
            CacheValue::Ref(entity_key)
        } else {
            CacheValue::Object(next_record)
        };

        Ok((
            Value::Object(output),
            cache_value,
            object_ref_key,
            entity_key,
            is_union_interface,
        ))
    }
}

fn coerce_id(value: &Value) -> Option<String> {
    match value {
        Value::String(s) => Some(s.clone()),
        Value::Number(n) => Some(n.to_string()),
        _ => None,
    }
}

fn cached_typename_from_value(value: &CacheValue) -> Option<String> {
    match value {
        CacheValue::Ref(key) => key.split(':').next().map(|s| s.to_string()),
        CacheValue::Object(record) => record.get("__typename").and_then(|value| match value {
            CacheValue::Scalar(Value::String(s)) => Some(s.clone()),
            _ => None,
        }),
        CacheValue::Scalar(_) | CacheValue::List(_) => None,
    }
}

fn list_structure_changed(prev: &[CacheValue], next: &[CacheValue]) -> bool {
    if prev.len() != next.len() {
        return true;
    }
    for (idx, (left, right)) in prev.iter().zip(next.iter()).enumerate() {
        let left_key = list_item_identity(left, idx);
        let right_key = list_item_identity(right, idx);
        if left_key != right_key {
            return true;
        }
    }
    false
}

fn list_item_identity(value: &CacheValue, idx: usize) -> String {
    match value {
        CacheValue::Ref(key) => key.clone(),
        CacheValue::Scalar(value) => value.to_string(),
        CacheValue::Object(_) => format!("inline:{idx}"),
        CacheValue::List(_) => format!("list:{idx}"),
    }
}

fn selection_common_for_list_item() -> shalom_core::operation::types::FieldSelectionCommon {
    shalom_core::operation::types::FieldSelectionCommon {
        name: "__item".to_string(),
        description: None,
    }
}

struct ListNormalization {
    output: Vec<Value>,
    cache: Vec<CacheValue>,
}
