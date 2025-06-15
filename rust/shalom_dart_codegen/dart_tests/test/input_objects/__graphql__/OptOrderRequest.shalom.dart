import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types

class OptOrderRequestResponse {
  /// class members

  final OptOrderRequest_optOrderRequest? optOrderRequest;

  // keywordargs constructor
  OptOrderRequestResponse({this.optOrderRequest});
  static OptOrderRequestResponse fromJson(JsonObject data) {
    final OptOrderRequest_optOrderRequest? optOrderRequest_value;

    final JsonObject? optOrderRequest$raw = data['optOrderRequest'];
    if (optOrderRequest$raw != null) {
      optOrderRequest_value = OptOrderRequest_optOrderRequest.fromJson(
        optOrderRequest$raw,
      );
    } else {
      optOrderRequest_value = null;
    }

    return OptOrderRequestResponse(optOrderRequest: optOrderRequest_value);
  }

  OptOrderRequestResponse updateWithJson(JsonObject data) {
    final OptOrderRequest_optOrderRequest? optOrderRequest_value;
    if (data.containsKey('optOrderRequest')) {
      final JsonObject? optOrderRequest$raw = data['optOrderRequest'];
      if (optOrderRequest$raw != null) {
        optOrderRequest_value = OptOrderRequest_optOrderRequest.fromJson(
          optOrderRequest$raw,
        );
      } else {
        optOrderRequest_value = null;
      }
    } else {
      optOrderRequest_value = optOrderRequest;
    }

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
    return {'optOrderRequest': optOrderRequest?.toJson()};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class OptOrderRequest_optOrderRequest {
  /// class members

  final int? quantity;

  final String? name;

  final double? price;

  // keywordargs constructor
  OptOrderRequest_optOrderRequest({this.quantity, this.name, this.price});
  static OptOrderRequest_optOrderRequest fromJson(JsonObject data) {
    final int? quantity_value = data['quantity'];

    final String? name_value = data['name'];

    final double? price_value = data['price'];

    return OptOrderRequest_optOrderRequest(
      quantity: quantity_value,

      name: name_value,

      price: price_value,
    );
  }

  OptOrderRequest_optOrderRequest updateWithJson(JsonObject data) {
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
    return {'quantity': quantity, 'name': name, 'price': price};
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
      StringopName: 'OptOrderRequest',
    );
  }
}

class OptOrderRequestVariables {
  final Option<Order?> order;

  OptOrderRequestVariables({this.order = const None()});

  JsonObject toJson() {
    JsonObject data = {};

    if (order.isSome()) {
      data["order"] = order.some()?.toJson();
    }

    return data;
  }

  OptOrderRequestVariables updateWith({
    Option<Option<Order?>> order = const None(),
  }) {
    final Option<Order?> order$next;

    switch (order) {
      case Some(value: final data):
        order$next = data;
      case None():
        order$next = this.order;
    }

    return OptOrderRequestVariables(order: order$next);
  }
}
