import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types

class UpdateOrderResponse {
  /// class members

  final UpdateOrder_updateOrder? updateOrder;

  // keywordargs constructor
  UpdateOrderResponse({this.updateOrder});
  static UpdateOrderResponse fromJson(JsonObject data) {
    final UpdateOrder_updateOrder? updateOrder_value;

    final JsonObject? updateOrder$raw = data['updateOrder'];
    if (updateOrder$raw != null) {
      updateOrder_value = UpdateOrder_updateOrder.fromJson(updateOrder$raw);
    } else {
      updateOrder_value = null;
    }

    return UpdateOrderResponse(updateOrder: updateOrder_value);
  }

  UpdateOrderResponse updateWithJson(JsonObject data) {
    final UpdateOrder_updateOrder? updateOrder_value;
    if (data.containsKey('updateOrder')) {
      final JsonObject? updateOrder$raw = data['updateOrder'];
      if (updateOrder$raw != null) {
        updateOrder_value = UpdateOrder_updateOrder.fromJson(updateOrder$raw);
      } else {
        updateOrder_value = null;
      }
    } else {
      updateOrder_value = updateOrder;
    }

    return UpdateOrderResponse(updateOrder: updateOrder_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UpdateOrderResponse && other.updateOrder == updateOrder);
  }

  @override
  int get hashCode => updateOrder.hashCode;

  JsonObject toJson() {
    return {'updateOrder': updateOrder?.toJson()};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class UpdateOrder_updateOrder {
  /// class members

  final Status? status;

  final int quantity;

  final String name;

  final double price;

  // keywordargs constructor
  UpdateOrder_updateOrder({
    this.status,
    required this.quantity,
    required this.name,
    required this.price,
  });
  static UpdateOrder_updateOrder fromJson(JsonObject data) {
    final Status? status_value;

    final String? status$raw = data['status'];
    if (status$raw != null) {
      status_value = Status.fromString(status$raw);
    } else {
      status_value = null;
    }

    final int quantity_value = data['quantity'];

    final String name_value = data['name'];

    final double price_value = data['price'];

    return UpdateOrder_updateOrder(
      status: status_value,

      quantity: quantity_value,

      name: name_value,

      price: price_value,
    );
  }

  UpdateOrder_updateOrder updateWithJson(JsonObject data) {
    final Status? status_value;
    if (data.containsKey('status')) {
      final String? status$raw = data['status'];
      if (status$raw != null) {
        status_value = Status.fromString(status$raw);
      } else {
        status_value = null;
      }
    } else {
      status_value = status;
    }

    final int quantity_value;
    if (data.containsKey('quantity')) {
      quantity_value = data['quantity'];
    } else {
      quantity_value = quantity;
    }

    final String name_value;
    if (data.containsKey('name')) {
      name_value = data['name'];
    } else {
      name_value = name;
    }

    final double price_value;
    if (data.containsKey('price')) {
      price_value = data['price'];
    } else {
      price_value = price;
    }

    return UpdateOrder_updateOrder(
      status: status_value,

      quantity: quantity_value,

      name: name_value,

      price: price_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UpdateOrder_updateOrder &&
            other.status == status &&
            other.quantity == quantity &&
            other.name == name &&
            other.price == price);
  }

  @override
  int get hashCode => Object.hashAll([status, quantity, name, price]);

  JsonObject toJson() {
    return {
      'status': status?.name,

      'quantity': quantity,

      'name': name,

      'price': price,
    };
  }
}

// ------------ END OBJECT DEFINITIONS -------------

class RequestUpdateOrder extends Requestable {
  final UpdateOrderVariables variables;

  RequestUpdateOrder({required this.variables});

  @override
  Request toRequest() {
    JsonObject variablesJson = variables.toJson();
    return Request(
      query: r"""mutation UpdateOrder($order: OrderUpdate!) {
  updateOrder(order: $order) {
    status
    quantity
    name
    price
  }
}""",
      variables: variablesJson,
      opType: OperationType.Mutation,
      StringopName: 'UpdateOrder',
    );
  }
}

class UpdateOrderVariables {
  final OrderUpdate order;

  UpdateOrderVariables({required this.order});

  JsonObject toJson() {
    JsonObject data = {};

    data["order"] = order.toJson();

    return data;
  }
}
