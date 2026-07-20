// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions

import "../../graphql/__graphql__/schema.shalom.dart";

import 'dart:async' show Stream;

import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';

// Fragment imports
import 'PetWidget.shalom.dart';

// ------------ OBJECT DEFINITIONS -------------
class PetQueryData implements shalom_core.OperationInterface {
  static String G__typename = "query";

  /// class members
  final PetWidgetRef? pet;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  PetQueryData({this.pet});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is PetQueryData && pet == other.pet);
  }

  @override
  int get hashCode => Object.hashAll([pet, PetQueryData.G__typename]);

  shalom_core.JsonObject toJson() {
    return {'pet': this.pet?.toJson()};
  }

  shalom_core.ShalomJsonValue toShalomValue() => shalom_core.shalomJsonObject({
    'pet': this.pet == null
        ? shalom_core.shalomJsonValue(null)
        : this.pet!.toShalomValue(),
  });

  static PetQueryData fromJson(shalom_core.JsonObject data) {
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

  static PetQueryData fromShalomValue(shalom_core.ShalomJsonValue data) {
    final shalom_core.ShalomJsonValue? pet$raw = data.field('pet');
    final PetWidgetRef? pet$value = pet$raw == null || pet$raw!.isNull
        ? null
        : PetWidgetRef.fromInput(
            shalom_core.observedRefInputFromShalomValue(
              pet$raw!.field(r'$PetWidget')!,
            ),
          );
    return PetQueryData(pet: pet$value);
  }

  @override
  String operation$Name() => 'PetQuery';

  /// Reads this operation's current cache entry through [cache], decoding
  /// it as [PetQueryData]. Returns `null` when absent or incomplete.
  static Future<PetQueryData?> readFrom(
    shalom_core.CacheProxy cache, {
    PetQueryVariables? variables,
  }) async {
    return await cache.readOperation<PetQueryData>(
      name: 'PetQuery',
      decoder: fromShalomValue,

      variables: variables?.toShalomValue(),
    );
  }

  /// Evicts this operation's cached entry (matched by [variables]) through
  /// [cache], notifying any active subscribers. Returns `false` if no
  /// matching cache entry existed.
  static Future<bool> evictFrom(
    shalom_core.CacheProxy cache, {
    PetQueryVariables? variables,
  }) {
    return cache.evictOperation(
      name: 'PetQuery',

      variables: variables?.toShalomValue(),
    );
  }
}

class PetQuery_pet {
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

  shalom_core.ShalomJsonValue toShalomValue() => shalom_core.shalomJsonObject({
    'id': shalom_core.shalomJsonValue(this.id!),

    'name': shalom_core.shalomJsonValue(this.name!),
  });

  static PetQuery_pet fromJson(shalom_core.JsonObject data) {
    final String id$value = data['id'] as String;
    final String name$value = data['name'] as String;
    return PetQuery_pet(id: id$value, name: name$value);
  }

  static PetQuery_pet fromShalomValue(shalom_core.ShalomJsonValue data) {
    final shalom_core.ShalomJsonValue? id$raw = data.field('id');
    final String id$value = id$raw!.stringValue;
    final shalom_core.ShalomJsonValue? name$raw = data.field('name');
    final String name$value = name$raw!.stringValue;
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

// ------------ widget API -------------

final class PetQueryObservable {
  final shalom_core.ExecutionPolicyInput executionPolicy;
  final shalom_core.RetryDelay retryDelay;
  final Duration? autoRefetch;

  final PetQueryVariables variables;

  const PetQueryObservable({
    required this.variables,

    this.executionPolicy = shalom_core.ExecutionPolicyInput.cacheFirst,
    this.retryDelay = const shalom_core.RetryDelay.inherit(),
    this.autoRefetch,
  });

  String operation$Name() => 'PetQuery';

  Stream<shalom_core.GraphQLResponse<PetQueryData>> observe(
    shalom_core.ShalomRuntimeClient client,
  ) {
    return client.request<PetQueryData>(
      name: operation$Name(),

      variables: variables.toShalomValue(),

      decoder: PetQueryData.fromShalomValue,
      executionPolicy: executionPolicy,
      retryDelay: retryDelay,
      autoRefetch: autoRefetch,
    );
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

  shalom_core.ShalomJsonValue toShalomValue() {
    final $data = <String, shalom_core.ShalomJsonValue>{};
    $data["id"] = shalom_core.shalomJsonValue(this.id!);
    return shalom_core.shalomJsonObject($data);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is PetQueryVariables && this.id == other.id);
  }

  @override
  int get hashCode => Object.hashAll([id]);
}

// ------------ END widget API -------------
