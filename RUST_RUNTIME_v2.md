# Shalom Rust Runtime v2 Architecture

## Overview

The runtime is split into three layers:

1. **`shalom_runtime`** — pure logic: cache, normalization, subscriptions. Zero networking.
2. **`shalom_dart` (Rust crate)** — FRB bridge. Exposes an opaque `RuntimeHandle` that owns the runtime + transport bridge.
3. **Dart (`ShalomRuntimeClient`)** — owns all networking (HTTP, WS). Routes transport via existing Dart links.

The key invariant: **Rust never touches sockets.** Dart owns networking. Rust orchestrates.

---

## Component Map

```
┌─────────────────────────────────────────────────────┐
│  Flutter widget / Dart app                          │
│                                                     │
│  ShalomRuntimeClient                                │
│  ├── GraphQLLink (http_link / ws_link)              │
│  └── RustOpaque<RuntimeHandle>  ◄──── FRB ────────┐ │
└─────────────────────────────────────────────────────┘
                                                     │
┌─────────────────────────────────────────────────────┤
│  shalom_dart (Rust crate)                           │
│                                                     │
│  RuntimeHandle                                      │
│  ├── ShalomRuntime       (cache + subscriptions)   │
│  └── HostLink            (transport bridge)         │
└─────────────────────────────────────────────────────┘
                │
┌───────────────┴─────────────────────────────────────┐
│  shalom_runtime                                     │
│  ├── ShalomRuntime       (normalization, GC, subs)  │
│  ├── HostLink            (bidirectional channel bus)│
│  ├── NormalizedCache                                │
│  └── ExecutionEngine                                │
└─────────────────────────────────────────────────────┘
```

---

## Transport Bridge (`HostLink`)

`HostLink` is the seam between Rust's async execution model and Dart's networking.

### Structure

```rust
pub struct HostLink {
    // Outbound: Rust → Dart (pending transport requests)
    request_tx: mpsc::UnboundedSender<RequestEnvelope>,
    request_rx: Mutex<Option<mpsc::UnboundedReceiver<RequestEnvelope>>>,

    // Inbound: Dart → Rust (per-operation response feeds)
    // DashMap: concurrent per-entry locking, no global mutex on hot path
    response_senders: DashMap<OperationId, mpsc::Sender<GraphQLResponse>>,

    next_op_id: AtomicU64,
}
```

### Why DashMap here (and only here)

`response_senders` is the one map worth using `DashMap` for. Dart calls
`push_response` concurrently for different operations (e.g. multiple WS
subscriptions firing simultaneously). With `Mutex<HashMap>` every push locks the
whole map. With `DashMap` each entry is independently sharded — push for op 101
doesn't block push for op 202. Nowhere else in the runtime is this pattern needed.

### Key methods (FRB-exposed via `RuntimeHandle`)

| Method | Direction | Description |
|---|---|---|
| `take_request_stream()` | Rust → Dart | One-time: Dart subscribes to outbound requests |
| `push_response(op_id, response)` | Dart → Rust | Feed a response chunk (call multiple times for WS) |
| `complete_transport(op_id)` | Dart → Rust | Signal operation done, closes the Rust stream |

`take_request_stream()` is a one-shot: it moves the `UnboundedReceiver` out of the
`Mutex<Option<...>>`. Calling it twice returns an error. This prevents accidental
duplicate consumers.

### Request flow (HTTP)

```
dart: client.request(query, vars)
  └─ rust: parse query → op_ctx
  └─ rust: op_id = next_op_id.fetch_add(1, Relaxed)
  └─ rust: mpsc::channel(50) → stash tx in response_senders[op_id]
  └─ rust: emit RequestEnvelope { op_id, request } via request_tx
  └─ rust: return Stream<RuntimeResponse> (reads from rx, normalizes each item)

dart: transport_request_stream yields RequestEnvelope { op_id, ... }
  └─ dart: link.request(req) → http POST
  └─ dart: push_response(op_id, data)         // Rust normalizes, notifies subscribers
  └─ dart: complete_transport(op_id)           // tx dropped → rx stream ends → caller sees end
```

### Request flow (WS subscription)

Identical to HTTP from Rust's perspective. The difference is Dart:

```
dart: transport_request_stream yields RequestEnvelope { op_id, op_type: Subscription }
  └─ dart: ws_link.request(req)
      - sends graphql-transport-ws `subscribe` frame
      - for each `next` frame: push_response(op_id, payload)
      - on `complete` frame:   complete_transport(op_id)
      - on WS error:           push_transport_error(op_id, ...) then complete_transport(op_id)
      - on stream cancel:      send WS `complete` frame
```

The `graphql-transport-ws` protocol lives entirely in Dart's `ws_link.dart`. Rust
sees a plain stream of `GraphQLResponse` items regardless of transport.

---

## ShalomRuntime

`ShalomRuntime` has **no link field**. It knows nothing about networking. Its
responsibilities:

- Parse and register GraphQL operations/fragments from SDL
- Normalize server responses into the cache
- Track which cache keys changed on each write
- Maintain ref subscriptions (op/fragment → watched keys → update stream)
- Garbage-collect unreferenced cache entries

`ShalomRuntime::init()` signature:

```rust
pub fn init(
    schema_sdl: &str,
    fragments: Vec<String>,
    config: RuntimeConfig,
    // no link parameter
) -> anyhow::Result<Self>
```

All link wiring happens in `RuntimeHandle`, not in the runtime itself.

---

## RuntimeHandle (FRB Opaque)

`RuntimeHandle` owns both the runtime and the host link. It is the only type
exposed to Dart.

```rust
#[frb(opaque)]
pub struct RuntimeHandle {
    runtime: ShalomRuntime,
    link: Arc<HostLink>,
}
```

`request_stream()` on the runtime is driven by `RuntimeHandle::request()`:

```rust
impl RuntimeHandle {
    pub async fn request(&self, query: String, variables_json: Option<String>) -> anyhow::Result<String> {
        // 1. parse vars
        // 2. runtime parses query → op_ctx
        // 3. link emits RequestEnvelope to Dart
        // 4. runtime awaits first response from link (for non-subscription queries)
        // 5. normalize → return JSON
    }

    pub fn request_stream(&self, query: String, ...) -> impl Stream<Item = anyhow::Result<RuntimeResponse>> {
        // for subscriptions: returns full stream, Dart awaits each item
    }
}
```

---

## Ref Subscriptions (Cache-Level)

This is separate from transport subscriptions. A ref subscription watches a set
of cache keys and fires whenever any of them changes.

### Flow

```
1. widget calls: runtime.request("query Foo @subscribeable { ... }", vars)
   → returns RuntimeResponse { data, operation_id, __used_refs: [...] }

2. widget renders initial data from `data`

3. widget calls: sub_id = runtime.subscribe("Foo", used_refs)
   → Rust stores (refs_set, op_ctx, vars) for this sub_id
   → returns SubscriptionId

4. widget calls: runtime.listen_updates(sub_id)
   → returns Stream<RuntimeResponse>

5. any cache write that touches keys in refs_set:
   → rust re-reads "Foo" from cache
   → emits new RuntimeResponse to sub_id stream
   → widget StreamBuilder rebuilds

6. widget unmounts: runtime.unsubscribe(sub_id)
   → Rust removes ref counts → GC eligible
```

### For WS GraphQL subscriptions

Identical widget API. The difference: each server `next` message triggers a
`push_response` call from Dart, which normalizes into the cache, which fires the
ref subscription. The widget never knows it's backed by WS.

---

## Dart API (`ShalomRuntimeClient`)

```dart
class ShalomRuntimeClient {
  final RuntimeHandle _handle;  // RustOpaque
  final GraphQLLink _link;      // http_link or ws_link

  static Future<ShalomRuntimeClient> init({
    required String schemaSdl,
    required List<String> fragmentSdls,
    required GraphQLLink link,
  }) async {
    final handle = await rlib.initRuntime(schemaSdl: schemaSdl, ...);
    final client = ShalomRuntimeClient._(handle, link);
    client._bindTransport();   // subscribe to outbound request stream
    return client;
  }

  void _bindTransport() {
    rlib.listenRequests(handle: _handle).listen(_handleTransportRequest);
  }

  void _handleTransportRequest(RequestEnvelope envelope) {
    final sub = _link.request(request: envelope.toRequest()).listen(
      (resp) => rlib.pushResponse(handle: _handle, opId: envelope.id, ...),
      onError: (e) => rlib.pushTransportError(handle: _handle, opId: envelope.id, ...),
      onDone: () => rlib.completeTransport(handle: _handle, opId: envelope.id),
    );
    _activeRequests[envelope.id] = sub;
  }

  Future<RuntimeRequestResult> request({required String query, Map<String, dynamic>? variables});
  Stream<Map<String, dynamic>> subscribe({required String operationId, required List<String> refs});
  Stream<Map<String, dynamic>> subscribeFragment({required String fragmentName, required String rootRef, required List<String> refs});
  Future<void> dispose();
}
```

---

## Flutter Widget Integration

```dart
class ShalomQuery<T extends FromCache> extends StatefulWidget {
  final ShalomRuntimeClient runtime;
  final String query;
  final Map<String, dynamic>? variables;
  final T Function(Map<String, dynamic>) fromCache;

  // Internally:
  // 1. await runtime.request(query, variables) → initial data + used_refs
  // 2. if @subscribeable → runtime.subscribe(operationId, used_refs) → stream
  // 3. StreamBuilder over update stream
  // Widget never knows about transport layer.
}
```

---

## WS Sans-IO (Planned)

The `graphql-transport-ws` protocol state machine can optionally be implemented
as a pure Rust sans-IO library (no sockets, no timers — just message in / frame
out). Dart's `ws_link.dart` would call into it for message parsing and frame
generation, keeping all IO in Dart.

This is **not required for the initial implementation** — Dart's existing
`ws_link.dart` already handles the full protocol correctly.

---

## Warnings

### RustOpaque lifecycle

`RuntimeHandle` is a `RustOpaque` (wrapped in `Arc` on the Rust side). FRB
manages the refcount.

- **Always call `dispose()` on `ShalomRuntimeClient`** when done. This cancels
  the transport listener subscription. If you don't, the `listen_requests` stream
  keeps the `RuntimeHandle` Arc alive and the Dart finalizer may never fire.
- **Never share one `RuntimeHandle` across isolates** without going through FRB's
  opaque cloning mechanism. Dart finalizers are per-isolate.
- **Hot restart**: `take_request_stream()` is one-shot. On Flutter hot restart,
  the Dart isolate is torn down but the Rust side may still be alive (on some
  platforms). Always `dispose()` before reinitializing to ensure the old
  `RuntimeHandle` is dropped and a fresh one is created with a fresh request stream.

### StreamSink (`listenRequests`, `listenUpdates`)

FRB's `StreamSink<T>` is the Rust side of a Dart `Stream`. Rules:

- **`sink.add()` returns `Err` when the Dart stream is cancelled.** Always check
  the return value and break/return when it errors — do not keep pushing to a
  dead sink.
- **Do not hold a `StreamSink` in a global or static.** This causes the same
  hot-restart problem as `RuntimeHandle`. The sink is tied to the specific Dart
  stream subscription.
- **One active sink per stream.** `listenRequests` can only have one consumer.
  Calling it a second time before the first is cancelled will return an error on
  the Rust side (`request stream already taken`).
- **Backpressure**: `StreamSink` is unbounded by default. If Dart can't consume
  requests fast enough (unlikely but possible under heavy load), memory will grow.
  The current `mpsc::channel(50)` cap on response channels guards the inbound
  path; the outbound `UnboundedSender` for requests is fine since the number of
  in-flight operations is typically small.

---

## TODO

### Done
- [x] `NormalizedCache` + `CacheValue` structures
- [x] Normalization + used_refs collection + change tracking
- [x] `ShalomRuntime` public API (`normalize`, cache access)
- [x] Cache reader (rebuild response from cache)
- [x] Runtime init from schema SDL + fragments
- [x] `subscribe` / `listen_updates` / `unsubscribe` public API
- [x] `HostLink` basic structure (response_senders map, execute → stream)
- [x] `RuntimeHandle` opaque type with FRB bindings
- [x] `ShalomRuntimeClient` Dart wrapper with transport dispatch
- [x] `push_response` / `push_transport_error` FRB functions

### In Progress / Next

- [ ] **Fix `HostLink`**: add outbound `UnboundedSender<RequestEnvelope>`, implement
  `take_request_stream()`, `send_response()`, `complete()`. Current `host.rs`
  references these but they are not fully implemented.

- [ ] **Decouple `ShalomRuntime` from link**: remove `link: Option<Arc<dyn GraphQLLink>>`
  field and the `link` parameter from `ShalomRuntime::init()`. The runtime must
  not know about transport. Link wiring is `RuntimeHandle`'s job.

- [ ] **Add `complete_transport` FRB function**: Dart must be able to signal that
  a transport operation is done (drops the `tx`, closes the per-op rx stream).

- [ ] **Remove `HttpLink` / `HttpTransport` from `shalom_runtime`**: Dart owns
  all transport. These abstractions live in the wrong crate. Delete or move to a
  `shalom_native` crate for future native transport support.

- [ ] **Implement WS sans-IO state machine**: a pure Rust
  `graphql-transport-ws` message parser/framer that Dart's `ws_link.dart` can
  call into for protocol handling. Dart keeps all socket I/O.

- [ ] **Wire GC into runtime lifecycle**: call `collect_garbage()` periodically
  (or after `unsubscribe`) based on `subscription_tracker` active keys.

- [ ] **Migrate Dart tests**: update existing codegen tests to go through the
  runtime metadata path (`__used_refs`) rather than Dart-side normalization.
