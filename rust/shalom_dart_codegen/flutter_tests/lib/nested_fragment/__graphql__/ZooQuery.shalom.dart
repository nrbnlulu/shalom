// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions

import "../../graphql/__graphql__/schema.shalom.dart";

import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';
import 'package:meta/meta.dart' show experimental;

// Fragment imports
import 'ZooWidget.shalom.dart';

// ------------ OBJECT DEFINITIONS -------------

class ZooQueryResponse {
  static String G__typename = "query";

  /// class members
  final ZooWidgetRef? zoo;

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

  @experimental
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

  final String name;

  final String id;

  // keywordargs constructor
  ZooQuery_zoo({required this.cages, required this.name, required this.id});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ZooQuery_zoo &&
            const ListEquality().equals(cages, other.cages) &&
            name == other.name &&
            id == other.id);
  }

  @override
  int get hashCode =>
      Object.hashAll([cages, name, id, ZooQuery_zoo.G__typename]);

  shalom_core.JsonObject toJson() {
    return {
      'cages': this.cages.map((e) => e.toJson()).toList(),

      'name': this.name,

      'id': this.id,
    };
  }

  @experimental
  static ZooQuery_zoo fromJson(shalom_core.JsonObject data) {
    final List<ZooWidget_cages> cages$value = (data['cages'] as List<dynamic>)
        .map((e) => ZooWidget_cages.fromJson(e as shalom_core.JsonObject))
        .toList();
    final String name$value = data['name'] as String;
    final String id$value = data['id'] as String;
    return ZooQuery_zoo(cages: cages$value, name: name$value, id: id$value);
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

final class ZooQueryData {
  final ZooWidgetRef? zoo;

  const ZooQueryData({required this.zoo});

  @experimental
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

  shalom_core.JsonObject toJson() {
    return {'zoo': this.zoo?.toJson()};
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
