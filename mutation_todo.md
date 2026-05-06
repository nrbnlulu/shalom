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
await res.rollback(); // idempotent — no-op if already rolled back
```

---

## 1. Rust Runtime (`rust/shalom_runtime/src/`)

### 1a. `OptimisticWrite` snapshot store (`runtime.rs` or new `optimistic.rs`)

- [ ] Define `OptimisticWriteId(u64)` newtype (same pattern as `SubscriptionId`)
- [ ] Define `OptimisticWrite` struct:
  ```rust
  struct OptimisticWrite {
      id: OptimisticWriteId,
      // cache key → value that existed before the write (None = key was absent)
      snapshot: HashMap<String, Option<CacheValue>>,
  }
  ```
- [ ] Add `optimistic_writes: Arc<Mutex<HashMap<OptimisticWriteId, OptimisticWrite>>>` field to `ShalomRuntime`
- [ ] Add atomic counter for `OptimisticWriteId` generation (same as `SubscriptionId` counter)

### 1b. `write_optimistic` method on `ShalomRuntime`

- [ ] Signature: `pub fn write_optimistic(&self, op_name: &str, data: Value, variables: Option<&Map<String,Value>>) -> anyhow::Result<OptimisticWriteId>`
- [ ] Look up the `SharedOpCtx` by `op_name` (assert it is `OperationType::Mutation`)
- [ ] Before normalizing: snapshot all cache keys that the normalization would touch
  - Walk the `data` tree, collect the set of keys that `normalize()` would write
  - Read their current values from the cache → store in `OptimisticWrite::snapshot`
- [ ] Call the existing `normalize()` path with the optimistic data (writes to cache)
- [ ] Call `notify_subscribers()` so watching query subscriptions re-render immediately
- [ ] Store the `OptimisticWrite` in `optimistic_writes` map
- [ ] Return the `OptimisticWriteId`

> **Note on key collection**: the cleanest approach is to do a dry-run walk of `data` against
> the op context to collect the keys, then snapshot, then write. Alternatively, snapshot
> every key that `normalize()` touches by threading a `touched_keys` set through it (normalize
> already computes `NormalizationResult` — extend that or reuse `touched_cache_keys` from it).

### 1c. `rollback_optimistic` method on `ShalomRuntime`

- [ ] Signature: `pub fn rollback_optimistic(&self, id: OptimisticWriteId) -> anyhow::Result<()>`
- [ ] Look up and remove the `OptimisticWrite` from `optimistic_writes` (if absent → no-op, return Ok)
- [ ] For each `(key, maybe_prev_value)` in the snapshot:
  - `Some(prev)` → restore that value in the cache
  - `None` → remove the key from the cache (it didn't exist before)
- [ ] Call `notify_subscribers()` with the set of restored/removed keys so watchers re-render

### 1d. Mutation normalization (verify existing behaviour)

- [ ] Confirm that `normalize()` already uses `ROOT_MUTATION` as root when `op_type == Mutation`
- [ ] Confirm that entity keys (`User:1`, etc.) are written to the shared entity store (same as query normalization), so mutations update data watched by query subscriptions
- [ ] Add a runtime test: mutation normalizes entity → query subscription watching that entity fires

---

## 2. FRB Bridge (`dart/shalom/rust/src/api/runtime.rs`)

- [ ] Expose `OptimisticWriteId` to Dart as a `u64` (same pattern as `SubscriptionId`)
- [ ] Add `write_optimistic` FRB function:
  ```rust
  #[frb]
  pub async fn write_optimistic(
      handle: &RuntimeHandle,
      op_name: String,
      data_json: String,
  ) -> anyhow::Result<u64>  // OptimisticWriteId
  ```
  - Parse `data_json` → `serde_json::Value`
  - Delegate to `handle.runtime.write_optimistic(&op_name, data, None)`
  - Return `id.into()`

- [ ] Add `rollback_optimistic` FRB function:
  ```rust
  #[frb(sync)]
  pub fn rollback_optimistic(
      handle: &RuntimeHandle,
      write_id: u64,
  ) -> anyhow::Result<()>
  ```
  - Delegate to `handle.runtime.rollback_optimistic(OptimisticWriteId(write_id))`

- [ ] Re-run FRB codegen → regenerate `dart/shalom/lib/src/rust/api/runtime.dart`

---

## 3. Dart Client (`dart/shalom/lib/src/runtime_client.dart`)

- [ ] Add `mutate<T>()` — one-shot future (wraps `request().first`):
  ```dart
  Future<T> mutate<T>({
    required String name,
    Map<String, dynamic>? variables,
    required T Function(JsonObject) decoder,
  }) => request<T>(name: name, variables: variables, decoder: decoder).first;
  ```

- [ ] Add `writeOptimistic()`:
  ```dart
  Future<BigInt> writeOptimistic({
    required String name,
    required JsonObject data,
  }) async {
    final id = await rs_runtime.writeOptimistic(
      handle: _handle,
      opName: name,
      dataJson: jsonEncode(data),
    );
    return id;
  }
  ```

- [ ] Add `rollbackOptimistic()`:
  ```dart
  Future<void> rollbackOptimistic(BigInt writeId) =>
      rs_runtime.rollbackOptimistic(handle: _handle, writeId: writeId);
  ```

---

## 4. `OptimisticMutationResponse<T>` (`dart/shalom_flutter/lib/`)

- [ ] Create `dart/shalom_flutter/lib/src/optimistic_mutation_response.dart`:
  ```dart
  class OptimisticMutationResponse<T> {
    OptimisticMutationResponse._({
      required this.response,
      required this.wasRolledBack,
      required ShalomRuntimeClient client,
      required BigInt writeId,
    })  : _client = client,
          _writeId = writeId;

    final T response;
    final bool wasRolledBack;
    final ShalomRuntimeClient _client;
    final BigInt _writeId;
    bool _rolledBack = false;  // tracks if rollback() has been called

    Future<void> rollback() async {
      if (_rolledBack) return;
      _rolledBack = true;
      await _client.rollbackOptimistic(_writeId);
    }
  }
  ```
  > `wasRolledBack` is set at construction time (true if `rollbackWhen` fired).
  > `rollback()` is always safe to call — idempotent via `_rolledBack` guard.

- [ ] Export from `dart/shalom_flutter/lib/shalom_flutter.dart`

---

## 5. Annotations (`dart/shalom_annotations/`)

- [ ] Create `lib/src/mutation.dart`:
  ```dart
  import 'package:meta/meta.dart';

  @immutable
  class Mutation {
    final String sdl;
    const Mutation(this.sdl);
  }
  ```
- [ ] Export from `lib/shalom_annotations.dart`

---

## 6. Codegen Scanner (`rust/shalom_dart_codegen/src/dart_scanner.rs`)

- [ ] Replace `is_query: bool` on `WidgetAnnotation` with:
  ```rust
  pub enum WidgetKind {
      Query,
      Fragment,
      Mutation,
  }
  // on WidgetAnnotation:
  pub widget_kind: WidgetKind,
  ```
- [ ] Update all `is_query` call sites in `lib.rs` to use `widget_kind`
- [ ] Add `@Mutation` to the scan loop alongside `@Query` / `@Fragment`:
  ```rust
  for (kind, tag) in [
      (WidgetKind::Query,    r"@Query"),
      (WidgetKind::Fragment, r"@Fragment"),
      (WidgetKind::Mutation, r"@Mutation"),
  ] { ... }
  ```
- [ ] The regex is identical for all three — no other changes to the regex

---

## 7. Codegen Main Logic (`rust/shalom_dart_codegen/src/lib.rs`)

- [ ] In the widget dispatch loop, add arm for `WidgetKind::Mutation`:
  - Wrap SDL as `mutation <ClassName>(...) { <sdl> }` (no `@observe` directive)
  - Parse + validate against schema (same path as query, just different op type)
  - Render `mutation.dart.jinja` → emit `<snake_name>.shalom.dart`
  - Render `mutation_widget.dart.jinja` → emit `<snake_name>.widget.shalom.dart`
    (the file containing `$MutationName` base class — mirrors `operation_widget.dart.jinja`)

- [ ] In `generate_v2_registration_file`: include mutations in the registration call list
  - Register as operations via `client.registerOperation(document: r'mutation ...')` (same as queries)
  - No `@observe` → do NOT add the directive when wrapping mutation SDL

---

## 8. Templates (`rust/shalom_dart_codegen/templates/`)

### 8a. `mutation.dart.jinja` (new — mirrors `operation.dart.jinja` V2 section)

Generates the data + variables types. No widget, no state.

- [ ] Generate `<MutationName>Data` class with:
  - Typed fields for each selection
  - `static <MutationName>Data fromCache(JsonObject data)` deserializer
  - `JsonObject toJson()`

- [ ] Generate `<MutationName>Variables` class (if variables exist) with:
  - Typed fields (flat — same as query Variables codegen)
  - `JsonObject toJson()`
  - `operator ==` and `hashCode`

- [ ] Header imports: `shalom_core`, `collection`, `meta` (same as `operation.dart.jinja`)

- [ ] Generate union/interface sub-types if the mutation response contains them
  (reuse `selection_macros.dart.jinja` — same macro set as queries)

### 8b. `mutation_widget.dart.jinja` (new — mirrors `operation_widget.dart.jinja`)

Generates the `$<MutationName>` abstract base class.

- [ ] Imports:
  ```dart
  import 'dart:async';
  import 'package:shalom/shalom.dart' as shalom_core;
  import 'package:shalom_flutter/shalom_flutter.dart' show OptimisticMutationResponse;
  import '<mutation_name>.shalom.dart';
  ```

- [ ] Generate `abstract class $<MutationName>`:
  ```dart
  abstract class $<MutationName> {
    final shalom_core.ShalomRuntimeClient _client;
    const $<MutationName>(this._client);

    // -- execute() --
    // One named param per mutation variable (flat — no Variables wrapper at call site)
    Future<<MutationName>Data> execute({
      {% for name, field in op_variables %}required {{ type }} {{ name }},{% endfor %}
    }) =>
        _client.mutate(
          name: '<MutationName>',
          variables: <MutationName>Variables(
            {% for name in op_variables %}{{ name }}: {{ name }},{% endfor %}
          ).toJson(),
          decoder: <MutationName>Data.fromCache,
        );

    // -- executeOptimistic() --
    Future<OptimisticMutationResponse<<MutationName>Data>> executeOptimistic(
      <MutationName>Data Function(<MutationName>Variables vars) optimisticFactory, {
      bool Function(<MutationName>Data response)? rollbackWhen,
      {% for name, field in op_variables %}required {{ type }} {{ name }},{% endfor %}
    }) async {
      final vars = <MutationName>Variables(
        {% for name in op_variables %}{{ name }}: {{ name }},{% endfor %}
      );
      final writeId = await _client.writeOptimistic(
        name: '<MutationName>',
        data: optimisticFactory(vars).toJson(),
      );
      var rolledBack = false;
      Future<void> doRollback() async {
        if (rolledBack) return;
        rolledBack = true;
        await _client.rollbackOptimistic(writeId);
      }
      try {
        final response = await _client.mutate(
          name: '<MutationName>',
          variables: vars.toJson(),
          decoder: <MutationName>Data.fromCache,
        );
        if (rollbackWhen?.call(response) ?? false) await doRollback();
        return OptimisticMutationResponse._(
          response: response,
          wasRolledBack: rolledBack,
          client: _client,
          writeId: writeId,
        );
      } catch (e) {
        await doRollback();
        rethrow;
      }
    }
  }
  ```

- [ ] If mutation has no variables: omit `Variables` class and use empty `toJson()` / no named params on `execute()`

---

## 9. Tests

### Rust runtime tests (`rust/shalom_runtime/tests/`)

- [ ] `mutation_normalizes_shared_entity`: mutation response updates `User:1` → query subscription watching `User:1` fires
- [ ] `write_optimistic_updates_cache`: `write_optimistic` immediately updates cache; subscribers fire before network response
- [ ] `rollback_optimistic_restores_state`: after `rollback_optimistic`, cache keys return to pre-write values; subscribers re-render
- [ ] `rollback_optimistic_is_idempotent`: calling rollback twice does not panic or error
- [ ] `write_optimistic_absent_key_rolls_back_to_absent`: key that didn't exist before the optimistic write is removed on rollback (not left with stale value)
- [ ] `mutation_network_failure_does_not_corrupt_cache`: confirm no partial writes remain after a failed normalize

### Dart client tests (`dart/shalom/test/`)

- [ ] `mutate_returns_normalized_data`: `mutate()` resolves once with response data, stream closes
- [ ] `mutate_updates_query_subscription`: mutation on `User:1` triggers re-emit on an active query subscription watching `User:1`
- [ ] `write_optimistic_then_rollback`: cache reflects optimistic value, then restores after `rollbackOptimistic()`

### Codegen tests (`rust/shalom_dart_codegen/tests/usecase_tests.rs` + `dart_tests/`)

- [ ] Add `mutation_simple` usecase:
  - Schema with a mutation returning a type with `id`
  - `@Mutation(...)` annotation on a Dart class
  - Verify generated `Data` class: correct fields, `fromCache`, `toJson`
  - Verify generated `Variables` class: correct fields, `toJson`, `==`, `hashCode`
  - Verify generated `$Mutation` base class: `execute()` signature, `executeOptimistic()` signature

- [ ] Add `mutation_no_variables` usecase:
  - Mutation with no variables
  - Verify `execute()` takes no params, no `Variables` class generated

- [ ] Add `mutation_errors_as_data` dart test:
  - Response type includes an optional `error` field
  - `executeOptimistic(..., rollbackWhen: (r) => r.error != null)` rolls back when error is present
  - `wasRolledBack` is `true` on the returned response

---

## Implementation order

1. Rust: `OptimisticWriteId` + `OptimisticWrite` struct + `write_optimistic` + `rollback_optimistic` (§1)
2. Rust tests for optimistic (§9 Rust section) — confirm snapshot/restore works
3. FRB bridge: expose `write_optimistic` + `rollback_optimistic` + re-run codegen (§2)
4. Dart client: `mutate()` + `writeOptimistic()` + `rollbackOptimistic()` (§3)
5. `OptimisticMutationResponse<T>` in `shalom_flutter` (§4)
6. Annotations: `@Mutation` (§5) — trivial, do alongside §4
7. Scanner: `WidgetKind` enum + `@Mutation` scan (§6)
8. Codegen lib: dispatch for `WidgetKind::Mutation` (§7)
9. Templates: `mutation.dart.jinja` + `mutation_widget.dart.jinja` (§8)
10. Codegen + Dart tests (§9)
