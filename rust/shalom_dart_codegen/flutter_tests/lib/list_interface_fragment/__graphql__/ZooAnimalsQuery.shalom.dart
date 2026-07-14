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

  shalom_core.ShalomJsonValue toShalomValue() => shalom_core.shalomJsonObject({
    'zoo': this.zoo == null
        ? shalom_core.shalomJsonValue(null)
        : this.zoo!.toShalomValue(),
  });

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

  static ZooAnimalsQueryResponse fromShalomValue(
    shalom_core.ShalomJsonValue data,
  ) {
    final shalom_core.ShalomJsonValue? zoo$raw = data.field('zoo');
    final ZooAnimalsWidgetRef? zoo$value = zoo$raw == null || zoo$raw!.isNull
        ? null
        : ZooAnimalsWidgetRef.fromInput(
            shalom_core.observedRefInputFromShalomValue(
              zoo$raw!.field(r'$ZooAnimalsWidget')!,
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

  shalom_core.ShalomJsonValue toShalomValue() => shalom_core.shalomJsonObject({
    'animals': shalom_core.shalomJsonArray(
      this.animals!.map((e) => e!.toShalomValue()),
    ),

    'id': shalom_core.shalomJsonValue(this.id!),

    'name': shalom_core.shalomJsonValue(this.name!),
  });

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

  static ZooAnimalsQuery_zoo fromShalomValue(shalom_core.ShalomJsonValue data) {
    final shalom_core.ShalomJsonValue? animals$raw = data.field('animals');
    final List<ZooAnimalsWidget_animals> animals$value = animals$raw!.listValue
        .map((e) => ZooAnimalsWidget_animals.fromShalomValue(e!))
        .toList();
    final shalom_core.ShalomJsonValue? id$raw = data.field('id');
    final String id$value = id$raw!.stringValue;
    final shalom_core.ShalomJsonValue? name$raw = data.field('name');
    final String name$value = name$raw!.stringValue;
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

  static ZooAnimalsQueryData fromShalomValue(shalom_core.ShalomJsonValue data) {
    final shalom_core.ShalomJsonValue? zoo$raw = data.field('zoo');
    final ZooAnimalsWidgetRef? zoo$value = zoo$raw == null || zoo$raw!.isNull
        ? null
        : ZooAnimalsWidgetRef.fromInput(
            shalom_core.observedRefInputFromShalomValue(
              zoo$raw!.field(r'$ZooAnimalsWidget')!,
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
    return await cache.readQuery<ZooAnimalsQueryData>(
      name: 'ZooAnimalsQuery',
      bridgeDecoder: fromShalomValue,

      variablesValue: variables?.toShalomValue(),
    );
  }

  shalom_core.JsonObject toJson() {
    return {'zoo': this.zoo?.toJson()};
  }

  @override
  shalom_core.ShalomJsonValue toShalomValue() => shalom_core.shalomJsonObject({
    'zoo': this.zoo == null
        ? shalom_core.shalomJsonValue(null)
        : this.zoo!.toShalomValue(),
  });
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

      variablesValue: variables.toShalomValue(),

      bridgeDecoder: ZooAnimalsQueryData.fromShalomValue,
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

  shalom_core.ShalomJsonValue toShalomValue() {
    final data = <String, shalom_core.ShalomJsonValue>{};
    data["id"] = shalom_core.shalomJsonValue(this.id!);
    return shalom_core.shalomJsonObject(data);
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
