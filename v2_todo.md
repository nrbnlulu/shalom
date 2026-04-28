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

### Codegen tests — new V2 annotation-based tests

- [x] `dart_tests/pubspec.yaml` — add `shalom_annotations` dependency
- [x] `dart_scanner.rs` — fix `@Query`/`@Fragment` pattern
- [x] `observe_query_widget/` — `GetUser.dart` with `@Query(...)`, `test_runtime.dart`
- [x] `observe_fragment_widget/` — `PetFrag.dart` with `@Fragment(...)`, `test_runtime.dart`
- [x] `observe_union_fragment/` — `AnimalFrag.dart` with `@Fragment(...)`, `test_runtime.dart`
- [x] `usecases_test.rs` — entries for all three new tests
- [ ] Run the three new V2 tests end-to-end (blocked until `dart pub get` + frb codegen in CI)

### Codegen tests — migrate existing tests to annotation syntax

The existing tests fall into two categories:
- **Input tests** (`input_usecases_test.rs`): test codegen for mutation input types; most pass now
  that the core compile errors are fixed. 3 still use V1 API (`ShalomCtx`, `fromCache`, `fromResponseImpl`).
- **Selection tests** (`usecases_test.rs`): test codegen for query/fragment output types; these use
  `.graphql` input files and V1 API — all need migration.

**Currently passing** (10/13 input tests green):
- `simple_scalars`, `object_selection`, `nested_object_selection`, `fragments`, `cross_dir_fragments`,
  `fragment_with_nested_object_selection`, `union_selection`, `union_partial_selection`, `interface_selection`,
  `list_of_*`, `custom_scalar*`, `enum_*`, `cache_by_arguments_object`, `runtime_metadata`, `helpers`,
  `object_selection_with_typename` — these are the usecases_test.rs tests, not yet run
- `input_list_scalars`, `input_list_objects`, `input_list_enums`, `input_list_custom_scalars`,
  `input_objects`, `nested_input_objects`, `enum_arguments`, `operation_scalar_arguments`,
  `custom_scalar_arguments`, `required_inputs_with_defaults` ✅

**Still failing** (3 input tests use V1 API in their `test.dart`):
- [ ] `one_of_input` — `test.dart` uses `ShalomCtx`, `fromCache`, `fromResponseImpl`
- [ ] `input_objects_with_inline_variables` — same
- [ ] `input_list_with_defaults` — same

**Not yet run / need migration** (selection usecases_test.rs tests):
- [ ] `simple_scalars`
- [ ] `object_selection`
- [ ] `nested_object_selection`
- [ ] `fragments`
- [ ] `cross_dir_fragments`
- [ ] `fragment_with_nested_object_selection`
- [ ] `union_selection` / `union_partial_selection`
- [ ] `interface_selection`
- [ ] `list_of_scalars` / `list_of_objects` / `list_of_enums` / `list_of_fragments`
- [ ] `list_of_unions` / `list_of_interfaces` / `list_of_custom_scalars`
- [ ] `custom_scalar` / `custom_scalar_arguments`
- [ ] `enum_selection` / `enum_arguments`
- [ ] `cache_by_arguments_object`
- [ ] `input_objects_with_inline_variables` / `nested_input_objects`
- [ ] `fragments_on_interface` / `interface_shared_fragments` / `interface_with_nested_type_fragments`
- [ ] `nested_fragments_3_level` / `fragment_id_on_non_root_field`
- [ ] `object_fragment_list_interfaces`
- [ ] `operation_scalar_arguments`
- [ ] `runtime_metadata`
- [ ] `helpers`
- [ ] `object_selection_with_typename`

othis is how we should proceed with flutter tests:

- we should have test for every possible flutter style tests
meaning that we'd have a widget that uses `@Query` and we'd check that it actually accepts a result
then we should have another test for a `@Query` with a `@Fragment` widget (probably something like zoo->animals relation where zoo is the query and we have `AnimalWidget` which is a `@Fragment`).
- then we should keep the other dart only tests which will test edgecases for all the uniuque types and == operators etc.. 

this way we have a minimal tests for flutter just for the unique behaviour we expect from flutter (interacting with the runtime using the codegen) and dart tests can stay focused and minimal. 

one thing that we must verify is that the codegen code that generates the dart types is re-used for the flutter codegen. so that we don't need to test everything twice.

start with the first test for `@Query` I'll revise this and you'd continute.

[@lib](file:///run/media/dev/33da92da-1869-46ee-a0c1-fd5c4c9049e5/@home/dev/1tb_desktop/1tboss/shalom/rust/shalom_dart_codegen/dart_tests/lib/) concept is that [@observe_query_widget](file:///run/media/dev/33da92da-1869-46ee-a0c1-fd5c4c9049e5/@home/dev/1tb_desktop/1tboss/shalom/rust/shalom_dart_codegen/dart_tests/test/observe_query_widget/) would use the minimal flutter app in [@lib](file:///run/media/dev/33da92da-1869-46ee-a0c1-fd5c4c9049e5/@home/dev/1tb_desktop/1tboss/shalom/rust/shalom_dart_codegen/dart_tests/lib/) that would contain `/query/user_widget.dart` and `/query/users_screen.dart` and the generated code would reside there.  and we'd use proper flutter testing to check if the widget succesfully rendered with the rust runtime passing the data (mock link)

---

## Current Status (agent handoff 2026-04-28)

### What's done

The test structure has been fully split into two separate projects:

**`flutter_tests/`** — Flutter-specific integration tests
- Three test scenarios: `UserWidget` (`@Query`), `PetQuery`+`PetWidget` (`@Query`+`@Fragment`), `AnimalQuery`+`AnimalWidget` (`@Query`+union `@Fragment` on interface `Animal`)
- All Dart files use the correct short-form SDL (body only, no `query Name(...)` prefix) and PascalCase import paths matching codegen output
- Test files import from correct `../__graphql__/shalom_init.shalom.dart` (root of flutter_tests, not lib/)
- `lib/main.dart` is a minimal valid Flutter app (no dot-shorthand syntax)

**`dart_tests/`** — Pure Dart codegen tests (no Flutter widgets)
- All Flutter files removed (`lib/main.dart`, `lib/query/`, `test/observe_*/test_runtime.dart`)
- `test/observe_query_widget/GetUser.dart` added as a minimal `@Query` annotated class
- `pubspec.yaml` cleaned: removed `shalom_flutter`/`flutter_test`, kept `flutter: sdk: flutter` (required transitively via shalom's flutter_rust_bridge dep)
- `tests/usecases_test.rs` cleaned: removed `run_runtime_tests_for_usecase` import and dead test

**`templates/operation.dart.jinja`**
- Fixed `Variables.==` operator: now inlines list check using `field.common.type.kind.kind == "List"` instead of calling `selection_equality_comparison_macro` with an `InputFieldDefinition` (which has no top-level `kind`)

### Current blocker — multiple Dart compile errors in flutter test

Running `cargo test -p shalom_dart_codegen test_flutter_app` fails at `flutter test`. The codegen runs successfully but the generated Dart has these issues:

**1. `{Fragment}Ref._` private constructor used across files**
- `fragment.dart.jinja` generates `extension type AnimalWidgetRef._(ObservedRefInput _inner)` — the `._` constructor is Dart library-private
- `selection_macros.dart.jinja` line 82/84 generates `AnimalWidgetRef._(shalom_core.observedRefInputFromJson(...))` from a different file
- Fix: change `._` to a public named constructor (e.g. `.fromInput`) in the fragment template, and update the macro to match

**2. `{Fragment}Ref.toJson()` missing**
- `AnimalQueryData.toJson()` calls `this.animal?.toJson()` but `AnimalWidgetRef` has no `toJson()` method
- Fix: add `shalom_core.JsonObject toJson() => _inner.toJson();` to the `{Fragment}Ref` extension type in `fragment.dart.jinja`

**3. `Object.hash()` requires ≥2 args — single-field classes fail**
- `AnimalWidgetData$Impl` (1 field: `id`) and `AnimalQueryVariables` (1 field: `id`) generate `Object.hash(id,)` which Dart rejects
- Affected templates: `fragment.dart.jinja` line 88 and `operation.dart.jinja` line 168
- Fix: change both to `Object.hashAll([...])` which works for any number of fields

**4. Legacy object/interface class generates `implements AnimalWidget` in V2 mode**
- `operation.dart.jinja` lines 51/68 call `implements_used_fragments(concrete_subset.used_fragments)` for union/interface concrete classes
- In V2 mode, the fragment sidecar has no interface named `AnimalWidget` — that name belongs to the user's Flutter widget class
- Error: `sealed class AnimalQuery_animal implements AnimalWidget` — `AnimalWidget` type not found
- Fix: suppress `implements_used_fragments` when `is_observe` is true (add `and not is_observe` guard in the macro inside `selection_macros.dart.jinja`)
- Also: `selection_object_impl.fromJson` uses `type_name_for_selection` for local variable types but deserializes to a `{Frag}Ref` type — these are inconsistent. Fix: use `type_name_for_selection_with_observe` for the local variable type declaration (line 289 of `selection_macros.dart.jinja`)

**5. `AnimalWidgetData$Dog` / `AnimalWidgetData$Cat` not generated (most complex)**
- `AnimalWidget` fragment is on interface `Animal` with `... on Dog { breed }` / `... on Cat { color }` inline fragments
- `fragment.dart.jinja` has the right template logic (lines 118–181) to generate `Data$Dog`/`Data$Cat` from `typedefs.interfaces`
- But `typedefs.interfaces` is empty for the `AnimalWidget` fragment — the shalom_core parser doesn't populate interface typedefs when the fragment root type is itself an interface
- The QUERY sidecar (`AnimalQuery.shalom.dart`) DOES correctly generate `AnimalQuery_animal__Dog`/`AnimalQuery_animal__Cat`, so the parsing works for queries but not for fragments
- Fix: investigate `shalom_core/src/operation/parse.rs` — `parse_obj_like_from_selection_set` handles inline fragments (lines 221–245) but for a fragment whose root IS an interface, the inline `... on Dog {}` merges into `obj_like.type_cond_selections` via `obj_like.merge(typed_obj)`. Check if `parse_fragment` in `fragments.rs` calls `parse_interface_selection` for the root type, or if it bypasses that and goes straight to `parse_obj_like_from_selection_set` which skips interface typedef registration.

### Files modified this session

| File | Change |
|------|--------|
| `rust/shalom_dart_codegen/src/lib.rs` | Fragment-before-query ordering in `generate_v2_widgets`; `@observe` placement fix using `replacen` |
| `templates/operation.dart.jinja` | Fixed `Variables.==` operator (inlined list check) |
| `flutter_tests/lib/query/user_widget.dart` | Short-form SDL, PascalCase widget sidecar import |
| `flutter_tests/lib/fragment/pet_widget.dart` | PascalCase import |
| `flutter_tests/lib/fragment/pet_query.dart` | Short-form SDL, correct widget sidecar import |
| `flutter_tests/lib/union_fragment/animal_widget.dart` | PascalCase import |
| `flutter_tests/lib/union_fragment/animal_query.dart` | Short-form SDL, correct widget sidecar import |
| `flutter_tests/test/user_widget_test.dart` | Correct shalom_init path |
| `flutter_tests/test/pet_widget_test.dart` | Correct shalom_init + PetQuery import paths |
| `flutter_tests/test/animal_widget_test.dart` | Correct shalom_init + AnimalQuery import paths |
| `flutter_tests/test/widget_test.dart` | Deleted |
| `flutter_tests/lib/main.dart` | Replaced with minimal valid Flutter app |
| `dart_tests/lib/main.dart` | Deleted |
| `dart_tests/lib/query/` | Deleted (all Flutter widget files) |
| `dart_tests/test/observe_*/test_runtime.dart` | Deleted (Flutter tests) |
| `dart_tests/test/observe_query_widget/GetUser.dart` | Created (pure Dart `@Query` class) |
| `dart_tests/pubspec.yaml` | Removed `shalom_flutter`/`flutter_test` |
| `tests/usecases_test.rs` | Removed dead `run_runtime_tests_for_usecase` import + test |

### Next steps for the next agent

Apply fixes in this order (each is independent except #5 which requires Rust):

1. **`fragment.dart.jinja`**: Change `._` → `.fromInput` in extension type constructor; add `toJson()` → `_inner.toJson()` method; change `Object.hash(...)` → `Object.hashAll([...])`
2. **`operation.dart.jinja`**: Change `Object.hash(...)` → `Object.hashAll([...])`
3. **`selection_macros.dart.jinja`**:
   - Lines 82/84: change `Ref._(` → `Ref.fromInput(`
   - Line 289 (`selection_object_impl.fromJson`): change `type_name_for_selection(selection)` → `type_name_for_selection_with_observe(selection)` for local variable type declarations
   - `implements_used_fragments` macro (lines 3–10): add `and not is_observe` so it suppresses the `implements` clause for V2 operations
4. **`shalom_core/src/operation/parse.rs` or `fragments.rs`**: Fix `AnimalWidgetData$Dog`/`Cat` generation — the fragment root type (`Animal`) is an interface, but `parse_fragment` doesn't register the interface typedef (`typedefs.interfaces`) the way `parse_field_selection` does for query fields. The inline fragments (`... on Dog`, `... on Cat`) in `parse_obj_like_from_selection_set` end up in `obj_like.type_cond_selections` but never get promoted to `ctx.typedefs_mut().interfaces`. Look at how `parse_interface_selection` is called for query fields (line 374–381 of parse.rs) — replicate that typedef registration for the fragment root when it is an interface type. 