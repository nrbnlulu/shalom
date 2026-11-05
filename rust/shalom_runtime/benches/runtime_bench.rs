//! Time + memory benchmarks for the runtime cache.
//!
//! Run: `cargo bench -p shalom_runtime --bench runtime_bench`
//! Results are printed and written as JSON to `$BENCH_OUTPUT` (default `bench-results.json`)
//! as a list of `{ "name", "unit", "value" }` entries where smaller is better.

use std::alloc::{GlobalAlloc, Layout, System};
use std::collections::HashSet;
use std::hint::black_box;
use std::path::PathBuf;
use std::sync::atomic::{AtomicUsize, Ordering::Relaxed};
use std::time::Instant;

use serde_json::{Map, Value, json};
use shalom_core::context::ShalomGlobalContext;
use shalom_core::entrypoint::parse_schema;
use shalom_core::shalom_config::ShalomConfig;
use shalom_runtime::cache::{CacheRecord, CacheValue, NormalizedCache};
use shalom_runtime::gc::collect_garbage;
use shalom_runtime::{ExecutionPolicy, ShalomRuntime};

/// Allocator wrapper tracking live bytes and the peak since the last reset.
struct Counting;
static LIVE: AtomicUsize = AtomicUsize::new(0);
static PEAK: AtomicUsize = AtomicUsize::new(0);

unsafe impl GlobalAlloc for Counting {
    unsafe fn alloc(&self, l: Layout) -> *mut u8 {
        let p = unsafe { System.alloc(l) };
        if !p.is_null() {
            let now = LIVE.fetch_add(l.size(), Relaxed) + l.size();
            PEAK.fetch_max(now, Relaxed);
        }
        p
    }
    unsafe fn dealloc(&self, p: *mut u8, l: Layout) {
        unsafe { System.dealloc(p, l) };
        LIVE.fetch_sub(l.size(), Relaxed);
    }
    unsafe fn realloc(&self, p: *mut u8, l: Layout, new: usize) -> *mut u8 {
        let np = unsafe { System.realloc(p, l, new) };
        if !np.is_null() {
            if new >= l.size() {
                let now = LIVE.fetch_add(new - l.size(), Relaxed) + (new - l.size());
                PEAK.fetch_max(now, Relaxed);
            } else {
                LIVE.fetch_sub(l.size() - new, Relaxed);
            }
        }
        np
    }
}

#[global_allocator]
static ALLOC: Counting = Counting;

const SAMPLES: usize = 7;

#[derive(Default)]
struct Results(Vec<Value>);

impl Results {
    fn push(&mut self, name: &str, unit: &str, value: f64) {
        println!("{name:<55} {value:>14.1} {unit}");
        self.0
            .push(json!({ "name": name, "unit": unit, "value": value }));
    }

    /// Runs `setup` then times `run(state)` `SAMPLES` times; records the median time and
    /// the peak extra memory (over what `setup` retained) of the median-time sample.
    fn bench<S, R>(
        &mut self,
        name: &str,
        mut setup: impl FnMut() -> S,
        mut run: impl FnMut(&mut S) -> R,
    ) {
        // Warm caches and lazy initialization without contaminating measured state.
        black_box(run(&mut setup()));
        let mut samples = Vec::with_capacity(SAMPLES);
        for _ in 0..SAMPLES {
            let mut state = setup();
            let base = LIVE.load(Relaxed);
            PEAK.store(base, Relaxed);
            let started = Instant::now();
            black_box(run(&mut state));
            let elapsed = started.elapsed().as_nanos() as f64;
            let peak = PEAK.load(Relaxed).saturating_sub(base) as f64;
            samples.push((elapsed, peak));
        }
        samples.sort_by(|a, b| a.0.total_cmp(&b.0));
        let (time, peak) = samples[SAMPLES / 2];
        self.push(&format!("{name} / time"), "ns", time);
        self.push(&format!("{name} / peak alloc"), "bytes", peak);
    }

    /// Records the bytes retained by whatever `build` returns.
    fn retained<T>(&mut self, name: &str, build: impl FnOnce() -> T) {
        let before = LIVE.load(Relaxed);
        let value = build();
        let after = LIVE.load(Relaxed);
        self.push(name, "bytes", after.saturating_sub(before) as f64);
        black_box(value);
    }
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

fn main() {
    let mut r = Results::default();

    r.bench(
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

    r.bench(
        "read / 100 reads, 50k unrelated root fields",
        root_runtime,
        |rt| {
            for _ in 0..100 {
                black_box(rt.try_read_operation("Value", None).unwrap().unwrap());
            }
        },
    );

    r.bench(
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
    r.bench(
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
    r.bench(
        "normalize / 4k observed items",
        || (runtime(ITEMS_SCHEMA, ITEMS_OP), items_data(ITEMS)),
        |(rt, data)| {
            let op = rt.operation_by_name("Items").unwrap();
            rt.normalize(&op, data.clone(), None).unwrap()
        },
    );

    r.bench(
        "read / 4k observed items",
        || {
            let rt = runtime(ITEMS_SCHEMA, ITEMS_OP);
            let op = rt.operation_by_name("Items").unwrap();
            rt.normalize(&op, items_data(ITEMS), None).unwrap();
            rt
        },
        |rt| rt.try_read_operation("Items", None).unwrap().unwrap(),
    );

    // Memory retained in the cache after normalizing a response.
    let rt = runtime(ITEMS_SCHEMA, ITEMS_OP);
    let op = rt.operation_by_name("Items").unwrap();
    let data = items_data(ITEMS);
    r.retained("memory / cache retained after 4k observed items", || {
        rt.normalize(&op, data, None).unwrap();
    });

    let rt = root_runtime();
    r.retained("memory / 100 reads on 50k-field root (leak check)", || {
        for _ in 0..100 {
            black_box(rt.try_read_operation("Value", None).unwrap().unwrap());
        }
    });

    let out = std::env::var("BENCH_OUTPUT").unwrap_or_else(|_| "bench-results.json".into());
    std::fs::write(&out, serde_json::to_string_pretty(&r.0).unwrap()).unwrap();
    println!("wrote {out}");
}
