// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions

import "../graphql/__graphql__/schema.shalom.dart";

import 'dart:async' show Stream;

import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';

// Fragment imports
import 'AlbumGif.shalom.dart';
import 'AlbumWidget.shalom.dart';

// ------------ OBJECT DEFINITIONS -------------

class AlbumsPageResponse {
  static String G__typename = "query";

  /// class members
  final List<AlbumWidgetRef> albums;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  AlbumsPageResponse({required this.albums});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AlbumsPageResponse &&
            const ListEquality().equals(albums, other.albums));
  }

  @override
  int get hashCode => Object.hashAll([albums, AlbumsPageResponse.G__typename]);

  shalom_core.JsonObject toJson() {
    return {'albums': this.albums.map((e) => e.toJson()).toList()};
  }

  static AlbumsPageResponse fromJson(shalom_core.JsonObject data) {
    final List<AlbumWidgetRef> albums$value = (data['albums'] as List<dynamic>)
        .map(
          (e) => AlbumWidgetRef.fromInput(
            shalom_core.observedRefInputFromJson(
              (e as shalom_core.JsonObject)[r'$AlbumWidget']
                  as shalom_core.JsonObject,
            ),
          ),
        )
        .toList();
    return AlbumsPageResponse(albums: albums$value);
  }
}

class AlbumsPage_albums {
  static String G__typename = "Album";

  /// class members
  final List<AlbumGifRef> gifs;

  final String id;

  final String name;

  final String tag;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  AlbumsPage_albums({
    required this.gifs,

    required this.id,

    required this.name,

    required this.tag,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AlbumsPage_albums &&
            const ListEquality().equals(gifs, other.gifs) &&
            id == other.id &&
            name == other.name &&
            tag == other.tag);
  }

  @override
  int get hashCode =>
      Object.hashAll([gifs, id, name, tag, AlbumsPage_albums.G__typename]);

  shalom_core.JsonObject toJson() {
    return {
      'gifs': this.gifs.map((e) => e.toJson()).toList(),

      'id': this.id,

      'name': this.name,

      'tag': this.tag,
    };
  }

  static AlbumsPage_albums fromJson(shalom_core.JsonObject data) {
    final List<AlbumGifRef> gifs$value = (data['gifs'] as List<dynamic>)
        .map(
          (e) => AlbumGifRef.fromInput(
            shalom_core.observedRefInputFromJson(
              (e as shalom_core.JsonObject)[r'$AlbumGif']
                  as shalom_core.JsonObject,
            ),
          ),
        )
        .toList();
    final String id$value = data['id'] as String;
    final String name$value = data['name'] as String;
    final String tag$value = data['tag'] as String;
    return AlbumsPage_albums(
      gifs: gifs$value,

      id: id$value,

      name: name$value,

      tag: tag$value,
    );
  }
}

// ------------ END OBJECT DEFINITIONS -------------

// ------------ UNION DEFINITIONS -------------

// ------------ END UNION DEFINITIONS -------------

// ------------ INTERFACE DEFINITIONS -------------

// ------------ END INTERFACE DEFINITIONS -------------

// ------------ MULTI-TYPE LIST EXTENSIONS -------------

// ------------ END MULTI-TYPE LIST EXTENSIONS -------------

// ------------ widget API -------------

final class AlbumsPageData implements shalom_core.OperationInterface {
  final List<AlbumWidgetRef> albums;

  const AlbumsPageData({required this.albums});

  @override
  String operation$Name() => 'AlbumsPage';

  static AlbumsPageData fromCache(shalom_core.JsonObject data) {
    final List<AlbumWidgetRef> albums$value = (data['albums'] as List<dynamic>)
        .map(
          (e) => AlbumWidgetRef.fromInput(
            shalom_core.observedRefInputFromJson(
              (e as shalom_core.JsonObject)[r'$AlbumWidget']
                  as shalom_core.JsonObject,
            ),
          ),
        )
        .toList();
    return AlbumsPageData(albums: albums$value);
  }

  /// Reads this operation's current cache entry through [cache], decoding
  /// it as [AlbumsPageData]. Returns `null` when absent or incomplete.
  static Future<AlbumsPageData?> readFrom(shalom_core.CacheProxy cache) async {
    return await cache.readQuery<AlbumsPageData>(
      name: 'AlbumsPage',
      decoder: fromCache,
    );
  }

  shalom_core.JsonObject toJson() {
    return {'albums': this.albums.map((e) => e.toJson()).toList()};
  }
}

final class AlbumsPageObservable {
  final shalom_core.ExecutionPolicyInput executionPolicy;

  const AlbumsPageObservable({
    this.executionPolicy = shalom_core.ExecutionPolicyInput.cacheFirst,
  });

  String operation$Name() => 'AlbumsPage';

  Stream<shalom_core.GraphQLResponse<AlbumsPageData>> observe(
    shalom_core.ShalomRuntimeClient client,
  ) {
    return client.request<AlbumsPageData>(
      name: operation$Name(),

      decoder: AlbumsPageData.fromCache,
      executionPolicy: executionPolicy,
    );
  }
}

// ------------ END widget API -------------
