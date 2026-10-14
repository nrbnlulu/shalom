// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions

import "../../graphql/__graphql__/schema.shalom.dart";

import 'dart:async' show Stream;

import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';

// Fragment imports
import 'ZooWidget.shalom.dart';

// ------------ OBJECT DEFINITIONS -------------
class ZooQueryData
    implements shalom_core.OperationInterface, shalom_core.StreamCompat {
  static String G__typename = "query";

  /// class members
  final ZooWidgetRef? zoo;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  ZooQueryData({this.zoo});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ZooQueryData && zoo == other.zoo);
  }

  @override
  int get hashCode => Object.hashAll([zoo, ZooQueryData.G__typename]);

  shalom_core.JsonObject toJson() {
    return {'zoo': this.zoo?.toJson()};
  }

  shalom_core.ShalomJsonValue toShalomValue() => shalom_core.shalomJsonObject({
    'zoo': this.zoo == null
        ? shalom_core.shalomJsonValue(null)
        : this.zoo!.toShalomValue(),
  });

  static ZooQueryData fromJson(shalom_core.JsonObject data) {
    final ZooWidgetRef? zoo$value = data['zoo'] == null
        ? null
        : ZooWidgetRef.fromInput(
            shalom_core.observedRefInputFromJson(
              (data['zoo'] as shalom_core.JsonObject)[r'$ZooWidget']
                  as shalom_core.JsonObject,
            ),
          );
    return ZooQueryData(zoo: zoo$value);
  }

  static ZooQueryData fromShalomValue(shalom_core.ShalomJsonValue data) {
    final shalom_core.ShalomJsonValue? zoo$raw = data.field('zoo');
    final ZooWidgetRef? zoo$value = zoo$raw == null || zoo$raw!.isNull
        ? null
        : ZooWidgetRef.fromInput(
            shalom_core.observedRefInputFromShalomValue(
              zoo$raw!.field(r'$ZooWidget')!,
            ),
          );
    return ZooQueryData(zoo: zoo$value);
  }

  @override
  String operation$Name() => 'ZooQuery';

  /// Reads this operation's current cache entry through [cache], decoding
  /// it as [ZooQueryData]. Returns `null` when absent or incomplete.
  static Future<ZooQueryData?> readFrom(
    shalom_core.CacheProxy cache, {
    ZooQueryVariables? variables,
  }) async {
    return await cache.readOperation<ZooQueryData>(
      name: 'ZooQuery',
      decoder: fromShalomValue,

      variables: variables?.toShalomValue(),
    );
  }

  /// Evicts this operation's cached entry (matched by [variables]) through
  /// [cache], notifying any active subscribers. Returns `false` if no
  /// matching cache entry existed.
  static Future<bool> evictFrom(
    shalom_core.CacheProxy cache, {
    ZooQueryVariables? variables,
  }) {
    return cache.evictOperation(
      name: 'ZooQuery',

      variables: variables?.toShalomValue(),
    );
  }
}

class ZooQuery_zoo {
  static String G__typename = "Zoo";

  /// class members
  final List<ZooWidget_cages> cages;

  final String id;

  final String name;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  ZooQuery_zoo({required this.cages, required this.id, required this.name});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ZooQuery_zoo &&
            const ListEquality().equals(cages, other.cages) &&
            id == other.id &&
            name == other.name);
  }

  @override
  int get hashCode =>
      Object.hashAll([cages, id, name, ZooQuery_zoo.G__typename]);

  shalom_core.JsonObject toJson() {
    return {
      'cages': this.cages.map((e) => e.toJson()).toList(),

      'id': this.id,

      'name': this.name,
    };
  }

  shalom_core.ShalomJsonValue toShalomValue() => shalom_core.shalomJsonObject({
    'cages': shalom_core.shalomJsonArray(
      this.cages!.map((e) => e!.toShalomValue()),
    ),

    'id': shalom_core.shalomJsonValue(this.id!),

    'name': shalom_core.shalomJsonValue(this.name!),
  });

  static ZooQuery_zoo fromJson(shalom_core.JsonObject data) {
    final List<ZooWidget_cages> cages$value = (data['cages'] as List<dynamic>)
        .map((e) => ZooWidget_cages.fromJson(e as shalom_core.JsonObject))
        .toList();
    final String id$value = data['id'] as String;
    final String name$value = data['name'] as String;
    return ZooQuery_zoo(cages: cages$value, id: id$value, name: name$value);
  }

  static ZooQuery_zoo fromShalomValue(shalom_core.ShalomJsonValue data) {
    final shalom_core.ShalomJsonValue? cages$raw = data.field('cages');
    final List<ZooWidget_cages> cages$value = cages$raw!.listValue
        .map((e) => ZooWidget_cages.fromShalomValue(e!))
        .toList();
    final shalom_core.ShalomJsonValue? id$raw = data.field('id');
    final String id$value = id$raw!.stringValue;
    final shalom_core.ShalomJsonValue? name$raw = data.field('name');
    final String name$value = name$raw!.stringValue;
    return ZooQuery_zoo(cages: cages$value, id: id$value, name: name$value);
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

final class ZooQueryObservable {
  final shalom_core.ExecutionPolicyInput executionPolicy;
  final shalom_core.RetryDelay retryDelay;
  final Duration? autoRefetch;

  final ZooQueryVariables variables;

  const ZooQueryObservable({
    required this.variables,

    this.executionPolicy = shalom_core.ExecutionPolicyInput.cacheFirst,
    this.retryDelay = const shalom_core.RetryDelay.inherit(),
    this.autoRefetch,
  });

  String operation$Name() => 'ZooQuery';

  Stream<shalom_core.GraphQLResponse<ZooQueryData>> observe(
    shalom_core.ShalomRuntimeClient client,
  ) {
    return client.request<ZooQueryData>(
      name: operation$Name(),

      variables: variables.toShalomValue(),

      decoder: ZooQueryData.fromShalomValue,
      executionPolicy: executionPolicy,
      retryDelay: retryDelay,
      autoRefetch: autoRefetch,
    );
  }
}

final class ZooQueryVariables {
  final String id;

  const ZooQueryVariables({required this.id});

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
        (other is ZooQueryVariables && this.id == other.id);
  }

  @override
  int get hashCode => Object.hashAll([id]);
}

// ------------ END widget API -------------
