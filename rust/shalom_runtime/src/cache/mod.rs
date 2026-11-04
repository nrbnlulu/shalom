use std::collections::{HashMap, HashSet};
use std::fmt::Write;

use serde_json::Value;

pub type CacheKey = String;
pub type CacheRecord = HashMap<String, CacheValue>;

#[derive(Debug, Clone, PartialEq)]
pub enum CacheValue {
    Scalar(Value),
    List(Vec<CacheValue>),
    Object(CacheRecord),
    Ref(CacheKey),
}

impl CacheValue {
    pub fn as_ref_key(&self) -> Option<&str> {
        match self {
            CacheValue::Ref(key) => Some(key.as_str()),
            _ => None,
        }
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum RefKind {
    Id,
    Path,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum LocatorSegment {
    Field(CacheKey),
    Index(usize),
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct CacheLocator {
    pub base: CacheKey,
    pub path: Vec<LocatorSegment>,
}

impl CacheLocator {
    pub fn root(base: CacheKey) -> Self {
        Self {
            base,
            path: Vec::new(),
        }
    }

    pub fn child_field(&self, key: CacheKey) -> Self {
        let mut path = self.path.clone();
        path.push(LocatorSegment::Field(key));
        Self {
            base: self.base.clone(),
            path,
        }
    }

    pub fn child_index(&self, index: usize) -> Self {
        let mut path = self.path.clone();
        path.push(LocatorSegment::Index(index));
        Self {
            base: self.base.clone(),
            path,
        }
    }

    pub fn to_path_key(&self) -> String {
        let mut key = self.base.clone();
        for segment in &self.path {
            match segment {
                LocatorSegment::Field(f) => {
                    key.push('.');
                    key.push_str(f);
                }
                LocatorSegment::Index(i) => {
                    let _ = write!(key, "[{i}]");
                }
            }
        }
        key
    }
}

#[derive(Debug, Default)]
pub struct NormalizedCache {
    entries: HashMap<CacheKey, CacheRecord>,
    ref_index: HashMap<CacheKey, CacheLocator>,
}

impl NormalizedCache {
    pub fn new() -> Self {
        Self {
            entries: HashMap::new(),
            ref_index: HashMap::new(),
        }
    }

    pub fn clear(&mut self) {
        self.entries.clear();
        self.ref_index.clear();
    }

    pub fn get(&self, key: &str) -> Option<&CacheRecord> {
        self.entries.get(key)
    }

    pub fn get_mut(&mut self, key: &str) -> Option<&mut CacheRecord> {
        self.entries.get_mut(key)
    }

    pub fn get_or_insert(&mut self, key: CacheKey) -> &mut CacheRecord {
        self.entries.entry(key).or_default()
    }

    pub fn insert(&mut self, key: CacheKey, record: CacheRecord) {
        self.entries.insert(key, record);
    }

    pub fn remove(&mut self, key: &str) -> Option<CacheRecord> {
        self.entries.remove(key)
    }

    pub fn keys(&self) -> impl Iterator<Item = &CacheKey> {
        self.entries.keys()
    }

    pub fn record_ref(&mut self, key: CacheKey, locator: CacheLocator) {
        self.ref_index.insert(key, locator);
    }

    pub fn ref_locator(&self, key: &str) -> Option<&CacheLocator> {
        self.ref_index.get(key)
    }

    pub fn resolve_locator(&self, locator: &CacheLocator) -> Option<CacheValue> {
        self.resolve_locator_ref(locator).cloned()
    }

    pub fn resolve_locator_ref(&self, locator: &CacheLocator) -> Option<&CacheValue> {
        resolve_locator(&self.entries, locator)
    }

    pub(crate) fn prune_ref_index(&mut self) {
        let entries = &self.entries;
        self.ref_index
            .retain(|_, locator| resolve_locator(entries, locator).is_some());
    }

    /// Deletes an entity record by its [id],
    /// unlinking all references to it across other records in the cache (removing it from lists,
    /// setting single references to null) and returns the set of changed cache ref paths.
    pub fn delete(&mut self, id: &str) -> Option<HashSet<String>> {
        let entity_key = self
            .entries
            .keys()
            .find(|k| k.split_once(':').map(|(_, item_id)| item_id) == Some(id))?
            .clone();

        let removed_record = self.entries.remove(&entity_key)?;

        let mut changed = HashSet::new();
        changed.insert(entity_key.clone());
        for field_key in removed_record.keys() {
            changed.insert(format!("{entity_key}.{field_key}"));
        }
        self.ref_index.remove(&entity_key);

        let mut ref_index = std::mem::take(&mut self.ref_index);

        for (record_key, record) in self.entries.iter_mut() {
            for (field_key, value) in record.iter_mut() {
                let path = format!("{record_key}.{field_key}");
                let mut locator_path = vec![LocatorSegment::Field(field_key.clone())];
                prune_cache_value(
                    value,
                    &entity_key,
                    &path,
                    record_key,
                    &mut locator_path,
                    &mut ref_index,
                    &mut changed,
                );
            }
        }

        self.ref_index = ref_index;
        self.prune_ref_index();

        Some(changed)
    }
}

fn prune_cache_value(
    value: &mut CacheValue,
    target: &str,
    current_path: &str,
    base_key: &str,
    locator_path: &mut Vec<LocatorSegment>,
    ref_index: &mut HashMap<CacheKey, CacheLocator>,
    changed: &mut HashSet<String>,
) -> bool {
    match value {
        CacheValue::Ref(k) if k == target => {
            *value = CacheValue::Scalar(Value::Null);
            changed.insert(current_path.to_string());
            true
        }
        CacheValue::List(items) => {
            let mut modified = false;
            let mut i = 0;
            while i < items.len() {
                if matches!(&items[i], CacheValue::Ref(k) if k == target) {
                    items.remove(i);
                    modified = true;
                    shift_list_locators(ref_index, base_key, locator_path, i, changed);
                } else {
                    let item_path = format!("{current_path}[{i}]");
                    locator_path.push(LocatorSegment::Index(i));
                    if prune_cache_value(
                        &mut items[i],
                        target,
                        &item_path,
                        base_key,
                        locator_path,
                        ref_index,
                        changed,
                    ) {
                        modified = true;
                    }
                    locator_path.pop();
                    i += 1;
                }
            }
            if modified {
                changed.insert(current_path.to_string());
            }
            modified
        }
        CacheValue::Object(record) => {
            let mut modified = false;
            for (field_key, val) in record.iter_mut() {
                let field_path = format!("{current_path}.{field_key}");
                locator_path.push(LocatorSegment::Field(field_key.clone()));
                if prune_cache_value(
                    val,
                    target,
                    &field_path,
                    base_key,
                    locator_path,
                    ref_index,
                    changed,
                ) {
                    modified = true;
                }
                locator_path.pop();
            }
            if modified {
                changed.insert(current_path.to_string());
            }
            modified
        }
        _ => false,
    }
}

fn shift_list_locators(
    ref_index: &mut HashMap<CacheKey, CacheLocator>,
    base_key: &str,
    list_path: &[LocatorSegment],
    removed_idx: usize,
    changed: &mut HashSet<String>,
) {
    if ref_index.is_empty() {
        return;
    }

    let prefix_len = list_path.len();
    let mut to_remove = Vec::new();
    let mut to_insert = Vec::new();

    for (key, locator) in ref_index.iter() {
        if locator.base == base_key
            && locator.path.len() > prefix_len
            && locator.path[..prefix_len] == *list_path
            && let LocatorSegment::Index(idx) = locator.path[prefix_len]
        {
            if idx == removed_idx {
                to_remove.push(key.clone());
            } else if idx > removed_idx {
                let mut new_locator = locator.clone();
                new_locator.path[prefix_len] = LocatorSegment::Index(idx - 1);
                let new_key = new_locator.to_path_key();
                to_remove.push(key.clone());
                to_insert.push((new_key, new_locator));
            }
        }
    }

    for k in to_remove {
        ref_index.remove(&k);
        changed.insert(k);
    }
    for (k, loc) in to_insert {
        changed.insert(k.clone());
        ref_index.insert(k, loc);
    }
}

fn resolve_locator<'a>(
    entries: &'a HashMap<CacheKey, CacheRecord>,
    locator: &CacheLocator,
) -> Option<&'a CacheValue> {
    let base = entries.get(&locator.base)?;
    let (first, rest) = locator.path.split_first()?;
    let mut current = match first {
        LocatorSegment::Field(key) => base.get(key)?,
        LocatorSegment::Index(_) => return None,
    };
    for segment in rest {
        current = match (segment, current) {
            (LocatorSegment::Field(key), CacheValue::Object(record)) => record.get(key)?,
            (LocatorSegment::Index(idx), CacheValue::List(items)) => items.get(*idx)?,
            _ => return None,
        };
    }
    Some(current)
}
