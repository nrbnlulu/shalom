// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";
import 'dart:async';

import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

typedef JsonObject = Map<String, dynamic>;

class OptOrderRequestResponse {
  /// class members

  OptOrderRequest_optOrderRequest? optOrderRequest;

  // keywordargs constructor
  OptOrderRequestResponse({this.optOrderRequest});
  static OptOrderRequestResponse fromJson(
    JsonObject data,
    ShalomContext? context,
  ) {
    final OptOrderRequest_optOrderRequest? optOrderRequest_value;
    final optOrderRequest$raw = data["optOrderRequest"];

    optOrderRequest_value =
        optOrderRequest$raw == null
            ? null
            : OptOrderRequest_optOrderRequest.fromJson(
              optOrderRequest$raw,
              context,
            );

    return OptOrderRequestResponse(optOrderRequest: optOrderRequest_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is OptOrderRequestResponse &&
            other.optOrderRequest == optOrderRequest);
  }

  @override
  int get hashCode => optOrderRequest.hashCode;

  JsonObject toJson() {
    return {'optOrderRequest': this.optOrderRequest?.toJson()};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class OptOrderRequest_optOrderRequest {
  /// class members

  int? quantity;

  String? name;

  double? price;

  // keywordargs constructor
  OptOrderRequest_optOrderRequest({this.quantity, this.name, this.price});
  static OptOrderRequest_optOrderRequest fromJson(
    JsonObject data,
    ShalomContext? context,
  ) {
    final int? quantity_value;
    final quantity$raw = data["quantity"];

    quantity_value = quantity$raw as int?;

    final String? name_value;
    final name$raw = data["name"];

    name_value = name$raw as String?;

    final double? price_value;
    final price$raw = data["price"];

    price_value = price$raw as double?;

    return OptOrderRequest_optOrderRequest(
      quantity: quantity_value,

      name: name_value,

      price: price_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is OptOrderRequest_optOrderRequest &&
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

class RequestOptOrderRequest extends Requestable {
  final OptOrderRequestVariables variables;

  RequestOptOrderRequest({required this.variables});

  @override
  Request toRequest() {
    JsonObject variablesJson = variables.toJson();
    return Request(
      query: r"""mutation OptOrderRequest($order: Order) {
  optOrderRequest(order: $order) {
    quantity
    name
    price
  }
}""",
      variables: variablesJson,
      opType: OperationType.Mutation,
      opName: 'OptOrderRequest',
    );
  }
}

class OptOrderRequestVariables {
  final Option<Order?> order;

  OptOrderRequestVariables({this.order = const None()});

  JsonObject toJson() {
    JsonObject data = {};

    if (order.isSome()) {
      final value = this.order.some();
      data["order"] = value?.toJson();
    }

    return data;
  }

  OptOrderRequestVariables updateWith({
    Option<Option<Order?>> order = const None(),
  }) {
    final Option<Order?> order$next;

    switch (order) {
      case Some(value: final updateData):
        order$next = updateData;
      case None():
        order$next = this.order;
    }

    return OptOrderRequestVariables(order: order$next);
  }
}
