use std::collections::{HashMap, HashSet, VecDeque};

use crate::cache::{CacheRecord, CacheValue, NormalizedCache};

#[derive(Debug, Default)]
pub struct SubscriptionTracker {
    counts: HashMap<String, usize>,
}

impl SubscriptionTracker {
    pub fn new() -> Self {
        Self {
            counts: HashMap::new(),
        }
    }

    pub fn subscribe<I: IntoIterator<Item = String>>(&mut self, keys: I) {
        for key in keys {
            *self.counts.entry(key).or_insert(0) += 1;
        }
    }

    pub fn unsubscribe<I: IntoIterator<Item = String>>(&mut self, keys: I) {
        for key in keys {
            if let Some(count) = self.counts.get_mut(&key) {
                if *count > 1 {
                    *count -= 1;
                } else {
                    self.counts.remove(&key);
                }
            }
        }
    }

    pub fn active_keys(&self) -> HashSet<String> {
        self.counts.keys().cloned().collect()
    }
}

pub fn collect_garbage(cache: &mut NormalizedCache, active_keys: &HashSet<String>) -> Vec<String> {
    let mut keep = HashSet::new();
    for root in ["ROOT_QUERY", "ROOT_MUTATION", "ROOT_SUBSCRIPTION"] {
        if cache.get(root).is_some() {
            keep.insert(root.to_string());
        }
    }

    for key in cache.keys() {
        if keep.contains(key) {
            continue;
        }
        if active_keys
            .iter()
            .any(|sub| sub == key || sub.starts_with(&format!("{key}_")))
        {
            keep.insert(key.clone());
        }
    }

    let mut queue = VecDeque::from_iter(keep.iter().cloned());
    while let Some(key) = queue.pop_front() {
        let record = match cache.get(&key) {
            Some(record) => record,
            None => continue,
        };
        let refs = collect_record_refs(record);
        for reference in refs {
            if keep.insert(reference.clone()) {
                queue.push_back(reference);
            }
        }
    }

    let mut evicted = Vec::new();
    let keys: Vec<String> = cache.keys().cloned().collect();
    for key in keys {
        if keep.contains(&key) {
            continue;
        }
        if cache.remove(&key).is_some() {
            evicted.push(key);
        }
    }

    evicted
}

fn collect_record_refs(record: &CacheRecord) -> HashSet<String> {
    let mut refs = HashSet::new();
    for value in record.values() {
        collect_value_refs(value, &mut refs);
    }
    refs
}

fn collect_value_refs(value: &CacheValue, refs: &mut HashSet<String>) {
    match value {
        CacheValue::Ref(key) => {
            refs.insert(key.clone());
        }
        CacheValue::List(items) => {
            for item in items {
                collect_value_refs(item, refs);
            }
        }
        CacheValue::Object(obj) => {
            for value in obj.values() {
                collect_value_refs(value, refs);
            }
        }
        CacheValue::Scalar(_) => {}
    }
}
