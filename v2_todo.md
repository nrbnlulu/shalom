# V2 Implementation TODO

Work must proceed bottom-up: Rust runtime → FRB bridge → Dart client → templates → tests.
Each layer depends on the one below it.

---

## 1. Rust Runtime (`rust/shalom_runtime/src/runtime.rs`)

- [ ] Add `ObservedRef { observable_id: String, anchor: String }` struct (mirroring the spec type)
- [ ] Add `register_operation(name: &str, document: &str)` — parses + registers SDL by name without executing a request (distinct from the existing `register_operation_from_query` which is ad-hoc)
- [ ] Add `register_fragment(name: &str, document: &str)` — same for fragments
- [ ] Add `observe_operation(name: &str, variables_json: Option<&str>) → SubscriptionId` — looks up pre-registered op, reads from cache (empty ok), opens subscription
- [ ] Add `observe_fragment(ref: ObservedRef) → SubscriptionId` — looks up pre-registered fragment by `observable_id`, roots at `anchor`, opens subscription
- [ ] Add `FragmentTemplate` struct — precomputed list of relative field paths (e.g. `[".id", ".name"]`) derived from a fragment's selection set at registration time; cached per `observable_id`
- [ ] Add `rebind_subscription(id: SubscriptionId, new_ref: ObservedRef)` — if `observable_id` matches existing subscription: increment new-anchor refs first, decrement old-anchor refs second (never let both be zero simultaneously), re-read cache at new anchor and push to existing channel; if `observable_id` differs: full teardown + new subscription
- [ ] Background GC sweep — spawn a tokio task on `ShalomRuntime::init` that calls `collect_garbage` on a ~2s interval instead of the current manual call-site approach

---

## 2. FRB Bridge (`dart/shalom/rust/src/api/runtime.rs`)

- [ ] Expose `ObservedRefInput { observable_id: String, anchor: String }` as a plain FRB struct (becomes a Dart class automatically)
- [ ] Add `#[frb] fn register_operation(handle: &RuntimeHandle, name: String, document: String) → Result<()>`
- [ ] Add `#[frb] fn register_fragment(handle: &RuntimeHandle, name: String, document: String) → Result<()>`
- [ ] Add `#[frb(sync)] fn observe_operation(handle: &RuntimeHandle, name: String, variables_json: Option<String>) → Result<u64>`
- [ ] Add `#[frb(sync)] fn observe_fragment(handle: &RuntimeHandle, ref_input: ObservedRefInput) → Result<u64>`
- [ ] Add `#[frb(sync)] fn rebind_subscription(handle: &RuntimeHandle, subscription_id: u64, new_ref: ObservedRefInput) → Result<()>`
- [ ] Re-run `flutter_rust_bridge_codegen` to regenerate `dart/shalom/lib/src/rust/api/runtime.dart` and the FRB glue

---

## 3. Dart Client (`dart/shalom/lib/src/runtime_client.dart`)

- [ ] Export `ObservedRefInput` from `runtime_client.dart` (add to the `show` list on the `rust/api/runtime.dart` import)
- [ ] Add `void registerOperation({required String name, required String document})` — thin wrapper over `rs_runtime.registerOperation`
- [ ] Add `void registerFragment({required String name, required String document})` — thin wrapper over `rs_runtime.registerFragment`
- [ ] Add `Stream<T> observeOperation<T>({required String name, Map<String, dynamic>? variables, required T Function(Map<String, dynamic>) decoder})` — calls `rs_runtime.observeOperation`, opens `listenSubscription` stream, cancels via `unsubscribe`
- [ ] Add `Stream<T> observeFragment<T>({required ObservedRefInput ref, required T Function(Map<String, dynamic>) decoder})` — calls `rs_runtime.observeFragment`, opens `listenSubscription` stream, cancels via `unsubscribe`
- [ ] Add `Stream<T> rebindFragmentSubscription<T>({required StreamSubscription<T> subscription, required ObservedRefInput newRef, required T Function(Map<String, dynamic>) decoder})` — calls `rs_runtime.rebindSubscription`; the existing stream stays alive, only its anchor changes

---

## 4. Dart Package Export (`dart/shalom/lib/shalom.dart`)

- [ ] Re-export `ObservedRefInput` so generated sidecars can use `shalom_core.ObservedRefInput`
- [ ] Re-export `ShalomScope` / `ShalomProvider` from `shalom_flutter` OR move them into `shalom` — the generated templates import `shalom_core` and call `ShalomScope.of(context)` without a package prefix, so it must resolve from `package:shalom/shalom.dart`

---

## 5. Codegen Templates

### `operation.dart.jinja` — V2 section

- [ ] Add `import 'dart:async' show StreamSubscription;`
- [ ] Add `import 'package:flutter/widgets.dart';`
- [ ] Verify `ShalomScope` resolves from the imports already present (fix if not — see item above)

### `fragment.dart.jinja` — V2 section

- [ ] Add `import 'dart:async' show StreamSubscription;`
- [ ] Add `import 'package:flutter/widgets.dart';`
- [ ] Verify `ShalomScope` resolves (same as above)
- [ ] Fix `Data$Unknown` class — it must extend the sealed `{{ fragment_name }}Data` base class (currently it does not: `final class XxxData$Unknown` is declared without `extends XxxData`)

---

## 6. Tests

### Runtime tests (`dart/shalom/test/runtime_test.dart`)

- [ ] `observeOperation` emits initial data + re-emits on cache write to same entity
- [ ] `observeFragment` with `ObservedRefInput(observableId, anchor)` fires when entity is updated by a subsequent operation
- [ ] `rebindSubscription` — subscribe to `Pet:14`, rebind to `Pet:15`, verify stream emits `Pet:15` data without cancel/re-subscribe

### Codegen tests (`rust/shalom_dart_codegen/dart_tests/test/`)

- [ ] `observe_query_widget/` — schema + `@observe` query; verify `$XxxWidget`, `XxxWidgetData`, `XxxWidgetVariables`, `fromCache` decoder compile and are correct
- [ ] `observe_fragment_widget/` — schema + `@observe` fragment; verify `XxxWidgetRef` extension type, sealed `XxxWidgetData`, `$XxxWidget` with `ref` parameter
- [ ] `observe_union_fragment/` — union schema + `@observe` fragment; verify sealed concrete classes and opaque refs for nested `@observe`d fragments
