// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;

class GetIDOptionalResponse {
  /// class members

  final String? idOptional;

  // keywordargs constructor
  GetIDOptionalResponse({this.idOptional});
  static GetIDOptionalResponse fromJson(JsonObject data) {
    final String? idOptional_value;

    idOptional_value = data['idOptional'];

    return GetIDOptionalResponse(idOptional: idOptional_value);
  }

  GetIDOptionalResponse updateWithJson(JsonObject data) {
    final String? idOptional_value;
    if (data.containsKey('idOptional')) {
      idOptional_value = data['idOptional'];
    } else {
      idOptional_value = idOptional;
    }

    return GetIDOptionalResponse(idOptional: idOptional_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetIDOptionalResponse && other.idOptional == idOptional);
  }

  @override
  int get hashCode => idOptional.hashCode;

  JsonObject toJson() {
    return {'idOptional': idOptional};
  }
}

// ------------ OBJECT DEFINITIONS -------------

// ------------ END OBJECT DEFINITIONS -------------

class RequestGetIDOptional extends Requestable {
  RequestGetIDOptional();

  @override
  Request toRequest() {
    JsonObject variablesJson = {};
    return Request(
      query: r"""query GetIDOptional {
  idOptional
}""",
      variables: variablesJson,
      opType: OperationType.Query,
      StringopName: 'GetIDOptional',
    );
  }
}

// ------------ Node DEFINITIONS -------------

class GetIDOptionalNode extends Node {
  GetIDOptionalResponse? _obj;
  GetIDOptionalNode({required super.id});

  @override
  void updateStoreWithRaw(JsonObject raw, NodeManager manager) {
    _obj = GetIDOptionalResponse.fromJson(raw);
    manager.addOrUpdateNode(this);
  }

  @override
  void updateWithJson(JsonObject newData) {
    if (_obj != null) {
      _obj = _obj?.updateWithJson(newData);
    } else {
      _obj = GetIDOptionalResponse.fromJson(newData);
    }
    notifyListeners();
  }

  @override
  void setObj(JsonObject? data) {
    if (data != null) {
      _obj = GetIDOptionalResponse.fromJson(data);
    }
  }

  @override
  JsonObject? data() {
    final data = _obj?.toJson();
    return data;
  }

  GetIDOptionalResponse? get obj {
    return _obj;
  }
}

// ------------ END Node DEFINITIONS -------------
