// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions

import "../../graphql/__graphql__/schema.shalom.dart";

import 'dart:async' show Stream;

import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';

// Fragment imports
import 'ZooAnimalsWidget.shalom.dart';

// ------------ OBJECT DEFINITIONS -------------

class ZooAnimalsQueryResponse {
  static String G__typename = "query";

  /// class members
  final ZooAnimalsWidgetRef? zoo;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  ZooAnimalsQueryResponse({this.zoo});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ZooAnimalsQueryResponse && zoo == other.zoo);
  }

  @override
  int get hashCode =>
      Object.hashAll([zoo, ZooAnimalsQueryResponse.G__typename]);

  shalom_core.JsonObject toJson() {
    return {'zoo': this.zoo?.toJson()};
  }

  static ZooAnimalsQueryResponse fromJson(shalom_core.JsonObject data) {
    final ZooAnimalsWidgetRef? zoo$value = data['zoo'] == null
        ? null
        : ZooAnimalsWidgetRef.fromInput(
            shalom_core.observedRefInputFromJson(
              (data['zoo'] as shalom_core.JsonObject)[r'$ZooAnimalsWidget']
                  as shalom_core.JsonObject,
            ),
          );
    return ZooAnimalsQueryResponse(zoo: zoo$value);
  }
}

class ZooAnimalsQuery_zoo {
  static String G__typename = "Zoo";

  /// class members
  final List<ZooAnimalsWidget_animals> animals;

  final String id;

  final String name;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  ZooAnimalsQuery_zoo({
    required this.animals,

    required this.id,

    required this.name,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ZooAnimalsQuery_zoo &&
            const ListEquality().equals(animals, other.animals) &&
            id == other.id &&
            name == other.name);
  }

  @override
  int get hashCode =>
      Object.hashAll([animals, id, name, ZooAnimalsQuery_zoo.G__typename]);

  shalom_core.JsonObject toJson() {
    return {
      'animals': this.animals.map((e) => e.toJson()).toList(),

      'id': this.id,

      'name': this.name,
    };
  }

  static ZooAnimalsQuery_zoo fromJson(shalom_core.JsonObject data) {
    final List<ZooAnimalsWidget_animals> animals$value =
        (data['animals'] as List<dynamic>)
            .map(
              (e) => ZooAnimalsWidget_animals.fromJson(
                e as shalom_core.JsonObject,
              ),
            )
            .toList();
    final String id$value = data['id'] as String;
    final String name$value = data['name'] as String;
    return ZooAnimalsQuery_zoo(
      animals: animals$value,

      id: id$value,

      name: name$value,
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

// ------------ widget API -------------

final class ZooAnimalsQueryData implements shalom_core.OperationInterface {
  final ZooAnimalsWidgetRef? zoo;

  const ZooAnimalsQueryData({required this.zoo});

  @override
  String operation$Name() => 'ZooAnimalsQuery';

  static ZooAnimalsQueryData fromCache(shalom_core.JsonObject data) {
    final ZooAnimalsWidgetRef? zoo$value = data['zoo'] == null
        ? null
        : ZooAnimalsWidgetRef.fromInput(
            shalom_core.observedRefInputFromJson(
              (data['zoo'] as shalom_core.JsonObject)[r'$ZooAnimalsWidget']
                  as shalom_core.JsonObject,
            ),
          );
    return ZooAnimalsQueryData(zoo: zoo$value);
  }

  /// Reads this operation's current cache entry through [cache], decoding
  /// it as [ZooAnimalsQueryData]. Returns `null` when absent or incomplete.
  static Future<ZooAnimalsQueryData?> readFrom(
    shalom_core.CacheProxy cache, {
    ZooAnimalsQueryVariables? variables,
  }) async {
    return await cache.readOperation<ZooAnimalsQueryData>(
      name: 'ZooAnimalsQuery',
      decoder: fromCache,

      variables: variables?.toJson(),
    );
  }

  /// Evicts this operation's cached entry (matched by [variables]) through
  /// [cache], notifying any active subscribers. Returns `false` if no
  /// matching cache entry existed.
  static Future<bool> evictFrom(
    shalom_core.CacheProxy cache, {
    ZooAnimalsQueryVariables? variables,
  }) {
    return cache.evictOperation(
      name: 'ZooAnimalsQuery',

      variables: variables?.toJson(),
    );
  }

  shalom_core.JsonObject toJson() {
    return {'zoo': this.zoo?.toJson()};
  }
}

final class ZooAnimalsQueryObservable {
  final shalom_core.ExecutionPolicyInput executionPolicy;
  final shalom_core.RetryDelay retryDelay;
  final Duration? autoRefetch;

  final ZooAnimalsQueryVariables variables;

  const ZooAnimalsQueryObservable({
    required this.variables,

    this.executionPolicy = shalom_core.ExecutionPolicyInput.cacheFirst,
    this.retryDelay = const shalom_core.RetryDelay.inherit(),
    this.autoRefetch,
  });

  String operation$Name() => 'ZooAnimalsQuery';

  Stream<shalom_core.GraphQLResponse<ZooAnimalsQueryData>> observe(
    shalom_core.ShalomRuntimeClient client,
  ) {
    return client.request<ZooAnimalsQueryData>(
      name: operation$Name(),

      variables: variables.toJson(),

      decoder: ZooAnimalsQueryData.fromCache,
      executionPolicy: executionPolicy,
      retryDelay: retryDelay,
      autoRefetch: autoRefetch,
    );
  }
}

final class ZooAnimalsQueryVariables {
  final String id;

  const ZooAnimalsQueryVariables({required this.id});

  shalom_core.JsonObject toJson() {
    shalom_core.JsonObject data = {};

    data["id"] = this.id;

    return data;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ZooAnimalsQueryVariables && this.id == other.id);
  }

  @override
  int get hashCode => Object.hashAll([id]);
}

// ------------ END widget API -------------
