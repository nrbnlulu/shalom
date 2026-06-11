// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions

import "../graphql/__graphql__/schema.shalom.dart";

import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';
import 'package:meta/meta.dart' show experimental;

// Fragment imports

// ------------ OBJECT DEFINITIONS -------------

class AddGifToAlbumMutation_addGifToAlbum {
  static String G__typename = "Album";

  /// class members
  final String id;

  final List<AddGifToAlbumMutation_addGifToAlbum_gifs> gifs;

  final String name;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  AddGifToAlbumMutation_addGifToAlbum({
    required this.id,

    required this.gifs,

    required this.name,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AddGifToAlbumMutation_addGifToAlbum &&
            id == other.id &&
            const ListEquality().equals(gifs, other.gifs) &&
            name == other.name);
  }

  @override
  int get hashCode => Object.hashAll([
    id,

    gifs,

    name,

    AddGifToAlbumMutation_addGifToAlbum.G__typename,
  ]);

  shalom_core.JsonObject toJson() {
    return {
      'id': this.id,

      'gifs': this.gifs.map((e) => e.toJson()).toList(),

      'name': this.name,
    };
  }

  @experimental
  static AddGifToAlbumMutation_addGifToAlbum fromJson(
    shalom_core.JsonObject data,
  ) {
    final String id$value = data['id'] as String;
    final List<AddGifToAlbumMutation_addGifToAlbum_gifs> gifs$value =
        (data['gifs'] as List<dynamic>)
            .map(
              (e) => AddGifToAlbumMutation_addGifToAlbum_gifs.fromJson(
                e as shalom_core.JsonObject,
              ),
            )
            .toList();
    final String name$value = data['name'] as String;
    return AddGifToAlbumMutation_addGifToAlbum(
      id: id$value,

      gifs: gifs$value,

      name: name$value,
    );
  }
}

class AddGifToAlbumMutation_addGifToAlbum_gifs {
  static String G__typename = "Gif";

  /// class members
  final String title;

  final String id;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  AddGifToAlbumMutation_addGifToAlbum_gifs({
    required this.title,

    required this.id,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AddGifToAlbumMutation_addGifToAlbum_gifs &&
            title == other.title &&
            id == other.id);
  }

  @override
  int get hashCode => Object.hashAll([
    title,

    id,

    AddGifToAlbumMutation_addGifToAlbum_gifs.G__typename,
  ]);

  shalom_core.JsonObject toJson() {
    return {'title': this.title, 'id': this.id};
  }

  @experimental
  static AddGifToAlbumMutation_addGifToAlbum_gifs fromJson(
    shalom_core.JsonObject data,
  ) {
    final String title$value = data['title'] as String;
    final String id$value = data['id'] as String;
    return AddGifToAlbumMutation_addGifToAlbum_gifs(
      title: title$value,

      id: id$value,
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

// ------------ MUTATION DATA + VARIABLES -------------

final class AddGifToAlbumMutationData {
  final AddGifToAlbumMutation_addGifToAlbum addGifToAlbum;

  const AddGifToAlbumMutationData({required this.addGifToAlbum});

  @experimental
  static AddGifToAlbumMutationData fromCache(shalom_core.JsonObject data) {
    final AddGifToAlbumMutation_addGifToAlbum addGifToAlbum$value =
        AddGifToAlbumMutation_addGifToAlbum.fromJson(
          data['addGifToAlbum'] as shalom_core.JsonObject,
        );
    return AddGifToAlbumMutationData(addGifToAlbum: addGifToAlbum$value);
  }

  shalom_core.JsonObject toJson() {
    return {'addGifToAlbum': this.addGifToAlbum.toJson()};
  }
}

final class AddGifToAlbumMutationVariables {
  final String albumId;

  final String gifId;

  final shalom_core.Maybe<String?> previewUrl;

  final String title;

  final String url;

  const AddGifToAlbumMutationVariables({
    required this.albumId,

    required this.gifId,

    this.previewUrl = const shalom_core.None(),

    required this.title,

    required this.url,
  });

  shalom_core.JsonObject toJson() {
    shalom_core.JsonObject data = {};

    data["albumId"] = this.albumId;
    data["gifId"] = this.gifId;
    if (previewUrl.isSome()) {
      final value = this.previewUrl.some();
      data["previewUrl"] = value;
    }
    data["title"] = this.title;
    data["url"] = this.url;

    return data;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AddGifToAlbumMutationVariables &&
            this.albumId == other.albumId &&
            this.gifId == other.gifId &&
            this.previewUrl == other.previewUrl &&
            this.title == other.title &&
            this.url == other.url);
  }

  @override
  int get hashCode => Object.hashAll([albumId, gifId, previewUrl, title, url]);
}

// ------------ END MUTATION DATA + VARIABLES -------------
