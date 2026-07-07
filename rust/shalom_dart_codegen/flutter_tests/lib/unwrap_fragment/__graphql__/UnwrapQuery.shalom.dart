// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions

import "../../graphql/__graphql__/schema.shalom.dart";

import 'dart:async' show Stream;

import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';

// Fragment imports
import '../../fragment/__graphql__/PetWidget.shalom.dart';

// ------------ OBJECT DEFINITIONS -------------

class UnwrapQueryResponse {
  static String G__typename = "query";

  /// class members
  final PetWidgetRef? pet;

  final UnwrapQuery_petUnwrapped? petUnwrapped;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  UnwrapQueryResponse({this.pet, this.petUnwrapped});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UnwrapQueryResponse &&
            pet == other.pet &&
            petUnwrapped == other.petUnwrapped);
  }

  @override
  int get hashCode =>
      Object.hashAll([pet, petUnwrapped, UnwrapQueryResponse.G__typename]);

  shalom_core.JsonObject toJson() {
    return {
      'pet': this.pet?.toJson(),

      'petUnwrapped': this.petUnwrapped?.toJson(),
    };
  }

  static UnwrapQueryResponse fromJson(shalom_core.JsonObject data) {
    final PetWidgetRef? pet$value = data['pet'] == null
        ? null
        : PetWidgetRef.fromInput(
            shalom_core.observedRefInputFromJson(
              (data['pet'] as shalom_core.JsonObject)[r'$PetWidget']
                  as shalom_core.JsonObject,
            ),
          );
    final UnwrapQuery_petUnwrapped? petUnwrapped$value =
        data['petUnwrapped'] == null
        ? null
        : UnwrapQuery_petUnwrapped.fromJson(
            data['petUnwrapped'] as shalom_core.JsonObject,
          );
    return UnwrapQueryResponse(
      pet: pet$value,

      petUnwrapped: petUnwrapped$value,
    );
  }
}

class UnwrapQuery_pet {
  static String G__typename = "Pet";

  /// class members
  final String id;

  final String name;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  UnwrapQuery_pet({required this.id, required this.name});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UnwrapQuery_pet && id == other.id && name == other.name);
  }

  @override
  int get hashCode => Object.hashAll([id, name, UnwrapQuery_pet.G__typename]);

  shalom_core.JsonObject toJson() {
    return {'id': this.id, 'name': this.name};
  }

  static UnwrapQuery_pet fromJson(shalom_core.JsonObject data) {
    final String id$value = data['id'] as String;
    final String name$value = data['name'] as String;
    return UnwrapQuery_pet(id: id$value, name: name$value);
  }
}

class UnwrapQuery_petUnwrapped implements PetWidget {
  static String G__typename = "Pet";

  /// class members
  final String id;

  final String name;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  UnwrapQuery_petUnwrapped({required this.id, required this.name});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UnwrapQuery_petUnwrapped &&
            id == other.id &&
            name == other.name);
  }

  @override
  int get hashCode =>
      Object.hashAll([id, name, UnwrapQuery_petUnwrapped.G__typename]);

  shalom_core.JsonObject toJson() {
    return {'id': this.id, 'name': this.name};
  }

  static UnwrapQuery_petUnwrapped fromJson(shalom_core.JsonObject data) {
    final String id$value = data['id'] as String;
    final String name$value = data['name'] as String;
    return UnwrapQuery_petUnwrapped(id: id$value, name: name$value);
  }
}

// ------------ END OBJECT DEFINITIONS -------------

// ------------ UNION DEFINITIONS -------------

// ------------ END UNION DEFINITIONS -------------

// ------------ INTERFACE DEFINITIONS -------------

// ------------ END INTERFACE DEFINITIONS -------------

// ------------ MULTI-TYPE LIST EXTENSIONS -------------

// ------------ END MULTI-TYPE LIST EXTENSIONS -------------

// ------------ widget API -------------

final class UnwrapQueryData implements shalom_core.OperationInterface {
  final PetWidgetRef? pet;
  final UnwrapQuery_petUnwrapped? petUnwrapped;

  const UnwrapQueryData({required this.pet, required this.petUnwrapped});

  @override
  String operation$Name() => 'UnwrapQuery';

  static UnwrapQueryData fromCache(shalom_core.JsonObject data) {
    final PetWidgetRef? pet$value = data['pet'] == null
        ? null
        : PetWidgetRef.fromInput(
            shalom_core.observedRefInputFromJson(
              (data['pet'] as shalom_core.JsonObject)[r'$PetWidget']
                  as shalom_core.JsonObject,
            ),
          );
    final UnwrapQuery_petUnwrapped? petUnwrapped$value =
        data['petUnwrapped'] == null
        ? null
        : UnwrapQuery_petUnwrapped.fromJson(
            data['petUnwrapped'] as shalom_core.JsonObject,
          );
    return UnwrapQueryData(pet: pet$value, petUnwrapped: petUnwrapped$value);
  }

  /// Reads this operation's current cache entry through [cache], decoding
  /// it as [UnwrapQueryData]. Returns `null` when absent or incomplete.
  static Future<UnwrapQueryData?> readFrom(
    shalom_core.CacheProxy cache, {
    UnwrapQueryVariables? variables,
  }) async {
    return await cache.readQuery<UnwrapQueryData>(
      name: 'UnwrapQuery',
      decoder: fromCache,

      variables: variables?.toJson(),
    );
  }

  shalom_core.JsonObject toJson() {
    return {
      'pet': this.pet?.toJson(),

      'petUnwrapped': this.petUnwrapped?.toJson(),
    };
  }
}

final class UnwrapQueryObservable {
  final shalom_core.ExecutionPolicyInput executionPolicy;

  final UnwrapQueryVariables variables;

  const UnwrapQueryObservable({
    required this.variables,

    this.executionPolicy = shalom_core.ExecutionPolicyInput.cacheFirst,
  });

  String operation$Name() => 'UnwrapQuery';

  Stream<shalom_core.GraphQLResponse<UnwrapQueryData>> observe(
    shalom_core.ShalomRuntimeClient client,
  ) {
    return client.request<UnwrapQueryData>(
      name: operation$Name(),

      variables: variables.toJson(),

      decoder: UnwrapQueryData.fromCache,
      executionPolicy: executionPolicy,
    );
  }
}

final class UnwrapQueryVariables {
  final String id;

  const UnwrapQueryVariables({required this.id});

  shalom_core.JsonObject toJson() {
    shalom_core.JsonObject data = {};

    data["id"] = this.id;

    return data;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UnwrapQueryVariables && this.id == other.id);
  }

  @override
  int get hashCode => Object.hashAll([id]);
}

// ------------ END widget API -------------
