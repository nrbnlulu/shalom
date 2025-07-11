// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

typedef JsonObject = Map<String, dynamic>;

class GetFloatOptionalResponse {
  /// class members

  final double? floatOptional;

  // keywordargs constructor
  GetFloatOptionalResponse({this.floatOptional});

  GetFloatOptionalResponse updateWithJson(JsonObject data) {
    final double? floatOptional_value;
    if (data.containsKey('floatOptional')) {
      final floatOptional$raw = data["floatOptional"];
      floatOptional_value = floatOptional$raw as double?;
    } else {
      floatOptional_value = floatOptional;
    }

    return GetFloatOptionalResponse(floatOptional: floatOptional_value);
  }

  static GetFloatOptionalResponse fromJson(JsonObject data) {
    final double? floatOptional_value;
    final floatOptional$raw = data["floatOptional"];
    floatOptional_value = floatOptional$raw as double?;

    return GetFloatOptionalResponse(floatOptional: floatOptional_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetFloatOptionalResponse &&
            other.floatOptional == floatOptional);
  }

  @override
  int get hashCode => floatOptional.hashCode;

  JsonObject toJson() {
    return {'floatOptional': this.floatOptional};
  }
}

// ------------ OBJECT DEFINITIONS -------------

// ------------ END OBJECT DEFINITIONS -------------

class RequestGetFloatOptional extends Requestable {
  RequestGetFloatOptional();

  @override
  Request toRequest() {
    JsonObject variablesJson = {};
    return Request(
      query: r"""query GetFloatOptional {
  floatOptional
}""",
      variables: variablesJson,
      opType: OperationType.Query,
      opName: 'GetFloatOptional',
    );
  }
}
