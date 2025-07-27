// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";
import 'dart:async';

import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

typedef JsonObject = Map<String, dynamic>;

class GetIDOptionalResponse {
  /// class members

  final String? idOptional;

  // keywordargs constructor
  GetIDOptionalResponse({this.idOptional});
  static GetIDOptionalResponse fromJson(
    JsonObject data,
    ShalomContext? context,
  ) {
    final String? idOptional_value;
    final idOptional$raw = data["idOptional"];
    idOptional_value = idOptional$raw as String?;

    return GetIDOptionalResponse(idOptional: idOptional_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetIDOptionalResponse && other.idOptional == idOptional);
  }

  @override
  int get hashCode => idOptional.hashCode;

  JsonObject toJson() {
    return {'idOptional': this.idOptional};
  }
}

// ------------ OBJECT DEFINITIONS -------------

// ------------ END OBJECT DEFINITIONS -------------

class RequestGetIDOptional extends Requestable {
  RequestGetIDOptional();

  @override
  Request toRequest() {
    JsonObject variablesJson = {};
    return Request(
      query: r"""query GetIDOptional {
  idOptional
}""",
      variables: variablesJson,
      opType: OperationType.Query,
      opName: 'GetIDOptional',
    );
  }
}
