import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types

class UpdateOrderStatusResponse {
  /// class members

  final UpdateOrderStatus_updateOrderStatus? updateOrderStatus;

  // keywordargs constructor
  UpdateOrderStatusResponse({this.updateOrderStatus});
  static UpdateOrderStatusResponse fromJson(JsonObject data) {
    final UpdateOrderStatus_updateOrderStatus? updateOrderStatus_value;

    final JsonObject? updateOrderStatus$raw = data['updateOrderStatus'];
    if (updateOrderStatus$raw != null) {
      updateOrderStatus_value = UpdateOrderStatus_updateOrderStatus.fromJson(
        updateOrderStatus$raw,
      );
    } else {
      updateOrderStatus_value = null;
    }

    return UpdateOrderStatusResponse(
      updateOrderStatus: updateOrderStatus_value,
    );
  }

  UpdateOrderStatusResponse updateWithJson(JsonObject data) {
    final UpdateOrderStatus_updateOrderStatus? updateOrderStatus_value;
    if (data.containsKey('updateOrderStatus')) {
      final JsonObject? updateOrderStatus$raw = data['updateOrderStatus'];
      if (updateOrderStatus$raw != null) {
        updateOrderStatus_value = UpdateOrderStatus_updateOrderStatus.fromJson(
          updateOrderStatus$raw,
        );
      } else {
        updateOrderStatus_value = null;
      }
    } else {
      updateOrderStatus_value = updateOrderStatus;
    }

    return UpdateOrderStatusResponse(
      updateOrderStatus: updateOrderStatus_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UpdateOrderStatusResponse &&
            other.updateOrderStatus == updateOrderStatus);
  }

  @override
  int get hashCode => updateOrderStatus.hashCode;

  JsonObject toJson() {
    return {'updateOrderStatus': updateOrderStatus?.toJson()};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class UpdateOrderStatus_updateOrderStatus {
  /// class members

  final Status? status;

  final int quantity;

  final String name;

  final double price;

  // keywordargs constructor
  UpdateOrderStatus_updateOrderStatus({
    this.status,
    required this.quantity,
    required this.name,
    required this.price,
  });
  static UpdateOrderStatus_updateOrderStatus fromJson(JsonObject data) {
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

    return UpdateOrderStatus_updateOrderStatus(
      status: status_value,

      quantity: quantity_value,

      name: name_value,

      price: price_value,
    );
  }

  UpdateOrderStatus_updateOrderStatus updateWithJson(JsonObject data) {
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

    return UpdateOrderStatus_updateOrderStatus(
      status: status_value,

      quantity: quantity_value,

      name: name_value,

      price: price_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UpdateOrderStatus_updateOrderStatus &&
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

class RequestUpdateOrderStatus extends Requestable {
  final UpdateOrderStatusVariables variables;

  RequestUpdateOrderStatus({required this.variables});

  @override
  Request toRequest() {
    JsonObject variablesJson = variables.toJson();
    return Request(
      query: r"""mutation UpdateOrderStatus($status: Status!) {
  updateOrderStatus(status: $status) {
    status
    quantity
    name
    price
  }
}""",
      variables: variablesJson,
      opType: OperationType.Mutation,
      StringopName: 'UpdateOrderStatus',
    );
  }
}

class UpdateOrderStatusVariables {
  final Status status;

  UpdateOrderStatusVariables({required this.status});

  JsonObject toJson() {
    JsonObject data = {};

    data["status"] = status.name;

    return data;
  }
}
