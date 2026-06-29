// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions

import "../graphql/__graphql__/schema.shalom.dart";

import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';

// Fragment imports

// ------------ OBJECT DEFINITIONS -------------

class RemoveGifFromAlbumMutation_removeGifFromAlbum {
  static String G__typename = "MutationError";

  /// class members
  final String code;

  final String message;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  RemoveGifFromAlbumMutation_removeGifFromAlbum({
    required this.code,

    required this.message,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is RemoveGifFromAlbumMutation_removeGifFromAlbum &&
            code == other.code &&
            message == other.message);
  }

  @override
  int get hashCode => Object.hashAll([
    code,

    message,

    RemoveGifFromAlbumMutation_removeGifFromAlbum.G__typename,
  ]);

  shalom_core.JsonObject toJson() {
    return {'code': this.code, 'message': this.message};
  }

  static RemoveGifFromAlbumMutation_removeGifFromAlbum fromJson(
    shalom_core.JsonObject data,
  ) {
    final String code$value = data['code'] as String;
    final String message$value = data['message'] as String;
    return RemoveGifFromAlbumMutation_removeGifFromAlbum(
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

final class RemoveGifFromAlbumMutationData
    implements shalom_core.OperationInterface {
  final RemoveGifFromAlbumMutation_removeGifFromAlbum? removeGifFromAlbum;

  const RemoveGifFromAlbumMutationData({required this.removeGifFromAlbum});

  @override
  String operation$Name() => 'RemoveGifFromAlbumMutation';

  static RemoveGifFromAlbumMutationData fromCache(shalom_core.JsonObject data) {
    final RemoveGifFromAlbumMutation_removeGifFromAlbum?
    removeGifFromAlbum$value = data['removeGifFromAlbum'] == null
        ? null
        : RemoveGifFromAlbumMutation_removeGifFromAlbum.fromJson(
            data['removeGifFromAlbum'] as shalom_core.JsonObject,
          );
    return RemoveGifFromAlbumMutationData(
      removeGifFromAlbum: removeGifFromAlbum$value,
    );
  }

  shalom_core.JsonObject toJson() {
    return {'removeGifFromAlbum': this.removeGifFromAlbum?.toJson()};
  }
}

final class RemoveGifFromAlbumMutationVariables {
  final String albumId;

  final String gifId;

  const RemoveGifFromAlbumMutationVariables({
    required this.albumId,

    required this.gifId,
  });

  shalom_core.JsonObject toJson() {
    shalom_core.JsonObject data = {};

    data["albumId"] = this.albumId;
    data["gifId"] = this.gifId;

    return data;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is RemoveGifFromAlbumMutationVariables &&
            this.albumId == other.albumId &&
            this.gifId == other.gifId);
  }

  @override
  int get hashCode => Object.hashAll([albumId, gifId]);
}

// ------------ END MUTATION DATA + VARIABLES -------------
