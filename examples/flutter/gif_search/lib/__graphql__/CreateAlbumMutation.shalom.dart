// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions

import "../graphql/__graphql__/schema.shalom.dart";

import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';

// Fragment imports
import 'AlbumGif.shalom.dart';

// ------------ OBJECT DEFINITIONS -------------

class CreateAlbumMutation_createAlbum {
  static String G__typename = "Album";

  /// class members
  final List<AlbumGifRef> gifs;

  final String id;

  final String name;

  final String tag;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  CreateAlbumMutation_createAlbum({
    required this.gifs,

    required this.id,

    required this.name,

    required this.tag,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CreateAlbumMutation_createAlbum &&
            const ListEquality().equals(gifs, other.gifs) &&
            id == other.id &&
            name == other.name &&
            tag == other.tag);
  }

  @override
  int get hashCode => Object.hashAll([
    gifs,

    id,

    name,

    tag,

    CreateAlbumMutation_createAlbum.G__typename,
  ]);

  shalom_core.JsonObject toJson() {
    return {
      'gifs': this.gifs.map((e) => e.toJson()).toList(),

      'id': this.id,

      'name': this.name,

      'tag': this.tag,
    };
  }

  static CreateAlbumMutation_createAlbum fromJson(shalom_core.JsonObject data) {
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
    return CreateAlbumMutation_createAlbum(
      gifs: gifs$value,

      id: id$value,

      name: name$value,

      tag: tag$value,
    );
  }
}

class CreateAlbumMutation_createAlbum_gifs implements AlbumGif {
  static String G__typename = "Gif";

  /// class members
  final String id;

  final String title;

  final String url;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  CreateAlbumMutation_createAlbum_gifs({
    required this.id,

    required this.title,

    required this.url,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CreateAlbumMutation_createAlbum_gifs &&
            id == other.id &&
            title == other.title &&
            url == other.url);
  }

  @override
  int get hashCode => Object.hashAll([
    id,

    title,

    url,

    CreateAlbumMutation_createAlbum_gifs.G__typename,
  ]);

  shalom_core.JsonObject toJson() {
    return {'id': this.id, 'title': this.title, 'url': this.url};
  }

  static CreateAlbumMutation_createAlbum_gifs fromJson(
    shalom_core.JsonObject data,
  ) {
    final String id$value = data['id'] as String;
    final String title$value = data['title'] as String;
    final String url$value = data['url'] as String;
    return CreateAlbumMutation_createAlbum_gifs(
      id: id$value,

      title: title$value,

      url: url$value,
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

final class CreateAlbumMutationData implements shalom_core.OperationInterface {
  final CreateAlbumMutation_createAlbum createAlbum;

  const CreateAlbumMutationData({required this.createAlbum});

  @override
  String operation$Name() => 'CreateAlbumMutation';

  static CreateAlbumMutationData fromCache(shalom_core.JsonObject data) {
    final CreateAlbumMutation_createAlbum createAlbum$value =
        CreateAlbumMutation_createAlbum.fromJson(
          data['createAlbum'] as shalom_core.JsonObject,
        );
    return CreateAlbumMutationData(createAlbum: createAlbum$value);
  }

  shalom_core.JsonObject toJson() {
    return {'createAlbum': this.createAlbum.toJson()};
  }
}

final class CreateAlbumMutationVariables {
  final String name;

  const CreateAlbumMutationVariables({required this.name});

  shalom_core.JsonObject toJson() {
    shalom_core.JsonObject data = {};

    data["name"] = this.name;

    return data;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CreateAlbumMutationVariables && this.name == other.name);
  }

  @override
  int get hashCode => Object.hashAll([name]);
}

// ------------ END MUTATION DATA + VARIABLES -------------
