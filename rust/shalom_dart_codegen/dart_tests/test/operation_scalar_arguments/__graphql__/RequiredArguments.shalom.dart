// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;

class RequiredArgumentsResponse {
  /// class members

  final RequiredArguments_product? product;

  // keywordargs constructor
  RequiredArgumentsResponse({this.product});
  static RequiredArgumentsResponse fromJson(JsonObject data) {
    final RequiredArguments_product? product_value;

    final JsonObject? product$raw = data['product'];
    if (product$raw != null) {
      product_value = RequiredArguments_product.fromJson(product$raw);
    } else {
      product_value = null;
    }

    return RequiredArgumentsResponse(product: product_value);
  }

  RequiredArgumentsResponse updateWithJson(JsonObject data) {
    final RequiredArguments_product? product_value;
    if (data.containsKey('product')) {
      final JsonObject? product$raw = data['product'];
      if (product$raw != null) {
        product_value = RequiredArguments_product.fromJson(product$raw);
      } else {
        product_value = null;
      }
    } else {
      product_value = product;
    }

    return RequiredArgumentsResponse(product: product_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is RequiredArgumentsResponse && other.product == product);
  }

  @override
  int get hashCode => product.hashCode;

  JsonObject toJson() {
    return {'product': product?.toJson()};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class RequiredArguments_product {
  /// class members

  final String id;

  final String name;

  // keywordargs constructor
  RequiredArguments_product({required this.id, required this.name});
  static RequiredArguments_product fromJson(JsonObject data) {
    final String id_value;

    id_value = data['id'];

    final String name_value;

    name_value = data['name'];

    return RequiredArguments_product(id: id_value, name: name_value);
  }

  RequiredArguments_product updateWithJson(JsonObject data) {
    final String id_value;
    if (data.containsKey('id')) {
      id_value = data['id'];
    } else {
      id_value = id;
    }

    final String name_value;
    if (data.containsKey('name')) {
      name_value = data['name'];
    } else {
      name_value = name;
    }

    return RequiredArguments_product(id: id_value, name: name_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is RequiredArguments_product &&
            other.id == id &&
            other.name == name);
  }

  @override
  int get hashCode => Object.hashAll([id, name]);

  JsonObject toJson() {
    return {'id': id, 'name': name};
  }
}

// ------------ END OBJECT DEFINITIONS -------------

class RequestRequiredArguments extends Requestable {
  final RequiredArgumentsVariables variables;

  RequestRequiredArguments({required this.variables});

  @override
  Request toRequest() {
    JsonObject variablesJson = variables.toJson();
    return Request(
      query: r"""query RequiredArguments($id: ID!) {
  product(id: $id) {
    id
    name
  }
}""",
      variables: variablesJson,
      opType: OperationType.Query,
      StringopName: 'RequiredArguments',
    );
  }
}

class RequiredArgumentsVariables {
  final String id;

  RequiredArgumentsVariables({required this.id});

  JsonObject toJson() {
    JsonObject data = {};

    data["id"] = id;

    return data;
  }

  RequiredArgumentsVariables updateWith({String? id}) {
    final String id$next;

    if (id != null) {
      id$next = id;
    } else {
      id$next = this.id;
    }

    return RequiredArgumentsVariables(id: id$next);
  }
}

// ------------ Node DEFINITIONS -------------

class RequiredArgumentsNode extends Node {
  RequiredArgumentsResponse? _obj;
  RequiredArgumentsNode({required super.id});

  @override
  void updateStoreWithRaw(JsonObject raw, NodeManager manager) {
    _obj = RequiredArgumentsResponse.fromJson(raw);
    manager.addOrUpdateNode(this);
  }

  @override
  void updateWithJson(JsonObject newData) {
    if (_obj != null) {
      _obj = _obj?.updateWithJson(newData);
    } else {
      _obj = RequiredArgumentsResponse.fromJson(newData);
    }
    notifyListeners();
  }

  @override
  void setObj(JsonObject? data) {
    if (data != null) {
      _obj = RequiredArgumentsResponse.fromJson(data);
    }
  }

  @override
  JsonObject? data() {
    final data = _obj?.toJson();
    return data;
  }

  RequiredArgumentsResponse? get obj {
    return _obj;
  }
}

// ------------ END Node DEFINITIONS -------------
