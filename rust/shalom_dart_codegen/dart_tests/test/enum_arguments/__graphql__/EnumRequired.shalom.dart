// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;

class EnumRequiredResponse {
  /// class members

  final EnumRequired_updateOrderStatus? updateOrderStatus;

  // keywordargs constructor
  EnumRequiredResponse({this.updateOrderStatus});
  static EnumRequiredResponse fromJson(JsonObject data) {
    final EnumRequired_updateOrderStatus? updateOrderStatus_value;

    final JsonObject? updateOrderStatus$raw = data['updateOrderStatus'];
    if (updateOrderStatus$raw != null) {
      updateOrderStatus_value = EnumRequired_updateOrderStatus.fromJson(
        updateOrderStatus$raw,
      );
    } else {
      updateOrderStatus_value = null;
    }

    return EnumRequiredResponse(updateOrderStatus: updateOrderStatus_value);
  }

  EnumRequiredResponse updateWithJson(JsonObject data) {
    final EnumRequired_updateOrderStatus? updateOrderStatus_value;
    if (data.containsKey('updateOrderStatus')) {
      final JsonObject? updateOrderStatus$raw = data['updateOrderStatus'];
      if (updateOrderStatus$raw != null) {
        updateOrderStatus_value = EnumRequired_updateOrderStatus.fromJson(
          updateOrderStatus$raw,
        );
      } else {
        updateOrderStatus_value = null;
      }
    } else {
      updateOrderStatus_value = updateOrderStatus;
    }

    return EnumRequiredResponse(updateOrderStatus: updateOrderStatus_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is EnumRequiredResponse &&
            other.updateOrderStatus == updateOrderStatus);
  }

  @override
  int get hashCode => updateOrderStatus.hashCode;

  JsonObject toJson() {
    return {'updateOrderStatus': updateOrderStatus?.toJson()};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class EnumRequired_updateOrderStatus {
  /// class members

  final Status? status;

  final int quantity;

  final String name;

  final double price;

  // keywordargs constructor
  EnumRequired_updateOrderStatus({
    this.status,
    required this.quantity,
    required this.name,
    required this.price,
  });
  static EnumRequired_updateOrderStatus fromJson(JsonObject data) {
    final Status? status_value;

    final String? status$raw = data['status'];
    if (status$raw != null) {
      status_value = Status.fromString(status$raw);
    } else {
      status_value = null;
    }

    final int quantity_value;

    quantity_value = data['quantity'];

    final String name_value;

    name_value = data['name'];

    final double price_value;

    price_value = data['price'];

    return EnumRequired_updateOrderStatus(
      status: status_value,

      quantity: quantity_value,

      name: name_value,

      price: price_value,
    );
  }

  EnumRequired_updateOrderStatus updateWithJson(JsonObject data) {
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

    return EnumRequired_updateOrderStatus(
      status: status_value,

      quantity: quantity_value,

      name: name_value,

      price: price_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is EnumRequired_updateOrderStatus &&
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

class RequestEnumRequired extends Requestable {
  final EnumRequiredVariables variables;

  RequestEnumRequired({required this.variables});

  @override
  Request toRequest() {
    JsonObject variablesJson = variables.toJson();
    return Request(
      query: r"""mutation EnumRequired($status: Status!) {
  updateOrderStatus(status: $status) {
    status
    quantity
    name
    price
  }
}""",
      variables: variablesJson,
      opType: OperationType.Mutation,
      StringopName: 'EnumRequired',
    );
  }
}

class EnumRequiredVariables {
  final Status status;

  EnumRequiredVariables({required this.status});

  JsonObject toJson() {
    JsonObject data = {};

    data["status"] = this.status.name;

    return data;
  }

  EnumRequiredVariables updateWith({Status? status}) {
    final Status status$next;

    if (status != null) {
      status$next = status;
    } else {
      status$next = this.status;
    }

    return EnumRequiredVariables(status: status$next);
  }
}
