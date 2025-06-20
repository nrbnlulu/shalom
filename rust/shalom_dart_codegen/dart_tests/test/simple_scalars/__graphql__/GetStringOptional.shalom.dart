// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;

class GetStringOptionalResponse {
  /// class members

  final String? stringOptional;

  // keywordargs constructor
  GetStringOptionalResponse({this.stringOptional});
  static GetStringOptionalResponse fromJson(JsonObject data) {
    final String? stringOptional_value;

    stringOptional_value = data['stringOptional'];

    return GetStringOptionalResponse(stringOptional: stringOptional_value);
  }

  GetStringOptionalResponse updateWithJson(JsonObject data) {
    final String? stringOptional_value;
    if (data.containsKey('stringOptional')) {
      stringOptional_value = data['stringOptional'];
    } else {
      stringOptional_value = stringOptional;
    }

    return GetStringOptionalResponse(stringOptional: stringOptional_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetStringOptionalResponse &&
            other.stringOptional == stringOptional);
  }

  @override
  int get hashCode => stringOptional.hashCode;

  JsonObject toJson() {
    return {'stringOptional': stringOptional};
  }
}

// ------------ OBJECT DEFINITIONS -------------

// ------------ END OBJECT DEFINITIONS -------------

class RequestGetStringOptional extends Requestable {
  RequestGetStringOptional();

  @override
  Request toRequest() {
    JsonObject variablesJson = {};
    return Request(
      query: r"""query GetStringOptional {
  stringOptional
}""",
      variables: variablesJson,
      opType: OperationType.Query,
      StringopName: 'GetStringOptional',
    );
  }
}
