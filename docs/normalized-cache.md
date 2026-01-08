# Normalized Cache

Shalom stores GraphQL responses in a normalized cache so the same entity can be
updated across multiple queries. Instead of embedding nested objects directly,
it keys entities by their identity (typically `__typename` + `id`) and stores
references from parent objects.

## What this means in practice

- A `Film` fetched by two different operations is stored once in the cache.
- When a new response includes the same `Film`, the cache entry is updated and
  any streams that read it emit the latest data.
- Generated helpers like `fromCache` and `normalize$inCache` handle the read/write
  logic automatically.

## Example flow

1. `RequestGetFilms` fetches a list of films and normalizes them into the cache.
2. Another operation fetches a single film by ID.
3. The shared cache key resolves to the same entity, so both operations stay in
   sync when new data arrives.

## When to rely on it

Use the normalized cache when you want live updates across screens or widgets.
Because requests are stream-based, the UI can rebuild whenever normalized data
changes, even if that change came from a different operation.
