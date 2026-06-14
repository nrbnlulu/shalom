// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions

import "../../graphql/__graphql__/schema.shalom.dart";

import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';
import 'package:meta/meta.dart' show experimental;

// Fragment imports
import 'DogFrag.shalom.dart';

// ------------ OBJECT DEFINITIONS -------------

class ShelterSubscriptionResponse {
  static String G__typename = "subscription";

  /// class members
  final ShelterSubscription_shelterAnimals shelterAnimals;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  ShelterSubscriptionResponse({required this.shelterAnimals});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ShelterSubscriptionResponse &&
            shelterAnimals == other.shelterAnimals);
  }

  @override
  int get hashCode =>
      Object.hashAll([shelterAnimals, ShelterSubscriptionResponse.G__typename]);

  shalom_core.JsonObject toJson() {
    return {'shelterAnimals': this.shelterAnimals.toJson()};
  }

  @experimental
  static ShelterSubscriptionResponse fromJson(shalom_core.JsonObject data) {
    final ShelterSubscription_shelterAnimals shelterAnimals$value =
        ShelterSubscription_shelterAnimals.fromJson(
          data['shelterAnimals'] as shalom_core.JsonObject,
        );
    return ShelterSubscriptionResponse(shelterAnimals: shelterAnimals$value);
  }
}

// ------------ END OBJECT DEFINITIONS -------------

// ------------ UNION DEFINITIONS -------------

// ------------ END UNION DEFINITIONS -------------

// ------------ INTERFACE DEFINITIONS -------------

sealed class ShelterSubscription_shelterAnimals {
  String get id;

  String get $__typename;
  const ShelterSubscription_shelterAnimals();

  shalom_core.JsonObject toJson();

  @experimental
  static ShelterSubscription_shelterAnimals fromJson(
    shalom_core.JsonObject data,
  ) {
    final typename = data['__typename'] as String;
    switch (typename) {
      case 'Dog':
        return ShelterSubscription_shelterAnimals__Dog.fromJson(data);
      case 'Cat':
        return ShelterSubscription_shelterAnimals__Cat.fromJson(data);

      default:
        throw Exception("Unknown typename $typename");
    }
  }
}

class ShelterSubscription_shelterAnimals__Dog
    extends ShelterSubscription_shelterAnimals
    implements DogFrag {
  static String G__typename = "Dog";

  /// class members
  final String name;

  final String breed;

  final String id;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  const ShelterSubscription_shelterAnimals__Dog({
    required this.name,

    required this.breed,

    required this.id,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ShelterSubscription_shelterAnimals__Dog &&
            name == other.name &&
            breed == other.breed &&
            id == other.id);
  }

  @override
  int get hashCode => Object.hashAll([
    name,

    breed,

    id,

    ShelterSubscription_shelterAnimals__Dog.G__typename,
  ]);

  shalom_core.JsonObject toJson() {
    return {
      'name': this.name,

      'breed': this.breed,

      'id': this.id,

      "__typename": ShelterSubscription_shelterAnimals__Dog.G__typename,
    };
  }

  @experimental
  static ShelterSubscription_shelterAnimals__Dog fromJson(
    shalom_core.JsonObject data,
  ) {
    final String name$value = data['name'] as String;
    final String breed$value = data['breed'] as String;
    final String id$value = data['id'] as String;
    return ShelterSubscription_shelterAnimals__Dog(
      name: name$value,

      breed: breed$value,

      id: id$value,
    );
  }
}

class ShelterSubscription_shelterAnimals__Cat
    extends ShelterSubscription_shelterAnimals {
  static String G__typename = "Cat";

  /// class members
  final String id;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  const ShelterSubscription_shelterAnimals__Cat({required this.id});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ShelterSubscription_shelterAnimals__Cat && id == other.id);
  }

  @override
  int get hashCode =>
      Object.hashAll([id, ShelterSubscription_shelterAnimals__Cat.G__typename]);

  shalom_core.JsonObject toJson() {
    return {
      'id': this.id,

      "__typename": ShelterSubscription_shelterAnimals__Cat.G__typename,
    };
  }

  @experimental
  static ShelterSubscription_shelterAnimals__Cat fromJson(
    shalom_core.JsonObject data,
  ) {
    final String id$value = data['id'] as String;
    return ShelterSubscription_shelterAnimals__Cat(id: id$value);
  }
}

// ------------ END INTERFACE DEFINITIONS -------------

// ------------ MULTI-TYPE LIST EXTENSIONS -------------

// ------------ END MULTI-TYPE LIST EXTENSIONS -------------

// ------------ V2 WIDGET API -------------

final class ShelterSubscriptionData {
  final ShelterSubscription_shelterAnimals shelterAnimals;

  const ShelterSubscriptionData({required this.shelterAnimals});

  @experimental
  static ShelterSubscriptionData fromCache(shalom_core.JsonObject data) {
    final ShelterSubscription_shelterAnimals shelterAnimals$value =
        ShelterSubscription_shelterAnimals.fromJson(
          data['shelterAnimals'] as shalom_core.JsonObject,
        );
    return ShelterSubscriptionData(shelterAnimals: shelterAnimals$value);
  }

  shalom_core.JsonObject toJson() {
    return {'shelterAnimals': this.shelterAnimals.toJson()};
  }
}

// ------------ END V2 WIDGET API -------------
