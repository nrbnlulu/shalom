# Shalom Rust Runtime Implementation Plan
# initial query
## Context

We are working on a **Rust runtime for Shalom**.
Instead of the current code-generation approach, logic is moved into a runtime layer.

The previous behavior is documented in `AGENTS.md` and implemented via Dart codegen templates such as:

* `operation.dart.jinja`
* `selection_macros.dart.jinja`

These templates implemented logic such as `fromCache`, `normalize_selection_in_cache`, and related helpers.
All of this logic must now live in the Rust runtime.

---

## Components to implement

### 1. `shalom_runtime`

Responsible for:

* Executing GraphQL operations
* Normalizing results
* Managing the normalized cache
* Emitting fine-grained cache update signals
* Performing cache garbage collection based on active subscriptions

---

### Normalization rules

When an operation result arrives, normalize objects as follows (as documented in `AGENTS.md`):

#### Objects with an `id` field

* `id` may be `Int`, `ID`, or `String`
* `id` may be optional
* When present:

  * stringify it
  * store the object **at the top level of the cache** using a canonical entity key:

    ```
    <TypeName>:<id>
    ```
* Parent objects store a `Ref(<TypeName>:<id>)` instead of the full object

#### Objects without an `id` field

* Stored inline on the parent object
* Cache keys must include:

  * field name
  * field arguments (including variables)

---

### Example query

```graphql
person(name: "foo") {
  name
  pets(first: 5) {
    name
  }
  country(birth: true) {
    id
    name
  }
}
```

### Normalized cache shape

```json
{
  "ROOT_QUERY": {
    "person_name:foo": {
      "name": "foo",
      "pets_first:5": [
        { "name": "cocky" },
        { "name": "baz" }
      ],
      "country_birth:true": { "__ref": "Country:4324" }
    }
  },
  "Country:4324": {
    "id": 4324,
    "name": "Israel"
  }
}
```

---

## 2. `shalom_link`

A Rust implementation of the Dart links responsible for **GraphQL transport protocols**:

* **GraphQL-over-HTTP**
* **The new GraphQL WebSocket protocol**

These are currently implemented in Dart and must be ported to Rust:

* `http_link.dart`
* `ws_link.dart`

### Important constraints

* **Rust must NOT perform network requests**

  * Dart (or other host languages) owns networking
  * This mirrors the existing design using `dio_transport.dart`
  * This is required for Web support
* Rust links:

  * orchestrate request / response lifecycles
  * handle protocol-level framing and streaming
* A native Rust transport may be added in the future, but **not now**

---

## 3. `shalom_dart` crate

* Integrates Dart / Flutter with `shalom_runtime`
* Uses `flutter_rust_bridge`
* Responsible for:

  * sending operations to the runtime
  * receiving execution results
  * subscribing to runtime update signals

---

## Execution & streaming model

* GraphQL is **stream-based**
* If Rust has a native stream abstraction, use it
* Otherwise, use an **SPSC channel**

### Flow

1. Client sends `(query, variables)` to the runtime
2. Runtime executes the operation via configured links
3. Runtime returns:

   * the **raw GraphQL response data**
   * injected metadata (see below)
4. Client deserializes the response using its generated types
5. Clients (e.g. Flutter widgets) use the returned metadata to subscribe to updates

---

## Cache updates & subscriptions (critical)

### Motivation

Currently, cache updates are delegated to `client.request`, which forces:

* full response traversal
* rebuilding large widget trees (often entire root queries)

This is prohibitively expensive for large queries.

### New approach: injected subscription metadata

The runtime returns **normal response data**, plus **metadata fields** that allow clients to subscribe to **specific cache locations**.

This metadata is explicitly designed to be used by **Flutter (and other clients)** to:

* subscribe to field-level changes
* rebuild only affected widgets
* avoid whole-tree invalidation

---

## Metadata conventions

Injected fields are **not part of the GraphQL schema** and are reserved by the runtime.

### Reserved fields

* `__ref`
  Object-level subscription metadata

* `__ref_<field>`
  Subscription key for a scalar or subfield

* `__ref_<listField>`
  Subscription key for list structural changes

---

## Update semantics

The runtime must trigger updates when:

### 1. Union / interface object identity changes

* If `__typename` changes between writes
* Notify the object-level `__ref`
* If the object has an `id`, entity subscribers must also be notified

### 2. Scalar field changes

* Notify `__ref_<field>`

### 3. List structural changes

* Length changes
* Reordering
* Pagination merges
* Notify `__ref_<listField>`

Item-level field changes must notify only the item’s own refs unless structure changes.

---

## Returned response shape (example)

```json
{
  "person": {
    "__ref": { "path": "ROOT_QUERY_person$name:foo" },

    "name": "foo",
    "__ref_name": "ROOT_QUERY_person$name:foo_name",

    "pets": [
      {
        "name": "cocky",
        "__ref": { "path": "ROOT_QUERY_person$name:foo_pets$first:5[0]" }
      },
      {
        "name": "baz",
        "__ref": { "path": "ROOT_QUERY_person$name:foo_pets$first:5[1]" }
      }
    ],
    "__ref_pets": "ROOT_QUERY_person$name:foo_pets$first:5",

    "country": {
      "__ref": { "id": "Country:4324" },
      "id": 4324,
      "name": "Israel",
      "__ref_name": "Country:4324_name"
    }
  }
}
```

### Important clarification about `country`

* `country` is **NOT** a union or interface
* Therefore:

  * It **MUST NOT** include a `path` field
  * It **ONLY** includes an `id`
* The `id` **must be the canonical entity key**:

```json
"__ref": { "id": "Country:4324" }
```

Paths are required only for:

* non-entity objects
* union / interface objects whose concrete type may change

---

## Garbage collection (GC)

The Rust runtime is responsible for **cache garbage collection**.

### GC model

* Clients subscribe to cache locations using subscription keys derived from:

  * `__ref`
  * `__ref_<field>`
  * `__ref_<listField>`
* The runtime maintains reference counts (or equivalent bookkeeping) for active subscriptions.

### GC behavior

* Periodically, the runtime scans the cache
* If a cache entry (field, object, or list):

  * has **no active subscriptions**
  * and is **not required as a parent for any subscribed entry**
* Then the runtime **may evict it from the cache**

### Requirements

* GC must be safe:

  * never evict data still reachable by an active subscription
* GC may be incremental or batched
* Entity objects (`<Type>:<id>`) may be retained longer, but must still be evictable when fully unused

---

## Summary

This runtime-driven model:

* Eliminates expensive full-tree rebuilds
* Enables fine-grained Flutter subscriptions
* Centralizes normalization, execution, GC, and signaling in Rust
* Preserves compatibility with generated client models
* Supports GraphQL-over-HTTP and the new GraphQL WebSocket protocol without Rust networking

### Client (target language) API
ok now the client api should look like so.

- init runtime: provide the schema SDL (as a string for now), a root link and a config (for now we don't anything in the config I think but..) and a list of all the fragment SDL's. the codegen of the target language (for now dart only) can auto generate an init runtime for each schema it finds (for now we only support one schema).
- client calls runtime.request(query: "<query SDL>", variables: vars) and gets a response with injected refs as json.
- if the client decides it wants to subscribe to an object it will call `runtime.subscribe(operation_id, list_of_refs)` the runtime will watch for changes in those refs, and once found it will "execute" against the cache (internally) for all the selections (if its not a scalar) under the root ref that was provided based on the operation_id parsed SDL.  
- for flutter i.e we can have a stream builder for each runtime subscription, it will internally accept a runtime (can be fetched from the context) and any type that implements `FromCache` (since dart doesn't have static "traits" i.e overrides that returns Self we need to do a trick with a method that returns a builder of Self) the codegen can automatically generate the FromCache thing and ITF might also auto inject the type. OFC the type that we use in that we use must be the correct type of the root ref. ideally we should encourege just using fragments for `RefSubscriptionWdiget`s.

make sure that the rust backend is ready for this and implement needed api in the flutter_rust_bridge codegen.


## Goals
- Move normalization, cache management, and update signaling into Rust runtime.
- Emit metadata fields (`__ref`, `__ref_<field>`) for fine-grained client subscriptions.
- Keep transport logic in Rust orchestration layer without performing network I/O.
- Provide a Dart/Flutter bridge entry point (via `flutter_rust_bridge` later).

## Runtime Architecture (Proposed)
- `shalom_runtime`
  - `cache`: normalized store (ROOT_* + entity records).
  - `normalization`: response normalization + metadata injection + change tracking.
  - `execution`: orchestration layer (links + cache + streams).
  - `link`: HTTP + WS framing (no networking).
  - `host`: request/response bridge for host languages (outgoing request stream + response sink).
- `shalom_dart`
  - Glue crate exposing runtime to Dart via FRB.
  - API surface: execute op, normalize response, subscribe/unsubscribe.

## Cache & Normalization Model
- Cache keys:
  - Root: `ROOT_QUERY`, `ROOT_MUTATION`, `ROOT_SUBSCRIPTION`.
  - Entity: `<TypeName>:<id>`.
  - Field cache key (for storage): `field_arg:val_arg2:val2` (args joined by `_`).
  - Path key (for metadata): `parent_field$arg:val` (args joined by `$`).
- Objects:
  - With `id`: store under `<Type>:<id>`; parent stores `Ref(<Type>:<id>)`.
  - Without `id`: store inline in parent record.
- Metadata injection:
  - `__ref`: `{id: "<Type>:<id>"}` for entities, `{path: "<path>"}` for inline/union/interface.
  - `__ref_<field>`: `<object_ref_key>_<field_segment>` for scalar/object/list fields.

## Update Semantics (Runtime)
- Scalar field change → notify `__ref_<field>`.
- List structural change (length/order) → notify `__ref_<listField>`.
- Union/interface typename change → notify object-level `__ref` (path) and new entity key if present.
- Object ref change (null ↔ some, entity ref swap) → notify `__ref_<field>`.

## Garbage Collection (Planned)
- Maintain subscription ref counts for keys emitted in metadata.
- Evict top-level entries when no active subscriptions and not referenced.
- Start conservatively (entity-only eviction) and expand to path-based GC.

## Progress
- Done: `NormalizedCache` + `CacheValue` structures in `shalom_runtime`.
- Done: normalization + metadata injection + change tracking in Rust.
- Done: `ShalomRuntime` public API (`normalize` + cache access) and cache tests wired through it.
- Done: Rust cache tests covering all listed use cases (scalars, enums, objects, unions/interfaces, fragments, lists, inputs).
- Done: cache reader for rebuilding responses from normalized cache + runtime subscription updates (`subscribe` + `drain_updates`).
- Done: runtime init from schema SDL + fragment SDLs with host link stub for request/response orchestration.
- Done: request/subscribe public API exposed via `shalom_dart` (FRB entrypoints).
- Done: moved link modules into `shalom_runtime` (HTTP implemented, WS stubbed).
- Partial: runtime `request` uses host link for first response; full streaming orchestration still missing.
- Partial: GC helpers exist (subscription tracker + eviction), not yet wired into runtime.
- Partial: `shalom_dart` crate (FRB bindings exist, but Dart-side wiring still pending).
- Partial: Dart tests updated only with a runtime metadata sanity case.

## TODO
- Implement runtime execution/stream wiring (links → normalizer → update stream); use native stream or SPSC channel for streaming ops.
- Wire subscription bookkeeping into runtime and GC eviction pass based on active refs.
- Implement GraphQL WS protocol state machine in `shalom_runtime::link`.
- Wire Dart transport to the host link request stream + response sink.
- Migrate existing Dart tests/codegen off Dart-side normalization to runtime metadata.

## Next Steps
- Implement runtime execution stream wiring (links → normalizer → update stream).
- Add GC bookkeeping and eviction pass.
- Flesh out WebSocket link state machine (graphql-transport-ws).
- Update Dart codegen/tests to consume runtime metadata.
