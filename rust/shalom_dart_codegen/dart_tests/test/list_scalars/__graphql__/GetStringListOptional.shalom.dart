// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;

class GetStringListOptionalResponse {
  /// class members

  final List<String>? stringListOptional;

  // keywordargs constructor
  GetStringListOptionalResponse({this.stringListOptional});
  static GetStringListOptionalResponse fromJson(JsonObject data) {
    final List<String>? stringListOptional_value;

    stringListOptional_value =
        data['stringListOptional'] == null
            ? null
            : (data['stringListOptional'] as List).cast<String>();

    return GetStringListOptionalResponse(
      stringListOptional: stringListOptional_value,
    );
  }

  GetStringListOptionalResponse updateWithJson(JsonObject data) {
    final List<String>? stringListOptional_value;
    if (data.containsKey('stringListOptional')) {
      stringListOptional_value = data['stringListOptional'];
    } else {
      stringListOptional_value = stringListOptional;
    }

    return GetStringListOptionalResponse(
      stringListOptional: stringListOptional_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetStringListOptionalResponse &&
            other.stringListOptional == stringListOptional);
  }

  @override
  int get hashCode => stringListOptional.hashCode;

  JsonObject toJson() {
    return {'stringListOptional': stringListOptional};
  }
}

// ------------ OBJECT DEFINITIONS -------------

// ------------ END OBJECT DEFINITIONS -------------

class RequestGetStringListOptional extends Requestable {
  RequestGetStringListOptional();

  @override
  Request toRequest() {
    JsonObject variablesJson = {};
    return Request(
      query: r"""query GetStringListOptional {
  stringListOptional
}""",
      variables: variablesJson,
      opType: OperationType.Query,
      StringopName: 'GetStringListOptional',
    );
  }
}
