// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

typedef JsonObject = Map<String, dynamic>;

class OrderRequestResponse {
  /// class members

  final OrderRequest_orderRequest? orderRequest;

  // keywordargs constructor
  OrderRequestResponse({this.orderRequest});
  static OrderRequestResponse fromJson(JsonObject data) {
    final OrderRequest_orderRequest? orderRequest_value;
    final selection$raw = data["orderRequest"];

    orderRequest_value =
        selection$raw == null
            ? null
            : OrderRequest_orderRequest.fromJson(selection$raw);

    return OrderRequestResponse(orderRequest: orderRequest_value);
  }

  OrderRequestResponse updateWithJson(JsonObject data) {
    final OrderRequest_orderRequest? orderRequest_value;
    if (data.containsKey('orderRequest')) {
      final orderRequest$raw = data["orderRequest"];

      orderRequest_value =
          orderRequest$raw == null
              ? null
              : OrderRequest_orderRequest.fromJson(orderRequest$raw);
    } else {
      orderRequest_value = orderRequest;
    }

    return OrderRequestResponse(orderRequest: orderRequest_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is OrderRequestResponse && other.orderRequest == orderRequest);
  }

  @override
  int get hashCode => orderRequest.hashCode;

  JsonObject toJson() {
    return {'orderRequest': this.orderRequest?.toJson()};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class OrderRequest_orderRequest {
  /// class members

  final int? quantity;

  final String? name;

  final double? price;

  // keywordargs constructor
  OrderRequest_orderRequest({this.quantity, this.name, this.price});
  static OrderRequest_orderRequest fromJson(JsonObject data) {
    final int? quantity_value;
    final selection$raw = data["quantity"];

    quantity_value = selection$raw as int?;

    final String? name_value;
    final selection$raw = data["name"];

    name_value = selection$raw as String?;

    final double? price_value;
    final selection$raw = data["price"];

    price_value = selection$raw as double?;

    return OrderRequest_orderRequest(
      quantity: quantity_value,

      name: name_value,

      price: price_value,
    );
  }

  OrderRequest_orderRequest updateWithJson(JsonObject data) {
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

    return OrderRequest_orderRequest(
      quantity: quantity_value,

      name: name_value,

      price: price_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is OrderRequest_orderRequest &&
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

class RequestOrderRequest extends Requestable {
  final OrderRequestVariables variables;

  RequestOrderRequest({required this.variables});

  @override
  Request toRequest() {
    JsonObject variablesJson = variables.toJson();
    return Request(
      query: r"""mutation OrderRequest($order: Order!) {
  orderRequest(order: $order) {
    quantity
    name
    price
  }
}""",
      variables: variablesJson,
      opType: OperationType.Mutation,
      StringopName: 'OrderRequest',
    );
  }
}

class OrderRequestVariables {
  final Order order;

  OrderRequestVariables({required this.order});

  JsonObject toJson() {
    JsonObject data = {};

    data["order"] = this.order.toJson();

    return data;
  }

  OrderRequestVariables updateWith({Order? order}) {
    final Order order$next;

    if (order != null) {
      order$next = order;
    } else {
      order$next = this.order;
    }

    return OrderRequestVariables(order: order$next);
  }
}
