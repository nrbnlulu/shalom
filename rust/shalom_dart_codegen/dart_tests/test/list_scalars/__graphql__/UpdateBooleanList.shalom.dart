// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;

class UpdateBooleanListResponse {
  /// class members

  final UpdateBooleanList_updateBooleanList? updateBooleanList;

  // keywordargs constructor
  UpdateBooleanListResponse({this.updateBooleanList});
  static UpdateBooleanListResponse fromJson(JsonObject data) {
    final UpdateBooleanList_updateBooleanList? updateBooleanList_value;

    final JsonObject? updateBooleanList$raw = data['updateBooleanList'];
    if (updateBooleanList$raw != null) {
      updateBooleanList_value = UpdateBooleanList_updateBooleanList.fromJson(
        updateBooleanList$raw,
      );
    } else {
      updateBooleanList_value = null;
    }

    return UpdateBooleanListResponse(
      updateBooleanList: updateBooleanList_value,
    );
  }

  UpdateBooleanListResponse updateWithJson(JsonObject data) {
    final UpdateBooleanList_updateBooleanList? updateBooleanList_value;
    if (data.containsKey('updateBooleanList')) {
      final JsonObject? updateBooleanList$raw = data['updateBooleanList'];
      if (updateBooleanList$raw != null) {
        updateBooleanList_value = UpdateBooleanList_updateBooleanList.fromJson(
          updateBooleanList$raw,
        );
      } else {
        updateBooleanList_value = null;
      }
    } else {
      updateBooleanList_value = updateBooleanList;
    }

    return UpdateBooleanListResponse(
      updateBooleanList: updateBooleanList_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UpdateBooleanListResponse &&
            other.updateBooleanList == updateBooleanList);
  }

  @override
  int get hashCode => updateBooleanList.hashCode;

  JsonObject toJson() {
    return {'updateBooleanList': updateBooleanList?.toJson()};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class UpdateBooleanList_updateBooleanList {
  /// class members

  final bool success;

  // keywordargs constructor
  UpdateBooleanList_updateBooleanList({required this.success});
  static UpdateBooleanList_updateBooleanList fromJson(JsonObject data) {
    final bool success_value;

    success_value = data['success'];

    return UpdateBooleanList_updateBooleanList(success: success_value);
  }

  UpdateBooleanList_updateBooleanList updateWithJson(JsonObject data) {
    final bool success_value;
    if (data.containsKey('success')) {
      success_value = data['success'];
    } else {
      success_value = success;
    }

    return UpdateBooleanList_updateBooleanList(success: success_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UpdateBooleanList_updateBooleanList &&
            other.success == success);
  }

  @override
  int get hashCode => success.hashCode;

  JsonObject toJson() {
    return {'success': success};
  }
}

// ------------ END OBJECT DEFINITIONS -------------

class RequestUpdateBooleanList extends Requestable {
  final UpdateBooleanListVariables variables;

  RequestUpdateBooleanList({required this.variables});

  @override
  Request toRequest() {
    JsonObject variablesJson = variables.toJson();
    return Request(
      query: r"""mutation UpdateBooleanList($booleans: [Boolean!]!) {
  updateBooleanList(booleans: $booleans) {
    success
  }
}""",
      variables: variablesJson,
      opType: OperationType.Mutation,
      StringopName: 'UpdateBooleanList',
    );
  }
}

class UpdateBooleanListVariables {
  final List<bool> booleans;

  UpdateBooleanListVariables({required this.booleans});

  JsonObject toJson() {
    JsonObject data = {};

    data["booleans"] = booleans;

    return data;
  }

  UpdateBooleanListVariables updateWith({List<bool>? booleans}) {
    final List<bool> booleans$next;

    if (booleans != null) {
      booleans$next = booleans;
    } else {
      booleans$next = this.booleans;
    }

    return UpdateBooleanListVariables(booleans: booleans$next);
  }
}
