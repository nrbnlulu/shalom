// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions

import "../schema.shalom.dart";

import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';
import 'package:meta/meta.dart' show experimental;

// Fragment imports
import 'AlbumWidget.shalom.dart';

// ------------ OBJECT DEFINITIONS -------------

class AlbumsPageResponse {
  static String G__typename = "query";

  /// class members
  final List<AlbumWidgetRef> albums;

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

  @experimental
  static AlbumsPageResponse fromJson(shalom_core.JsonObject data) {
    final List<AlbumWidgetRef> albums$value =
        (data['albums'] as List<dynamic>)
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
  final String id;

  final String name;

  final List<AlbumWidget_gifs> gifs;

  // keywordargs constructor
  AlbumsPage_albums({required this.id, required this.name, required this.gifs});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AlbumsPage_albums &&
            id == other.id &&
            name == other.name &&
            const ListEquality().equals(gifs, other.gifs));
  }

  @override
  int get hashCode =>
      Object.hashAll([id, name, gifs, AlbumsPage_albums.G__typename]);

  shalom_core.JsonObject toJson() {
    return {
      'id': this.id,

      'name': this.name,

      'gifs': this.gifs.map((e) => e.toJson()).toList(),
    };
  }

  @experimental
  static AlbumsPage_albums fromJson(shalom_core.JsonObject data) {
    final String id$value = data['id'] as String;
    final String name$value = data['name'] as String;
    final List<AlbumWidget_gifs> gifs$value =
        (data['gifs'] as List<dynamic>)
            .map((e) => AlbumWidget_gifs.fromJson(e as shalom_core.JsonObject))
            .toList();
    return AlbumsPage_albums(id: id$value, name: name$value, gifs: gifs$value);
  }
}

// ------------ END OBJECT DEFINITIONS -------------

// ------------ UNION DEFINITIONS -------------

// ------------ END UNION DEFINITIONS -------------

// ------------ INTERFACE DEFINITIONS -------------

// ------------ END INTERFACE DEFINITIONS -------------

// ------------ MULTI-TYPE LIST EXTENSIONS -------------

// ------------ END MULTI-TYPE LIST EXTENSIONS -------------

// ------------ V2 WIDGET API -------------

final class AlbumsPageData {
  final List<AlbumWidgetRef> albums;

  const AlbumsPageData({required this.albums});

  @experimental
  static AlbumsPageData fromCache(shalom_core.JsonObject data) {
    final List<AlbumWidgetRef> albums$value =
        (data['albums'] as List<dynamic>)
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

  shalom_core.JsonObject toJson() {
    return {'albums': this.albums.map((e) => e.toJson()).toList()};
  }
}

// ------------ END V2 WIDGET API -------------
