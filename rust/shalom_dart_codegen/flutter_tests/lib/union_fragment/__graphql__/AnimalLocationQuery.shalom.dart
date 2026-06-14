// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions

import "../../graphql/__graphql__/schema.shalom.dart";

import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';
import 'package:meta/meta.dart' show experimental;

// Fragment imports
import 'AnimalWithLocation.shalom.dart';

// ------------ OBJECT DEFINITIONS -------------

class AnimalLocationQueryResponse {
  static String G__typename = "query";

  /// class members
  final AnimalWithLocationRef? animal;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  AnimalLocationQueryResponse({this.animal});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AnimalLocationQueryResponse && animal == other.animal);
  }

  @override
  int get hashCode =>
      Object.hashAll([animal, AnimalLocationQueryResponse.G__typename]);

  shalom_core.JsonObject toJson() {
    return {'animal': this.animal?.toJson()};
  }

  @experimental
  static AnimalLocationQueryResponse fromJson(shalom_core.JsonObject data) {
    final AnimalWithLocationRef? animal$value = data['animal'] == null
        ? null
        : AnimalWithLocationRef.fromInput(
            shalom_core.observedRefInputFromJson(
              (data['animal'] as shalom_core.JsonObject)[r'$AnimalWithLocation']
                  as shalom_core.JsonObject,
            ),
          );
    return AnimalLocationQueryResponse(animal: animal$value);
  }
}

// ------------ END OBJECT DEFINITIONS -------------

// ------------ UNION DEFINITIONS -------------

// ------------ END UNION DEFINITIONS -------------

// ------------ INTERFACE DEFINITIONS -------------

sealed class AnimalLocationQuery_animal implements AnimalWithLocation {
  String get id;

  String get $__typename;
  const AnimalLocationQuery_animal();

  shalom_core.JsonObject toJson();

  @experimental
  static AnimalLocationQuery_animal fromJson(shalom_core.JsonObject data) {
    final typename = data['__typename'] as String;
    switch (typename) {
      case 'Dog':
        return AnimalLocationQuery_animal__Dog.fromJson(data);
      case 'Cat':
        return AnimalLocationQuery_animal__Cat.fromJson(data);

      default:
        throw Exception("Unknown typename $typename");
    }
  }
}

class AnimalLocationQuery_animal__Dog extends AnimalLocationQuery_animal {
  static String G__typename = "Dog";

  /// class members
  final AnimalWithLocation__Dog_location? location;

  final String breed;

  final String id;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  const AnimalLocationQuery_animal__Dog({
    this.location,

    required this.breed,

    required this.id,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AnimalLocationQuery_animal__Dog &&
            location == other.location &&
            breed == other.breed &&
            id == other.id);
  }

  @override
  int get hashCode => Object.hashAll([
    location,

    breed,

    id,

    AnimalLocationQuery_animal__Dog.G__typename,
  ]);

  shalom_core.JsonObject toJson() {
    return {
      'location': this.location?.toJson(),

      'breed': this.breed,

      "__typename": AnimalLocationQuery_animal__Dog.G__typename,

      'id': this.id,
    };
  }

  @experimental
  static AnimalLocationQuery_animal__Dog fromJson(shalom_core.JsonObject data) {
    final AnimalWithLocation__Dog_location? location$value =
        data['location'] == null
        ? null
        : AnimalWithLocation__Dog_location.fromJson(
            data['location'] as shalom_core.JsonObject,
          );
    final String breed$value = data['breed'] as String;
    final String id$value = data['id'] as String;
    return AnimalLocationQuery_animal__Dog(
      location: location$value,

      breed: breed$value,

      id: id$value,
    );
  }
}

class AnimalLocationQuery_animal__Cat extends AnimalLocationQuery_animal {
  static String G__typename = "Cat";

  /// class members
  final String color;

  final String id;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  const AnimalLocationQuery_animal__Cat({
    required this.color,

    required this.id,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AnimalLocationQuery_animal__Cat &&
            color == other.color &&
            id == other.id);
  }

  @override
  int get hashCode =>
      Object.hashAll([color, id, AnimalLocationQuery_animal__Cat.G__typename]);

  shalom_core.JsonObject toJson() {
    return {
      'color': this.color,

      "__typename": AnimalLocationQuery_animal__Cat.G__typename,

      'id': this.id,
    };
  }

  @experimental
  static AnimalLocationQuery_animal__Cat fromJson(shalom_core.JsonObject data) {
    final String color$value = data['color'] as String;
    final String id$value = data['id'] as String;
    return AnimalLocationQuery_animal__Cat(color: color$value, id: id$value);
  }
}

// ------------ END INTERFACE DEFINITIONS -------------

// ------------ MULTI-TYPE LIST EXTENSIONS -------------

// ------------ END MULTI-TYPE LIST EXTENSIONS -------------

// ------------ V2 WIDGET API -------------

final class AnimalLocationQueryData {
  final AnimalWithLocationRef? animal;

  const AnimalLocationQueryData({required this.animal});

  @experimental
  static AnimalLocationQueryData fromCache(shalom_core.JsonObject data) {
    final AnimalWithLocationRef? animal$value = data['animal'] == null
        ? null
        : AnimalWithLocationRef.fromInput(
            shalom_core.observedRefInputFromJson(
              (data['animal'] as shalom_core.JsonObject)[r'$AnimalWithLocation']
                  as shalom_core.JsonObject,
            ),
          );
    return AnimalLocationQueryData(animal: animal$value);
  }

  shalom_core.JsonObject toJson() {
    return {'animal': this.animal?.toJson()};
  }
}

final class AnimalLocationQueryVariables {
  final String id;

  const AnimalLocationQueryVariables({required this.id});

  shalom_core.JsonObject toJson() {
    shalom_core.JsonObject data = {};

    data["id"] = this.id;

    return data;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AnimalLocationQueryVariables && this.id == other.id);
  }

  @override
  int get hashCode => Object.hashAll([id]);
}

// ------------ END V2 WIDGET API -------------
