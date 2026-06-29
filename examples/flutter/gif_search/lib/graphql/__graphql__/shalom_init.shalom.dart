// ignore_for_file: unused_import
import 'package:flutter/widgets.dart';
import 'package:shalom/shalom.dart';
import 'package:shalom_flutter/shalom_flutter.dart' show ShalomInheritedWidget;

/// The GraphQL schema SDL inlined at code-generation time.
///
/// Use this to create the [ShalomRuntimeClient] — no async asset loading needed:
/// ```dart
/// final client = ShalomRuntimeClient.create(schemaSdl: kSchemaSdl, link: link);
/// ```
const String kSchemaSdl = r'''type Album {
  id: String!
  name: String!
  gifs: [Gif!]!
  tag: String!
}

type AlbumEvent {
  kind: AlbumEventKind!
  album: Album!
  gif: Gif
}

enum AlbumEventKind {
  ALBUM_CREATED
  ALBUM_DELETED
  GIF_ADDED_TO_ALBUM
  GIF_REMOVED_FROM_ALBUM
}

type Gif implements GifInterface {
  title: String!
  url: String!
  previewUrl: String
  id: String!
}

interface GifInterface {
  title: String!
  url: String!
  previewUrl: String
}

type GifSearchPage {
  items: [PreviewGif!]!
  offset: Int!
  limit: Int!
  totalCount: Int
  hasNextPage: Boolean!
}

type Mutation {
  createAlbum(name: String!): Album!
  deleteAlbum(id: String!): MutationError
  addGifToAlbum(albumId: String!, title: String!, url: String!, previewUrl: String = null): Gif!
  removeGifFromAlbum(albumId: String!, gifId: String!): MutationError
}

type MutationError {
  code: String!
  message: String!
}

type PreviewGif implements GifInterface {
  title: String!
  url: String!
  previewUrl: String
}

type Query {
  searchGifs(query: String!, offset: Int! = 0, limit: Int! = 20): GifSearchPage!
  albums: [Album!]!
  album(id: String!): Album
}

type Subscription {
  albumEvents: AlbumEvent!
}''';

/// Register all @Query, @Fragment, @Mutation, and @Subscription operations with the Shalom client.
void registerShalomDefinitions(ShalomRuntimeClient client) {
  client.registerFragment(
    document: r'''
fragment AlbumGif on Gif @observe {
    id
    title
    url
  }
''',
  );
  client.registerFragment(
    document: r'''
fragment AlbumWidget on Album @observe {
    id
    name
    tag
    gifs {
      ...AlbumGif
    }
  }
''',
  );
  client.registerOperation(
    document: r'''
query AlbumsPage @observe {
    albums {
      ...AlbumWidget
    }
  }
''',
  );
  client.registerOperation(
    document: r'''
query AlbumGifSearch ($query: String!, $offset: Int!, $limit: Int!) @observe {
    searchGifs(query: $query, offset: $offset, limit: $limit) {
      items {
        title
        url
        previewUrl
      }
      hasNextPage
    }
  }
''',
  );
  client.registerOperation(
    document: r'''
mutation DeleteAlbumMutation ($id: String!) {
    deleteAlbum(id: $id) {
      code
      message
    }
  }
''',
  );
  client.registerOperation(
    document: r'''
mutation CreateAlbumMutation ($name: String!) {
    createAlbum(name: $name) {
      id 
      name
      tag
      gifs {
        ...AlbumGif
      }
    }
  }
''',
  );
  client.registerOperation(
    document: r'''
mutation AddGifToAlbumMutation ($albumId: String!, $title: String!, $url: String!, $previewUrl: String) {
    addGifToAlbum(albumId: $albumId, title: $title, url: $url, previewUrl: $previewUrl) {
      ...AlbumGif
    }
  }
''',
  );
  client.registerOperation(
    document: r'''
mutation RemoveGifFromAlbumMutation ($albumId: String!, $gifId: String!) {
    removeGifFromAlbum(albumId: $albumId, gifId: $gifId) {
      code
      message
    }
  }
''',
  );
}

/// Generated [ShalomProvider] for this app.
///
/// Place this at the root of your widget tree.  On hot-reload it automatically
/// reloads the schema and re-registers all operations and fragments so that any
/// SDL changes take effect without a full restart.
class ShalomProvider extends StatefulWidget {
  final ShalomRuntimeClient client;
  final Widget child;

  const ShalomProvider({super.key, required this.client, required this.child});

  @override
  State<ShalomProvider> createState() => _ShalomProviderState();
}

class _ShalomProviderState extends State<ShalomProvider> {
  @override
  void reassemble() {
    super.reassemble();
    widget.client.reloadSchema(schemaSdl: kSchemaSdl);
    registerShalomDefinitions(widget.client);
  }

  @override
  Widget build(BuildContext context) =>
      ShalomInheritedWidget(client: widget.client, child: widget.child);
}
