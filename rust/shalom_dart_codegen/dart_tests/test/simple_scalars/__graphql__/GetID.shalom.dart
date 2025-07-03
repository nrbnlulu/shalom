// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;

class GetIDResponse {
  /// class members

  final String id;

  // keywordargs constructor
  GetIDResponse({required this.id});
  static GetIDResponse fromJson(JsonObject data) {
    final String id_value;

    id_value = data['id'];

    return GetIDResponse(id: id_value);
  }

  GetIDResponse updateWithJson(JsonObject data) {
    final String id_value;
    if (data.containsKey('id')) {
      id_value = data['id'];
    } else {
      id_value = id;
    }

    return GetIDResponse(id: id_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) || (other is GetIDResponse && other.id == id);
  }

  @override
  int get hashCode => id.hashCode;

  JsonObject toJson() {
    return {'id': id};
  }
}

// ------------ OBJECT DEFINITIONS -------------

// ------------ END OBJECT DEFINITIONS -------------

class RequestGetID extends Requestable {
  RequestGetID();

  @override
  Request toRequest() {
    JsonObject variablesJson = {};
    return Request(
      query: r"""query GetID {
  id
}""",
      variables: variablesJson,
      opType: OperationType.Query,
      StringopName: 'GetID',
    );
  }
}

// ------------ Node DEFINITIONS -------------

class GetIDNode extends Node {
  GetIDResponse? _obj;
  GetIDNode({required super.id});

  @override
  void updateStoreWithRaw(JsonObject raw, NodeManager manager) {
    _obj = GetIDResponse.fromJson(raw);
    manager.addOrUpdateNode(this);
  }

  @override
  void updateWithJson(JsonObject newData) {
    if (_obj != null) {
      _obj = _obj?.updateWithJson(newData);
    } else {
      _obj = GetIDResponse.fromJson(newData);
    }
    notifyListeners();
  }

  @override
  void setObj(JsonObject? data) {
    if (data != null) {
      _obj = GetIDResponse.fromJson(data);
    }
  }

  @override
  JsonObject? data() {
    final data = _obj?.toJson();
    return data;
  }

  GetIDResponse? get obj {
    return _obj;
  }
}

// ------------ END Node DEFINITIONS -------------
