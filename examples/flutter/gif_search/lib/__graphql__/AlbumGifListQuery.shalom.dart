// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions

import "../graphql/__graphql__/schema.shalom.dart";

import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';

// Fragment imports

// ------------ OBJECT DEFINITIONS -------------

class AlbumGifListQueryResponse {
  static String G__typename = "query";

  /// class members
  final AlbumGifListQuery_album? album;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  AlbumGifListQueryResponse({this.album});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AlbumGifListQueryResponse && album == other.album);
  }

  @override
  int get hashCode =>
      Object.hashAll([album, AlbumGifListQueryResponse.G__typename]);

  shalom_core.JsonObject toJson() {
    return {'album': this.album?.toJson()};
  }

  static AlbumGifListQueryResponse fromJson(shalom_core.JsonObject data) {
    final AlbumGifListQuery_album? album$value = data['album'] == null
        ? null
        : AlbumGifListQuery_album.fromJson(
            data['album'] as shalom_core.JsonObject,
          );
    return AlbumGifListQueryResponse(album: album$value);
  }
}

class AlbumGifListQuery_album {
  static String G__typename = "Album";

  /// class members
  final List<AlbumGifListQuery_album_gifs> gifs;

  final String id;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  AlbumGifListQuery_album({required this.gifs, required this.id});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AlbumGifListQuery_album &&
            const ListEquality().equals(gifs, other.gifs) &&
            id == other.id);
  }

  @override
  int get hashCode =>
      Object.hashAll([gifs, id, AlbumGifListQuery_album.G__typename]);

  shalom_core.JsonObject toJson() {
    return {'gifs': this.gifs.map((e) => e.toJson()).toList(), 'id': this.id};
  }

  static AlbumGifListQuery_album fromJson(shalom_core.JsonObject data) {
    final List<AlbumGifListQuery_album_gifs> gifs$value =
        (data['gifs'] as List<dynamic>)
            .map(
              (e) => AlbumGifListQuery_album_gifs.fromJson(
                e as shalom_core.JsonObject,
              ),
            )
            .toList();
    final String id$value = data['id'] as String;
    return AlbumGifListQuery_album(gifs: gifs$value, id: id$value);
  }
}

class AlbumGifListQuery_album_gifs {
  static String G__typename = "Gif";

  /// class members
  final String id;

  final String title;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  AlbumGifListQuery_album_gifs({required this.id, required this.title});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AlbumGifListQuery_album_gifs &&
            id == other.id &&
            title == other.title);
  }

  @override
  int get hashCode =>
      Object.hashAll([id, title, AlbumGifListQuery_album_gifs.G__typename]);

  shalom_core.JsonObject toJson() {
    return {'id': this.id, 'title': this.title};
  }

  static AlbumGifListQuery_album_gifs fromJson(shalom_core.JsonObject data) {
    final String id$value = data['id'] as String;
    final String title$value = data['title'] as String;
    return AlbumGifListQuery_album_gifs(id: id$value, title: title$value);
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

final class AlbumGifListQueryData implements shalom_core.OperationInterface {
  final AlbumGifListQuery_album? album;

  const AlbumGifListQueryData({required this.album});

  @override
  String operation$Name() => 'AlbumGifListQuery';

  static AlbumGifListQueryData fromCache(shalom_core.JsonObject data) {
    final AlbumGifListQuery_album? album$value = data['album'] == null
        ? null
        : AlbumGifListQuery_album.fromJson(
            data['album'] as shalom_core.JsonObject,
          );
    return AlbumGifListQueryData(album: album$value);
  }

  shalom_core.JsonObject toJson() {
    return {'album': this.album?.toJson()};
  }
}

final class AlbumGifListQueryVariables {
  final String albumId;

  const AlbumGifListQueryVariables({required this.albumId});

  shalom_core.JsonObject toJson() {
    shalom_core.JsonObject data = {};

    data["albumId"] = this.albumId;

    return data;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AlbumGifListQueryVariables && this.albumId == other.albumId);
  }

  @override
  int get hashCode => Object.hashAll([albumId]);
}

// ------------ END V2 WIDGET API -------------
