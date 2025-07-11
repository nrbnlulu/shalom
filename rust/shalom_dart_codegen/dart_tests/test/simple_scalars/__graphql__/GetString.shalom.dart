// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

typedef JsonObject = Map<String, dynamic>;

class GetStringResponse {
  /// class members

  final String string;

  // keywordargs constructor
  GetStringResponse({required this.string});
  static GetStringResponse fromJson(JsonObject data) {
    final String string_value;
    final string$raw = data["string"];
    string_value = string$raw as String;

    return GetStringResponse(string: string_value);
  }

  GetStringResponse updateWithJson(JsonObject data) {
    final String string_value;
    if (data.containsKey('string')) {
      final string$raw = data["string"];
      string_value = string$raw as String;
    } else {
      string_value = string;
    }

    return GetStringResponse(string: string_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetStringResponse && other.string == string);
  }

  @override
  int get hashCode => string.hashCode;

  JsonObject toJson() {
    return {'string': this.string};
  }
}

// ------------ OBJECT DEFINITIONS -------------

// ------------ END OBJECT DEFINITIONS -------------

class RequestGetString extends Requestable {
  RequestGetString();

  @override
  Request toRequest() {
    JsonObject variablesJson = {};
    return Request(
      query: r"""query GetString {
  string
}""",
      variables: variablesJson,
      opType: OperationType.Query,
      opName: 'GetString',
    );
  }
}
