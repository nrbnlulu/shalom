// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;

class GetIntResponse {
  /// class members

  final int intField;

  // keywordargs constructor
  GetIntResponse({required this.intField});
  static GetIntResponse fromJson(JsonObject data) {
    final int intField_value;

    intField_value = data['intField'];

    return GetIntResponse(intField: intField_value);
  }

  GetIntResponse updateWithJson(JsonObject data) {
    final int intField_value;
    if (data.containsKey('intField')) {
      intField_value = data['intField'];
    } else {
      intField_value = intField;
    }

    return GetIntResponse(intField: intField_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetIntResponse && other.intField == intField);
  }

  @override
  int get hashCode => intField.hashCode;

  JsonObject toJson() {
    return {'intField': intField};
  }
}

// ------------ OBJECT DEFINITIONS -------------

// ------------ END OBJECT DEFINITIONS -------------

class RequestGetInt extends Requestable {
  RequestGetInt();

  @override
  Request toRequest() {
    JsonObject variablesJson = {};
    return Request(
      query: r"""query GetInt {
  intField
}""",
      variables: variablesJson,
      opType: OperationType.Query,
      StringopName: 'GetInt',
    );
  }
}

// ------------ Node DEFINITIONS -------------

class GetIntNode extends Node {
  GetIntResponse? _obj;
  GetIntNode({required super.id});

  @override
  void updateStoreWithRaw(JsonObject raw, NodeManager manager) {
    _obj = GetIntResponse.fromJson(raw);
    manager.addOrUpdateNode(this);
  }

  @override
  void updateWithJson(JsonObject newData) {
    if (_obj != null) {
      _obj = _obj?.updateWithJson(newData);
    } else {
      _obj = GetIntResponse.fromJson(newData);
    }
    notifyListeners();
  }

  @override
  void setObj(JsonObject? data) {
    if (data != null) {
      _obj = GetIntResponse.fromJson(data);
    }
  }

  @override
  JsonObject? data() {
    final data = _obj?.toJson();
    return data;
  }

  GetIntResponse? get obj {
    return _obj;
  }
}

// ------------ END Node DEFINITIONS -------------
