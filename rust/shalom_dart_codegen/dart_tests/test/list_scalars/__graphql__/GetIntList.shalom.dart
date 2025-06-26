// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;

class GetIntListResponse {
  /// class members

  final List<int> intList;

  // keywordargs constructor
  GetIntListResponse({required this.intList});
  static GetIntListResponse fromJson(JsonObject data) {
    final List<int> intList_value;

    intList_value = (data['intList'] as List).cast<int>();

    return GetIntListResponse(intList: intList_value);
  }

  GetIntListResponse updateWithJson(JsonObject data) {
    final List<int> intList_value;
    if (data.containsKey('intList')) {
      intList_value = data['intList'];
    } else {
      intList_value = intList;
    }

    return GetIntListResponse(intList: intList_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetIntListResponse && other.intList == intList);
  }

  @override
  int get hashCode => intList.hashCode;

  JsonObject toJson() {
    return {'intList': intList};
  }
}

// ------------ OBJECT DEFINITIONS -------------

// ------------ END OBJECT DEFINITIONS -------------

class RequestGetIntList extends Requestable {
  RequestGetIntList();

  @override
  Request toRequest() {
    JsonObject variablesJson = {};
    return Request(
      query: r"""query GetIntList {
  intList
}""",
      variables: variablesJson,
      opType: OperationType.Query,
      StringopName: 'GetIntList',
    );
  }
}
