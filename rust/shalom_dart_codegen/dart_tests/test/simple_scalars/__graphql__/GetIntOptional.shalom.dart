// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;

class GetIntOptionalResponse {
  /// class members

  final int? intOptional;

  // keywordargs constructor
  GetIntOptionalResponse({this.intOptional});
  static GetIntOptionalResponse fromJson(JsonObject data) {
    final int? intOptional_value;

    intOptional_value = data['intOptional'];

    return GetIntOptionalResponse(intOptional: intOptional_value);
  }

  GetIntOptionalResponse updateWithJson(JsonObject data) {
    final int? intOptional_value;
    if (data.containsKey('intOptional')) {
      intOptional_value = data['intOptional'];
    } else {
      intOptional_value = intOptional;
    }

    return GetIntOptionalResponse(intOptional: intOptional_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetIntOptionalResponse && other.intOptional == intOptional);
  }

  @override
  int get hashCode => intOptional.hashCode;

  JsonObject toJson() {
    return {'intOptional': intOptional};
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
      StringopName: 'GetIntOptional',
    );
  }
}
