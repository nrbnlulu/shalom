// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;

class GetIDListResponse {
  /// class members

  final List<String> idList;

  // keywordargs constructor
  GetIDListResponse({required this.idList});
  static GetIDListResponse fromJson(JsonObject data) {
    final List<String> idList_value;

    idList_value = (data['idList'] as List).cast<String>();

    return GetIDListResponse(idList: idList_value);
  }

  GetIDListResponse updateWithJson(JsonObject data) {
    final List<String> idList_value;
    if (data.containsKey('idList')) {
      idList_value = data['idList'];
    } else {
      idList_value = idList;
    }

    return GetIDListResponse(idList: idList_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetIDListResponse && other.idList == idList);
  }

  @override
  int get hashCode => idList.hashCode;

  JsonObject toJson() {
    return {'idList': idList};
  }
}

// ------------ OBJECT DEFINITIONS -------------

// ------------ END OBJECT DEFINITIONS -------------

class RequestGetIDList extends Requestable {
  RequestGetIDList();

  @override
  Request toRequest() {
    JsonObject variablesJson = {};
    return Request(
      query: r"""query GetIDList {
  idList
}""",
      variables: variablesJson,
      opType: OperationType.Query,
      StringopName: 'GetIDList',
    );
  }
}
