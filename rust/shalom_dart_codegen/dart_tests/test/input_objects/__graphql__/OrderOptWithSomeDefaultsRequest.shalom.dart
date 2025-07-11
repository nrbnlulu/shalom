// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

typedef JsonObject = Map<String, dynamic>;

class OrderOptWithSomeDefaultsRequestResponse {
  /// class members

  final OrderOptWithSomeDefaultsRequest_orderOptWithSomeDefaultsRequest?
  orderOptWithSomeDefaultsRequest;

  // keywordargs constructor
  OrderOptWithSomeDefaultsRequestResponse({
    this.orderOptWithSomeDefaultsRequest,
  });
  static OrderOptWithSomeDefaultsRequestResponse fromJson(JsonObject data) {
    final OrderOptWithSomeDefaultsRequest_orderOptWithSomeDefaultsRequest?
    orderOptWithSomeDefaultsRequest_value;
    final orderOptWithSomeDefaultsRequest$raw =
        data["orderOptWithSomeDefaultsRequest"];
    orderOptWithSomeDefaultsRequest_value =
        orderOptWithSomeDefaultsRequest$raw == null
            ? null
            : OrderOptWithSomeDefaultsRequest_orderOptWithSomeDefaultsRequest.fromJson(
              orderOptWithSomeDefaultsRequest$raw,
            );

    return OrderOptWithSomeDefaultsRequestResponse(
      orderOptWithSomeDefaultsRequest: orderOptWithSomeDefaultsRequest_value,
    );
  }

  OrderOptWithSomeDefaultsRequestResponse updateWithJson(JsonObject data) {
    final OrderOptWithSomeDefaultsRequest_orderOptWithSomeDefaultsRequest?
    orderOptWithSomeDefaultsRequest_value;
    if (data.containsKey('orderOptWithSomeDefaultsRequest')) {
      final orderOptWithSomeDefaultsRequest$raw =
          data["orderOptWithSomeDefaultsRequest"];
      orderOptWithSomeDefaultsRequest_value =
          orderOptWithSomeDefaultsRequest$raw == null
              ? null
              : OrderOptWithSomeDefaultsRequest_orderOptWithSomeDefaultsRequest.fromJson(
                orderOptWithSomeDefaultsRequest$raw,
              );
    } else {
      orderOptWithSomeDefaultsRequest_value = orderOptWithSomeDefaultsRequest;
    }

    return OrderOptWithSomeDefaultsRequestResponse(
      orderOptWithSomeDefaultsRequest: orderOptWithSomeDefaultsRequest_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is OrderOptWithSomeDefaultsRequestResponse &&
            other.orderOptWithSomeDefaultsRequest ==
                orderOptWithSomeDefaultsRequest);
  }

  @override
  int get hashCode => orderOptWithSomeDefaultsRequest.hashCode;

  JsonObject toJson() {
    return {
      'orderOptWithSomeDefaultsRequest':
          this.orderOptWithSomeDefaultsRequest?.toJson(),
    };
  }
}

// ------------ OBJECT DEFINITIONS -------------

class OrderOptWithSomeDefaultsRequest_orderOptWithSomeDefaultsRequest {
  /// class members

  final int? quantity;

  final String? name;

  final double? price;

  // keywordargs constructor
  OrderOptWithSomeDefaultsRequest_orderOptWithSomeDefaultsRequest({
    this.quantity,

    this.name,

    this.price,
  });
  static OrderOptWithSomeDefaultsRequest_orderOptWithSomeDefaultsRequest
  fromJson(JsonObject data) {
    final int? quantity_value;
    final quantity$raw = data["quantity"];
    quantity_value = quantity$raw as int?;

    final String? name_value;
    final name$raw = data["name"];
    name_value = name$raw as String?;

    final double? price_value;
    final price$raw = data["price"];
    price_value = price$raw as double?;

    return OrderOptWithSomeDefaultsRequest_orderOptWithSomeDefaultsRequest(
      quantity: quantity_value,

      name: name_value,

      price: price_value,
    );
  }

  OrderOptWithSomeDefaultsRequest_orderOptWithSomeDefaultsRequest
  updateWithJson(JsonObject data) {
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

    return OrderOptWithSomeDefaultsRequest_orderOptWithSomeDefaultsRequest(
      quantity: quantity_value,

      name: name_value,

      price: price_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is OrderOptWithSomeDefaultsRequest_orderOptWithSomeDefaultsRequest &&
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

class RequestOrderOptWithSomeDefaultsRequest extends Requestable {
  final OrderOptWithSomeDefaultsRequestVariables variables;

  RequestOrderOptWithSomeDefaultsRequest({required this.variables});

  @override
  Request toRequest() {
    JsonObject variablesJson = variables.toJson();
    return Request(
      query:
          r"""mutation OrderOptWithSomeDefaultsRequest($order: OrderOptWithSomeDefaults!) {
  orderOptWithSomeDefaultsRequest(order: $order) {
    quantity
    name
    price
  }
}""",
      variables: variablesJson,
      opType: OperationType.Mutation,
      opName: 'OrderOptWithSomeDefaultsRequest',
    );
  }
}

class OrderOptWithSomeDefaultsRequestVariables {
  final OrderOptWithSomeDefaults order;

  OrderOptWithSomeDefaultsRequestVariables({required this.order});

  JsonObject toJson() {
    JsonObject data = {};

    data["order"] = this.order.toJson();

    return data;
  }

  OrderOptWithSomeDefaultsRequestVariables updateWith({
    OrderOptWithSomeDefaults? order,
  }) {
    final OrderOptWithSomeDefaults order$next;

    if (order != null) {
      order$next = order;
    } else {
      order$next = this.order;
    }

    return OrderOptWithSomeDefaultsRequestVariables(order: order$next);
  }
}
