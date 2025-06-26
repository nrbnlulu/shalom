// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;

class GetFloatListWithNullsResponse {
  /// class members

  final List<double?> floatListWithNulls;

  // keywordargs constructor
  GetFloatListWithNullsResponse({required this.floatListWithNulls});
  static GetFloatListWithNullsResponse fromJson(JsonObject data) {
    final List<double?> floatListWithNulls_value;

    floatListWithNulls_value =
        (data['floatListWithNulls'] as List).cast<double?>();

    return GetFloatListWithNullsResponse(
      floatListWithNulls: floatListWithNulls_value,
    );
  }

  GetFloatListWithNullsResponse updateWithJson(JsonObject data) {
    final List<double?> floatListWithNulls_value;
    if (data.containsKey('floatListWithNulls')) {
      floatListWithNulls_value = data['floatListWithNulls'];
    } else {
      floatListWithNulls_value = floatListWithNulls;
    }

    return GetFloatListWithNullsResponse(
      floatListWithNulls: floatListWithNulls_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetFloatListWithNullsResponse &&
            other.floatListWithNulls == floatListWithNulls);
  }

  @override
  int get hashCode => floatListWithNulls.hashCode;

  JsonObject toJson() {
    return {'floatListWithNulls': floatListWithNulls};
  }
}

// ------------ OBJECT DEFINITIONS -------------

// ------------ END OBJECT DEFINITIONS -------------

class RequestGetFloatListWithNulls extends Requestable {
  RequestGetFloatListWithNulls();

  @override
  Request toRequest() {
    JsonObject variablesJson = {};
    return Request(
      query: r"""query GetFloatListWithNulls {
  floatListWithNulls
}""",
      variables: variablesJson,
      opType: OperationType.Query,
      StringopName: 'GetFloatListWithNulls',
    );
  }
}
