# Normalized Cache

Shalom's Rust runtime stores GraphQL responses in a normalized cache so the
same entity can be updated across multiple queries, subscriptions, mutations,
and fragments. Instead of embedding nested objects directly, it keys root
operation results (`ROOT_QUERY`, `ROOT_MUTATION`, `ROOT_SUBSCRIPTION`) and
entity records such as `Album:123` by identity, and stores references from
parent objects down to them.

## What this means in practice

- An `Album` fetched by a query and read again by a fragment widget is stored
  once in the cache.
- When any response includes the same entity, the cache entry is updated and
  every active observer of that entity re-emits the latest data.
- Generated `@Query` / `@Subscription` / `@Fragment` widgets register as cache
  observers automatically (marked with the `@observe` directive in generated
  SDL) — you don't call `subscribe`/`observe` yourself in normal usage.
- List membership (adding/removing/reordering items) is not inferred from a
  mutation response alone. If a mutation creates, deletes, or reorders items
  and the response doesn't include the parent list field, update the cached
  query or fragment yourself with `executeWithCacheUpdate` (see below).

## Example flow

1. `AlbumsPage`, a `@Query` widget, fetches `albums { ...AlbumWidget }` and
   normalizes each album into the cache under `Album:<id>`.
2. `AlbumWidget`, a `@Fragment` widget, is mounted for each album via its
   generated ref (`AlbumWidgetRef.fromId(id)`), and observes that same
   `Album:<id>` entity.
3. A mutation that returns fields on that `Album` (for example renaming it)
   updates the shared cache entry, so both `AlbumsPage`'s list item and any
   standalone `AlbumWidgetScope` showing that album re-render immediately.

```dart
// Mounting a fragment reactively via its Scope:
AlbumWidgetScope(
  ref: AlbumWidgetRef.fromId(albumId),
  builder: (context, album) => Text(album.name),
)
```

## When to rely on it

Use the normalized cache implicitly by default: mount generated `@Query` /
`@Subscription` widgets for screen-level data, and `@Fragment` widgets/`XScope`
for reactive, entity-scoped UI. Because reads are cache-first by default
(`ExecutionPolicyInput.cacheFirst`), the UI re-renders whenever normalized
data changes, even if that change came from a different operation or a
mutation elsewhere in the app.

## Updating lists after mutations

When a mutation creates, deletes, adds, or removes items, the mutation response normalizes the target entity automatically, but GraphQL servers typically don't return the entire parent list.

Use `executeWithCacheUpdate` to read the cached query or fragment, modify the list, and write it back:

### 1. Adding an item to a root query list

```dart
await CreateAlbumMutation(client).executeWithCacheUpdate(
  name: name,
  update: (cache, data) async {
    final current = await AlbumsPageData.readFrom(cache);
    if (current == null) return;

    final newRef = AlbumWidgetRef.fromId(data.createAlbum.id);
    await cache.writeOperation(
      data: AlbumsPageData(
        albums: [...current.albums, newRef],
      ),
    );
  },
);
```

### 2. Updating or removing items from a nested entity list

```dart
await RemoveGifFromAlbumMutation(client).executeWithCacheUpdate(
  albumId: albumId,
  gifId: gifId,
  update: (cache, data) async {
    if (data.removeGifFromAlbum != null) return;

    final current = await AlbumWidgetRef.fromId(albumId).readFrom(cache);
    if (current == null) return;

    await cache.writeFragment(
      data: AlbumWidgetData(
        id: current.id,
        name: current.name,
        tag: current.tag,
        gifs: current.gifs.where((g) => g.id != gifId).toList(),
      ),
    );
  },
);
```

## Optimistic updates

Use generated `executeOptimistic` when you want instant UI feedback before the network responds:

```dart
final result = await RenameAlbumMutation(client).executeOptimistic(
  (vars) => RenameAlbumMutationData(
    renameAlbum: RenameAlbumMutation_renameAlbum(
      id: vars.id,
      name: vars.name,
    ),
  ),
  id: albumId,
  name: nextName,
  rollbackWhen: (data) => data.renameAlbum == null,
);
```

- Normalizes the predicted payload immediately and notifies any widget or fragment observing that entity record.
- Automatically rolls back if the network call throws or if `rollbackWhen` evaluates to `true`.
- Returns an `OptimisticMutationResponse` with `response` and an async `rollback()` method.

## Garbage collection

The runtime only keeps a root operation field (and entities reachable through
it) alive while some active subscription still references it.

!!! note "One-shot imperative reads"
    A one-shot imperative read (`client.request(...).first`) never registers as an active
    subscriber, so its data becomes eligible for eviction the moment any other
    cache activity triggers GC. For a one-off read that should stay live for as
    long as the UI cares about it, mount the generated `@Query` widget
    conditionally instead of using a one-shot imperative request.

## Debugging the cache

`package:shalom_flutter` includes a `ShalomDebugPanel` widget that renders the
live normalized cache next to your app, useful for verifying that entities
normalize and update the way you expect:

```dart
ShalomDebugPanel(client: ShalomScope.of(context))
```
