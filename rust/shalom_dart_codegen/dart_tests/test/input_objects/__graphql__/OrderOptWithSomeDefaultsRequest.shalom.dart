// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";
import 'dart:async';

import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

typedef JsonObject = Map<String, dynamic>;

class OrderOptWithSomeDefaultsRequestResponse {
  /// class members

  OrderOptWithSomeDefaultsRequest_orderOptWithSomeDefaultsRequest?
  orderOptWithSomeDefaultsRequest;

  // keywordargs constructor
  OrderOptWithSomeDefaultsRequestResponse({
    this.orderOptWithSomeDefaultsRequest,
  });
  static OrderOptWithSomeDefaultsRequestResponse fromJson(
    JsonObject data,
    ShalomContext? context,
  ) {
    final OrderOptWithSomeDefaultsRequest_orderOptWithSomeDefaultsRequest?
    orderOptWithSomeDefaultsRequest_value;
    final orderOptWithSomeDefaultsRequest$raw =
        data["orderOptWithSomeDefaultsRequest"];

    orderOptWithSomeDefaultsRequest_value =
        orderOptWithSomeDefaultsRequest$raw == null
            ? null
            : OrderOptWithSomeDefaultsRequest_orderOptWithSomeDefaultsRequest.fromJson(
              orderOptWithSomeDefaultsRequest$raw,
              context,
            );

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

  int? quantity;

  String? name;

  double? price;

  // keywordargs constructor
  OrderOptWithSomeDefaultsRequest_orderOptWithSomeDefaultsRequest({
    this.quantity,

    this.name,

    this.price,
  });
  static OrderOptWithSomeDefaultsRequest_orderOptWithSomeDefaultsRequest
  fromJson(JsonObject data, ShalomContext? context) {
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
