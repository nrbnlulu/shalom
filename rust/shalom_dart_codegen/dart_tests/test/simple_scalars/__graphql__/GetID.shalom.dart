// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

typedef JsonObject = Map<String, dynamic>;

class GetIDResponse {
  /// class members

  final String id;

  // keywordargs constructor
  GetIDResponse({required this.id});
  static GetIDResponse fromJson(JsonObject data) {
    final String id_value;
    final id$raw = data["id"];
    id_value = id$raw as String;

    return GetIDResponse(id: id_value);
  }

  GetIDResponse updateWithJson(JsonObject data) {
    final String id_value;
    if (data.containsKey('id')) {
      final id$raw = data["id"];
      id_value = id$raw as String;
    } else {
      id_value = id;
    }

    return GetIDResponse(id: id_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) || (other is GetIDResponse && other.id == id);
  }

  @override
  int get hashCode => id.hashCode;

  JsonObject toJson() {
    return {'id': this.id};
  }
}

// ------------ OBJECT DEFINITIONS -------------

// ------------ END OBJECT DEFINITIONS -------------

class RequestGetID extends Requestable {
  RequestGetID();

  @override
  Request toRequest() {
    JsonObject variablesJson = {};
    return Request(
      query: r"""query GetID {
  id
}""",
      variables: variablesJson,
      opType: OperationType.Query,
      opName: 'GetID',
    );
  }
}
