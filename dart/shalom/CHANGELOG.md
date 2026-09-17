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
