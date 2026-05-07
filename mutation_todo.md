# Mutation API Implementation TODO

Work proceeds bottom-up, same as v2_todo.md:
Rust runtime → FRB bridge → Dart client → annotations → codegen scanner → codegen lib → templates → tests.

---

## Agreed API shape (reference)

```dart
// User writes:
@Mutation("""
($input: UpdateUserInput!) {
  updateUser(input: $input) { id name }
}
""")
class UpdateUserMutation extends $UpdateUserMutation {
  const UpdateUserMutation(super.client);
}

// Simple call:
final data = await UpdateUserMutation(client).execute(input: UpdateUserInput(name: 'Alice'));

// Optimistic call:
final res = await UpdateUserMutation(client).executeOptimistic(
  (vars) => UpdateUserMutationData(
    updateUser: UpdateUserMutationData$updateUser(name: vars.input.name),
  ),
  rollbackWhen: (r) => r.updateUser == null,
  input: UpdateUserInput(name: 'Alice'),
);
if (res.wasRolledBack) showError(res.response);
res.rollback(); // idempotent — no-op if already rolled back (sync)
```

---

## 1. Rust Runtime (`rust/shalom_runtime/src/`) ✅

### 1a. `OptimisticWrite` snapshot store (`runtime.rs` or new `optimistic.rs`) ✅

- [x] Define `OptimisticWriteId(u64)` newtype (same pattern as `SubscriptionId`)
- [x] Define `OptimisticWrite` struct with `snapshot: HashMap<String, Option<CacheRecord>>` and `changed_refs: HashSet<String>`
- [x] Add `optimistic_writes: Arc<Mutex<HashMap<OptimisticWriteId, OptimisticWrite>>>` field to `ShalomRuntime`
- [x] Add atomic counter for `OptimisticWriteId` generation

### 1b. `write_optimistic` method on `ShalomRuntime` ✅

- [x] Signature: `pub fn write_optimistic(&self, op_name: &str, data: Value) -> anyhow::Result<OptimisticWriteId>`
- [x] Call `normalize_response_with_snapshot` (snapshot captured inside normalizer before each cache.insert)
- [x] Store `OptimisticWrite` in `optimistic_writes` map
- [x] Call `notify_subscribers()` so watching query subscriptions re-render immediately
- [x] Return the `OptimisticWriteId`

### 1c. `rollback_optimistic` method on `ShalomRuntime` ✅

- [x] Signature: `pub fn rollback_optimistic(&self, id: OptimisticWriteId) -> anyhow::Result<()>`
- [x] Look up and remove the `OptimisticWrite` from `optimistic_writes` (if absent → no-op)
- [x] For each `(key, maybe_prev_value)` in the snapshot: `Some(prev)` → restore; `None` → remove
- [x] Call `notify_subscribers()` with restored/removed keys

### 1d. Mutation normalization ✅

- [x] Snapshot captured inside `Normalizer::new_with_snapshot()` before each `cache.insert()`
- [x] Entity keys shared between queries and mutations (same normalized cache)
- [x] `normalize_response_with_snapshot` added to `execution/mod.rs`

---

## 2. FRB Bridge (`dart/shalom/rust/src/api/runtime.rs`) ✅

- [x] Expose `OptimisticWriteId` to Dart as `u64`
- [x] Add `write_optimistic` FRB async function returning `anyhow::Result<u64>`
- [x] Add `rollback_optimistic` FRB sync function (`#[frb(sync)]`)
- [x] Re-ran FRB codegen → regenerated `dart/shalom/lib/src/rust/api/runtime.dart` and `frb_generated.dart`

---

## 3. Dart Client (`dart/shalom/lib/src/runtime_client.dart`) ✅

- [x] Added `mutate<T>()` — one-shot future (wraps `request().first`)
- [x] Added `writeOptimistic()` — delegates to `rs_runtime.writeOptimistic`
- [x] Added `rollbackOptimistic()` — sync, delegates to `rs_runtime.rollbackOptimistic`

---

## 4. `OptimisticMutationResponse<T>` (`dart/shalom_flutter/lib/`) ✅

- [x] Created `dart/shalom_flutter/lib/src/optimistic_mutation_response.dart`
  - Public constructor (generated code in user apps must be able to call it)
  - `response`, `wasRolledBack` fields
  - `rollback()` sync method (idempotent via `_rolledBack` guard)
  - Holds `_client` and `_writeId` to perform rollback directly
- [x] Exported from `dart/shalom_flutter/lib/shalom_flutter.dart`

---

## 5. Annotations (`dart/shalom_annotations/`) ✅

- [x] Created `lib/src/mutation.dart` with `@immutable class Mutation { final String sdl; const Mutation(this.sdl); }`
- [x] Exported from `lib/shalom_annotations.dart`

---

## 6. Codegen Scanner (`rust/shalom_dart_codegen/src/dart_scanner.rs`) ✅

- [x] Replaced `is_query: bool` with `widget_kind: WidgetKind` (`Query | Fragment | Mutation`)
- [x] Updated all call sites in `lib.rs`
- [x] Added `@Mutation` to the scan loop

---

## 7. Codegen Main Logic (`rust/shalom_dart_codegen/src/lib.rs`) ✅

- [x] Added `generate_v2_mutation_sidecar()` function dispatched from main widget loop
- [x] Registered `mutation` and `mutation_widget` templates
- [x] Added `render_mutation()` and `render_mutation_widget()` to `OperationEnv`
- [x] Mutations registered in `generate_v2_registration_file()` without `@observe`

---

## 8. Templates (`rust/shalom_dart_codegen/templates/`) ✅

### 8a. `mutation.dart.jinja` ✅

- [x] Generates `<MutationName>Data` with typed fields, `fromCache`, `toJson`
- [x] Generates `<MutationName>Variables` (when variables exist) with `toJson`, `==`, `hashCode`
- [x] Handles unions, interfaces, fragment selection macros (same as `operation.dart.jinja`)

### 8b. `mutation_widget.dart.jinja` ✅

- [x] Generates `abstract class $<MutationName>` with `_client` field
- [x] Generates `execute({required Type varName,...})` returning `Future<Data>`
- [x] Generates `executeOptimistic(factory, {rollbackWhen, required vars,...})` returning `Future<OptimisticMutationResponse<Data>>`

---

## 9. Tests

### Rust runtime tests (`rust/shalom_runtime/tests/mutation.rs`) ✅

- [x] `mutation_normalizes_shared_entity` — mutation on User:1 triggers query subscription
- [x] `write_optimistic_updates_cache` — optimistic write fires before network
- [x] `rollback_optimistic_restores_state` — rollback restores Alice after Bob was written optimistically
- [x] `rollback_optimistic_is_idempotent` — calling rollback twice is a no-op
- [x] `write_optimistic_absent_key_rolls_back_to_absent` — key created by optimistic write is removed on rollback

### Codegen tests (`rust/shalom_dart_codegen/tests/`) ✅

- [x] Added `mutation_simple` usecase — `updateUserName(id, name): User`, tests `fromCache`/`toJson`/Variables
- [x] Added `mutation_no_variables` usecase — `resetCache: Boolean`, no Variables class, no-arg `execute()`

---

## Implementation order

1. ✅ Rust: `OptimisticWriteId` + `OptimisticWrite` struct + `write_optimistic` + `rollback_optimistic` (§1)
2. ✅ Rust tests for optimistic (§9 Rust section) — all 5 pass
3. ✅ FRB bridge: expose `write_optimistic` + `rollback_optimistic` + re-run codegen (§2)
4. ✅ Dart client: `mutate()` + `writeOptimistic()` + `rollbackOptimistic()` (§3)
5. ✅ `OptimisticMutationResponse<T>` in `shalom_flutter` (§4)
6. ✅ Annotations: `@Mutation` (§5)
7. ✅ Scanner: `WidgetKind` enum + `@Mutation` scan (§6)
8. ✅ Codegen lib: dispatch for `WidgetKind::Mutation` (§7)
9. ✅ Templates: `mutation.dart.jinja` + `mutation_widget.dart.jinja` (§8)
10. ✅ Codegen integration tests: `mutation_simple` + `mutation_no_variables` (§9)
