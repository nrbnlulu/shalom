// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;

class GetStringListWithNullsResponse {
  /// class members

  final List<String?> stringListWithNulls;

  // keywordargs constructor
  GetStringListWithNullsResponse({required this.stringListWithNulls});
  static GetStringListWithNullsResponse fromJson(JsonObject data) {
    final List<String?> stringListWithNulls_value;

    stringListWithNulls_value =
        (data['stringListWithNulls'] as List).cast<String?>();

    return GetStringListWithNullsResponse(
      stringListWithNulls: stringListWithNulls_value,
    );
  }

  GetStringListWithNullsResponse updateWithJson(JsonObject data) {
    final List<String?> stringListWithNulls_value;
    if (data.containsKey('stringListWithNulls')) {
      stringListWithNulls_value = data['stringListWithNulls'];
    } else {
      stringListWithNulls_value = stringListWithNulls;
    }

    return GetStringListWithNullsResponse(
      stringListWithNulls: stringListWithNulls_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetStringListWithNullsResponse &&
            other.stringListWithNulls == stringListWithNulls);
  }

  @override
  int get hashCode => stringListWithNulls.hashCode;

  JsonObject toJson() {
    return {'stringListWithNulls': stringListWithNulls};
  }
}

// ------------ OBJECT DEFINITIONS -------------

// ------------ END OBJECT DEFINITIONS -------------

class RequestGetStringListWithNulls extends Requestable {
  RequestGetStringListWithNulls();

  @override
  Request toRequest() {
    JsonObject variablesJson = {};
    return Request(
      query: r"""query GetStringListWithNulls {
  stringListWithNulls
}""",
      variables: variablesJson,
      opType: OperationType.Query,
      StringopName: 'GetStringListWithNulls',
    );
  }
}
