// ignore_for_file: unused_import
import 'package:shalom/shalom.dart';

/// Register all @Query, @Fragment, @Mutation, and @Subscription operations with the Shalom client.
Future<void> registerShalomDefinitions(ShalomRuntimeClient client) async {
  await client.registerFragment(
    document: r'''
fragment GifWidget on Gif @observe {
    id
    title
    url
    previewUrl
  }
''',
  );
  await client.registerFragment(
    document: r'''
fragment AlbumWidget on Album @observe {
    id
    name
    gifs {
      id
      title
    }
  }
''',
  );
  await client.registerOperation(
    document: r'''
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
''',
  );
  await client.registerOperation(
    document: r'''
query AlbumsPage @observe {
    albums {
      ...AlbumWidget
    }
  }
''',
  );
  await client.registerOperation(
    document: r'''
mutation CreateAlbumMutation ($name: String!) {
    createAlbum(name: $name) {
      id
      name
    }
  }
''',
  );
  await client.registerOperation(
    document: r'''
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
''',
  );
  await client.registerOperation(
    document: r'''
mutation RemoveGifFromAlbumMutation ($albumId: String!, $gifId: String!) {
    removeGifFromAlbum(albumId: $albumId, gifId: $gifId) {
      id
      name
    }
  }
''',
  );
}
