// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;

class GetIntListOptionalResponse {
  /// class members

  final List<int?>? intListOptional;

  // keywordargs constructor
  GetIntListOptionalResponse({this.intListOptional});
  static GetIntListOptionalResponse fromJson(JsonObject data) {
    final List<int?>? intListOptional_value;

    intListOptional_value =
        data['intListOptional'] == null
            ? null
            : (data['intListOptional'] as List).cast<int?>();

    return GetIntListOptionalResponse(intListOptional: intListOptional_value);
  }

  GetIntListOptionalResponse updateWithJson(JsonObject data) {
    final List<int?>? intListOptional_value;
    if (data.containsKey('intListOptional')) {
      intListOptional_value = data['intListOptional'];
    } else {
      intListOptional_value = intListOptional;
    }

    return GetIntListOptionalResponse(intListOptional: intListOptional_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetIntListOptionalResponse &&
            other.intListOptional == intListOptional);
  }

  @override
  int get hashCode => intListOptional.hashCode;

  JsonObject toJson() {
    return {'intListOptional': intListOptional};
  }
}

// ------------ OBJECT DEFINITIONS -------------

// ------------ END OBJECT DEFINITIONS -------------

class RequestGetIntListOptional extends Requestable {
  RequestGetIntListOptional();

  @override
  Request toRequest() {
    JsonObject variablesJson = {};
    return Request(
      query: r"""query GetIntListOptional {
  intListOptional
}""",
      variables: variablesJson,
      opType: OperationType.Query,
      StringopName: 'GetIntListOptional',
    );
  }
}
