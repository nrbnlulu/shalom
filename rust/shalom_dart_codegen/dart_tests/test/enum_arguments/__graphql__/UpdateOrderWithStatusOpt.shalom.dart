import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types

class UpdateOrderWithStatusOptResponse {
  /// class members

  final UpdateOrderWithStatusOpt_updateOrderWithStatusOpt?
  updateOrderWithStatusOpt;

  // keywordargs constructor
  UpdateOrderWithStatusOptResponse({this.updateOrderWithStatusOpt});
  static UpdateOrderWithStatusOptResponse fromJson(JsonObject data) {
    final UpdateOrderWithStatusOpt_updateOrderWithStatusOpt?
    updateOrderWithStatusOpt_value;

    final JsonObject? updateOrderWithStatusOpt$raw =
        data['updateOrderWithStatusOpt'];
    if (updateOrderWithStatusOpt$raw != null) {
      updateOrderWithStatusOpt_value =
          UpdateOrderWithStatusOpt_updateOrderWithStatusOpt.fromJson(
            updateOrderWithStatusOpt$raw,
          );
    } else {
      updateOrderWithStatusOpt_value = null;
    }

    return UpdateOrderWithStatusOptResponse(
      updateOrderWithStatusOpt: updateOrderWithStatusOpt_value,
    );
  }

  UpdateOrderWithStatusOptResponse updateWithJson(JsonObject data) {
    final UpdateOrderWithStatusOpt_updateOrderWithStatusOpt?
    updateOrderWithStatusOpt_value;
    if (data.containsKey('updateOrderWithStatusOpt')) {
      final JsonObject? updateOrderWithStatusOpt$raw =
          data['updateOrderWithStatusOpt'];
      if (updateOrderWithStatusOpt$raw != null) {
        updateOrderWithStatusOpt_value =
            UpdateOrderWithStatusOpt_updateOrderWithStatusOpt.fromJson(
              updateOrderWithStatusOpt$raw,
            );
      } else {
        updateOrderWithStatusOpt_value = null;
      }
    } else {
      updateOrderWithStatusOpt_value = updateOrderWithStatusOpt;
    }

    return UpdateOrderWithStatusOptResponse(
      updateOrderWithStatusOpt: updateOrderWithStatusOpt_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UpdateOrderWithStatusOptResponse &&
            other.updateOrderWithStatusOpt == updateOrderWithStatusOpt);
  }

  @override
  int get hashCode => updateOrderWithStatusOpt.hashCode;

  JsonObject toJson() {
    return {'updateOrderWithStatusOpt': updateOrderWithStatusOpt?.toJson()};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class UpdateOrderWithStatusOpt_updateOrderWithStatusOpt {
  /// class members

  final Status? status;

  final int quantity;

  final String name;

  final double price;

  // keywordargs constructor
  UpdateOrderWithStatusOpt_updateOrderWithStatusOpt({
    this.status,
    required this.quantity,
    required this.name,
    required this.price,
  });
  static UpdateOrderWithStatusOpt_updateOrderWithStatusOpt fromJson(
    JsonObject data,
  ) {
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

    return UpdateOrderWithStatusOpt_updateOrderWithStatusOpt(
      status: status_value,

      quantity: quantity_value,

      name: name_value,

      price: price_value,
    );
  }

  UpdateOrderWithStatusOpt_updateOrderWithStatusOpt updateWithJson(
    JsonObject data,
  ) {
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

    return UpdateOrderWithStatusOpt_updateOrderWithStatusOpt(
      status: status_value,

      quantity: quantity_value,

      name: name_value,

      price: price_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UpdateOrderWithStatusOpt_updateOrderWithStatusOpt &&
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

class RequestUpdateOrderWithStatusOpt extends Requestable {
  final UpdateOrderWithStatusOptVariables variables;

  RequestUpdateOrderWithStatusOpt({required this.variables});

  @override
  Request toRequest() {
    JsonObject variablesJson = variables.toJson();
    return Request(
      query:
          r"""mutation UpdateOrderWithStatusOpt($order: OrderUpdateStatusOpt!) {
  updateOrderWithStatusOpt(order: $order) {
    status
    quantity
    name
    price
  }
}""",
      variables: variablesJson,
      opType: OperationType.Mutation,
      StringopName: 'UpdateOrderWithStatusOpt',
    );
  }
}

class UpdateOrderWithStatusOptVariables {
  final OrderUpdateStatusOpt order;

  UpdateOrderWithStatusOptVariables({required this.order});

  JsonObject toJson() {
    JsonObject data = {};

    data["order"] = order.toJson();

    return data;
  }
}
