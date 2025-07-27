// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";
import 'dart:async';

import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

typedef JsonObject = Map<String, dynamic>;

class OrderOptWithNullDefaultsRequestResponse {
  /// class members

  OrderOptWithNullDefaultsRequest_orderOptWithNullDefaultsRequest?
  orderOptWithNullDefaultsRequest;

  // keywordargs constructor
  OrderOptWithNullDefaultsRequestResponse({
    this.orderOptWithNullDefaultsRequest,
  });
  static OrderOptWithNullDefaultsRequestResponse fromJson(
    JsonObject data, {
    ShalomContext? context,
  }) {
    final OrderOptWithNullDefaultsRequest_orderOptWithNullDefaultsRequest?
    orderOptWithNullDefaultsRequest_value;
    final orderOptWithNullDefaultsRequest$raw =
        data["orderOptWithNullDefaultsRequest"];
    orderOptWithNullDefaultsRequest_value =
        orderOptWithNullDefaultsRequest$raw == null
            ? null
            : OrderOptWithNullDefaultsRequest_orderOptWithNullDefaultsRequest.fromJson(
              orderOptWithNullDefaultsRequest$raw,
              context: context,
            );

    return OrderOptWithNullDefaultsRequestResponse(
      orderOptWithNullDefaultsRequest: orderOptWithNullDefaultsRequest_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is OrderOptWithNullDefaultsRequestResponse &&
            other.orderOptWithNullDefaultsRequest ==
                orderOptWithNullDefaultsRequest);
  }

  @override
  int get hashCode => orderOptWithNullDefaultsRequest.hashCode;

  JsonObject toJson() {
    return {
      'orderOptWithNullDefaultsRequest':
          this.orderOptWithNullDefaultsRequest?.toJson(),
    };
  }
}

// ------------ OBJECT DEFINITIONS -------------

class OrderOptWithNullDefaultsRequest_orderOptWithNullDefaultsRequest {
  /// class members

  int? quantity;

  String? name;

  double? price;

  // keywordargs constructor
  OrderOptWithNullDefaultsRequest_orderOptWithNullDefaultsRequest({
    this.quantity,

    this.name,

    this.price,
  });
  static OrderOptWithNullDefaultsRequest_orderOptWithNullDefaultsRequest
  fromJson(JsonObject data, {ShalomContext? context}) {
    final int? quantity_value;
    final quantity$raw = data["quantity"];
    quantity_value = quantity$raw as int?;

    final String? name_value;
    final name$raw = data["name"];
    name_value = name$raw as String?;

    final double? price_value;
    final price$raw = data["price"];
    price_value = price$raw as double?;

    return OrderOptWithNullDefaultsRequest_orderOptWithNullDefaultsRequest(
      quantity: quantity_value,

      name: name_value,

      price: price_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is OrderOptWithNullDefaultsRequest_orderOptWithNullDefaultsRequest &&
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

class RequestOrderOptWithNullDefaultsRequest extends Requestable {
  final OrderOptWithNullDefaultsRequestVariables variables;

  RequestOrderOptWithNullDefaultsRequest({required this.variables});

  @override
  Request toRequest() {
    JsonObject variablesJson = variables.toJson();
    return Request(
      query:
          r"""mutation OrderOptWithNullDefaultsRequest($order: OrderOptWithNullDefaults!) {
  orderOptWithNullDefaultsRequest(order: $order) {
    quantity
    name
    price
  }
}""",
      variables: variablesJson,
      opType: OperationType.Mutation,
      opName: 'OrderOptWithNullDefaultsRequest',
    );
  }
}

class OrderOptWithNullDefaultsRequestVariables {
  final OrderOptWithNullDefaults order;

  OrderOptWithNullDefaultsRequestVariables({required this.order});

  JsonObject toJson() {
    JsonObject data = {};

    data["order"] = this.order.toJson();

    return data;
  }

  OrderOptWithNullDefaultsRequestVariables updateWith({
    OrderOptWithNullDefaults? order,
  }) {
    final OrderOptWithNullDefaults order$next;

    if (order != null) {
      order$next = order;
    } else {
      order$next = this.order;
    }

    return OrderOptWithNullDefaultsRequestVariables(order: order$next);
  }
}
