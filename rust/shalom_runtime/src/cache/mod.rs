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

#[derive(Debug, Default)]
pub struct NormalizedCache {
    entries: HashMap<CacheKey, CacheRecord>,
}

impl NormalizedCache {
    pub fn new() -> Self {
        Self {
            entries: HashMap::new(),
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
}
