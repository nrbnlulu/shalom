// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions

import "../../graphql/__graphql__/schema.shalom.dart";

import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';
import 'package:meta/meta.dart' show experimental;

// Fragment imports
import 'PetWidget.shalom.dart';

// ------------ OBJECT DEFINITIONS -------------

class PetQueryResponse {
  static String G__typename = "query";

  /// class members
  final PetWidgetRef? pet;

  // keywordargs constructor
  PetQueryResponse({this.pet});

  static PetQueryResponse fromResponse(
    shalom_core.JsonObject data, {
    PetQueryVariables? variables,
  }) {
    return fromJson(data);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is PetQueryResponse && pet == other.pet);
  }

  @override
  int get hashCode => Object.hashAll([pet, PetQueryResponse.G__typename]);

  shalom_core.JsonObject toJson() {
    return {'pet': this.pet?.toJson()};
  }

  @experimental
  static PetQueryResponse fromJson(shalom_core.JsonObject data) {
    final PetWidgetRef? pet$value = data['pet'] == null
        ? null
        : PetWidgetRef.fromInput(
            shalom_core.observedRefInputFromJson(
              (data['pet'] as shalom_core.JsonObject)[r'$PetWidget']
                  as shalom_core.JsonObject,
            ),
          );
    return PetQueryResponse(pet: pet$value);
  }
}

class PetQuery_pet {
  static String G__typename = "Pet";

  /// class members
  final String name;

  final String id;

  // keywordargs constructor
  PetQuery_pet({required this.name, required this.id});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is PetQuery_pet && name == other.name && id == other.id);
  }

  @override
  int get hashCode => Object.hashAll([name, id, PetQuery_pet.G__typename]);

  shalom_core.JsonObject toJson() {
    return {'name': this.name, 'id': this.id};
  }

  @experimental
  static PetQuery_pet fromJson(shalom_core.JsonObject data) {
    final String name$value = data['name'] as String;
    final String id$value = data['id'] as String;
    return PetQuery_pet(name: name$value, id: id$value);
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

final class PetQueryData {
  final PetWidgetRef? pet;

  const PetQueryData({required this.pet});

  @experimental
  static PetQueryData fromCache(shalom_core.JsonObject data) {
    final PetWidgetRef? pet$value = data['pet'] == null
        ? null
        : PetWidgetRef.fromInput(
            shalom_core.observedRefInputFromJson(
              (data['pet'] as shalom_core.JsonObject)[r'$PetWidget']
                  as shalom_core.JsonObject,
            ),
          );
    return PetQueryData(pet: pet$value);
  }

  shalom_core.JsonObject toJson() {
    return {'pet': this.pet?.toJson()};
  }
}

final class PetQueryVariables {
  final String id;

  const PetQueryVariables({required this.id});

  shalom_core.JsonObject toJson() {
    shalom_core.JsonObject data = {};

    data["id"] = this.id;

    return data;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is PetQueryVariables && this.id == other.id);
  }

  @override
  int get hashCode => Object.hashAll([id]);
}

// ------------ END V2 WIDGET API -------------
