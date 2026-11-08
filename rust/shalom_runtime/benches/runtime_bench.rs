//! Runtime cache benchmarks measured by CodSpeed (CPU and memory).
//!
//! Local timings: `cargo bench -j 2 -p shalom_runtime --bench runtime_bench`

use criterion::{BatchSize, Criterion, criterion_group, criterion_main};
use std::collections::HashSet;
use std::hint::black_box;
use std::path::PathBuf;

use serde_json::{Map, Value, json};
use shalom_core::context::ShalomGlobalContext;
use shalom_core::entrypoint::parse_schema;
use shalom_core::shalom_config::ShalomConfig;
use shalom_runtime::cache::{CacheRecord, CacheValue, NormalizedCache};
use shalom_runtime::gc::collect_garbage;
use shalom_runtime::{ExecutionPolicy, ShalomRuntime};

// Fresh state per iteration keeps mutating workloads comparable. Setup and
// teardown are excluded; PerIteration bounds memory for the large fixtures.
fn bench<S, R>(
    c: &mut Criterion,
    name: &str,
    mut setup: impl FnMut() -> S,
    mut run: impl FnMut(&mut S) -> R,
) {
    c.bench_function(name, |b| {
        b.iter_batched_ref(&mut setup, &mut run, BatchSize::PerIteration);
    });
}

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

fn items_data(n: usize) -> Value {
    json!({
        "items": (0..n)
            .map(|id| json!({"id": id.to_string(), "name": format!("Item {id}"), "value": id}))
            .collect::<Vec<Value>>()
    })
}

const ITEMS_SCHEMA: &str =
    "type Query { items: [Item!]! } type Item { id: ID! name: String! value: Int! }";
const ITEMS_OP: &str = "fragment ItemFields on Item @observe { id name value } query Items { items { ...ItemFields } }";

fn runtime_benchmarks(c: &mut Criterion) {
    bench(
        c,
        "gc / 10k entries, 10k watched keys",
        || {
            let mut cache = NormalizedCache::new();
            let mut active = HashSet::new();
            for id in 0..10_000 {
                cache.insert(format!("Entity:{id}"), scalar_record(id));
                active.insert(format!("Entity:{id}_value"));
            }
            (cache, active)
        },
        |(cache, active)| collect_garbage(cache, active),
    );

    const ROOT_FIELDS: usize = 50_000;
    let root_runtime = || {
        let rt = runtime("type Query { value: Int }", "query Value { value }");
        rt.cache().lock().insert(
            "ROOT_QUERY".to_string(),
            root_with_unrelated_fields(ROOT_FIELDS),
        );
        rt
    };

    bench(
        c,
        "read / 100 reads, 50k unrelated root fields",
        root_runtime,
        |rt| {
            for _ in 0..100 {
                black_box(rt.try_read_operation("Value", None).unwrap().unwrap());
            }
        },
    );

    bench(
        c,
        "normalize / 100 updates, 50k unrelated root fields",
        root_runtime,
        |rt| {
            let op = rt.operation_by_name("Value").unwrap();
            for value in 0..100 {
                black_box(rt.normalize(&op, json!({ "value": value }), None).unwrap());
            }
        },
    );

    const OBSERVERS: usize = 25_000;
    bench(
        c,
        "dispatch / 1k updates, 25k unrelated observers",
        || {
            let rt = runtime(
                "type Query { value(id: Int!): Int }",
                "query Value($id: Int!) { value(id: $id) }",
            );
            let op = rt.operation_by_name("Value").unwrap();
            let mut root = CacheRecord::with_capacity(OBSERVERS);
            for id in 0..OBSERVERS {
                root.insert(
                    format!("value({{\"id\":{id}}})"),
                    CacheValue::Scalar(json!(0)),
                );
            }
            rt.cache().lock().insert("ROOT_QUERY".to_string(), root);
            for id in 0..OBSERVERS {
                rt.create_operation_subscription(
                    op.clone(),
                    Some(variables(id)),
                    ExecutionPolicy::CacheFirst,
                );
            }
            (rt, op)
        },
        |(rt, op)| {
            let vars = variables(0);
            for value in 0..1_000 {
                black_box(
                    rt.normalize(op, json!({ "value": value }), Some(&vars))
                        .unwrap(),
                );
            }
        },
    );

    const ITEMS: usize = 4_000;
    bench(
        c,
        "normalize / 4k observed items",
        || (runtime(ITEMS_SCHEMA, ITEMS_OP), items_data(ITEMS)),
        |(rt, data)| {
            let op = rt.operation_by_name("Items").unwrap();
            rt.normalize(&op, data.clone(), None).unwrap()
        },
    );

    bench(
        c,
        "read / 4k observed items",
        || {
            let rt = runtime(ITEMS_SCHEMA, ITEMS_OP);
            let op = rt.operation_by_name("Items").unwrap();
            rt.normalize(&op, items_data(ITEMS), None).unwrap();
            rt
        },
        |rt| rt.try_read_operation("Items", None).unwrap().unwrap(),
    );
}

criterion_group!(benches, runtime_benchmarks);
criterion_main!(benches);
