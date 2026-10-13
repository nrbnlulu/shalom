# Quickstart

This walkthrough is a hands-on tutorial for the GIF search Flutter example in
`examples/flutter/gif_search`. The same approach works for any Flutter app
using Shalom's declarative annotation API.

## 1. Add your schema

Shalom still needs a GraphQL schema for validation and type generation. The
example keeps it at `examples/flutter/gif_search/lib/graphql/schema.graphql`:

```graphql
type Album {
  id: ID!
  name: String!
  tag: String!
  gifs: [Gif!]!
}

type Gif {
  id: ID!
  title: String!
  url: String!
}
```

## 2. Annotate widgets, fragments, and mutations

Unlike v1, there are no separate `.graphql` operation files. You annotate the
Dart/Flutter classes that need data directly, and the codegen generates a
`$ClassName` base class alongside them:

```dart
import 'package:flutter/material.dart';
import 'package:shalom_annotations/shalom_annotations.dart';
import 'package:gif_search/__graphql__/AlbumsPage.widget.shalom.dart';
import 'package:gif_search/__graphql__/AlbumWidget.shalom.dart';

@Query(r"""
  {
    albums {
      ...AlbumWidget
    }
  }
""")
class AlbumsPage extends $AlbumsPage {
  const AlbumsPage({super.key});

  @override
  Widget buildData(BuildContext context, AlbumsPageData data) {
    return ListView.builder(
      itemCount: data.albums.length,
      itemBuilder: (context, i) => AlbumWidget(ref: data.albums[i]),
    );
  }
}

@Fragment(r"""
  on Album {
    id
    name
    tag
    gifs { id title url }
  }
""")
class AlbumWidget extends $AlbumWidget {
  const AlbumWidget({super.key, required super.ref});

  @override
  Widget buildData(BuildContext context, AlbumWidgetData album) =>
      ListTile(title: Text(album.name));
}
```

You can also annotate mutation classes to generate type-safe mutation executors:

```dart
import 'package:gif_search/__graphql__/CreateAlbumMutation.mutation.shalom.dart';

@Mutation(r"""
  ($name: String!) {
    createAlbum(name: $name) {
      id
      name
      tag
    }
  }
""")
class CreateAlbumMutation extends $CreateAlbumMutation {
  const CreateAlbumMutation(super.client);
}
```

Mutations are executed imperatively with generated executor classes:

```dart
final client = ShalomScope.of(context);
final response = await CreateAlbumMutation(client).execute(name: 'Favorites');
```

## 3. Run codegen

```bash
shalom generate --path examples/flutter/gif_search
```

Shalom emits Dart files under a `__graphql__` directory next to each
annotated file (for example `lib/__graphql__/AlbumsPage.widget.shalom.dart`
and `lib/__graphql__/AlbumWidget.shalom.dart`). It also emits a single
registration file next to your schema under `lib/graphql/__graphql__/shalom_init.shalom.dart`,
exporting `kSchemaSdl`, `registerShalomDefinitions(client)`, and the app-scoped `ShalomProvider`.

## 4. Create the client and register definitions

```dart
import 'package:flutter/material.dart';
import 'package:shalom/shalom.dart';
import 'package:gif_search/graphql/__graphql__/shalom_init.shalom.dart'
    show kSchemaSdl, registerShalomDefinitions, ShalomProvider;

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

`ShalomProvider` puts the client above your widget tree so generated
query/subscription/fragment widgets and `ShalomScope.of(context)` can find it.

## 5. Mount the generated widget

There is no manual `request`/subscribe call for reads. Just place the
annotated widget in the tree:

```dart
home: const AlbumsPage(),
```

`AlbumsPage` fetches on mount, normalizes the response into the cache, and
rebuilds whenever a watched cache entry changes — including changes written
by other operations or mutations.

## 6. Handle loading, error, and data states

For `@Query` and `@Subscription` widgets, `buildLoading`, `buildError`, and `buildData` are all abstract methods that must be implemented:

- **`buildLoading(BuildContext context)`**: Displayed while the query or subscription is in flight and no cached data is available.
- **`buildError(BuildContext context, Object error)`**: Displayed when a request fails with an error and no cached fallback exists.
- **`buildData(BuildContext context, T data)`**: Called whenever data is ready or updated from the normalized cache.

For `@Fragment` widgets, `buildLoading` (defaults to `SizedBox.shrink()`) and `buildError` (defaults to `ErrorWidget`) have default implementations, while `buildData` is required. You can override them as needed:

```dart
@override
Widget buildLoading(BuildContext context) =>
    const Center(child: CircularProgressIndicator());

@override
Widget buildError(BuildContext context, Object error) =>
    Center(child: Text('Error: $error'));
```
!!! note "Reusing loading and error states"
    In real applications, you can define a mixin (like `QueryWidgetMixin`) to avoid repeating `buildLoading` and `buildError` implementations across your screens:

    ```dart
    mixin QueryWidgetMixin {
      Widget buildLoading(BuildContext context) =>
          const Center(child: CircularProgressIndicator());

      Widget buildError(BuildContext context, Object error) =>
          Center(child: Text('Error: $error'));
    }

    class MyQueryScreen extends $MyQueryScreen with QueryWidgetMixin {
      @override
      Widget buildData(BuildContext context, MyQueryData data) => ...;
    }
    ```

## 7. (Optional) Configure `shalom.yml`

A `shalom.yml` configuration file in your project root is optional, but lets you configure custom scalar mappings or override output directories:

```yml
custom_scalars: {}
```

See the [Custom Scalars](custom-scalars.md) guide for details on mapping custom GraphQL types to Dart classes.

## 8. Run the example app

The example app includes a local mock GraphQL server in `examples/flutter/gif_search/server`.

Start the mock server (in one terminal):

```bash
cd examples/flutter/gif_search/server
uv run python main.py
```

The server runs on `http://127.0.0.1:7000/graphql` and includes a GraphiQL playground.

Then, start the Flutter app (in another terminal):

```bash
cd examples/flutter/gif_search
flutter run
```

## 9. Next: Normalized Cache

Shalom normalizes response data into typed entity records (e.g. `Album:<id>`), so a change from one operation (a mutation, another query, or a subscription) immediately updates every widget that reads the same entity — with zero prop drilling or manual refetching.

Head over to the [Normalized Cache](normalized-cache.md) guide!
