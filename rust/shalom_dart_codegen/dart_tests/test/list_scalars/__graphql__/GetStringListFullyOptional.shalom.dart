// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;

class GetStringListFullyOptionalResponse {
  /// class members

  final List<String?>? stringListFullyOptional;

  // keywordargs constructor
  GetStringListFullyOptionalResponse({this.stringListFullyOptional});
  static GetStringListFullyOptionalResponse fromJson(JsonObject data) {
    final List<String?>? stringListFullyOptional_value;

    stringListFullyOptional_value =
        data['stringListFullyOptional'] == null
            ? null
            : (data['stringListFullyOptional'] as List).cast<String?>();

    return GetStringListFullyOptionalResponse(
      stringListFullyOptional: stringListFullyOptional_value,
    );
  }

  GetStringListFullyOptionalResponse updateWithJson(JsonObject data) {
    final List<String?>? stringListFullyOptional_value;
    if (data.containsKey('stringListFullyOptional')) {
      stringListFullyOptional_value = data['stringListFullyOptional'];
    } else {
      stringListFullyOptional_value = stringListFullyOptional;
    }

    return GetStringListFullyOptionalResponse(
      stringListFullyOptional: stringListFullyOptional_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetStringListFullyOptionalResponse &&
            other.stringListFullyOptional == stringListFullyOptional);
  }

  @override
  int get hashCode => stringListFullyOptional.hashCode;

  JsonObject toJson() {
    return {'stringListFullyOptional': stringListFullyOptional};
  }
}

// ------------ OBJECT DEFINITIONS -------------

// ------------ END OBJECT DEFINITIONS -------------

class RequestGetStringListFullyOptional extends Requestable {
  RequestGetStringListFullyOptional();

  @override
  Request toRequest() {
    JsonObject variablesJson = {};
    return Request(
      query: r"""query GetStringListFullyOptional {
  stringListFullyOptional
}""",
      variables: variablesJson,
      opType: OperationType.Query,
      StringopName: 'GetStringListFullyOptional',
    );
  }
}
