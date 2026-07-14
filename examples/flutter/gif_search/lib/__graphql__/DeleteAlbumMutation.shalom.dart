// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions

import "../graphql/__graphql__/schema.shalom.dart";

import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';

// Fragment imports

// ------------ OBJECT DEFINITIONS -------------

class DeleteAlbumMutation_deleteAlbum {
  static String G__typename = "MutationError";

  /// class members
  final String code;

  final String message;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  DeleteAlbumMutation_deleteAlbum({required this.code, required this.message});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is DeleteAlbumMutation_deleteAlbum &&
            code == other.code &&
            message == other.message);
  }

  @override
  int get hashCode => Object.hashAll([
    code,

    message,

    DeleteAlbumMutation_deleteAlbum.G__typename,
  ]);

  shalom_core.JsonObject toJson() {
    return {'code': this.code, 'message': this.message};
  }

  shalom_core.ShalomJsonValue toShalomValue() => shalom_core.shalomJsonObject({
    'code': shalom_core.shalomJsonValue(this.code!),

    'message': shalom_core.shalomJsonValue(this.message!),
  });

  static DeleteAlbumMutation_deleteAlbum fromJson(shalom_core.JsonObject data) {
    final String code$value = data['code'] as String;
    final String message$value = data['message'] as String;
    return DeleteAlbumMutation_deleteAlbum(
      code: code$value,

      message: message$value,
    );
  }

  static DeleteAlbumMutation_deleteAlbum fromShalomValue(
    shalom_core.ShalomJsonValue data,
  ) {
    final shalom_core.ShalomJsonValue? code$raw = data.field('code');
    final String code$value = code$raw!.stringValue;
    final shalom_core.ShalomJsonValue? message$raw = data.field('message');
    final String message$value = message$raw!.stringValue;
    return DeleteAlbumMutation_deleteAlbum(
      code: code$value,
      message: message$value,
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

final class DeleteAlbumMutationData implements shalom_core.OperationInterface {
  final DeleteAlbumMutation_deleteAlbum? deleteAlbum;

  const DeleteAlbumMutationData({required this.deleteAlbum});

  @override
  String operation$Name() => 'DeleteAlbumMutation';

  static DeleteAlbumMutationData fromCache(shalom_core.JsonObject data) {
    final DeleteAlbumMutation_deleteAlbum? deleteAlbum$value =
        data['deleteAlbum'] == null
        ? null
        : DeleteAlbumMutation_deleteAlbum.fromJson(
            data['deleteAlbum'] as shalom_core.JsonObject,
          );
    return DeleteAlbumMutationData(deleteAlbum: deleteAlbum$value);
  }

  static DeleteAlbumMutationData fromShalomValue(
    shalom_core.ShalomJsonValue data,
  ) {
    final shalom_core.ShalomJsonValue? deleteAlbum$raw = data.field(
      'deleteAlbum',
    );
    final DeleteAlbumMutation_deleteAlbum? deleteAlbum$value =
        deleteAlbum$raw == null || deleteAlbum$raw!.isNull
        ? null
        : DeleteAlbumMutation_deleteAlbum.fromShalomValue(deleteAlbum$raw!);
    return DeleteAlbumMutationData(deleteAlbum: deleteAlbum$value);
  }

  shalom_core.JsonObject toJson() {
    return {'deleteAlbum': this.deleteAlbum?.toJson()};
  }

  @override
  shalom_core.ShalomJsonValue toShalomValue() => shalom_core.shalomJsonObject({
    'deleteAlbum': this.deleteAlbum == null
        ? shalom_core.shalomJsonValue(null)
        : this.deleteAlbum!.toShalomValue(),
  });
}

final class DeleteAlbumMutationVariables {
  final String id;

  const DeleteAlbumMutationVariables({required this.id});

  shalom_core.JsonObject toJson() {
    shalom_core.JsonObject data = {};

    data["id"] = this.id;

    return data;
  }

  shalom_core.ShalomJsonValue toShalomValue() {
    final $data = <String, shalom_core.ShalomJsonValue>{};
    $data["id"] = shalom_core.shalomJsonValue(this.id!);
    return shalom_core.shalomJsonObject($data);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is DeleteAlbumMutationVariables && this.id == other.id);
  }

  @override
  int get hashCode => Object.hashAll([id]);
}

// ------------ END MUTATION DATA + VARIABLES -------------
