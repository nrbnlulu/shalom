# V2 Implementation TODO

Work proceeds bottom-up: Rust runtime → FRB bridge → Dart client → templates → tests.
Each layer depends on the one below it.

> **Codegen input strategy**: The codegen is now **Flutter-only**. Input is Dart files
> annotated with `@Query(r'...')` / `@Fragment(r'...')` from `package:shalom_annotations`.
> Raw `.graphql` file support will be re-added in a future iteration for non-Flutter Dart usage.
> All codegen tests must use the annotation syntax.

---

## 1. Rust Runtime (`rust/shalom_runtime/src/runtime.rs`)

- [x] Add `ObservedRef { observable_id: String, anchor: String }` struct
- [x] Add `register_operation(document: &str)` — parses + registers SDL
- [x] Add `register_fragment(document: &str)` — same for fragments
- [x] Add `create_operation_subscription(op_ctx, variables) → SubscriptionId`
- [x] Add `observe_fragment(ref: ObservedRef) → SubscriptionId`
- [x] Add `rebind_subscription(id: SubscriptionId, new_ref: ObservedRef)`
- [x] Background GC sweep — tokio task on `ShalomRuntime::init`, ~2s interval

---

## 2. FRB Bridge (`dart/shalom/rust/src/api/runtime.rs`)

- [x] Expose `ObservedRefInput { observable_id: String, anchor: String }` as FRB struct
- [x] `register_operation(handle, document)` — async `#[frb]`
- [x] `register_fragment(handle, document)` — async `#[frb]`
- [x] `request(handle, name, variables_json)` — async `#[frb]`, spawns tokio task
- [x] `observe_fragment(handle, ref_input)` — `#[frb(sync)]`
- [x] `rebind_subscription(handle, subscription_id, new_ref)` — `#[frb(sync)]`
- [x] FRB codegen re-run → `dart/shalom/lib/src/rust/api/runtime.dart` regenerated

---

## 3. Dart Client (`dart/shalom/lib/src/runtime_client.dart`)

- [x] Export `ObservedRefInput` (via re-export chain from `runtime.dart`)
- [x] Export `observedRefInputFromJson` factory helper (for use by generated sidecars)
- [x] `init()` — no longer takes `fragmentSdls`
- [x] `registerOperation({required String document})`
- [x] `registerFragment({required String document})`
- [x] `request<T>({required String name, Map<String,dynamic>? variables, required decoder})`
- [x] `subscribeToFragment<T>({required ObservedRefInput ref, required decoder})`
- [x] `rebindFragmentSubscription<T>({required BigInt subscriptionId, required ObservedRefInput newRef, required decoder})`

---

## 4. Dart Package Export (`dart/shalom/lib/shalom.dart`)

- [x] `ObservedRefInput` accessible via `shalom_core.ObservedRefInput` (through re-export chain)
- [x] `observedRefInputFromJson` accessible via `shalom_core.observedRefInputFromJson`
  - Fixed: function body used bare `ObservedRefInput` but import is aliased as `rs_runtime`; fixed to `rs_runtime.ObservedRefInput`
- [x] `shalom.dart` does not need to re-export `ShalomScope` — templates import `shalom_flutter` directly

---

## 5. Codegen — Scanner & Templates

### `dart_scanner.rs`

- [x] Fix regex: match `@Query` / `@Fragment` (PascalCase from `shalom_annotations`)
- [x] Make raw-string prefix `r` optional in the regex (support both `r'''` and `'''`)
- [x] Case-insensitive match for backward compat with legacy `@query`/`@fragment`

### `lib.rs` — registration file generator & core functions

- [x] `generate_v2_registration_file`: remove bogus `name:` param from calls
- [x] `generate_v2_registration_file`: make function `async`
- [x] Restore accidentally-deleted functions: `object_like_needs_variables`, `get_field_name_with_args`, `generate_custom_scalar_imports`, `SchemaEnv::new/render_schema`, `collect_multi_type_list_selections`, `register_executable_fns`
- [x] Register `selection_observe_fragment_name` as a Jinja function (was defined but never registered; template called it at `selection_macros` line 14)
- [x] Add `allow_dups: bool` to `register_fragments` in `shalom_core` and thread through all callers (context.rs, entrypoint.rs, runtime.rs ×3, cache.rs, gc.rs, lib.rs)

### `operation.dart.jinja` — V2 section

- [x] Add `import 'dart:async' show StreamSubscription;`
- [x] Add `import 'package:flutter/widgets.dart';`
- [x] Add `import 'package:shalom_flutter/shalom_flutter.dart' show ShalomScope;`
- [x] Fix `client.observeOperation(...)` → `client.request(...)`

### `fragment.dart.jinja` — V2 section

- [x] Add `import 'dart:async' show StreamSubscription;`
- [x] Add `import 'package:flutter/widgets.dart';`
- [x] Add `import 'package:shalom_flutter/shalom_flutter.dart' show ShalomScope;`
- [x] Fix `client.observeFragment(...)` → `client.subscribeToFragment(...)`
- [x] Fix `Data$Unknown` — extend sealed base class `{{ fragment_name }}Data`

### `selection_macros.dart.jinja`

- [x] Fix `shalom_core.ObservedRefInput.fromJson(...)` → `shalom_core.observedRefInputFromJson(...)`

---

## 6. Tests

### Rust runtime tests (`rust/shalom_runtime/tests/`)

- [x] All 74 tests passing (cache.rs + gc.rs)
- [x] Fixed 2 failing `fragment_subscriptions` tests: `observe_fragment` immediately emits
      the current cached value; tests now use `yield_nth_update_sync(n=2)` to skip it

### Dart client tests (`dart/shalom/test/runtime_test.dart`)

- [x] Migrate all 5 tests from V1 API to V2
- [x] `request` returns normalised data from network
- [x] `request` re-emits when same entity is updated by another operation
- [x] Two unrelated operations do not cross-trigger subscriptions
- [x] `subscribeToFragment` fires when fragment entity is updated
- [x] `subscribeToFragment` with `ObservedRefInput` emits + re-emits
- [x] `rebindFragmentSubscription` delivers data from the new anchor

### dart /flutter codegen tests
ran via cargo in  shalom_dart_codegen/tests/usecase_tests.rs

- [ ] dart tests => in shalom_dart_codegen/dart_tests/<usecase>/test.dart? (still not migrated all tests to v2)
- [x] flutter tests => a simple flutter project that uses the `@Query` / `@Fragment` codegen api's (currently passing) 
- [ ] flutter tests => `@Mutation` apis, we haven't decided how the mutation api would look like just yet.



