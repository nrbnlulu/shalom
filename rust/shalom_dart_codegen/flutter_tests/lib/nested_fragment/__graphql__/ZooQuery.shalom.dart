// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions

import "../../graphql/__graphql__/schema.shalom.dart";

import 'dart:async' show Stream;

import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';

// Fragment imports
import 'ZooWidget.shalom.dart';

// ------------ OBJECT DEFINITIONS -------------

class ZooQueryResponse {
  static String G__typename = "query";

  /// class members
  final ZooWidgetRef? zoo;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  ZooQueryResponse({this.zoo});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ZooQueryResponse && zoo == other.zoo);
  }

  @override
  int get hashCode => Object.hashAll([zoo, ZooQueryResponse.G__typename]);

  shalom_core.JsonObject toJson() {
    return {'zoo': this.zoo?.toJson()};
  }

  static ZooQueryResponse fromJson(shalom_core.JsonObject data) {
    final ZooWidgetRef? zoo$value = data['zoo'] == null
        ? null
        : ZooWidgetRef.fromInput(
            shalom_core.observedRefInputFromJson(
              (data['zoo'] as shalom_core.JsonObject)[r'$ZooWidget']
                  as shalom_core.JsonObject,
            ),
          );
    return ZooQueryResponse(zoo: zoo$value);
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

  static ZooQuery_zoo fromJson(shalom_core.JsonObject data) {
    final List<ZooWidget_cages> cages$value = (data['cages'] as List<dynamic>)
        .map((e) => ZooWidget_cages.fromJson(e as shalom_core.JsonObject))
        .toList();
    final String id$value = data['id'] as String;
    final String name$value = data['name'] as String;
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

// ------------ V2 WIDGET API -------------

final class ZooQueryData implements shalom_core.OperationInterface {
  final ZooWidgetRef? zoo;

  const ZooQueryData({required this.zoo});

  @override
  String operation$Name() => 'ZooQuery';

  static ZooQueryData fromCache(shalom_core.JsonObject data) {
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

  /// Reads this operation's current cache entry through [cache], decoding
  /// it as [ZooQueryData]. Returns `null` when absent or incomplete.
  static ZooQueryData? readFrom(
    shalom_core.CacheProxy cache, {
    ZooQueryVariables? variables,
  }) {
    return cache.readQuery<ZooQueryData>(
      name: 'ZooQuery',
      decoder: fromCache,

      variables: variables?.toJson(),
    );
  }

  shalom_core.JsonObject toJson() {
    return {'zoo': this.zoo?.toJson()};
  }
}

final class ZooQueryObservable {
  final shalom_core.ExecutionPolicyInput executionPolicy;

  final ZooQueryVariables variables;

  const ZooQueryObservable({
    required this.variables,

    this.executionPolicy = shalom_core.ExecutionPolicyInput.cacheFirst,
  });

  String operation$Name() => 'ZooQuery';

  Stream<ZooQueryData> observe(shalom_core.ShalomRuntimeClient client) {
    return client.request<ZooQueryData>(
      name: operation$Name(),

      variables: variables.toJson(),

      decoder: ZooQueryData.fromCache,
      executionPolicy: executionPolicy,
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

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ZooQueryVariables && this.id == other.id);
  }

  @override
  int get hashCode => Object.hashAll([id]);
}

// ------------ END V2 WIDGET API -------------
