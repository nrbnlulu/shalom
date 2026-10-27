## 0.1.8

- Keep active query subscriptions alive even when no polling interval is configured, allowing them to await refetch signals instead of exiting after the initial network response.
- Cache eviction (via `evictOperation` and mutation widget `invalidateOperations`) now automatically refetches fresh data from the network over existing subscription streams instead of terminating them. Both declarative Flutter widgets and imperative observables (`observe()`) receive the latest data seamlessly without needing manual resubscription.
- Remove redundant direct `ShalomRuntimeClient.invalidateOperation` API in favor of `evictOperation`.

## 0.1.7

- Add `ShalomRuntimeClient.invalidateOperation` to evict an operation's cached root data and close its active subscriptions, so observers resubscribe and refetch from the network. Mutation widgets accept an `invalidateOperations` parameter to trigger this after a mutation.
- Drop responses that arrive for a subscription after it was cancelled instead of normalizing stale data into the cache, and keep cancellation signals that fire before the task is waiting on them.
- Update the native runtime to `shalom_runtime` 0.1.5.

## 0.1.6

- Parse GraphQL responses without cloning their fields, and hand WebSocket payloads to the runtime as a buffered response that is only materialized into Dart objects when a link inspects it. Reduces per-message overhead on large responses.
- Fix `@observe` ref tracking so a parent scope keeps re-registering a shared dependency that a nested observed fragment already claimed. The parent now still invalidates when that shared field changes.
- Update the native runtime to `shalom_runtime` 0.1.4.

## 0.1.5

- Persist `__typename` on every normalized entity that has an id, even when the selection that wrote it didn't request `__typename` (e.g. a plain object field). Fixes "union selection missing `__typename`" normalization errors when the same entity is later read through a union/interface selection elsewhere in the app.

## 0.1.4

- Register operations and fragments with their `__typename`/`id`-injected document instead of the raw widget SDL, so union/interface selections no longer fail normalization with a "missing `__typename`" error at runtime.

## 0.1.3

- Add `WebSocketLink.maxOperationsPerSocket` to cap how many concurrent subscriptions share a single WebSocket connection, opening additional connections as needed (defaults to unlimited, preserving prior behavior).

## 0.1.2

- Prevent the internal `@unwrap` directive from being sent to GraphQL servers when it is used inside a nested fragment.

## 0.1.1

- Fix `shalom_core`/`shalom_runtime` native dependencies pointing outside the published package; they are now resolved from crates.io.

## 0.1.0

- Initial version.
