// ignore_for_file: unused_import
import 'package:flutter/widgets.dart';
import 'package:shalom/shalom.dart';
import 'package:shalom_flutter/shalom_flutter.dart' show ShalomInheritedWidget;

/// Register all @Query, @Fragment, @Mutation, and @Subscription operations with the Shalom client.
void registerShalomDefinitions(ShalomRuntimeClient client) {
  client.registerFragment(document: r'''
fragment GifWidget on Gif @observe {
    id
    title
    url
    previewUrl
  }
''');
  client.registerFragment(document: r'''
fragment AlbumWidget on Album @observe {
    id
    name
    gifs {
      id
      title
    }
  }
''');
  client.registerOperation(document: r'''
query SearchGifsPage ($query: String!, $offset: Int!, $limit: Int!) @observe {
    searchGifs(query: $query, offset: $offset, limit: $limit) {
      items {
        ...GifWidget
      }
      offset
      limit
      totalCount
      hasNextPage
    }
  }
''');
  client.registerOperation(document: r'''
query AlbumsPage @observe {
    albums {
      ...AlbumWidget
    }
  }
''');
  client.registerOperation(document: r'''
mutation CreateAlbumMutation ($name: String!) {
    createAlbum(name: $name) {
      id
      name
    }
  }
''');
  client.registerOperation(document: r'''
mutation AddGifToAlbumMutation ($albumId: String!, $gifId: String!, $title: String!, $url: String!, $previewUrl: String) {
    addGifToAlbum(albumId: $albumId, gifId: $gifId, title: $title, url: $url, previewUrl: $previewUrl) {
      id
      name
      gifs {
        id
        title
      }
    }
  }
''');
  client.registerOperation(document: r'''
mutation RemoveGifFromAlbumMutation ($albumId: String!, $gifId: String!) {
    removeGifFromAlbum(albumId: $albumId, gifId: $gifId) {
      id
      name
    }
  }
''');
}

/// Generated [ShalomProvider] for this app.
///
/// Place this at the root of your widget tree.  On hot-reload it automatically
/// re-registers all operations and fragments so that any SDL changes take effect
/// without a full restart.
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
    registerShalomDefinitions(widget.client);
  }

  @override
  Widget build(BuildContext context) =>
      ShalomInheritedWidget(client: widget.client, child: widget.child);
}