// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

typedef JsonObject = Map<String, dynamic>;

class GetIntOptionalResponse {
  /// class members

  final int? intOptional;

  // keywordargs constructor
  GetIntOptionalResponse({this.intOptional});
  static GetIntOptionalResponse fromJson(JsonObject data) {
    final int? intOptional_value;
    final intOptional$raw = data["intOptional"];
    intOptional_value = intOptional$raw as int?;

    return GetIntOptionalResponse(intOptional: intOptional_value);
  }

  static GetIntOptionalResponse deserialize(
    JsonObject data,
    ShalomContext context,
  ) {
    final self = GetIntOptionalResponse.fromJson(data);

    return self;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetIntOptionalResponse && other.intOptional == intOptional);
  }

  @override
  int get hashCode => intOptional.hashCode;

  JsonObject toJson() {
    return {'intOptional': this.intOptional};
  }
}

// ------------ OBJECT DEFINITIONS -------------

// ------------ END OBJECT DEFINITIONS -------------

class RequestGetIntOptional extends Requestable {
  RequestGetIntOptional();

  @override
  Request toRequest() {
    JsonObject variablesJson = {};
    return Request(
      query: r"""query GetIntOptional {
  intOptional
}""",
      variables: variablesJson,
      opType: OperationType.Query,
      opName: 'GetIntOptional',
    );
  }
}
