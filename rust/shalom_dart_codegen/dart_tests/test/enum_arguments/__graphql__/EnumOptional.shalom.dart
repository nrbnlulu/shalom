// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;

class EnumOptionalResponse {
  /// class members

  final EnumOptional_updateOrderStatusOpt? updateOrderStatusOpt;

  // keywordargs constructor
  EnumOptionalResponse({this.updateOrderStatusOpt});
  static EnumOptionalResponse fromJson(JsonObject data) {
    final EnumOptional_updateOrderStatusOpt? updateOrderStatusOpt_value;

    final JsonObject? updateOrderStatusOpt$raw = data['updateOrderStatusOpt'];
    if (updateOrderStatusOpt$raw != null) {
      updateOrderStatusOpt_value = EnumOptional_updateOrderStatusOpt.fromJson(
        updateOrderStatusOpt$raw,
      );
    } else {
      updateOrderStatusOpt_value = null;
    }

    return EnumOptionalResponse(
      updateOrderStatusOpt: updateOrderStatusOpt_value,
    );
  }

  EnumOptionalResponse updateWithJson(JsonObject data) {
    final EnumOptional_updateOrderStatusOpt? updateOrderStatusOpt_value;
    if (data.containsKey('updateOrderStatusOpt')) {
      final JsonObject? updateOrderStatusOpt$raw = data['updateOrderStatusOpt'];
      if (updateOrderStatusOpt$raw != null) {
        updateOrderStatusOpt_value = EnumOptional_updateOrderStatusOpt.fromJson(
          updateOrderStatusOpt$raw,
        );
      } else {
        updateOrderStatusOpt_value = null;
      }
    } else {
      updateOrderStatusOpt_value = updateOrderStatusOpt;
    }

    return EnumOptionalResponse(
      updateOrderStatusOpt: updateOrderStatusOpt_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is EnumOptionalResponse &&
            other.updateOrderStatusOpt == updateOrderStatusOpt);
  }

  @override
  int get hashCode => updateOrderStatusOpt.hashCode;

  JsonObject toJson() {
    return {'updateOrderStatusOpt': updateOrderStatusOpt?.toJson()};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class EnumOptional_updateOrderStatusOpt {
  /// class members

  final Status? status;

  final int quantity;

  final String name;

  final double price;

  // keywordargs constructor
  EnumOptional_updateOrderStatusOpt({
    this.status,
    required this.quantity,
    required this.name,
    required this.price,
  });
  static EnumOptional_updateOrderStatusOpt fromJson(JsonObject data) {
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

    return EnumOptional_updateOrderStatusOpt(
      status: status_value,

      quantity: quantity_value,

      name: name_value,

      price: price_value,
    );
  }

  EnumOptional_updateOrderStatusOpt updateWithJson(JsonObject data) {
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

    return EnumOptional_updateOrderStatusOpt(
      status: status_value,

      quantity: quantity_value,

      name: name_value,

      price: price_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is EnumOptional_updateOrderStatusOpt &&
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

class RequestEnumOptional extends Requestable {
  final EnumOptionalVariables variables;

  RequestEnumOptional({required this.variables});

  @override
  Request toRequest() {
    JsonObject variablesJson = variables.toJson();
    return Request(
      query: r"""mutation EnumOptional($status: Status) {
  updateOrderStatusOpt(status: $status) {
    status
    quantity
    name
    price
  }
}""",
      variables: variablesJson,
      opType: OperationType.Mutation,
      StringopName: 'EnumOptional',
    );
  }
}

class EnumOptionalVariables {
  final Option<Status?> status;

  EnumOptionalVariables({this.status = const None()});

  JsonObject toJson() {
    JsonObject data = {};

    if (status.isSome()) {
      final $value = this.status.some();

      data["status"] = $value?.name;
    }

    return data;
  }

  EnumOptionalVariables updateWith({
    Option<Option<Status?>> status = const None(),
  }) {
    final Option<Status?> status$next;

    switch (status) {
      case Some(value: final updateData):
        status$next = updateData;
      case None():
        status$next = this.status;
    }

    return EnumOptionalVariables(status: status$next);
  }
}
