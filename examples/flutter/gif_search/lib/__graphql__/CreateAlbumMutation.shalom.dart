// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions

import "../graphql/__graphql__/schema.shalom.dart";

import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';
import 'package:meta/meta.dart' show experimental;

// Fragment imports

// ------------ OBJECT DEFINITIONS -------------

class CreateAlbumMutation_createAlbum {
  static String G__typename = "Album";

  /// class members
  final String id;

  final String name;

  // keywordargs constructor
  CreateAlbumMutation_createAlbum({required this.id, required this.name});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CreateAlbumMutation_createAlbum &&
            id == other.id &&
            name == other.name);
  }

  @override
  int get hashCode =>
      Object.hashAll([id, name, CreateAlbumMutation_createAlbum.G__typename]);

  shalom_core.JsonObject toJson() {
    return {'id': this.id, 'name': this.name};
  }

  @experimental
  static CreateAlbumMutation_createAlbum fromJson(shalom_core.JsonObject data) {
    final String id$value = data['id'] as String;
    final String name$value = data['name'] as String;
    return CreateAlbumMutation_createAlbum(id: id$value, name: name$value);
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

final class CreateAlbumMutationData {
  final CreateAlbumMutation_createAlbum createAlbum;

  const CreateAlbumMutationData({required this.createAlbum});

  @experimental
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
