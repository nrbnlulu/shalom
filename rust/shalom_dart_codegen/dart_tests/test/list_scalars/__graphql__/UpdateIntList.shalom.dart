// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;

class UpdateIntListResponse {
  /// class members

  final UpdateIntList_updateIntList? updateIntList;

  // keywordargs constructor
  UpdateIntListResponse({this.updateIntList});
  static UpdateIntListResponse fromJson(JsonObject data) {
    final UpdateIntList_updateIntList? updateIntList_value;

    final JsonObject? updateIntList$raw = data['updateIntList'];
    if (updateIntList$raw != null) {
      updateIntList_value = UpdateIntList_updateIntList.fromJson(
        updateIntList$raw,
      );
    } else {
      updateIntList_value = null;
    }

    return UpdateIntListResponse(updateIntList: updateIntList_value);
  }

  UpdateIntListResponse updateWithJson(JsonObject data) {
    final UpdateIntList_updateIntList? updateIntList_value;
    if (data.containsKey('updateIntList')) {
      final JsonObject? updateIntList$raw = data['updateIntList'];
      if (updateIntList$raw != null) {
        updateIntList_value = UpdateIntList_updateIntList.fromJson(
          updateIntList$raw,
        );
      } else {
        updateIntList_value = null;
      }
    } else {
      updateIntList_value = updateIntList;
    }

    return UpdateIntListResponse(updateIntList: updateIntList_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UpdateIntListResponse &&
            other.updateIntList == updateIntList);
  }

  @override
  int get hashCode => updateIntList.hashCode;

  JsonObject toJson() {
    return {'updateIntList': updateIntList?.toJson()};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class UpdateIntList_updateIntList {
  /// class members

  final bool success;

  // keywordargs constructor
  UpdateIntList_updateIntList({required this.success});
  static UpdateIntList_updateIntList fromJson(JsonObject data) {
    final bool success_value;

    success_value = data['success'];

    return UpdateIntList_updateIntList(success: success_value);
  }

  UpdateIntList_updateIntList updateWithJson(JsonObject data) {
    final bool success_value;
    if (data.containsKey('success')) {
      success_value = data['success'];
    } else {
      success_value = success;
    }

    return UpdateIntList_updateIntList(success: success_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UpdateIntList_updateIntList && other.success == success);
  }

  @override
  int get hashCode => success.hashCode;

  JsonObject toJson() {
    return {'success': success};
  }
}

// ------------ END OBJECT DEFINITIONS -------------

class RequestUpdateIntList extends Requestable {
  final UpdateIntListVariables variables;

  RequestUpdateIntList({required this.variables});

  @override
  Request toRequest() {
    JsonObject variablesJson = variables.toJson();
    return Request(
      query: r"""mutation UpdateIntList($ints: [Int]) {
  updateIntList(ints: $ints) {
    success
  }
}""",
      variables: variablesJson,
      opType: OperationType.Mutation,
      StringopName: 'UpdateIntList',
    );
  }
}

class UpdateIntListVariables {
  final Option<List<int?>?> ints;

  UpdateIntListVariables({this.ints = const None()});

  JsonObject toJson() {
    JsonObject data = {};

    if (ints.isSome()) {
      final value = ints.some();

      data["ints"] = value;
    } else {
      // This is a list type. Serialize None() to null.
      data["ints"] = null;
    }

    return data;
  }

  UpdateIntListVariables updateWith({
    Option<Option<List<int?>?>> ints = const None(),
  }) {
    final Option<List<int?>?> ints$next;

    switch (ints) {
      case Some(value: final data):
        ints$next = data;
      case None():
        ints$next = this.ints;
    }

    return UpdateIntListVariables(ints: ints$next);
  }
}
