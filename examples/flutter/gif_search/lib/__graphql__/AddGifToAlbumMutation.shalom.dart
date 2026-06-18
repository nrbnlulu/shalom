// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions

import "../graphql/__graphql__/schema.shalom.dart";

import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';

// Fragment imports

// ------------ OBJECT DEFINITIONS -------------

class AddGifToAlbumMutation_addGifToAlbum {
  static String G__typename = "Gif";

  /// class members
  final String id;

  final String title;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  AddGifToAlbumMutation_addGifToAlbum({required this.id, required this.title});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AddGifToAlbumMutation_addGifToAlbum &&
            id == other.id &&
            title == other.title);
  }

  @override
  int get hashCode => Object.hashAll([
    id,

    title,

    AddGifToAlbumMutation_addGifToAlbum.G__typename,
  ]);

  shalom_core.JsonObject toJson() {
    return {'id': this.id, 'title': this.title};
  }

  static AddGifToAlbumMutation_addGifToAlbum fromJson(
    shalom_core.JsonObject data,
  ) {
    final String id$value = data['id'] as String;
    final String title$value = data['title'] as String;
    return AddGifToAlbumMutation_addGifToAlbum(
      id: id$value,

      title: title$value,
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

final class AddGifToAlbumMutationData
    implements shalom_core.OperationInterface {
  final AddGifToAlbumMutation_addGifToAlbum addGifToAlbum;

  const AddGifToAlbumMutationData({required this.addGifToAlbum});

  @override
  String operation$Name() => 'AddGifToAlbumMutation';

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

  final shalom_core.Maybe<String?> previewUrl;

  final String title;

  final String url;

  const AddGifToAlbumMutationVariables({
    required this.albumId,

    this.previewUrl = const shalom_core.None(),

    required this.title,

    required this.url,
  });

  shalom_core.JsonObject toJson() {
    shalom_core.JsonObject data = {};

    data["albumId"] = this.albumId;
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
            this.previewUrl == other.previewUrl &&
            this.title == other.title &&
            this.url == other.url);
  }

  @override
  int get hashCode => Object.hashAll([albumId, previewUrl, title, url]);
}

// ------------ END MUTATION DATA + VARIABLES -------------
