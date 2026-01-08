use std::collections::HashSet;

use shalom_runtime::cache::{CacheRecord, CacheValue, NormalizedCache};
use shalom_runtime::gc::{SubscriptionTracker, collect_garbage};

fn make_entity(name: &str) -> CacheRecord {
    let mut record = CacheRecord::new();
    record.insert(
        "id".to_string(),
        CacheValue::Scalar(serde_json::Value::String(name.to_string())),
    );
    record
}

#[test]
fn gc_eviction_respects_active_keys() {
    let mut cache = NormalizedCache::new();
    let mut root = CacheRecord::new();
    root.insert("user".to_string(), CacheValue::Ref("User:1".to_string()));
    cache.insert("ROOT_QUERY".to_string(), root);
    cache.insert("User:1".to_string(), make_entity("User:1"));
    cache.insert("User:2".to_string(), make_entity("User:2"));

    let active = HashSet::from(["User:1_name".to_string()]);
    let evicted = collect_garbage(&mut cache, &active);

    assert!(evicted.contains(&"User:2".to_string()));
    assert!(cache.get("User:1").is_some());
    assert!(cache.get("User:2").is_none());
}

#[test]
fn gc_keeps_referenced_entity_for_root_subscription() {
    let mut cache = NormalizedCache::new();
    let mut root = CacheRecord::new();
    root.insert("user".to_string(), CacheValue::Ref("User:1".to_string()));
    cache.insert("ROOT_QUERY".to_string(), root);
    cache.insert("User:1".to_string(), make_entity("User:1"));

    let active = HashSet::from(["ROOT_QUERY_user".to_string()]);
    let evicted = collect_garbage(&mut cache, &active);

    assert!(evicted.is_empty());
    assert!(cache.get("User:1").is_some());
}

#[test]
fn subscription_tracker_counts_refs() {
    let mut tracker = SubscriptionTracker::new();
    tracker.subscribe(["User:1".to_string(), "User:1_name".to_string()]);
    tracker.subscribe(["User:1".to_string()]);
    tracker.unsubscribe(["User:1".to_string()]);

    let active = tracker.active_keys();
    assert!(active.contains("User:1"));
    assert!(active.contains("User:1_name"));

    tracker.unsubscribe(["User:1".to_string()]);
    let active = tracker.active_keys();
    assert!(!active.contains("User:1"));
    assert!(active.contains("User:1_name"));
}
