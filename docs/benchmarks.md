# Benchmarks

This page compares Shalom's Rust normalized cache with the normalized cache
of [Ferry](https://github.com/gql-dart/ferry) (`ferry_cache`), the most widely
used Dart GraphQL client. The harness lives in
[`benchmarks/ferry_comparison`](https://github.com/nrbnlulu/shalom/tree/main/benchmarks/ferry_comparison).

!!! note
    Only the cache is compared: network, parsing of HTTP responses and
    codegen-generated models are excluded. Numbers come from one machine and
    one run, so treat them as orders of magnitude, not exact figures.

## Setup

- Both clients get the same schema, query and payload (a list of `Item`s with
  scalars, a string list and a nested `Owner` object).
- Ferry: `ferry_cache` 0.10.1 with `JsonOperationRequest`, i.e. no generated
  models. Shalom: the release native runtime through the Dart bridge.
- Dart AOT build (`dart build cli`), Linux x86_64, Intel Core Ultra 7 255HX.
- Timings are medians in milliseconds. Sizes up to 4000 items use 11 samples
  after 3 warm-ups; 10000 items uses 3 samples after 1 warm-up, because Ferry
  needs tens of seconds per write.
- On the Shalom side one subscription stays open during the write/read
  benchmarks, like a mounted `@Query` widget. The runtime garbage-collects
  data that nothing observes, so a cache with no observer would read back
  `null` after a short while.

## Cache writes and reads

| Scenario | Items | Ferry | Shalom |
| --- | ---: | ---: | ---: |
| Write, empty cache | 1,000 | 131 ms | 48 ms |
| Write, empty cache | 4,000 | 1,060 ms | 235 ms |
| Write, empty cache | 10,000 | 8,606 ms | 699 ms |
| Write, identical data | 1,000 | 266 ms | 25 ms |
| Write, identical data | 4,000 | 2,571 ms | 149 ms |
| Write, identical data | 10,000 | 24,841 ms | 482 ms |
| Read, full cache | 1,000 | 3.6 ms | 12.5 ms |
| Read, full cache | 4,000 | 16.6 ms | 103 ms |
| Read, full cache | 10,000 | 73.8 ms | 430 ms |

- **Writes** are 3x to 50x faster in Shalom, and the gap widens with size:
  Ferry's write time grows faster than linearly in the number of items.
- **Reads** are faster in Ferry (about 5x). Ferry hands back an
  already-built Dart map, while Shalom's read serializes the result across
  the Rust/Dart bridge. The harness measures the raw runtime read, not
  generated models.

## Watchers

N watchers of the same 200-item query. "Changed write" is the time from
writing new data until every watcher has received it.

| Watchers | Metric | Ferry | Shalom |
| ---: | --- | ---: | ---: |
| 10 | Subscribe to full cache | 71 ms | 102 ms |
| 10 | Changed write | 273 ms | 66 ms |
| 10 | Memory growth | 195 MiB | ~0 MiB |
| 50 | Subscribe to full cache | 310 ms | 543 ms |
| 50 | Changed write | 1,516 ms | 250 ms |
| 50 | Memory growth | 845 MiB | 3 MiB |
| 100 | Subscribe to full cache | 517 ms | 1,025 ms |
| 100 | Changed write | 2,836 ms | 423 ms |
| 100 | Memory growth | 1,018 MiB | 7.5 MiB |

- Notifying watchers is 4x to 7x faster in Shalom, and memory is far lower:
  every Ferry watcher keeps its own denormalized copy of the result, while
  Shalom keeps one normalized copy in Rust.
- Subscribing is about 1.5-2x slower in Shalom, since each subscription is a
  round trip over the bridge.
- Memory is process RSS growth, which includes the Rust heap but is noisy at
  small sizes (it can read slightly negative).

## Caveats

- Shalom's reads and subscriptions pay a bridge cost that Ferry, being pure
  Dart, does not. The numbers above show where that matters.
- Ferry write times may be improved by custom `typePolicies` or
  `dataIdFromObject`; defaults were used here.
- Ferry does not emit if a write lands right after a watcher's first event;
  the harness lets watchers settle for 200 ms before timing writes.
- This does not cover network, link chains, or widget rebuild cost.

## Reproducing

```bash
cargo build --release -p shalom_ffi
cd benchmarks/ferry_comparison
dart pub get
dart build cli -t bin/bench.dart -o /tmp/ferry-vs-shalom
/tmp/ferry-vs-shalom/bundle/bin/bench \
    /tmp/ferry-vs-shalom/bundle/lib/libshalom_ffi.so results.json
```

Environment variables: `BENCH_SIZES` (default `1000,4000,10000`),
`BENCH_SUBS` (default `10,50,100`), and `BENCH_SKIP_SIZES=1` to run only the
watcher scenarios. Ferry's memory use grows quickly with watchers, so keep
`BENCH_SUBS` modest.

Shalom's own regression benchmarks run in CI with CodSpeed
(`rust/shalom_runtime/benches`).
