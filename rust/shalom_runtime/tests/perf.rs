//! Cache performance regression tests.
//!
//! Run these in release mode so the limits measure production-like code:
//! `cargo test -p shalom_runtime --release --test perf -- --ignored --nocapture --test-threads=1`

use std::collections::HashSet;
use std::hint::black_box;
use std::path::PathBuf;
use std::time::{Duration, Instant};

use serde_json::{Map, Value, json};
use shalom_core::context::ShalomGlobalContext;
use shalom_core::entrypoint::parse_schema;
use shalom_core::shalom_config::ShalomConfig;
use shalom_runtime::cache::{CacheRecord, CacheValue, NormalizedCache};
use shalom_runtime::gc::collect_garbage;
use shalom_runtime::{ExecutionPolicy, ShalomRuntime};

const ROOT_FIELDS: usize = 50_000;
const ITERATIONS: usize = 100;

fn runtime(schema: &str, operation: &str) -> ShalomRuntime {
    let schema = parse_schema(schema).expect("schema parses");
    let global = ShalomGlobalContext::new(
        schema,
        ShalomConfig::default(),
        PathBuf::from("schema.graphql"),
    );
    let runtime = ShalomRuntime::new(global);
    runtime
        .register_operation(operation)
        .expect("operation registers");
    runtime
}

fn scalar_record(id: usize) -> CacheRecord {
    CacheRecord::from([("value".to_string(), CacheValue::Scalar(json!(id)))])
}

fn root_with_unrelated_fields(size: usize) -> CacheRecord {
    let mut root = (0..size)
        .map(|id| (format!("unrelated({id})"), CacheValue::Scalar(json!(id))))
        .collect::<CacheRecord>();
    root.insert("value".to_string(), CacheValue::Scalar(json!(0)));
    root
}

fn variables(id: usize) -> Map<String, Value> {
    Map::from_iter([("id".to_string(), json!(id))])
}

fn report(name: &str, elapsed: Duration) {
    println!("{name}: {elapsed:?}");
}

#[test]
#[ignore = "performance test: run in release mode with --ignored"]
fn garbage_collection_is_linear_in_cache_and_watched_keys() {
    const SIZE: usize = 10_000;

    let mut cache = NormalizedCache::new();
    let mut active = HashSet::with_capacity(SIZE);
    for id in 0..SIZE {
        cache.insert(format!("Entity:{id}"), scalar_record(id));
        active.insert(format!("Entity:{id}_value"));
    }

    let started = Instant::now();
    let evicted = black_box(collect_garbage(&mut cache, &active));
    let elapsed = started.elapsed();
    report("GC for 10k entries and 10k watched keys", elapsed);

    assert!(evicted.is_empty());
    assert!(
        elapsed < Duration::from_millis(250),
        "GC regressed to {elapsed:?}; the former quadratic implementation took about 1.5s"
    );
}

#[test]
#[ignore = "performance test: run in release mode with --ignored"]
fn operation_reads_do_not_scale_with_unrelated_root_fields() {
    let runtime = runtime("type Query { value: Int }", "query Value { value }");
    runtime.cache().lock().insert(
        "ROOT_QUERY".to_string(),
        root_with_unrelated_fields(ROOT_FIELDS),
    );

    let started = Instant::now();
    for _ in 0..ITERATIONS {
        let result = runtime
            .try_read_operation("Value", None)
            .expect("cache read succeeds")
            .expect("cache read is complete");
        black_box(result);
    }
    let elapsed = started.elapsed();
    report("100 reads with 50k unrelated root fields", elapsed);

    assert!(
        elapsed < Duration::from_millis(100),
        "operation reads regressed to {elapsed:?}; this usually means the root record is cloned"
    );
}

#[test]
#[ignore = "performance test: run in release mode with --ignored"]
fn operation_updates_do_not_copy_unrelated_root_fields() {
    let runtime = runtime("type Query { value: Int }", "query Value { value }");
    runtime.cache().lock().insert(
        "ROOT_QUERY".to_string(),
        root_with_unrelated_fields(ROOT_FIELDS),
    );
    let operation = runtime.operation_by_name("Value").unwrap();

    let started = Instant::now();
    for value in 0..ITERATIONS {
        black_box(
            runtime
                .normalize(&operation, json!({ "value": value }), None)
                .expect("cache update succeeds"),
        );
    }
    let elapsed = started.elapsed();
    report("100 updates with 50k unrelated root fields", elapsed);

    assert!(
        elapsed < Duration::from_millis(100),
        "operation updates regressed to {elapsed:?}; this usually means the root record is copied"
    );
}

#[test]
#[ignore = "performance test: run in release mode with --ignored"]
fn subscriber_dispatch_does_not_scan_unrelated_observers() {
    const OBSERVERS: usize = 25_000;
    const UPDATES: usize = 1_000;

    let runtime = runtime(
        "type Query { value(id: Int!): Int }",
        "query Value($id: Int!) { value(id: $id) }",
    );
    let operation = runtime.operation_by_name("Value").unwrap();

    let mut root = CacheRecord::with_capacity(OBSERVERS);
    for id in 0..OBSERVERS {
        root.insert(
            format!("value({{\"id\":{id}}})"),
            CacheValue::Scalar(json!(0)),
        );
    }
    runtime
        .cache()
        .lock()
        .insert("ROOT_QUERY".to_string(), root);

    for id in 0..OBSERVERS {
        runtime.create_operation_subscription(
            operation.clone(),
            Some(variables(id)),
            ExecutionPolicy::CacheFirst,
        );
    }

    let target_variables = variables(0);
    let started = Instant::now();
    for value in 0..UPDATES {
        black_box(
            runtime
                .normalize(
                    &operation,
                    json!({ "value": value }),
                    Some(&target_variables),
                )
                .expect("cache update succeeds"),
        );
    }
    let elapsed = started.elapsed();
    report("1k updates with 25k unrelated observers", elapsed);

    assert!(
        elapsed < Duration::from_millis(100),
        "subscriber dispatch regressed to {elapsed:?}; changed keys should use the reverse index"
    );
}
