// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;

class UpdateIDListResponse {
  /// class members

  final UpdateIDList_updateIDList? updateIDList;

  // keywordargs constructor
  UpdateIDListResponse({this.updateIDList});
  static UpdateIDListResponse fromJson(JsonObject data) {
    final UpdateIDList_updateIDList? updateIDList_value;

    final JsonObject? updateIDList$raw = data['updateIDList'];
    if (updateIDList$raw != null) {
      updateIDList_value = UpdateIDList_updateIDList.fromJson(updateIDList$raw);
    } else {
      updateIDList_value = null;
    }

    return UpdateIDListResponse(updateIDList: updateIDList_value);
  }

  UpdateIDListResponse updateWithJson(JsonObject data) {
    final UpdateIDList_updateIDList? updateIDList_value;
    if (data.containsKey('updateIDList')) {
      final JsonObject? updateIDList$raw = data['updateIDList'];
      if (updateIDList$raw != null) {
        updateIDList_value = UpdateIDList_updateIDList.fromJson(
          updateIDList$raw,
        );
      } else {
        updateIDList_value = null;
      }
    } else {
      updateIDList_value = updateIDList;
    }

    return UpdateIDListResponse(updateIDList: updateIDList_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UpdateIDListResponse && other.updateIDList == updateIDList);
  }

  @override
  int get hashCode => updateIDList.hashCode;

  JsonObject toJson() {
    return {'updateIDList': updateIDList?.toJson()};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class UpdateIDList_updateIDList {
  /// class members

  final bool success;

  // keywordargs constructor
  UpdateIDList_updateIDList({required this.success});
  static UpdateIDList_updateIDList fromJson(JsonObject data) {
    final bool success_value;

    success_value = data['success'];

    return UpdateIDList_updateIDList(success: success_value);
  }

  UpdateIDList_updateIDList updateWithJson(JsonObject data) {
    final bool success_value;
    if (data.containsKey('success')) {
      success_value = data['success'];
    } else {
      success_value = success;
    }

    return UpdateIDList_updateIDList(success: success_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UpdateIDList_updateIDList && other.success == success);
  }

  @override
  int get hashCode => success.hashCode;

  JsonObject toJson() {
    return {'success': success};
  }
}

// ------------ END OBJECT DEFINITIONS -------------

class RequestUpdateIDList extends Requestable {
  final UpdateIDListVariables variables;

  RequestUpdateIDList({required this.variables});

  @override
  Request toRequest() {
    JsonObject variablesJson = variables.toJson();
    return Request(
      query: r"""mutation UpdateIDList($ids: [ID!]!) {
  updateIDList(ids: $ids) {
    success
  }
}""",
      variables: variablesJson,
      opType: OperationType.Mutation,
      StringopName: 'UpdateIDList',
    );
  }
}

class UpdateIDListVariables {
  final List<String> ids;

  UpdateIDListVariables({required this.ids});

  JsonObject toJson() {
    JsonObject data = {};

    data["ids"] = ids;

    return data;
  }

  UpdateIDListVariables updateWith({List<String>? ids}) {
    final List<String> ids$next;

    if (ids != null) {
      ids$next = ids;
    } else {
      ids$next = this.ids;
    }

    return UpdateIDListVariables(ids: ids$next);
  }
}
