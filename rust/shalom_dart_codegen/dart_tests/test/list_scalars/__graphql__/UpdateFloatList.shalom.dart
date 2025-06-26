// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;

class UpdateFloatListResponse {
  /// class members

  final UpdateFloatList_updateFloatList? updateFloatList;

  // keywordargs constructor
  UpdateFloatListResponse({this.updateFloatList});
  static UpdateFloatListResponse fromJson(JsonObject data) {
    final UpdateFloatList_updateFloatList? updateFloatList_value;

    final JsonObject? updateFloatList$raw = data['updateFloatList'];
    if (updateFloatList$raw != null) {
      updateFloatList_value = UpdateFloatList_updateFloatList.fromJson(
        updateFloatList$raw,
      );
    } else {
      updateFloatList_value = null;
    }

    return UpdateFloatListResponse(updateFloatList: updateFloatList_value);
  }

  UpdateFloatListResponse updateWithJson(JsonObject data) {
    final UpdateFloatList_updateFloatList? updateFloatList_value;
    if (data.containsKey('updateFloatList')) {
      final JsonObject? updateFloatList$raw = data['updateFloatList'];
      if (updateFloatList$raw != null) {
        updateFloatList_value = UpdateFloatList_updateFloatList.fromJson(
          updateFloatList$raw,
        );
      } else {
        updateFloatList_value = null;
      }
    } else {
      updateFloatList_value = updateFloatList;
    }

    return UpdateFloatListResponse(updateFloatList: updateFloatList_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UpdateFloatListResponse &&
            other.updateFloatList == updateFloatList);
  }

  @override
  int get hashCode => updateFloatList.hashCode;

  JsonObject toJson() {
    return {'updateFloatList': updateFloatList?.toJson()};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class UpdateFloatList_updateFloatList {
  /// class members

  final bool success;

  // keywordargs constructor
  UpdateFloatList_updateFloatList({required this.success});
  static UpdateFloatList_updateFloatList fromJson(JsonObject data) {
    final bool success_value;

    success_value = data['success'];

    return UpdateFloatList_updateFloatList(success: success_value);
  }

  UpdateFloatList_updateFloatList updateWithJson(JsonObject data) {
    final bool success_value;
    if (data.containsKey('success')) {
      success_value = data['success'];
    } else {
      success_value = success;
    }

    return UpdateFloatList_updateFloatList(success: success_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UpdateFloatList_updateFloatList && other.success == success);
  }

  @override
  int get hashCode => success.hashCode;

  JsonObject toJson() {
    return {'success': success};
  }
}

// ------------ END OBJECT DEFINITIONS -------------

class RequestUpdateFloatList extends Requestable {
  final UpdateFloatListVariables variables;

  RequestUpdateFloatList({required this.variables});

  @override
  Request toRequest() {
    JsonObject variablesJson = variables.toJson();
    return Request(
      query: r"""mutation UpdateFloatList($floats: [Float!]!) {
  updateFloatList(floats: $floats) {
    success
  }
}""",
      variables: variablesJson,
      opType: OperationType.Mutation,
      StringopName: 'UpdateFloatList',
    );
  }
}

class UpdateFloatListVariables {
  final List<double> floats;

  UpdateFloatListVariables({required this.floats});

  JsonObject toJson() {
    JsonObject data = {};

    data["floats"] = floats;

    return data;
  }

  UpdateFloatListVariables updateWith({List<double>? floats}) {
    final List<double> floats$next;

    if (floats != null) {
      floats$next = floats;
    } else {
      floats$next = this.floats;
    }

    return UpdateFloatListVariables(floats: floats$next);
  }
}
