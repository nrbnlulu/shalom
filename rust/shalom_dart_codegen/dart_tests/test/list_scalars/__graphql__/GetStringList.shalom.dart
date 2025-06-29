// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;

class GetStringListResponse {
  /// class members

  final List<String> stringList;

  // keywordargs constructor
  GetStringListResponse({required this.stringList});
  static GetStringListResponse fromJson(JsonObject data) {
    final List<String> stringList_value;

    stringList_value = (data['stringList'] as List).cast<String>();

    return GetStringListResponse(stringList: stringList_value);
  }

  GetStringListResponse updateWithJson(JsonObject data) {
    final List<String> stringList_value;
    if (data.containsKey('stringList')) {
      stringList_value = data['stringList'];
    } else {
      stringList_value = stringList;
    }

    return GetStringListResponse(stringList: stringList_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetStringListResponse && other.stringList == stringList);
  }

  @override
  int get hashCode => stringList.hashCode;

  JsonObject toJson() {
    return {'stringList': stringList};
  }
}

// ------------ OBJECT DEFINITIONS -------------

// ------------ END OBJECT DEFINITIONS -------------

class RequestGetStringList extends Requestable {
  RequestGetStringList();

  @override
  Request toRequest() {
    JsonObject variablesJson = {};
    return Request(
      query: r"""query GetStringList {
  stringList
}""",
      variables: variablesJson,
      opType: OperationType.Query,
      StringopName: 'GetStringList',
    );
  }
}
