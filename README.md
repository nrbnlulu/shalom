<p align="center">
  <img src="docs/assets/shalom_banner.png" alt="Shalom" width="100%">
</p>

<p align="center">
  <strong>High-performance GraphQL client runtime & codegen for Dart and Flutter, backed by Rust.</strong>
</p>

<p align="center">
  <a href="https://github.com/nrbnlulu/shalom"><img src="https://img.shields.io/badge/Dart-0175C2?logo=dart&logoColor=white" alt="Dart"></a>
  <a href="https://github.com/nrbnlulu/shalom"><img src="https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white" alt="Flutter"></a>
  <a href="https://github.com/nrbnlulu/shalom"><img src="https://img.shields.io/badge/Rust-DEA584?logo=rust&logoColor=black" alt="Rust"></a>
  <a href="https://github.com/nrbnlulu/shalom"><img src="https://img.shields.io/badge/GraphQL-E10098?logo=graphql&logoColor=white" alt="GraphQL"></a>
</p>

---

### Installation

1. Build the CLI from source:

```bash
cargo install --git https://github.com/nrbnlulu/shalom.git --branch main shalom_dart_codegen
```

2. add flutter deps
```bash
dart pub add shalom_flutter
dart pub add shalom_annotations
```

### Benchmarks

Rust cache benchmarks run on [CodSpeed](https://app.codspeed.io/) for pushes to
`main`, pull requests, and manual workflow runs. CodSpeed tracks the baseline,
compares regressions, and posts PR reports. Enable `nrbnlulu/shalom` in the
CodSpeed GitHub app to receive reports; public-repository uploads need no secret.
The workflow follows the [CodSpeed Criterion integration](https://codspeed.io/docs/benchmarks/rust/criterion)
and measures CPU simulation and heap memory on a standard GitHub runner.

To check the instrumented workloads locally:

```bash
cargo install cargo-codspeed --version 6.0.0 --locked -j 2
CARGO_BUILD_JOBS=2 cargo codspeed build --locked -p shalom_runtime --bench runtime_bench --measurement-mode simulation,memory
cargo codspeed run --measurement-mode simulation
cargo codspeed run --measurement-mode memory
```

Actual simulation measurements and uploads happen in CI. For local wall-clock
measurements, run `cargo bench -j 2 -p shalom_runtime --bench runtime_bench`.
Each iteration creates fresh state outside the measured section.

CodSpeed memory profiling replaces the custom counting allocator and JSON timing
harness. The existing normalization and read workloads cover cache allocations
and retained memory. Dart subscriber timing/RSS diagnostics remain in
`dart/shalom/benchmark/subscribers.dart`; these local diagnostics are not uploaded
to CodSpeed.
