// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions

import "../../graphql/__graphql__/schema.shalom.dart";

import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';

// Fragment imports
import 'PetWidget.shalom.dart';

// ------------ OBJECT DEFINITIONS -------------

class PetQueryResponse {
  static String G__typename = "query";

  /// class members
  final PetWidgetRef? pet;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  PetQueryResponse({this.pet});

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

class PetQuery_pet implements PetWidget {
  static String G__typename = "Pet";

  /// class members
  final String id;

  final String name;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  PetQuery_pet({required this.id, required this.name});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is PetQuery_pet && id == other.id && name == other.name);
  }

  @override
  int get hashCode => Object.hashAll([id, name, PetQuery_pet.G__typename]);

  shalom_core.JsonObject toJson() {
    return {'id': this.id, 'name': this.name};
  }

  static PetQuery_pet fromJson(shalom_core.JsonObject data) {
    final String id$value = data['id'] as String;
    final String name$value = data['name'] as String;
    return PetQuery_pet(id: id$value, name: name$value);
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
