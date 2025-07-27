// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";
import 'dart:async';

import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

typedef JsonObject = Map<String, dynamic>;

class EnumInputObjectRequiredResponse {
  /// class members

  EnumInputObjectRequired_updateOrder? updateOrder;

  // keywordargs constructor
  EnumInputObjectRequiredResponse({this.updateOrder});
  static EnumInputObjectRequiredResponse fromJson(
    JsonObject data, {
    ShalomContext? context,
  }) {
    final EnumInputObjectRequired_updateOrder? updateOrder_value;
    final updateOrder$raw = data["updateOrder"];
    updateOrder_value =
        updateOrder$raw == null
            ? null
            : EnumInputObjectRequired_updateOrder.fromJson(
              updateOrder$raw,
              context: context,
            );

    return EnumInputObjectRequiredResponse(updateOrder: updateOrder_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is EnumInputObjectRequiredResponse &&
            other.updateOrder == updateOrder);
  }

  @override
  int get hashCode => updateOrder.hashCode;

  JsonObject toJson() {
    return {'updateOrder': this.updateOrder?.toJson()};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class EnumInputObjectRequired_updateOrder {
  /// class members

  Status? status;

  int quantity;

  String name;

  double price;

  // keywordargs constructor
  EnumInputObjectRequired_updateOrder({
    this.status,

    required this.quantity,

    required this.name,

    required this.price,
  });
  static EnumInputObjectRequired_updateOrder fromJson(
    JsonObject data, {
    ShalomContext? context,
  }) {
    final Status? status_value;
    final status$raw = data["status"];
    status_value = status$raw == null ? null : Status.fromString(status$raw);

    final int quantity_value;
    final quantity$raw = data["quantity"];
    quantity_value = quantity$raw as int;

    final String name_value;
    final name$raw = data["name"];
    name_value = name$raw as String;

    final double price_value;
    final price$raw = data["price"];
    price_value = price$raw as double;

    return EnumInputObjectRequired_updateOrder(
      status: status_value,

      quantity: quantity_value,

      name: name_value,

      price: price_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is EnumInputObjectRequired_updateOrder &&
            other.status == status &&
            other.quantity == quantity &&
            other.name == name &&
            other.price == price);
  }

  @override
  int get hashCode => Object.hashAll([status, quantity, name, price]);

  JsonObject toJson() {
    return {
      'status': this.status?.name,

      'quantity': this.quantity,

      'name': this.name,

      'price': this.price,
    };
  }
}

// ------------ END OBJECT DEFINITIONS -------------

class RequestEnumInputObjectRequired extends Requestable {
  final EnumInputObjectRequiredVariables variables;

  RequestEnumInputObjectRequired({required this.variables});

  @override
  Request toRequest() {
    JsonObject variablesJson = variables.toJson();
    return Request(
      query: r"""mutation EnumInputObjectRequired($order: OrderUpdate!) {
  updateOrder(order: $order) {
    status
    quantity
    name
    price
  }
}""",
      variables: variablesJson,
      opType: OperationType.Mutation,
      opName: 'EnumInputObjectRequired',
    );
  }
}

class EnumInputObjectRequiredVariables {
  final OrderUpdate order;

  EnumInputObjectRequiredVariables({required this.order});

  JsonObject toJson() {
    JsonObject data = {};

    data["order"] = this.order.toJson();

    return data;
  }

  EnumInputObjectRequiredVariables updateWith({OrderUpdate? order}) {
    final OrderUpdate order$next;

    if (order != null) {
      order$next = order;
    } else {
      order$next = this.order;
    }

    return EnumInputObjectRequiredVariables(order: order$next);
  }
}
