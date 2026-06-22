---
name: shalom
description: Use when building or modifying Dart/Flutter apps that use the Shalom GraphQL client: annotated @Query/@Mutation/@Subscription/@Fragment classes, ShalomRuntimeClient setup, network links, normalized cache reads/writes, optimistic mutation updates, and mutation-driven list updates without refetching.
---

# Shalom

Use this skill when acting as an app developer consuming Shalom. Prefer Shalom's generated Dart/Flutter APIs over hand-written GraphQL plumbing. Do not edit generated `__graphql__` files directly; change annotations/schema/config and regenerate.

## Mental Model

Shalom has four user-facing layers:

- A Rust runtime under the Dart API that parses registered GraphQL documents, executes requests through your Dart link, normalizes responses, tracks cache observers, and rolls back optimistic writes.
- `package:shalom`, which exposes `ShalomRuntimeClient`, response types, `GraphQLLink`, HTTP/WebSocket links, `CacheProxy`, `Maybe`, `Some`, and `None`.
- `package:shalom_flutter`, which exposes `ShalomProvider`/`ShalomScope`, generated widget integration, observable scopes, and the debug panel.
- `package:shalom_annotations`, which marks user classes with `@Query`, `@Mutation`, `@Subscription`, and `@Fragment` for code generation.

Normal app flow:

1. Initialize the Flutter Rust bridge before creating the client.
2. Create a `GraphQLLink` (`HttpLink`, `WebSocketLink`, or a custom link).
3. Create `ShalomRuntimeClient` with the generated schema SDL.
4. Call generated `registerShalomDefinitions(client)`.
5. Put the client above your widgets with the generated `ShalomProvider` or `ShalomInheritedWidget`.
6. Use generated query/subscription/fragment widgets for reactive UI.
7. Use generated mutation classes for imperative writes.

Example client setup:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ShalomRuntimeClient.initFlutterRustBridge();

  final client = ShalomRuntimeClient.create(
    schemaSdl: kSchemaSdl,
    link: HttpLink(transportLayer: transport, url: graphqlUrl),
  );
  registerShalomDefinitions(client);

  runApp(ShalomProvider(client: client, child: const MyApp()));
}
```

## Normalized Cache

Shalom normalizes GraphQL responses into root records (`ROOT_QUERY`, `ROOT_MUTATION`, `ROOT_SUBSCRIPTION`) and entity records such as `Album:123`. Queries, subscriptions, and fragments generated from annotations are registered with `@observe`, so the runtime knows which cache refs they watch.

Cache writes notify active observers:

- Query/subscription widgets re-emit when any watched cache key changes.
- Fragment widgets/scopes re-emit when their target entity or nested watched refs change.
- Mutation responses are normalized automatically and update shared entities.
- List membership is not inferred unless the mutation response includes the parent/list field. For create/delete/add/remove list changes, update the relevant cached query or fragment yourself.

For network errors and GraphQL errors, handle all response variants:

```dart
switch (response) {
  case GraphQLData(data: final data):
    // use data
  case GraphQLError():
    // GraphQL-level errors
  case LinkExceptionResponse():
    // transport/network errors
}
```

## Queries And Subscriptions

Annotate a widget class with partial SDL. The generated operation is named after the Dart class.

```dart
@Query(r"""
  ($query: String!, $offset: Int!, $limit: Int!) {
    searchGifs(query: $query, offset: $offset, limit: $limit) {
      items {
        title
        url
        previewUrl
      }
      hasNextPage
    }
  }
""")
class AlbumGifSearch extends $AlbumGifSearch {
  const AlbumGifSearch({super.key, required super.variables});

  @override
  Widget buildLoading(BuildContext context) => const CircularProgressIndicator();

  @override
  Widget buildError(BuildContext context, Object error) => Text('$error');

  @override
  Widget buildData(BuildContext context, AlbumGifSearchData data) => ...;
}
```

Generated query/subscription APIs usually include:

- `$ClassName`, a widget base with `buildLoading`, `buildError`, and `buildData`.
- `ClassNameData`, nested result classes, and `ClassNameVariables` when variables exist.
- `ClassNameObservable.observe(client)` for lower-level observation.
- `ClassNameData.readFrom(cache)` for mutation update callbacks.
- `executionPolicy`, defaulting to `ExecutionPolicyInput.cacheFirst`.

For imperative one-off reads, use generated names, variables, and decoders:

```dart
final variables = AlbumGifSearchVariables(query: q, offset: 0, limit: 20);
final response = await ShalomScope.of(context)
    .request<AlbumGifSearchData>(
      name: 'AlbumGifSearch',
      variables: variables.toJson(),
      decoder: AlbumGifSearchData.fromCache,
    )
    .first;
```

`@Subscription` uses the same widget shape as `@Query`; the link must support streaming operation results.

## Imperative APIs In Flutter

Default to declarative generated widgets/scopes for reads:

- Use `@Query` / `@Subscription` widgets for screen-level data.
- Use `XScope` such as `AlbumWidgetScope` when the screen already has an entity id/ref and needs reactive fragment data.
- Keep local UI-only state, such as text input, selected tabs, filtering, and local search result lists, in normal Flutter state.

Use imperative Shalom APIs for event-driven work:

- Mutations triggered by button taps, form submits, swipe actions, etc.
- Optimistic updates, via generated `executeOptimistic`.
- Mutations that must add/remove/reorder cached list items, via `executeWithCacheUpdate`.
- One-shot operations that are not the screen's main reactive data, such as a submit-to-search request.
- UI side effects after an operation, such as `Navigator.pop`, snack bars, loading flags, and error messages.

The common Flutter shape is: declarative scope around the reactive entity, imperative handlers inside the state object.

```dart
class _AlbumDetailPageState extends State<_AlbumDetailPage> {
  Future<void> _addGif(SearchGif gif) async {
    final client = ShalomScope.of(context);
    final response = await AddGifToAlbumMutation(client).executeWithCacheUpdate(
      albumId: widget.albumId,
      title: gif.title,
      url: gif.url,
      previewUrl: gif.previewUrl != null ? Some(gif.previewUrl) : const None(),
      update: (cache, data) {
        final current = AlbumWidgetRef.fromId(widget.albumId).readFrom(cache);
        if (current == null) return;

        cache.writeFragment(
          data: AlbumWidgetData(
            id: current.id,
            name: current.name,
            tag: current.tag,
            gifs: [
              ...current.gifs,
              AlbumWidget_gifs(
                id: data.addGifToAlbum.id,
                title: data.addGifToAlbum.title,
                url: data.addGifToAlbum.url,
              ),
            ],
          ),
        );
      },
    );

    if (response is! GraphQLData && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add GIF')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlbumWidgetScope(
      ref: AlbumWidgetRef.fromId(widget.albumId),
      loadingBuilder: (_) => const CircularProgressIndicator(),
      errorBuilder: (context, error) => Text('$error'),
      builder: (context, album) {
        final filtered = _filteredLocal(album);
        return ListView(
          children: [
            for (final gif in filtered)
              ListTile(
                title: Text(gif.title),
                trailing: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _addGif(gif),
                ),
              ),
          ],
        );
      },
    );
  }
}
```

Avoid starting imperative `client.request(...)` calls directly inside `build`. Trigger them from handlers, lifecycle methods with cancellation, or generated widgets/scopes. For one-shot imperative requests, use `.first`; for long-lived manual subscriptions, keep and cancel the `StreamSubscription`.

## Mutations

`@Mutation` classes are imperative. They extend a generated base that takes a `ShalomRuntimeClient`.

```dart
@Mutation(r"""
  ($name: String!) {
    createAlbum(name: $name) {
      id
      name
      tag
      gifs { ...AlbumGif }
    }
  }
""")
class CreateAlbumMutation extends $CreateAlbumMutation {
  const CreateAlbumMutation(super.client);
}
```

Generated mutation APIs include:

- `execute(...)`: run the mutation and normalize the response.
- `executeWithCacheUpdate(..., update: (CacheProxy cache, Data data) { ... })`: run the mutation, then call `update` only for successful `GraphQLData`.
- `executeOptimistic(optimisticFactory, rollbackWhen: ..., ...)`: write a predicted mutation payload before the network response, then return an `OptimisticMutationResponse`.

Mutation selection rules:

- Include `id` on object results that should merge with normalized entities.
- Include every field needed by active fragments/widgets that will read the returned entity.
- Use fragment spreads in mutation SDL when you want generated mutation result classes to implement the same fragment interface as the UI.
- Remember that normalizing a mutation response updates matching entity records but does not automatically add/remove refs from parent lists.

## Fragments

Use `@Fragment` for reusable UI over one normalized entity, especially child widgets that should update independently from parent queries.

```dart
@Fragment(r"""
  on Album {
    id
    name
    tag
    gifs { ...AlbumGif }
  }
""")
class AlbumWidget extends $AlbumWidget {
  const AlbumWidget({super.key, required super.ref});

  @override
  Widget buildData(BuildContext context, AlbumWidgetData album) => ...;
}
```

Generated fragment APIs include:

- `FragmentNameRef.fromId(id)` and `FragmentNameRef.fromEntityKey(key)`.
- `ref.readFrom(cache)` and `ref.observe(client)`.
- `FragmentNameData implements FragmentInterface`.
- `FragmentNameData.entityKey(id)`.
- `$FragmentName` widget and `FragmentNameScope`.

Parent operations should spread fragments and pass refs:

```dart
@Query(r"""
  {
    albums {
      ...AlbumWidget
    }
  }
""")
class AlbumsPage extends $AlbumsPage {
  @override
  Widget buildData(BuildContext context, AlbumsPageData data) {
    return ListView.builder(
      itemCount: data.albums.length,
      itemBuilder: (context, i) => AlbumWidget(ref: data.albums[i]),
    );
  }
}
```

When a page already has an id, build the ref directly:

```dart
AlbumWidgetScope(
  ref: AlbumWidgetRef.fromId(albumId),
  builder: (context, album) => ...,
)
```

### Fragment Scope Shortcuts

Every generated fragment has two useful shortcuts:

- `XRef`: a typed cache pointer for the fragment, for example `AlbumWidgetRef.fromId(albumId)`.
- `XScope`: a lightweight builder widget for observing that ref without creating a separate `X extends $X` widget.

Use `XScope` when a screen already has the entity id/ref and just needs reactive fragment data:

```dart
AlbumWidgetScope(
  ref: AlbumWidgetRef.fromId(widget.albumId),
  loadingBuilder: (_) => const CircularProgressIndicator(),
  errorBuilder: (context, error) => Text('$error'),
  builder: (context, album) {
    return Text(album.name);
  },
)
```

Use the ref shortcuts inside cache update callbacks:

```dart
final ref = AlbumWidgetRef.fromId(albumId);
final current = ref.readFrom(cache);
if (current == null) return;

cache.writeFragment(
  data: AlbumWidgetData(
    id: current.id,
    name: current.name,
    tag: current.tag,
    gifs: current.gifs,
  ),
);
```

`ref.readFrom(cache)` is shorthand for `cache.readFragment(...)` with the generated fragment name, entity key, and decoder. `ref.observe(client)` is shorthand for `client.subscribeToFragment(...)` with the generated decoder.

Fragment guidelines:

- Include `id` for entity fragments you will manually address in cache updates.
- Pass refs to child fragment widgets instead of passing full data when the child should stay reactive.
- Fragment spreads are flattened into generated selections. If a fragment spreads another fragment, the generated concrete class implements the spread fragment interface.
- Nested object selections inside fragments are generated in the fragment file.
- Union/interface selections become sealed classes resolved by `__typename`.

## Optimistic Updates

Use generated `executeOptimistic` when the optimistic state can be represented as the mutation response shape.

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

What it does:

- Writes `optimisticFactory(vars).toJson()` through `client.writeOptimistic`.
- Normalizes the predicted payload and notifies observers immediately.
- Runs the real mutation.
- Calls `rollbackWhen` only for successful `GraphQLData`.
- Returns `OptimisticMutationResponse` with `response`, `wasRolledBack`, and idempotent `rollback()`.

Important details:

- The optimistic payload must exactly match the mutation response shape.
- Include ids and any fields watched by active fragments/widgets.
- `GraphQLError` and `LinkExceptionResponse` are response values, not thrown exceptions. Call `result.rollback()` yourself when those should undo the optimistic write.
- Thrown exceptions during the mutation path are rolled back by the generated helper.
- `executeOptimistic` does not run an `executeWithCacheUpdate` list callback. For optimistic list membership, prefer a mutation response that includes the parent/list field, or implement a manual rollback path for the extra list write.

## Updating Lists After Mutations

Use `executeWithCacheUpdate` when a mutation creates, deletes, adds, removes, or reorders items and the server response does not refetch the parent list. The mutation response is normalized before the callback runs.

Root query list add:

```dart
await CreateAlbumMutation(client).executeWithCacheUpdate(
  name: name,
  update: (cache, data) {
    final current = AlbumsPageData.readFrom(cache);
    if (current == null) return;

    cache.writeQuery(
      data: AlbumsPageData(
        albums: [
          ...current.albums,
          AlbumWidgetRef.fromId(data.createAlbum.id),
        ],
      ),
    );
  },
);
```

Entity child list add:

```dart
await AddGifToAlbumMutation(client).executeWithCacheUpdate(
  albumId: albumId,
  title: gif.title,
  url: gif.url,
  previewUrl: gif.previewUrl != null ? Some(gif.previewUrl) : const None(),
  update: (cache, data) {
    final current = AlbumWidgetRef.fromId(albumId).readFrom(cache);
    if (current == null) return;
    if (current.gifs.any((g) => g.url == data.addGifToAlbum.url)) return;

    cache.writeFragment(
      data: AlbumWidgetData(
        id: current.id,
        name: current.name,
        tag: current.tag,
        gifs: [
          ...current.gifs,
          AlbumWidget_gifs(
            id: data.addGifToAlbum.id,
            title: data.addGifToAlbum.title,
            url: data.addGifToAlbum.url,
          ),
        ],
      ),
    );
  },
);
```

Entity child list remove:

```dart
await RemoveGifFromAlbumMutation(client).executeWithCacheUpdate(
  albumId: albumId,
  gifId: gifId,
  update: (cache, data) {
    if (data.removeGifFromAlbum != null) return;

    final current = cache.readFragment<AlbumWidgetData>(
      fragmentName: 'AlbumWidget',
      entityKey: AlbumWidgetData.entityKey(albumId),
      decoder: AlbumWidgetData.fromCache,
    );
    if (current == null) return;

    cache.writeFragment(
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

List update rules:

- Use `cache.writeQuery` for root operation data.
- Use `cache.writeFragment` for one normalized entity's fragment data.
- Preserve all required fields from the existing cached value when constructing replacement data.
- `readFrom`, `readQuery`, and `readFragment` can return `null` when data is absent or incomplete.
- Guard duplicate inserts with stable ids or unique fields.
- Only write generated refs such as `AlbumWidgetRef.fromId(id)` after the mutation response includes enough fields to satisfy that fragment.
- For queries with variables, pass the same variables to `readQuery`/`writeQuery`; argument values are part of the normalized field key.
