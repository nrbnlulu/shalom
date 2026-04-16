# Shalom Rust Runtime Implementation Plan

# initial query

## Context

We are working on a **Rust runtime for Shalom**.
Instead of the current code-generation approach, logic is moved into a runtime layer.

The previous behavior is documented in `AGENTS.md` and implemented via Dart codegen templates such as:

- `operation.dart.jinja`
- `selection_macros.dart.jinja`

These templates implemented logic such as `fromCache`, `normalize_selection_in_cache`, and related helpers.
All of this logic must now live in the Rust runtime.

---

## Components to implement

### 1. `shalom_runtime`

Responsible for:

- Executing GraphQL operations
- Normalizing results
- Managing the normalized cache
- Emitting fine-grained cache update signals
- Performing cache garbage collection based on active subscriptions

---

### Normalization rules

When an operation result arrives, normalize objects as follows (as documented in `AGENTS.md`):

#### Objects with an `id` field

- `id` may be `Int`, `ID`, or `String`
- `id` may be optional
- When present:
    - stringify it
    - store the object **at the top level of the cache** using a canonical entity key:

        ```
        <TypeName>:<id>
        ```

- Parent objects store a `Ref(<TypeName>:<id>)` instead of the full object

#### Objects without an `id` field

- Stored inline on the parent object
- Cache keys must include:
    - field name
    - field arguments (including variables)

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
        "person(name: 'foo')": {
            "name": "foo",
            "pets(first: 5)": [{ "name": "cocky" }, { "name": "baz" }],
            "country(birth:true)": { "$ref": "Country:4324" }
        }
    },
    "Country:4324": {
        "id": 4324,
        "name": "Israel"
    }
}
```

Note: `$ref` is a conceptual placeholder for `CacheValue::Ref`.

---

## 2. `shalom_link`

A Rust implementation of the Dart links responsible for **GraphQL transport protocols**:

- **GraphQL-over-HTTP**
- **The new GraphQL WebSocket protocol**

These are currently implemented in Dart and must be ported to Rust:

- `http_link.dart`
- `ws_link.dart`

### Important constraints

- **Rust must NOT perform network requests**
    - Dart (or other host languages) owns networking
    - This mirrors the existing design using `dio_transport.dart`
    - This is required for Web support

- Rust links:
    - orchestrate request / response lifecycles
    - handle protocol-level framing and streaming

- A native Rust transport may be added in the future, but **not now**

---

## 3. `dart/shalom/rust` crate

- Integrates Dart / Flutter with `shalom_runtime`
- Uses `flutter_rust_bridge`
- Responsible for:
    - sending operations to the runtime
    - receiving execution results
    - subscribing to runtime update signals

---

## Execution & streaming model

- GraphQL is **stream-based**
- If Rust has a native stream abstraction, use it
- Otherwise, use an **SPSC channel**

### Flow

1. Client sends `(query, variables)` to the runtime
2. Runtime executes the operation via configured links
3. Runtime returns:
    - the **raw GraphQL response data**
    - optional `__used_refs` (entrypoints only, see below)

4. Client deserializes the response using its generated types
5. Clients (e.g. Flutter widgets) use `__used_refs` to subscribe to updates

---

## Cache updates & subscriptions (critical)

### Motivation

Currently, cache updates are delegated to `client.request`, which forces:

- full response traversal
- rebuilding large widget trees (often entire root queries)

This is prohibitively expensive for large queries.

### New approach: entrypoint-level used refs

The runtime returns **normal response data**, plus a **single `__used_refs` field** on
entrypoints (operations and fragments marked `@subscribeable`). This field contains every
cache ref needed to subscribe to all selections in the entrypoint.

`__used_refs` is explicitly designed to be used by **Flutter (and other clients)** to:

- subscribe to field-level changes
- rebuild only affected widgets
- avoid whole-tree invalidation

---

## Metadata conventions

Injected fields are **not part of the GraphQL schema** and are reserved by the runtime.

### Reserved fields

- `__used_refs`
  A list of all cache refs used by the entrypoint response

- `__ref_anchor`
  Present only on `@subscribeable` fragment responses, contains the root ref key used to
  anchor the fragment selection

---

## Update semantics

The runtime must trigger updates when:

### 1. Union / interface object identity changes

- If `__typename` changes between writes
- Notify the object-level ref key
- If the object has an `id`, entity subscribers must also be notified

### 2. Scalar field changes

- Notify the field ref key

### 3. List structural changes

- Length changes
- Reordering
- Pagination merges
- Notify the list field ref key

Item-level field changes must notify only the item’s own refs unless structure changes.

---

## Returned response shape (example)

````json
{
  "person": {
    "name": "foo",
    "pets": [
      {
        "name": "cocky"
      },
      {
        "name": "baz"
      }
    ],
    "country": {
      "id": 4324,
      "name": "Israel"
    }
  },
  "__used_refs": [
    "ROOT_QUERY_person$name:foo",
    "ROOT_QUERY_person$name:foo_name",
    "ROOT_QUERY_person$name:foo_pets$first:5",
    "ROOT_QUERY_person$name:foo_pets$first:5[0]",
    "ROOT_QUERY_person$name:foo_pets$first:5[1]",
    "Country:4324",
    "Country:4324_name"
  ]
}

---

## Garbage collection (GC)

The Rust runtime is responsible for **cache garbage collection**.

### GC model

* Clients subscribe to cache locations using the `__used_refs` list.
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
- client calls runtime.request(query: "<query SDL>", variables: vars) and gets a response with 1. graphql data, 2. `__used_refs` (only if the entrypoint is `@subscribeable`), 3. the id for that operation SDL (note that even if we fire the same query twice, thats the same id).

- if the client decides it wants to subscribe to an object it will call `runtime.subscribe(subscribeable_id (the operation / fragment sdl id), list_of_refs)` where `list_of_refs` is `__used_refs`. the runtime will watch for changes in those refs, and once found it will "execute" against the cache (internally) for all the selections (if its not a scalar) under the root ref.

- for flutter i.e we can have a stream builder for each runtime subscription, it will internally accept a runtime (can be fetched from the context) and any type that implements `FromCache` (which is root operation types and fragments) (since dart doesn't have static "traits" i.e overrides that returns Self we need to do a trick with a method that returns a builder of Self) the codegen can automatically generate the FromCache thing on it.
OFC the type that we use in that we use must be the correct type of the root ref.


make sure that the rust backend is ready for this and implement needed api in the flutter_rust_bridge codegen.

### Subscribeable entrypoints

Operations and fragments must opt-in to subscription metadata using `@subscribeable`.

Example:

```graphql
query Foo @subscribeable {
  person { id name }
}

fragment FriendFragment on Person @subscribeable {
  id
  name
}
````

## Goals

- Move normalization, cache management, and update signaling into Rust runtime.
- Emit `__used_refs` for fine-grained client subscriptions (entrypoints only).
- Keep transport logic in Rust orchestration layer without performing network I/O.
- Provide a Dart/Flutter bridge entry point (via `flutter_rust_bridge` later).

## Runtime Architecture (Proposed)

- `shalom_runtime`
    - `cache`: normalized store (ROOT\_\* + entity records).
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
    - Path key (for refs): `parent_field$arg:val` (args joined by `$`).
- Objects:
    - With `id`: store under `<Type>:<id>`; parent stores `Ref(<Type>:<id>)`.
    - Without `id`: store inline in parent record.
- Metadata injection:
    - `__used_refs`: list of cache ref keys used by the entrypoint response (only when `@subscribeable`).
    - `__ref_anchor`: fragment root ref key (only for `@subscribeable` fragments).

## Update Semantics (Runtime)

- Scalar field change → notify the field ref key.
- List structural change (length/order) → notify the list field ref key.
- Union/interface typename change → notify object ref key (path) and new entity key if present.
- Object ref change (null ↔ some, entity ref swap) → notify the field ref key.

## Garbage Collection (Planned)

- Maintain subscription ref counts for keys emitted in metadata.
- Evict top-level entries when no active subscriptions and not referenced.
- Start conservatively (entity-only eviction) and expand to path-based GC.

## Progress

- Done: `NormalizedCache` + `CacheValue` structures in `shalom_runtime`.
- Done: normalization + used refs collection + change tracking in Rust.
- Done: `ShalomRuntime` public API (`normalize` + cache access) and cache tests wired through it.
- Done: Rust cache tests covering all listed use cases (scalars, enums, objects, unions/interfaces, fragments, lists, inputs).
- Done: cache reader for rebuilding responses from normalized cache + runtime subscription updates (`subscribe` + `drain_updates`).
- Done: runtime init from schema SDL + fragment SDLs with host link stub for request/response orchestration.
- Done: request/subscribe public API exposed via `dart/shalom` (FRB entrypoints).
- Done: moved link modules into `shalom_runtime` (HTTP implemented, WS stubbed).
- Done: runtime request streaming (link → normalize → response stream) with tests.
- Partial: GC helpers exist (subscription tracker + eviction), not yet wired into runtime.
- Partial: `shalom_dart` crate (FRB bindings exist, but Dart-side wiring still pending).
- Partial: Dart tests updated only with a runtime metadata sanity case.

## TODO

- Wire subscription bookkeeping into runtime and GC eviction pass based on active refs.
- Implement GraphQL WS protocol state machine in `shalom_runtime::link`.
- Wire Dart transport to the host link request stream + response sink.
- Migrate existing Dart tests/codegen off Dart-side normalization to runtime metadata.

## Next Steps

- Add GC bookkeeping and eviction pass.
- Flesh out WebSocket link state machine (graphql-transport-ws).
- Update Dart codegen/tests to consume runtime metadata.

---

- I think we dont need a dashmap at all we can just use opque types (described below)
- I think there should be a common implementation for the graphql-over-http and graphql-ws-transport protocols in rust, the target language (i.e dart) would have a wrapper over the raw implementation and links would be managed in the target language like so

```dart
class GraphQlOverHttpDioLink extends Link{
    final Dio dio;
    final String serverUrl
    final RustGraphQlOverHttpSansIo sansio;

    Future<GraphQlOverHttpLink> create(){

        return GraphQlOverHttpLink(rlib.create_...())
    };

    Stream<GraphqlResponse> request(request){
        try{
            // data compatible with the protocol specs
        final resp  = await dio.post(serverUrl, data: ..., headers: request.headers);
        yield sansio.request(request);


        } catch Exception as e {
            yield GraphQlTransportError(e.toString());
        }

    }
}

class GraphQlWsTransportLink extends Link {
    final Websocket ws;
    final GraphQlWsTransportSansIO sansio;
    final <correct type here> wsListener;
    Future<GraphQlWsTransportLink> create(Websocket){
        final sansio = rlib.create...;
        final listener = socket.events.listen(
            (event){
                // here also add error handeling.
                // 1. if the sansio couldn't parse the message it would
                // add GraphQlTransportError for the subscription
                // 2. if the events listerner had errors (due to ws diconnection) or similar u should add GraphQlTransportError to all of the operations using sansio.onWebsocketError(error.toString());
                switch (e){
                    case TextDataReceived(:final text): {
                        sansio.on_message(text)
                    }
                }
            }

        )
    };

    Stream<GraphQlResponse> request(request) async* {
        final opID = Uuid::uuid4();
        /// here we use frb `StreamSink<GraphQLResponse>` feature
        final resultsStream = sansio.registerOperation(request, opID.toString());
        await ws.sendText({
            // valid new operation request as per the protocol
        });
        // also add error handeling
        await for (final res: resultsStream.stream){
            yield res;
        }

    }
}
```

now the runtime would also be a rust opaque
and the api would be as follows

```dart

class Runtime{
    final rlib.Runtime impl;
    final Link rootLink;

    Future<void> create(RuntimeConfig config){
        final impl = await rlib.createRuntime(config);
    }
    
    

}

```
---

# docs

````
# Rust Opaque

## Design

We try our best to achieve the following:

import Goal from '../../../snippets/_opaque-design-goal.mdx';

:::tip goal
<Goal />
:::

## Safety concern

When looking at the components below, one critical question is: Is the implementation safe and sound?
With the following three components, in my humble opinion, the question is roughly splitted into:

1. `Droppable`: Does it ensure the "release the resource once and exactly once"?
2. `RustArc`: Does it ensure the semantics of standard `std::sync::Arc`?
E.g. after `intoRaw` is called, are we guarantee the pointer is "forgotten"?
3. `RustOpaque`: Together with the Rust side, is the `Arc::into_raw` and `Arc::from_raw` paired? (One `into_raw` for one `from_raw`)

Since each component is quite tiny, it is not very hard to check it.
Feel free to create an issue if you find any problems!

## Transferring between Rust and Dart

With the three-components abstractions below, this can be explained within a sentence:
To transfer a `RustOpaque` (indeed an `Arc`),
do `std::sync::Arc::into_raw` on one side,
and `std::sync::Arc::from_raw` on the other side.
(Replace `Arc` with `RustArc` when proper).

## Details of the components

(The text below are mainly copied from the code comments.)

### `Droppable`

```dart
class Droppable {
  PlatformPointer? _ptr;
  void dispose() { ... }
}
````

Encapsulates the `internalResource` release logic.

In Rust, it is simple to release some resource: Just implement `Drop` trait.
However, there are two possible chances to release resource in Dart:

1. When the object is garbage collected, the Dart finalizer will call a callback you choose.
2. When the user explicitly calls `dispose()` function, you can do releasing job.

But we want to release the `internalResource` _once and exactly once_.
That's what this class does.

### `RustArc`

```dart
class RustArc extends Droppable {
  RustArc clone() { ... }
  RustArc.fromRaw({int ptr}) { ... }
  PlatformPointer intoRaw() { ... }
}
```

The Rust `std::sync::Arc` on the Dart side.

It uses `Droppable` to ensure the Arc's destructor is correctly called exactly once.

### `RustOpaque`

```dart
abstract class RustOpaque {
  final RustArc _arc;
  RustOpaque.decode(raw) { ... }
  int encode() { ... }
}
```

Finally, the object we are interested in.

It uses `RustArc` to hold the actual data.

## V1 documentations

:::info
This section was written for V1, so it may be slightly outdated for V2.
:::

### Restrictions

A `RustOpaque type` can be created from any Rust structure.
The `flutter_rust_bridge` async dart api requires the Rust type to be `Send` and `Sync`, due to the possible sharing of `RustOpaque type` by multiple `flutter_rust_bridge` executor threads.

### Ownership and GC

From the moment an opaque type is passed to Dart, it has full ownership of it.
Dart implements a finalizer for opaque types, but the memory usage of opaque types is not monitored by Dart and can accumulate, so in order to prevent memory leaks, opaque pointers must be `dispose`d.

### Rust opaque type like function args

When calling a function with an opaque type argument, the Dart thread safely shares ownership of the opaque type with Rust. This is safe because `RustOpaque<T>` requires that T be `Send` and `Sync`, furthermore Rust's `RustOpaque<T>` hand out immutable references through `Deref` or get an internal property if only Rust owns the opaque type. If dispose is called on the Dart side before the function call completes, Rust takes full ownership.

### Example

#### Case 1: Simple call.

Rust `api.rs`:

```rust
pub use crate::data::HideData; // `pub` for bridge_generated.rs

pub fn create_opaque() -> RustOpaque<HideData> {
    // [`HideData`] has private fields.
    RustOpaque::new(HideData::new())
}

pub fn run_opaque(opaque: RustOpaque<HideData>) -> String {
    // RustOpaque impl Deref trait.
    opaque.hide_data()
}
```

Dart: (test:'Simple call' frb_example/pure_dart/dart/lib/main.dart)

```dart
// (Arc counter = 1) Dart has full ownership.
var opaque = await api.createOpaque();

// (Arc counter = 2) for the duration of the function
// and after (Arc counter = 1).
//
// Dart and Rust share the opaque type.
String hideData = await api.runOpaque(opaque);

// (Arc counter = 0) opaque type is dropped (deallocated).
opaque.dispose();
```

#### Case 2: Call after dispose.

Rust `api.rs`:

```rust
pub use crate::data::HideData; // `pub` for bridge_generated.rs

pub fn create_opaque() -> RustOpaque<HideData> {
    // [`HideData`] has private fields.
    RustOpaque::new(HideData::new())
}

pub fn run_opaque(opaque: RustOpaque<HideData>) -> String {
    // RustOpaque impl Deref trait.
    opaque.hide_data()
}
```

Dart: (test:'Call after dispose' frb_example/pure_dart/dart/lib/main.dart)

```dart
// (Arc counter = 1) Dart has full ownership.
var opaque = await api.createOpaque();

// (Arc counter = 0) opaque type dropped (deallocated)
opaque.dispose();

// (Arc counter = 0) Dart throws StateError('Use after dispose.')
try {
    await api.runOpaque(opaque: opaque);
} on StateError catch (e) {
    expect(e.toString(), 'Bad state: Use after dispose.');
}
```

#### Case 3: Dispose before complete.

Rust `api.rs`:

```rust
pub use crate::data::HideData; // `pub` for bridge_generated.rs

pub fn create_opaque() -> RustOpaque<HideData> {
    // [`HideData`] has private fields.
    RustOpaque::new(HideData::new())
}

pub fn run_opaque(opaque: RustOpaque<HideData>) -> String {
    // RustOpaque impl Deref trait.
    opaque.hide_data()
}

pub fn run_opaque_with_delay(opaque: RustOpaque<HideData>) -> String {
    sleep(Duration::from_millis(1000));
    opaque.hide_data()
}
```

Dart:

```dart
// (Arc counter = 1) Dart has full ownership.
var opaque = await api.createOpaque();

// (Arc counter = 2) increases immediately.
// Dart and Rust share the opaque type.
// Safely because opaque type has `Send` `Sync` Rust trait.
var unawait_task = api.runOpaqueWithDelay(opaque: opaque);

// (Arc counter = 1) Rust has full ownership.
// Dart stops owning the opaque type.
// Trying to use an opaque type will throw StateError('Use after dispose.')
opaque.dispose();

// Successfully completed.
//
// Rust:
// `executes run_opaque_with_delay.`
// after complete (Arc counter = 0)
// opaque type is dropped (deallocated)
await unawait_task;
```

#### Case 4: Multi call.

Rust `api.rs`:

```rust
pub use crate::data::HideData; // `pub` for bridge_generated.rs

pub fn create_opaque() -> RustOpaque<HideData> {
    // [`HideData`] has private fields.
    RustOpaque::new(HideData::new())
}

pub fn run_opaque(opaque: RustOpaque<HideData>) -> String {
    // RustOpaque impl Deref trait.
    opaque.hide_data()
}
```

Dart: (test:'Double Call' frb_example/pure_dart/dart/lib/main.dart)

```dart

// (Arc counter = 1) Dart has full ownership.
var opaque = await api.createOpaque();

// (Arc counter = 2) increases immediately.
// (Arc counter = 1) after complete
String hideData1 = await api.runOpaque(opaque: opaque);

// (Arc counter = 2) increases immediately.
// (Arc counter = 1) after complete
String hideData2 = await api.runOpaque(opaque: opaque);

// (Arc counter = 0) opaque type is dropped (deallocated)
opaque.dispose();
```

#### Case 5: Double call with dispose before complete.

Rust `api.rs`:

```rust
pub use crate::data::HideData; // `pub` for bridge_generated.rs

pub fn create_opaque() -> RustOpaque<HideData> {
    // [`HideData`] has private fields.
    RustOpaque::new(HideData::new())
}

pub fn run_opaque(opaque: RustOpaque<HideData>) -> String {
    // RustOpaque impl Deref trait.
    opaque.hide_data()
}
```

Dart:

```dart

// (Arc counter = 1) Dart has full ownership.
var opaque = await api.createOpaque();

// (Arc counter = 2) increases immediately.
var unawait_task1 = api.runOpaque(opaque); *1

// (Arc counter = 3) increases immediately.
var unawait_task2 = api.runOpaque(opaque); *2

// (Arc counter = 2) Rust has full ownership
opaque.dispose();

// (*1 is complete) (Arc counter = 1)
//
// Rust:
//
//`executes rust_call_example and counter decreases.`

// (*2 is complete) (Arc counter = 0)
// opaque type is dropped (deallocated)
//
// Rust:
//
//`executes rust_call_example and drop opaque type.`
```

#### Case 6: Dispose was not called (native).

Rust `api.rs`:

```rust
pub use crate::data::HideData; // `pub` for bridge_generated.rs

pub fn create_opaque() -> RustOpaque<HideData> {
    // [`HideData`] has private fields.
    RustOpaque::new(HideData::new())
}

pub fn run_opaque(opaque: RustOpaque<HideData>) -> String {
    // RustOpaque impl Deref trait.
    opaque.hide_data()
}
```

Dart:

```dart

// (Arc counter = 1) Dart has full ownership.
var opaque = await api.createOpaque();

// (Arc counter = 2) increases immediately.
String hideData = await api.runOpaque(opaque);

// (Arc counter = 1)
//
// Rust:
//
// `executes rust_call_example and counter decreases.`

// memory of opaque types is not monitoring by dart and can accumulate.
// (Arc counter = 0)
// opaque type is dropped (deallocated)
//
// Dart:
//
// `the finalizer is guaranteed to be called before the program terminates.`
```

#### Case 7: Dispose was not called (web).

Rust `api.rs`:

```rust
pub use crate::data::HideData; // `pub` for bridge_generated.rs

pub fn create_opaque() -> RustOpaque<HideData> {
    // [`HideData`] has private fields.
    RustOpaque::new(HideData::new())
}

pub fn run_opaque(opaque: RustOpaque<HideData>) -> String {
    // RustOpaque impl Deref trait.
    opaque.hide_data()
}
```

Dart:

```dart

// (Arc counter = 1) Dart has full ownership.
var opaque = await api.createOpaque();

// (Arc counter = 2) increases immediately.
String hideData = await api.rustOpaque(opaque);

// (Arc counter = 1)
//
// Rust:
//
//`executes rust_call_example and counter decreases.`

// memory of opaque types is not monitoring by Dart and can accumulate.
// (Arc count can be 0 or 1) don't count on automatic clearing.
//
// Dart:
//
//`the finalizer is NOT guaranteed to be called before the program terminates.`
```

#### Case 8: Unwrap.

Rust `api.rs`:

```rust
pub use crate::data::HideData; // `pub` for bridge_generated.rs

pub fn unwrap_rust_opaque(opaque: Opaque<HideData>) -> Result<String> {
    let res: Result<HideData, Opaque<HideData>> = opaque.try_unwrap();
    let data: HideData = res.map_err(|_| anyhow::anyhow!("opaque type is shared"))?;
    Ok(data.hide_data())
}

```

Dart:

```dart

// (Arc counter = 1) Dart has full ownership.
var opaque = await api.createOpaque();

// When passed as an argument, dart will relinquish ownership.
opaque.move = true;

// (Arc counter = 1) Rust has full ownership.
// On the Rust side, the Arc unwrap safely
// as the Rust has full ownership of the opaque type.
// Memory is cleared in the usual way Rust.
await api.unwrapRustOpaque(opaque: data);
```

```
Overview
This feature, sometimes called RustAutoOpaque throughout the documentation, allows arbitrary Rust type to be used without manual intervention, by representing arbitrary Rust object as (smart) pointers in Dart.

Different from non-opaque types, opaque types are not copied/moved/reconstructed at all. For example, if you pass around RwLock<Mutex<ArbitraryData> in arguments and return values, you will get the exact same RwLock<ArbitraryData> object.

Example
Suppose you have a type that is not encodable:

pub struct MyNonEncodableType {
    // e.g., a temporary directory, a file descriptor, a native resource, a lock, a channel, ...
    sample_non_encodable_field: tempdir::TempDir,
}


Then you can have Rust functions and methods on it. Most, if not all, features of flutter_rust_bridge are supported, and here are a few examples:

pub fn create() -> MyNonEncodableType { ... }

pub fn consume(obj: MyNonEncodableType) { ... }

pub fn borrow(obj: &MyNonEncodableType) { ... }

pub fn mutable_borrow(obj: &mut MyNonEncodableType) { ... }

impl MyNonEncodableType {
    // Or `self`, `&mut self`
    pub fn methods_on_it(&self) { ... }
}

They can be called in Dart:

var object = await create();
await borrow(object);
await mutable_borrow(object);
await consume(object);
```
