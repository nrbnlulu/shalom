use serde_json::{Map, Value};

use shalom_core::context::SharedShalomGlobalContext;
use shalom_core::operation::context::{ExecutableContext, SharedOpCtx};
use shalom_core::operation::fragments::SharedFragmentContext;
use shalom_core::operation::types::{FieldSelection, SelectionKind};
use shalom_core::schema::types::GraphQLAny;

use crate::cache::{CacheRecord, CacheValue, NormalizedCache, RefKind};
use crate::selection::{
    field_cache_key, field_path_segment, resolve_multitype_selections, resolve_object_selections,
};

pub struct CacheReader<'a> {
    global_ctx: SharedShalomGlobalContext,
    cache: &'a NormalizedCache,
    variables: Option<&'a Map<String, Value>>,
}

impl<'a> CacheReader<'a> {
    pub fn new(
        global_ctx: SharedShalomGlobalContext,
        cache: &'a NormalizedCache,
        variables: Option<&'a Map<String, Value>>,
    ) -> Self {
        Self {
            global_ctx,
            cache,
            variables,
        }
    }

    pub fn read_operation(&self, op_ctx: &SharedOpCtx) -> anyhow::Result<Value> {
        let root_key = match op_ctx.op_type() {
            shalom_core::operation::types::OperationType::Query => "ROOT_QUERY",
            shalom_core::operation::types::OperationType::Mutation => "ROOT_MUTATION",
            shalom_core::operation::types::OperationType::Subscription => "ROOT_SUBSCRIPTION",
        }
        .to_string();

        let root_record = self.cache.get(&root_key).cloned().unwrap_or_default();
        let selections = resolve_object_selections(op_ctx.get_root(), &self.global_ctx);
        let mut output = Map::new();

        for selection in selections {
            let field_name = selection.self_selection_name().clone();
            let cache_key = field_cache_key(&field_name, &selection.arguments, self.variables);
            let field_segment =
                field_path_segment(&field_name, &selection.arguments, self.variables);
            let field_ref_key = format!("{}_{}", root_key, field_segment);
            let cached_value = root_record.get(&cache_key);

            let value = self.read_field(&selection, cached_value, &root_key, &field_segment)?;

            output.insert(field_name.clone(), value);
            if field_name != "__typename" {
                output.insert(
                    format!("__ref_{}", field_name),
                    Value::String(field_ref_key),
                );
            }
        }

        Ok(Value::Object(output))
    }

    pub fn read_fragment(
        &self,
        fragment: &SharedFragmentContext,
        root_ref: &str,
    ) -> anyhow::Result<Value> {
        let (cached_value, ref_kind) = if let Some(locator) = self.cache.ref_locator(root_ref) {
            match self.cache.resolve_locator(locator) {
                Some(value) => (value, RefKind::Path),
                None => return Ok(Value::Null),
            }
        } else if self.cache.get(root_ref).is_some() {
            (CacheValue::Ref(root_ref.to_string()), RefKind::Id)
        } else {
            return Ok(Value::Null);
        };

        self.read_root_object(fragment, &cached_value, root_ref, ref_kind)
    }

    fn read_field(
        &self,
        selection: &FieldSelection,
        cached_value: Option<&CacheValue>,
        parent_ref_key: &str,
        field_segment: &str,
    ) -> anyhow::Result<Value> {
        match &selection.kind {
            SelectionKind::Scalar(_) | SelectionKind::Enum(_) => match cached_value {
                Some(CacheValue::Scalar(value)) => Ok(value.clone()),
                Some(_) => Err(anyhow::anyhow!(
                    "expected scalar for field {}",
                    selection.self_selection_name()
                )),
                None => Ok(Value::Null),
            },
            SelectionKind::List(list_sel) => match cached_value {
                Some(CacheValue::Scalar(value)) if value.is_null() => Ok(Value::Null),
                Some(CacheValue::List(items)) => {
                    self.read_list(list_sel, items, parent_ref_key, field_segment)
                }
                Some(_) => Err(anyhow::anyhow!(
                    "expected list for field {}",
                    selection.self_selection_name()
                )),
                None => Ok(Value::Null),
            },
            SelectionKind::Object(_) | SelectionKind::Union(_) | SelectionKind::Interface(_) => {
                match cached_value {
                    Some(CacheValue::Scalar(value)) if value.is_null() => Ok(Value::Null),
                    Some(CacheValue::Ref(_) | CacheValue::Object(_)) => self.read_object(
                        selection,
                        cached_value.expect("cache value checked"),
                        parent_ref_key,
                        field_segment,
                    ),
                    Some(_) => Err(anyhow::anyhow!(
                        "expected object for field {}",
                        selection.self_selection_name()
                    )),
                    None => Ok(Value::Null),
                }
            }
        }
    }

    fn read_object(
        &self,
        selection: &FieldSelection,
        cached_value: &CacheValue,
        parent_ref_key: &str,
        field_segment: &str,
    ) -> anyhow::Result<Value> {
        let (record, entity_key) = match cached_value {
            CacheValue::Ref(key) => (
                self.cache
                    .get(key)
                    .cloned()
                    .ok_or_else(|| anyhow::anyhow!("missing record for {key}"))?,
                Some(key.clone()),
            ),
            CacheValue::Object(record) => (record.clone(), None),
            CacheValue::Scalar(value) if value.is_null() => {
                return Ok(Value::Null);
            }
            _ => {
                return Err(anyhow::anyhow!(
                    "unexpected cache value for {}",
                    selection.self_selection_name()
                ));
            }
        };

        let (_typename, selections, is_union_interface) = match &selection.kind {
            SelectionKind::Object(obj) => (
                obj.common.schema_typename.clone(),
                resolve_object_selections(&obj.common, &self.global_ctx),
                false,
            ),
            SelectionKind::Union(union) => {
                let typename = cached_typename_from_record(&record)
                    .ok_or_else(|| anyhow::anyhow!("union selection missing __typename"))?;
                (
                    typename.clone(),
                    resolve_multitype_selections(&union.common.common, &typename, &self.global_ctx),
                    true,
                )
            }
            SelectionKind::Interface(interface) => {
                let typename = cached_typename_from_record(&record)
                    .ok_or_else(|| anyhow::anyhow!("interface selection missing __typename"))?;
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

        let path_key = format!("{}_{}", parent_ref_key, field_segment);
        let object_ref_key = if is_union_interface || entity_key.is_none() {
            path_key.clone()
        } else {
            entity_key.clone().unwrap_or(path_key.clone())
        };

        let mut output = Map::new();
        let mut ref_meta = Map::new();
        if is_union_interface || entity_key.is_none() {
            ref_meta.insert("path".to_string(), Value::String(object_ref_key.clone()));
        } else {
            ref_meta.insert("id".to_string(), Value::String(object_ref_key.clone()));
        }
        output.insert("__ref".to_string(), Value::Object(ref_meta));

        for selection in selections {
            let field_name = selection.self_selection_name().clone();
            let cache_key = field_cache_key(&field_name, &selection.arguments, self.variables);
            let field_segment =
                field_path_segment(&field_name, &selection.arguments, self.variables);
            let field_ref_key = format!("{}_{}", object_ref_key, field_segment);
            let cached_value = record.get(&cache_key);

            let value =
                self.read_field(&selection, cached_value, &object_ref_key, &field_segment)?;

            output.insert(field_name.clone(), value);
            if field_name != "__typename" {
                output.insert(
                    format!("__ref_{}", field_name),
                    Value::String(field_ref_key),
                );
            }
        }

        Ok(Value::Object(output))
    }

    fn read_list(
        &self,
        list_sel: &shalom_core::operation::types::ListSelection,
        cached_items: &[CacheValue],
        parent_ref_key: &str,
        field_segment: &str,
    ) -> anyhow::Result<Value> {
        let mut output = Vec::with_capacity(cached_items.len());
        for (idx, cached_item) in cached_items.iter().enumerate() {
            let item_segment = format!("{}[{}]", field_segment, idx);
            let value = match &list_sel.of_kind {
                SelectionKind::Scalar(_) | SelectionKind::Enum(_) => match cached_item {
                    CacheValue::Scalar(value) => value.clone(),
                    _ => return Err(anyhow::anyhow!("expected scalar list item at {idx}")),
                },
                SelectionKind::Object(_)
                | SelectionKind::Union(_)
                | SelectionKind::Interface(_) => match cached_item {
                    CacheValue::Scalar(value) if value.is_null() => Value::Null,
                    CacheValue::Ref(_) | CacheValue::Object(_) => self.read_object(
                        &FieldSelection::new(
                            selection_common_for_list_item(),
                            list_sel.of_kind.clone(),
                            Vec::new(),
                        ),
                        cached_item,
                        parent_ref_key,
                        &item_segment,
                    )?,
                    _ => return Err(anyhow::anyhow!("expected object list item at {idx}")),
                },
                SelectionKind::List(inner_list) => match cached_item {
                    CacheValue::Scalar(value) if value.is_null() => Value::Null,
                    CacheValue::List(inner_items) => {
                        self.read_list(inner_list, inner_items, parent_ref_key, &item_segment)?
                    }
                    _ => return Err(anyhow::anyhow!("expected nested list item at {idx}")),
                },
            };
            output.push(value);
        }
        Ok(Value::Array(output))
    }

    fn read_root_object(
        &self,
        fragment: &SharedFragmentContext,
        cached_value: &CacheValue,
        object_ref_key: &str,
        ref_kind: RefKind,
    ) -> anyhow::Result<Value> {
        let (record, _entity_key) = match cached_value {
            CacheValue::Ref(key) => match self.cache.get(key) {
                Some(record) => (record.clone(), Some(key.clone())),
                None => return Ok(Value::Null),
            },
            CacheValue::Object(record) => (record.clone(), None),
            CacheValue::Scalar(value) if value.is_null() => {
                return Ok(Value::Null);
            }
            _ => {
                return Err(anyhow::anyhow!(
                    "unexpected cache value for fragment {}",
                    fragment.get_fragment_name()
                ));
            }
        };

        let root_common = fragment.get_on_type();
        let (selections, is_union_interface) = match self
            .global_ctx
            .schema_ctx
            .get_type_strict(&root_common.schema_typename)
        {
            GraphQLAny::Union(_) => {
                let typename = cached_typename_from_record(&record)
                    .ok_or_else(|| anyhow::anyhow!("union selection missing __typename"))?;
                (
                    resolve_multitype_selections(root_common, &typename, &self.global_ctx),
                    true,
                )
            }
            GraphQLAny::Interface(_) => {
                let typename = cached_typename_from_record(&record)
                    .ok_or_else(|| anyhow::anyhow!("interface selection missing __typename"))?;
                (
                    resolve_multitype_selections(root_common, &typename, &self.global_ctx),
                    true,
                )
            }
            _ => (
                resolve_object_selections(root_common, &self.global_ctx),
                false,
            ),
        };

        let mut output = Map::new();
        let mut ref_meta = Map::new();
        match ref_kind {
            RefKind::Id => {
                ref_meta.insert("id".to_string(), Value::String(object_ref_key.to_string()));
            }
            RefKind::Path => {
                ref_meta.insert(
                    "path".to_string(),
                    Value::String(object_ref_key.to_string()),
                );
            }
        }
        output.insert("__ref".to_string(), Value::Object(ref_meta));

        for selection in selections {
            let field_name = selection.self_selection_name().clone();
            let cache_key = field_cache_key(&field_name, &selection.arguments, self.variables);
            let field_segment =
                field_path_segment(&field_name, &selection.arguments, self.variables);
            let field_ref_key = format!("{}_{}", object_ref_key, field_segment);
            let cached_value = record.get(&cache_key);

            let value =
                self.read_field(&selection, cached_value, object_ref_key, &field_segment)?;

            output.insert(field_name.clone(), value);
            if field_name != "__typename" {
                output.insert(
                    format!("__ref_{}", field_name),
                    Value::String(field_ref_key),
                );
            }
        }

        if is_union_interface && cached_typename_from_record(&record).is_none() {
            return Err(anyhow::anyhow!(
                "missing __typename for fragment {}",
                fragment.get_fragment_name()
            ));
        }

        Ok(Value::Object(output))
    }
}

fn cached_typename_from_record(record: &CacheRecord) -> Option<String> {
    record.get("__typename").and_then(|value| match value {
        CacheValue::Scalar(Value::String(s)) => Some(s.clone()),
        _ => None,
    })
}

fn selection_common_for_list_item() -> shalom_core::operation::types::FieldSelectionCommon {
    shalom_core::operation::types::FieldSelectionCommon {
        name: "__item".to_string(),
        description: None,
    }
}
