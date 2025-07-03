// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;

class GetFloatOptionalResponse {
  /// class members

  final double? floatOptional;

  // keywordargs constructor
  GetFloatOptionalResponse({this.floatOptional});
  static GetFloatOptionalResponse fromJson(JsonObject data) {
    final double? floatOptional_value;

    floatOptional_value = data['floatOptional'];

    return GetFloatOptionalResponse(floatOptional: floatOptional_value);
  }

  GetFloatOptionalResponse updateWithJson(JsonObject data) {
    final double? floatOptional_value;
    if (data.containsKey('floatOptional')) {
      floatOptional_value = data['floatOptional'];
    } else {
      floatOptional_value = floatOptional;
    }

    return GetFloatOptionalResponse(floatOptional: floatOptional_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetFloatOptionalResponse &&
            other.floatOptional == floatOptional);
  }

  @override
  int get hashCode => floatOptional.hashCode;

  JsonObject toJson() {
    return {'floatOptional': floatOptional};
  }
}

// ------------ OBJECT DEFINITIONS -------------

// ------------ END OBJECT DEFINITIONS -------------

class RequestGetFloatOptional extends Requestable {
  RequestGetFloatOptional();

  @override
  Request toRequest() {
    JsonObject variablesJson = {};
    return Request(
      query: r"""query GetFloatOptional {
  floatOptional
}""",
      variables: variablesJson,
      opType: OperationType.Query,
      StringopName: 'GetFloatOptional',
    );
  }
}

// ------------ Node DEFINITIONS -------------

class GetFloatOptionalNode extends Node {
  GetFloatOptionalResponse? _obj;
  GetFloatOptionalNode({required super.id});

  @override
  void updateStoreWithRaw(JsonObject raw, NodeManager manager) {
    _obj = GetFloatOptionalResponse.fromJson(raw);
    manager.addOrUpdateNode(this);
  }

  @override
  void updateWithJson(JsonObject newData) {
    if (_obj != null) {
      _obj = _obj?.updateWithJson(newData);
    } else {
      _obj = GetFloatOptionalResponse.fromJson(newData);
    }
    notifyListeners();
  }

  @override
  void setObj(JsonObject? data) {
    if (data != null) {
      _obj = GetFloatOptionalResponse.fromJson(data);
    }
  }

  @override
  JsonObject? data() {
    final data = _obj?.toJson();
    return data;
  }

  GetFloatOptionalResponse? get obj {
    return _obj;
  }
}

// ------------ END Node DEFINITIONS -------------
