import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types

class GetOrderByStatusResponse {
  /// class members

  final GetOrderByStatus_getOrderByStatus? getOrderByStatus;

  // keywordargs constructor
  GetOrderByStatusResponse({this.getOrderByStatus});
  static GetOrderByStatusResponse fromJson(JsonObject data) {
    final GetOrderByStatus_getOrderByStatus? getOrderByStatus_value;

    final JsonObject? getOrderByStatus$raw = data['getOrderByStatus'];
    if (getOrderByStatus$raw != null) {
      getOrderByStatus_value = GetOrderByStatus_getOrderByStatus.fromJson(
        getOrderByStatus$raw,
      );
    } else {
      getOrderByStatus_value = null;
    }

    return GetOrderByStatusResponse(getOrderByStatus: getOrderByStatus_value);
  }

  GetOrderByStatusResponse updateWithJson(JsonObject data) {
    final GetOrderByStatus_getOrderByStatus? getOrderByStatus_value;
    if (data.containsKey('getOrderByStatus')) {
      final JsonObject? getOrderByStatus$raw = data['getOrderByStatus'];
      if (getOrderByStatus$raw != null) {
        getOrderByStatus_value = GetOrderByStatus_getOrderByStatus.fromJson(
          getOrderByStatus$raw,
        );
      } else {
        getOrderByStatus_value = null;
      }
    } else {
      getOrderByStatus_value = getOrderByStatus;
    }

    return GetOrderByStatusResponse(getOrderByStatus: getOrderByStatus_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetOrderByStatusResponse &&
            other.getOrderByStatus == getOrderByStatus);
  }

  @override
  int get hashCode => getOrderByStatus.hashCode;

  JsonObject toJson() {
    return {'getOrderByStatus': getOrderByStatus?.toJson()};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class GetOrderByStatus_getOrderByStatus {
  /// class members

  final Status? status;

  final int quantity;

  final String name;

  final double price;

  // keywordargs constructor
  GetOrderByStatus_getOrderByStatus({
    this.status,
    required this.quantity,
    required this.name,
    required this.price,
  });
  static GetOrderByStatus_getOrderByStatus fromJson(JsonObject data) {
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

    return GetOrderByStatus_getOrderByStatus(
      status: status_value,

      quantity: quantity_value,

      name: name_value,

      price: price_value,
    );
  }

  GetOrderByStatus_getOrderByStatus updateWithJson(JsonObject data) {
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

    return GetOrderByStatus_getOrderByStatus(
      status: status_value,

      quantity: quantity_value,

      name: name_value,

      price: price_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetOrderByStatus_getOrderByStatus &&
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

class RequestGetOrderByStatus extends Requestable {
  final GetOrderByStatusVariables variables;

  RequestGetOrderByStatus({required this.variables});

  @override
  Request toRequest() {
    JsonObject variablesJson = variables.toJson();
    return Request(
      query: r"""query GetOrderByStatus($status: Status = SENT) {
  getOrderByStatus(status: $status) {
    status
    quantity
    name
    price
  }
}""",
      variables: variablesJson,
      opType: OperationType.Query,
      StringopName: 'GetOrderByStatus',
    );
  }
}

class GetOrderByStatusVariables {
  final Status? status;

  GetOrderByStatusVariables({this.status = Status.SENT});

  JsonObject toJson() {
    JsonObject data = {};

    data["status"] = status?.name;

    return data;
  }
}
