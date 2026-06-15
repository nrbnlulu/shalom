// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions

import "../../graphql/__graphql__/schema.shalom.dart";

import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';

// Fragment imports
import 'DogFrag.shalom.dart';

// ------------ OBJECT DEFINITIONS -------------

class StreetSubscriptionResponse {
  static String G__typename = "subscription";

  /// class members
  final StreetSubscription_streetAnimals streetAnimals;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  StreetSubscriptionResponse({required this.streetAnimals});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is StreetSubscriptionResponse &&
            streetAnimals == other.streetAnimals);
  }

  @override
  int get hashCode =>
      Object.hashAll([streetAnimals, StreetSubscriptionResponse.G__typename]);

  shalom_core.JsonObject toJson() {
    return {'streetAnimals': this.streetAnimals.toJson()};
  }

  static StreetSubscriptionResponse fromJson(shalom_core.JsonObject data) {
    final StreetSubscription_streetAnimals streetAnimals$value =
        StreetSubscription_streetAnimals.fromJson(
          data['streetAnimals'] as shalom_core.JsonObject,
        );
    return StreetSubscriptionResponse(streetAnimals: streetAnimals$value);
  }
}

// ------------ END OBJECT DEFINITIONS -------------

// ------------ UNION DEFINITIONS -------------

// ------------ END UNION DEFINITIONS -------------

// ------------ INTERFACE DEFINITIONS -------------

sealed class StreetSubscription_streetAnimals {
  String get id;

  String get $__typename;
  const StreetSubscription_streetAnimals();

  shalom_core.JsonObject toJson();

  static StreetSubscription_streetAnimals fromJson(
    shalom_core.JsonObject data,
  ) {
    final typename = data['__typename'] as String;
    switch (typename) {
      case 'Dog':
        return StreetSubscription_streetAnimals__Dog.fromJson(data);
      case 'Cat':
        return StreetSubscription_streetAnimals__Cat.fromJson(data);

      default:
        throw Exception("Unknown typename $typename");
    }
  }
}

class StreetSubscription_streetAnimals__Dog
    extends StreetSubscription_streetAnimals
    implements DogFrag {
  static String G__typename = "Dog";

  /// class members
  final String id;

  final String breed;

  final String name;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  const StreetSubscription_streetAnimals__Dog({
    required this.id,

    required this.breed,

    required this.name,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is StreetSubscription_streetAnimals__Dog &&
            id == other.id &&
            breed == other.breed &&
            name == other.name);
  }

  @override
  int get hashCode => Object.hashAll([
    id,

    breed,

    name,

    StreetSubscription_streetAnimals__Dog.G__typename,
  ]);

  shalom_core.JsonObject toJson() {
    return {
      'id': this.id,

      'breed': this.breed,

      "__typename": StreetSubscription_streetAnimals__Dog.G__typename,

      'name': this.name,
    };
  }

  static StreetSubscription_streetAnimals__Dog fromJson(
    shalom_core.JsonObject data,
  ) {
    final String id$value = data['id'] as String;
    final String breed$value = data['breed'] as String;
    final String name$value = data['name'] as String;
    return StreetSubscription_streetAnimals__Dog(
      id: id$value,

      breed: breed$value,

      name: name$value,
    );
  }
}

class StreetSubscription_streetAnimals__Cat
    extends StreetSubscription_streetAnimals {
  static String G__typename = "Cat";

  /// class members
  final String id;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  const StreetSubscription_streetAnimals__Cat({required this.id});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is StreetSubscription_streetAnimals__Cat && id == other.id);
  }

  @override
  int get hashCode =>
      Object.hashAll([id, StreetSubscription_streetAnimals__Cat.G__typename]);

  shalom_core.JsonObject toJson() {
    return {
      'id': this.id,

      "__typename": StreetSubscription_streetAnimals__Cat.G__typename,
    };
  }

  static StreetSubscription_streetAnimals__Cat fromJson(
    shalom_core.JsonObject data,
  ) {
    final String id$value = data['id'] as String;
    return StreetSubscription_streetAnimals__Cat(id: id$value);
  }
}

// ------------ END INTERFACE DEFINITIONS -------------

// ------------ MULTI-TYPE LIST EXTENSIONS -------------

// ------------ END MULTI-TYPE LIST EXTENSIONS -------------

// ------------ V2 WIDGET API -------------

final class StreetSubscriptionData {
  final StreetSubscription_streetAnimals streetAnimals;

  const StreetSubscriptionData({required this.streetAnimals});

  static StreetSubscriptionData fromCache(shalom_core.JsonObject data) {
    final StreetSubscription_streetAnimals streetAnimals$value =
        StreetSubscription_streetAnimals.fromJson(
          data['streetAnimals'] as shalom_core.JsonObject,
        );
    return StreetSubscriptionData(streetAnimals: streetAnimals$value);
  }

  shalom_core.JsonObject toJson() {
    return {'streetAnimals': this.streetAnimals.toJson()};
  }
}

// ------------ END V2 WIDGET API -------------
