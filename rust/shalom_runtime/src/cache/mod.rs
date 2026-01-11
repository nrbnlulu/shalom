use std::collections::HashMap;

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

    pub fn get(&self, key: &str) -> Option<&CacheRecord> {
        self.entries.get(key)
    }

    pub fn get_mut(&mut self, key: &str) -> Option<&mut CacheRecord> {
        self.entries.get_mut(key)
    }

    pub fn get_or_insert(&mut self, key: CacheKey) -> &mut CacheRecord {
        self.entries.entry(key).or_insert_with(HashMap::new)
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
        let mut current = CacheValue::Object(self.entries.get(&locator.base)?.clone());
        for segment in &locator.path {
            current = match (segment, current) {
                (LocatorSegment::Field(key), CacheValue::Object(record)) => {
                    record.get(key).cloned()?
                }
                (LocatorSegment::Index(idx), CacheValue::List(items)) => {
                    items.get(*idx).cloned()?
                }
                _ => return None,
            };
        }
        Some(current)
    }
}
