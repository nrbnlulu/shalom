// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

typedef JsonObject = Map<String, dynamic>;

class OrderOptRequestResponse {
  /// class members

  final OrderOptRequest_orderOptRequest? orderOptRequest;

  // keywordargs constructor
  OrderOptRequestResponse({this.orderOptRequest});
  static OrderOptRequestResponse fromJson(JsonObject data) {
    final OrderOptRequest_orderOptRequest? orderOptRequest_value;
    final orderOptRequest$raw = data["orderOptRequest"];
    orderOptRequest_value =
        orderOptRequest$raw == null
            ? null
            : OrderOptRequest_orderOptRequest.fromJson(orderOptRequest$raw);

    return OrderOptRequestResponse(orderOptRequest: orderOptRequest_value);
  }

  OrderOptRequestResponse updateWithJson(JsonObject data) {
    final OrderOptRequest_orderOptRequest? orderOptRequest_value;
    if (data.containsKey('orderOptRequest')) {
      final orderOptRequest$raw = data["orderOptRequest"];
      orderOptRequest_value =
          orderOptRequest$raw == null
              ? null
              : OrderOptRequest_orderOptRequest.fromJson(orderOptRequest$raw);
    } else {
      orderOptRequest_value = orderOptRequest;
    }

    return OrderOptRequestResponse(orderOptRequest: orderOptRequest_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is OrderOptRequestResponse &&
            other.orderOptRequest == orderOptRequest);
  }

  @override
  int get hashCode => orderOptRequest.hashCode;

  JsonObject toJson() {
    return {'orderOptRequest': this.orderOptRequest?.toJson()};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class OrderOptRequest_orderOptRequest {
  /// class members

  final int? quantity;

  final String? name;

  final double? price;

  // keywordargs constructor
  OrderOptRequest_orderOptRequest({this.quantity, this.name, this.price});
  static OrderOptRequest_orderOptRequest fromJson(JsonObject data) {
    final int? quantity_value;
    final quantity$raw = data["quantity"];
    quantity_value = quantity$raw as int?;

    final String? name_value;
    final name$raw = data["name"];
    name_value = name$raw as String?;

    final double? price_value;
    final price$raw = data["price"];
    price_value = price$raw as double?;

    return OrderOptRequest_orderOptRequest(
      quantity: quantity_value,

      name: name_value,

      price: price_value,
    );
  }

  OrderOptRequest_orderOptRequest updateWithJson(JsonObject data) {
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

    return OrderOptRequest_orderOptRequest(
      quantity: quantity_value,

      name: name_value,

      price: price_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is OrderOptRequest_orderOptRequest &&
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

class RequestOrderOptRequest extends Requestable {
  final OrderOptRequestVariables variables;

  RequestOrderOptRequest({required this.variables});

  @override
  Request toRequest() {
    JsonObject variablesJson = variables.toJson();
    return Request(
      query: r"""mutation OrderOptRequest($order: OrderOpt!) {
  orderOptRequest(order: $order) {
    quantity
    name
    price
  }
}""",
      variables: variablesJson,
      opType: OperationType.Mutation,
      opName: 'OrderOptRequest',
    );
  }
}

class OrderOptRequestVariables {
  final OrderOpt order;

  OrderOptRequestVariables({required this.order});

  JsonObject toJson() {
    JsonObject data = {};

    data["order"] = this.order.toJson();

    return data;
  }

  OrderOptRequestVariables updateWith({OrderOpt? order}) {
    final OrderOpt order$next;

    if (order != null) {
      order$next = order;
    } else {
      order$next = this.order;
    }

    return OrderOptRequestVariables(order: order$next);
  }
}
