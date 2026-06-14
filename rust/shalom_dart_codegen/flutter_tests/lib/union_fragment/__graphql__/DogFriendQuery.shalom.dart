// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions

import "../../graphql/__graphql__/schema.shalom.dart";

import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';
import 'package:meta/meta.dart' show experimental;

// Fragment imports
import 'DogWithFriendWidget.shalom.dart';

// ------------ OBJECT DEFINITIONS -------------

class DogFriendQueryResponse {
  static String G__typename = "query";

  /// class members
  final DogWithFriendWidgetRef? dog;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  DogFriendQueryResponse({this.dog});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is DogFriendQueryResponse && dog == other.dog);
  }

  @override
  int get hashCode => Object.hashAll([dog, DogFriendQueryResponse.G__typename]);

  shalom_core.JsonObject toJson() {
    return {'dog': this.dog?.toJson()};
  }

  @experimental
  static DogFriendQueryResponse fromJson(shalom_core.JsonObject data) {
    final DogWithFriendWidgetRef? dog$value = data['dog'] == null
        ? null
        : DogWithFriendWidgetRef.fromInput(
            shalom_core.observedRefInputFromJson(
              (data['dog'] as shalom_core.JsonObject)[r'$DogWithFriendWidget']
                  as shalom_core.JsonObject,
            ),
          );
    return DogFriendQueryResponse(dog: dog$value);
  }
}

class DogFriendQuery_dog implements DogWithFriendWidget {
  static String G__typename = "Dog";

  /// class members
  final String id;

  final DogWithFriendWidget_friend? friend;

  final String breed;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  DogFriendQuery_dog({required this.id, this.friend, required this.breed});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is DogFriendQuery_dog &&
            id == other.id &&
            friend == other.friend &&
            breed == other.breed);
  }

  @override
  int get hashCode =>
      Object.hashAll([id, friend, breed, DogFriendQuery_dog.G__typename]);

  shalom_core.JsonObject toJson() {
    return {
      'id': this.id,

      'friend': this.friend?.toJson(),

      'breed': this.breed,
    };
  }

  @experimental
  static DogFriendQuery_dog fromJson(shalom_core.JsonObject data) {
    final String id$value = data['id'] as String;
    final DogWithFriendWidget_friend? friend$value = data['friend'] == null
        ? null
        : DogWithFriendWidget_friend.fromJson(
            data['friend'] as shalom_core.JsonObject,
          );
    final String breed$value = data['breed'] as String;
    return DogFriendQuery_dog(
      id: id$value,

      friend: friend$value,

      breed: breed$value,
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

// ------------ V2 WIDGET API -------------

final class DogFriendQueryData {
  final DogWithFriendWidgetRef? dog;

  const DogFriendQueryData({required this.dog});

  @experimental
  static DogFriendQueryData fromCache(shalom_core.JsonObject data) {
    final DogWithFriendWidgetRef? dog$value = data['dog'] == null
        ? null
        : DogWithFriendWidgetRef.fromInput(
            shalom_core.observedRefInputFromJson(
              (data['dog'] as shalom_core.JsonObject)[r'$DogWithFriendWidget']
                  as shalom_core.JsonObject,
            ),
          );
    return DogFriendQueryData(dog: dog$value);
  }

  shalom_core.JsonObject toJson() {
    return {'dog': this.dog?.toJson()};
  }
}

final class DogFriendQueryVariables {
  final String id;

  const DogFriendQueryVariables({required this.id});

  shalom_core.JsonObject toJson() {
    shalom_core.JsonObject data = {};

    data["id"] = this.id;

    return data;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is DogFriendQueryVariables && this.id == other.id);
  }

  @override
  int get hashCode => Object.hashAll([id]);
}

// ------------ END V2 WIDGET API -------------
