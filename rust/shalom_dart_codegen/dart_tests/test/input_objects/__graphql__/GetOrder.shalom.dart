// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;

class GetOrderResponse {
  /// class members

  final GetOrder_getOrder? getOrder;

  // keywordargs constructor
  GetOrderResponse({this.getOrder});
  static GetOrderResponse fromJson(JsonObject data) {
    final GetOrder_getOrder? getOrder_value;

    final JsonObject? getOrder$raw = data['getOrder'];
    if (getOrder$raw != null) {
      getOrder_value = GetOrder_getOrder.fromJson(getOrder$raw);
    } else {
      getOrder_value = null;
    }

    return GetOrderResponse(getOrder: getOrder_value);
  }

  GetOrderResponse updateWithJson(JsonObject data) {
    final GetOrder_getOrder? getOrder_value;
    if (data.containsKey('getOrder')) {
      final JsonObject? getOrder$raw = data['getOrder'];
      if (getOrder$raw != null) {
        getOrder_value = GetOrder_getOrder.fromJson(getOrder$raw);
      } else {
        getOrder_value = null;
      }
    } else {
      getOrder_value = getOrder;
    }

    return GetOrderResponse(getOrder: getOrder_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetOrderResponse && other.getOrder == getOrder);
  }

  @override
  int get hashCode => getOrder.hashCode;

  JsonObject toJson() {
    return {'getOrder': getOrder?.toJson()};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class GetOrder_getOrder {
  /// class members

  final int? quantity;

  final String? name;

  final double? price;

  // keywordargs constructor
  GetOrder_getOrder({this.quantity, this.name, this.price});
  static GetOrder_getOrder fromJson(JsonObject data) {
    final int? quantity_value;

    quantity_value = data['quantity'];

    final String? name_value;

    name_value = data['name'];

    final double? price_value;

    price_value = data['price'];

    return GetOrder_getOrder(
      quantity: quantity_value,

      name: name_value,

      price: price_value,
    );
  }

  GetOrder_getOrder updateWithJson(JsonObject data) {
    final int? quantity_value;
    if (data.containsKey('quantity')) {
      quantity_value = data['quantity'];
    } else {
      quantity_value = quantity;
    }

    final String? name_value;
    if (data.containsKey('name')) {
      name_value = data['name'];
    } else {
      name_value = name;
    }

    final double? price_value;
    if (data.containsKey('price')) {
      price_value = data['price'];
    } else {
      price_value = price;
    }

    return GetOrder_getOrder(
      quantity: quantity_value,

      name: name_value,

      price: price_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetOrder_getOrder &&
            other.quantity == quantity &&
            other.name == name &&
            other.price == price);
  }

  @override
  int get hashCode => Object.hashAll([quantity, name, price]);

  JsonObject toJson() {
    return {'quantity': quantity, 'name': name, 'price': price};
  }
}

// ------------ END OBJECT DEFINITIONS -------------

class RequestGetOrder extends Requestable {
  final GetOrderVariables variables;

  RequestGetOrder({required this.variables});

  @override
  Request toRequest() {
    JsonObject variablesJson = variables.toJson();
    return Request(
      query: r"""query GetOrder($id: ID!, $order: Order) {
  getOrder(id: $id, order: $order) {
    quantity
    name
    price
  }
}""",
      variables: variablesJson,
      opType: OperationType.Query,
      StringopName: 'GetOrder',
    );
  }
}

class GetOrderVariables {
  final String id;

  final Option<Order?> order;

  GetOrderVariables({required this.id, this.order = const None()});

  JsonObject toJson() {
    JsonObject data = {};

    data["id"] = id;

    if (order.isSome()) {
      final value = order.some();

      data["order"] = value?.toJson();
    }

    return data;
  }

  GetOrderVariables updateWith({
    String? id,

    Option<Option<Order?>> order = const None(),
  }) {
    final String id$next;

    if (id != null) {
      id$next = id;
    } else {
      id$next = this.id;
    }

    final Option<Order?> order$next;

    switch (order) {
      case Some(value: final data):
        order$next = data;
      case None():
        order$next = this.order;
    }

    return GetOrderVariables(id: id$next, order: order$next);
  }
}
