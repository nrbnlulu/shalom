use std::collections::HashSet;
use std::path::PathBuf;

use serde_json::json;
use shalom_core::context::ShalomGlobalContext;
use shalom_core::entrypoint::{parse_document, parse_schema, register_fragments_from_document};
use shalom_core::operation::context::SharedOpCtx;
use shalom_core::shalom_config::ShalomConfig;
use shalom_runtime::cache::{CacheRecord, CacheValue, NormalizedCache};
use shalom_runtime::gc::{SubscriptionTracker, collect_garbage};
use shalom_runtime::ShalomRuntime;

fn make_entity(name: &str) -> CacheRecord {
    let mut record = CacheRecord::new();
    record.insert(
        "id".to_string(),
        CacheValue::Scalar(serde_json::Value::String(name.to_string())),
    );
    record
}

fn build_runtime(schema: &str, operation: &str) -> (ShalomRuntime, SharedOpCtx) {
    let schema_ctx = parse_schema(schema).expect("schema parse failed");
    let config = ShalomConfig::default();
    let global_ctx = ShalomGlobalContext::new(schema_ctx, config, PathBuf::from("schema.graphql"));
    register_fragments_from_document(&global_ctx, operation, &PathBuf::from("ops.graphql"))
        .expect("register fragments");
    let ops = parse_document(&global_ctx, operation, &PathBuf::from("ops.graphql"))
        .expect("operation parse failed");
    let op_ctx = ops.values().next().expect("missing op").clone();
    let runtime = ShalomRuntime::new(global_ctx);
    (runtime, op_ctx)
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

#[test]
fn runtime_gc_respects_subscription_tracker() {
    let schema = r#"
        type Query { user: User }
        type User { id: ID!, name: String }
    "#;
    let operation = r#"
        query GetUser { user { id name } }
    "#;
    let (runtime, op_ctx) = build_runtime(schema, operation);

    let result = runtime
        .normalize(
            &op_ctx,
            json!({ "user": { "id": "1", "name": "Ana" } }),
            None,
        )
        .expect("normalize response");
    let mut refs = result.used_refs.iter().cloned().collect::<Vec<_>>();
    refs.push("Temp:1_field".to_string());
    let subscription = runtime
        .subscribe(op_ctx.get_operation_name(), None, refs)
        .expect("subscribe");

    {
        let cache = runtime.cache();
        let mut cache = cache.lock().expect("cache lock poisoned");
        cache.insert("Temp:1".to_string(), make_entity("Temp:1"));
    }

    let evicted = runtime.collect_garbage();
    assert!(!evicted.contains(&"Temp:1".to_string()));

    runtime.unsubscribe(subscription);
    let evicted = runtime.collect_garbage();
    assert!(evicted.contains(&"Temp:1".to_string()));
}
