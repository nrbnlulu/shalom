// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;

class GetFloatListResponse {
  /// class members

  final List<double> floatList;

  // keywordargs constructor
  GetFloatListResponse({required this.floatList});
  static GetFloatListResponse fromJson(JsonObject data) {
    final List<double> floatList_value;

    floatList_value = (data['floatList'] as List).cast<double>();

    return GetFloatListResponse(floatList: floatList_value);
  }

  GetFloatListResponse updateWithJson(JsonObject data) {
    final List<double> floatList_value;
    if (data.containsKey('floatList')) {
      floatList_value = data['floatList'];
    } else {
      floatList_value = floatList;
    }

    return GetFloatListResponse(floatList: floatList_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetFloatListResponse && other.floatList == floatList);
  }

  @override
  int get hashCode => floatList.hashCode;

  JsonObject toJson() {
    return {'floatList': floatList};
  }
}

// ------------ OBJECT DEFINITIONS -------------

// ------------ END OBJECT DEFINITIONS -------------

class RequestGetFloatList extends Requestable {
  RequestGetFloatList();

  @override
  Request toRequest() {
    JsonObject variablesJson = {};
    return Request(
      query: r"""query GetFloatList {
  floatList
}""",
      variables: variablesJson,
      opType: OperationType.Query,
      StringopName: 'GetFloatList',
    );
  }
}
