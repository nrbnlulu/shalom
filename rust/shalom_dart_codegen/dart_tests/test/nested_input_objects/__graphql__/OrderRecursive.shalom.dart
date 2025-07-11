// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

typedef JsonObject = Map<String, dynamic>;

class OrderRecursiveResponse {
  /// class members

  final OrderRecursive_orderRecursive? orderRecursive;

  // keywordargs constructor
  OrderRecursiveResponse({this.orderRecursive});

  static OrderRecursiveResponse fromJson(JsonObject data) {
    final OrderRecursive_orderRecursive? orderRecursive_value;
    final orderRecursive$raw = data["orderRecursive"];
    orderRecursive_value =
        orderRecursive$raw == null
            ? null
            : OrderRecursive_orderRecursive.fromJson(orderRecursive$raw);

    return OrderRecursiveResponse(orderRecursive: orderRecursive_value);
  }

  OrderRecursiveResponse updateWithJson(JsonObject data) {
    final OrderRecursive_orderRecursive? orderRecursive_value;
    if (data.containsKey('orderRecursive')) {
      final orderRecursive$raw = data["orderRecursive"];
      orderRecursive_value =
          orderRecursive$raw == null
              ? null
              : OrderRecursive_orderRecursive.fromJson(orderRecursive$raw);
    } else {
      orderRecursive_value = orderRecursive;
    }

    return OrderRecursiveResponse(orderRecursive: orderRecursive_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is OrderRecursiveResponse &&
            other.orderRecursive == orderRecursive);
  }

  @override
  int get hashCode => orderRecursive.hashCode;

  JsonObject toJson() {
    return {'orderRecursive': this.orderRecursive?.toJson()};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class OrderRecursive_orderRecursive {
  /// class members

  final int? quantity;

  final String? name;

  final double? price;

  // keywordargs constructor
  OrderRecursive_orderRecursive({this.quantity, this.name, this.price});

  static OrderRecursive_orderRecursive fromJson(JsonObject data) {
    final int? quantity_value;
    final quantity$raw = data["quantity"];
    quantity_value = quantity$raw as int?;

    final String? name_value;
    final name$raw = data["name"];
    name_value = name$raw as String?;

    final double? price_value;
    final price$raw = data["price"];
    price_value = price$raw as double?;

    return OrderRecursive_orderRecursive(
      quantity: quantity_value,

      name: name_value,

      price: price_value,
    );
  }

  OrderRecursive_orderRecursive updateWithJson(JsonObject data) {
    final int? quantity_value;
    if (data.containsKey('quantity')) {
      final quantity$raw = data["quantity"];
      quantity_value = quantity$raw as int?;
    } else {
      quantity_value = quantity;
    }

    final String? name_value;
    if (data.containsKey('name')) {
      final name$raw = data["name"];
      name_value = name$raw as String?;
    } else {
      name_value = name;
    }

    final double? price_value;
    if (data.containsKey('price')) {
      final price$raw = data["price"];
      price_value = price$raw as double?;
    } else {
      price_value = price;
    }

    return OrderRecursive_orderRecursive(
      quantity: quantity_value,

      name: name_value,

      price: price_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is OrderRecursive_orderRecursive &&
            other.quantity == quantity &&
            other.name == name &&
            other.price == price);
  }

  @override
  int get hashCode => Object.hashAll([quantity, name, price]);

  JsonObject toJson() {
    return {'quantity': this.quantity, 'name': this.name, 'price': this.price};
  }
}

// ------------ END OBJECT DEFINITIONS -------------

class RequestOrderRecursive extends Requestable {
  final OrderRecursiveVariables variables;

  RequestOrderRecursive({required this.variables});

  @override
  Request toRequest() {
    JsonObject variablesJson = variables.toJson();
    return Request(
      query: r"""mutation OrderRecursive($order: OrderRecursive) {
  orderRecursive(order: $order) {
    quantity
    name
    price
  }
}""",
      variables: variablesJson,
      opType: OperationType.Mutation,
      opName: 'OrderRecursive',
    );
  }
}

class OrderRecursiveVariables {
  final Option<OrderRecursive?> order;

  OrderRecursiveVariables({this.order = const None()});

  JsonObject toJson() {
    JsonObject data = {};

    if (order.isSome()) {
      final value = this.order.some();
      data["order"] = value?.toJson();
    }

    return data;
  }

  OrderRecursiveVariables updateWith({
    Option<Option<OrderRecursive?>> order = const None(),
  }) {
    final Option<OrderRecursive?> order$next;

    switch (order) {
      case Some(value: final updateData):
        order$next = updateData;
      case None():
        order$next = this.order;
    }

    return OrderRecursiveVariables(order: order$next);
  }
}
