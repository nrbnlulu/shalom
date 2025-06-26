// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;

class GetBooleanListResponse {
  /// class members

  final List<bool> booleanList;

  // keywordargs constructor
  GetBooleanListResponse({required this.booleanList});
  static GetBooleanListResponse fromJson(JsonObject data) {
    final List<bool> booleanList_value;

    booleanList_value = (data['booleanList'] as List).cast<bool>();

    return GetBooleanListResponse(booleanList: booleanList_value);
  }

  GetBooleanListResponse updateWithJson(JsonObject data) {
    final List<bool> booleanList_value;
    if (data.containsKey('booleanList')) {
      booleanList_value = data['booleanList'];
    } else {
      booleanList_value = booleanList;
    }

    return GetBooleanListResponse(booleanList: booleanList_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetBooleanListResponse && other.booleanList == booleanList);
  }

  @override
  int get hashCode => booleanList.hashCode;

  JsonObject toJson() {
    return {'booleanList': booleanList};
  }
}

// ------------ OBJECT DEFINITIONS -------------

// ------------ END OBJECT DEFINITIONS -------------

class RequestGetBooleanList extends Requestable {
  RequestGetBooleanList();

  @override
  Request toRequest() {
    JsonObject variablesJson = {};
    return Request(
      query: r"""query GetBooleanList {
  booleanList
}""",
      variables: variablesJson,
      opType: OperationType.Query,
      StringopName: 'GetBooleanList',
    );
  }
}
