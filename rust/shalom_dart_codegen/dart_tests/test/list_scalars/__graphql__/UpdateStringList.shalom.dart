// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;

class UpdateStringListResponse {
  /// class members

  final UpdateStringList_updateStringList? updateStringList;

  // keywordargs constructor
  UpdateStringListResponse({this.updateStringList});
  static UpdateStringListResponse fromJson(JsonObject data) {
    final UpdateStringList_updateStringList? updateStringList_value;

    final JsonObject? updateStringList$raw = data['updateStringList'];
    if (updateStringList$raw != null) {
      updateStringList_value = UpdateStringList_updateStringList.fromJson(
        updateStringList$raw,
      );
    } else {
      updateStringList_value = null;
    }

    return UpdateStringListResponse(updateStringList: updateStringList_value);
  }

  UpdateStringListResponse updateWithJson(JsonObject data) {
    final UpdateStringList_updateStringList? updateStringList_value;
    if (data.containsKey('updateStringList')) {
      final JsonObject? updateStringList$raw = data['updateStringList'];
      if (updateStringList$raw != null) {
        updateStringList_value = UpdateStringList_updateStringList.fromJson(
          updateStringList$raw,
        );
      } else {
        updateStringList_value = null;
      }
    } else {
      updateStringList_value = updateStringList;
    }

    return UpdateStringListResponse(updateStringList: updateStringList_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UpdateStringListResponse &&
            other.updateStringList == updateStringList);
  }

  @override
  int get hashCode => updateStringList.hashCode;

  JsonObject toJson() {
    return {'updateStringList': updateStringList?.toJson()};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class UpdateStringList_updateStringList {
  /// class members

  final bool success;

  // keywordargs constructor
  UpdateStringList_updateStringList({required this.success});
  static UpdateStringList_updateStringList fromJson(JsonObject data) {
    final bool success_value;

    success_value = data['success'];

    return UpdateStringList_updateStringList(success: success_value);
  }

  UpdateStringList_updateStringList updateWithJson(JsonObject data) {
    final bool success_value;
    if (data.containsKey('success')) {
      success_value = data['success'];
    } else {
      success_value = success;
    }

    return UpdateStringList_updateStringList(success: success_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UpdateStringList_updateStringList &&
            other.success == success);
  }

  @override
  int get hashCode => success.hashCode;

  JsonObject toJson() {
    return {'success': success};
  }
}

// ------------ END OBJECT DEFINITIONS -------------

class RequestUpdateStringList extends Requestable {
  final UpdateStringListVariables variables;

  RequestUpdateStringList({required this.variables});

  @override
  Request toRequest() {
    JsonObject variablesJson = variables.toJson();
    return Request(
      query: r"""mutation UpdateStringList($strings: [String!]!) {
  updateStringList(strings: $strings) {
    success
  }
}""",
      variables: variablesJson,
      opType: OperationType.Mutation,
      StringopName: 'UpdateStringList',
    );
  }
}

class UpdateStringListVariables {
  final List<String> strings;

  UpdateStringListVariables({required this.strings});

  JsonObject toJson() {
    JsonObject data = {};

    data["strings"] = strings;

    return data;
  }

  UpdateStringListVariables updateWith({List<String>? strings}) {
    final List<String> strings$next;

    if (strings != null) {
      strings$next = strings;
    } else {
      strings$next = this.strings;
    }

    return UpdateStringListVariables(strings: strings$next);
  }
}
