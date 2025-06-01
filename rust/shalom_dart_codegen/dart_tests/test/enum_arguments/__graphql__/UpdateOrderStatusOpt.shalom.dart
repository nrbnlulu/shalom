import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types

class UpdateOrderStatusOptResponse {
  /// class members

  final UpdateOrderStatusOpt_updateOrderStatusOpt? updateOrderStatusOpt;

  // keywordargs constructor
  UpdateOrderStatusOptResponse({this.updateOrderStatusOpt});
  static UpdateOrderStatusOptResponse fromJson(JsonObject data) {
    final UpdateOrderStatusOpt_updateOrderStatusOpt? updateOrderStatusOpt_value;

    final JsonObject? updateOrderStatusOpt$raw = data['updateOrderStatusOpt'];
    if (updateOrderStatusOpt$raw != null) {
      updateOrderStatusOpt_value =
          UpdateOrderStatusOpt_updateOrderStatusOpt.fromJson(
            updateOrderStatusOpt$raw,
          );
    } else {
      updateOrderStatusOpt_value = null;
    }

    return UpdateOrderStatusOptResponse(
      updateOrderStatusOpt: updateOrderStatusOpt_value,
    );
  }

  UpdateOrderStatusOptResponse updateWithJson(JsonObject data) {
    final UpdateOrderStatusOpt_updateOrderStatusOpt? updateOrderStatusOpt_value;
    if (data.containsKey('updateOrderStatusOpt')) {
      final JsonObject? updateOrderStatusOpt$raw = data['updateOrderStatusOpt'];
      if (updateOrderStatusOpt$raw != null) {
        updateOrderStatusOpt_value =
            UpdateOrderStatusOpt_updateOrderStatusOpt.fromJson(
              updateOrderStatusOpt$raw,
            );
      } else {
        updateOrderStatusOpt_value = null;
      }
    } else {
      updateOrderStatusOpt_value = updateOrderStatusOpt;
    }

    return UpdateOrderStatusOptResponse(
      updateOrderStatusOpt: updateOrderStatusOpt_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UpdateOrderStatusOptResponse &&
            other.updateOrderStatusOpt == updateOrderStatusOpt);
  }

  @override
  int get hashCode => updateOrderStatusOpt.hashCode;

  JsonObject toJson() {
    return {'updateOrderStatusOpt': updateOrderStatusOpt?.toJson()};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class UpdateOrderStatusOpt_updateOrderStatusOpt {
  /// class members

  final Status? status;

  final int quantity;

  final String name;

  final double price;

  // keywordargs constructor
  UpdateOrderStatusOpt_updateOrderStatusOpt({
    this.status,
    required this.quantity,
    required this.name,
    required this.price,
  });
  static UpdateOrderStatusOpt_updateOrderStatusOpt fromJson(JsonObject data) {
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

    return UpdateOrderStatusOpt_updateOrderStatusOpt(
      status: status_value,

      quantity: quantity_value,

      name: name_value,

      price: price_value,
    );
  }

  UpdateOrderStatusOpt_updateOrderStatusOpt updateWithJson(JsonObject data) {
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

    return UpdateOrderStatusOpt_updateOrderStatusOpt(
      status: status_value,

      quantity: quantity_value,

      name: name_value,

      price: price_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UpdateOrderStatusOpt_updateOrderStatusOpt &&
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

class RequestUpdateOrderStatusOpt extends Requestable {
  final UpdateOrderStatusOptVariables variables;

  RequestUpdateOrderStatusOpt({required this.variables});

  @override
  Request toRequest() {
    JsonObject variablesJson = variables.toJson();
    return Request(
      query: r"""mutation UpdateOrderStatusOpt($status: Status) {
  updateOrderStatusOpt(status: $status) {
    status
    quantity
    name
    price
  }
}""",
      variables: variablesJson,
      opType: OperationType.Mutation,
      StringopName: 'UpdateOrderStatusOpt',
    );
  }
}

class UpdateOrderStatusOptVariables {
  final Option<Status?> status;

  UpdateOrderStatusOptVariables({this.status = const None()});

  JsonObject toJson() {
    JsonObject data = {};

    if (status.isSome()) {
      data["status"] = status.some()?.name;
    }

    return data;
  }
}
