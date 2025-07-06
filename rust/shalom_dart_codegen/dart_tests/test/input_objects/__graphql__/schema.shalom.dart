// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, unnecessary_this

import 'package:shalom_core/shalom_core.dart';

// ------------ Enum DEFINITIONS -------------

// ------------ END Enum DEFINITIONS -------------
// ------------ Input DEFINITIONS -------------

class Order {
  final String name;

  final double price;

  final int quantity;

  Order({required this.name, required this.price, required this.quantity});

  JsonObject toJson() {
    JsonObject data = {};

    data["name"] = this.name;

    data["price"] = this.price;

    data["quantity"] = this.quantity;

    return data;
  }

  Order updateWith({String? name, double? price, int? quantity}) {
    final String name$next;

    if (name != null) {
      name$next = name;
    } else {
      name$next = this.name;
    }

    final double price$next;

    if (price != null) {
      price$next = price;
    } else {
      price$next = this.price;
    }

    final int quantity$next;

    if (quantity != null) {
      quantity$next = quantity;
    } else {
      quantity$next = this.quantity;
    }

    return Order(name: name$next, price: price$next, quantity: quantity$next);
  }
}

class OrderOpt {
  final Option<String?> name;

  final Option<double?> price;

  final Option<int?> quantity;

  OrderOpt({
    this.name = const None(),

    this.price = const None(),

    this.quantity = const None(),
  });

  JsonObject toJson() {
    JsonObject data = {};

    if (name.isSome()) {
      final value = this.name.some();

      data["name"] = value;
    }

    if (price.isSome()) {
      final value = this.price.some();

      data["price"] = value;
    }

    if (quantity.isSome()) {
      final value = this.quantity.some();

      data["quantity"] = value;
    }

    return data;
  }

  OrderOpt updateWith({
    Option<Option<String?>> name = const None(),

    Option<Option<double?>> price = const None(),

    Option<Option<int?>> quantity = const None(),
  }) {
    final Option<String?> name$next;

    switch (name) {
      case Some(value: final updateData):
        name$next = updateData;
      case None():
        name$next = this.name;
    }

    final Option<double?> price$next;

    switch (price) {
      case Some(value: final updateData):
        price$next = updateData;
      case None():
        price$next = this.price;
    }

    final Option<int?> quantity$next;

    switch (quantity) {
      case Some(value: final updateData):
        quantity$next = updateData;
      case None():
        quantity$next = this.quantity;
    }

    return OrderOpt(
      name: name$next,

      price: price$next,

      quantity: quantity$next,
    );
  }
}

class OrderOptWithNullDefaults {
  final String? name;

  final double? price;

  final int? quantity;

  OrderOptWithNullDefaults({this.name, this.price, this.quantity});

  JsonObject toJson() {
    JsonObject data = {};

    data["name"] = this.name;

    data["price"] = this.price;

    data["quantity"] = this.quantity;

    return data;
  }

  OrderOptWithNullDefaults updateWith({
    Option<String?> name = const None(),

    Option<double?> price = const None(),

    Option<int?> quantity = const None(),
  }) {
    final String? name$next;

    switch (name) {
      case Some(value: final updateData):
        name$next = updateData;
      case None():
        name$next = this.name;
    }

    final double? price$next;

    switch (price) {
      case Some(value: final updateData):
        price$next = updateData;
      case None():
        price$next = this.price;
    }

    final int? quantity$next;

    switch (quantity) {
      case Some(value: final updateData):
        quantity$next = updateData;
      case None():
        quantity$next = this.quantity;
    }

    return OrderOptWithNullDefaults(
      name: name$next,

      price: price$next,

      quantity: quantity$next,
    );
  }
}

class OrderOptWithSomeDefaults {
  final String? name;

  final double? price;

  final int? quantity;

  OrderOptWithSomeDefaults({
    this.name = "burgers",

    this.price = 10.0,

    this.quantity = 2,
  });

  JsonObject toJson() {
    JsonObject data = {};

    data["name"] = this.name;

    data["price"] = this.price;

    data["quantity"] = this.quantity;

    return data;
  }

  OrderOptWithSomeDefaults updateWith({
    Option<String?> name = const None(),

    Option<double?> price = const None(),

    Option<int?> quantity = const None(),
  }) {
    final String? name$next;

    switch (name) {
      case Some(value: final updateData):
        name$next = updateData;
      case None():
        name$next = this.name;
    }

    final double? price$next;

    switch (price) {
      case Some(value: final updateData):
        price$next = updateData;
      case None():
        price$next = this.price;
    }

    final int? quantity$next;

    switch (quantity) {
      case Some(value: final updateData):
        quantity$next = updateData;
      case None():
        quantity$next = this.quantity;
    }

    return OrderOptWithSomeDefaults(
      name: name$next,

      price: price$next,

      quantity: quantity$next,
    );
  }
}

// ------------ END Input DEFINITIONS -------------
