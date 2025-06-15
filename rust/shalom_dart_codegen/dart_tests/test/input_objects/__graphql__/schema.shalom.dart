// ignore_for_file: constant_identifier_names

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

    data["name"] = name;

    data["price"] = price;

    data["quantity"] = quantity;

    return data;
  }

  static fromJson(JsonObject data) {
    final String name_value;

    name_value = data['name'];

    final double price_value;

    price_value = data['price'];

    final int quantity_value;

    quantity_value = data['quantity'];

    return Order(
      name: name_value,

      price: price_value,

      quantity: quantity_value,
    );
  }

  Order updateWithJson(JsonObject data) {
    final String name_value;

    name_value = data['name'];

    final double price_value;

    price_value = data['price'];

    final int quantity_value;

    quantity_value = data['quantity'];

    return Order(
      name: name_value,

      price: price_value,

      quantity: quantity_value,
    );
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
      data["name"] = name.some();
    }

    if (price.isSome()) {
      data["price"] = price.some();
    }

    if (quantity.isSome()) {
      data["quantity"] = quantity.some();
    }

    return data;
  }

  static fromJson(JsonObject data) {
    final Option<String?> name_value;

    final String? name$raw = data['name'];
    if (name$raw != null) {
      name_value = Some(name$raw);
    } else {
      name_value = None();
    }

    final Option<double?> price_value;

    final double? price$raw = data['price'];
    if (price$raw != null) {
      price_value = Some(price$raw);
    } else {
      price_value = None();
    }

    final Option<int?> quantity_value;

    final int? quantity$raw = data['quantity'];
    if (quantity$raw != null) {
      quantity_value = Some(quantity$raw);
    } else {
      quantity_value = None();
    }

    return OrderOpt(
      name: name_value,

      price: price_value,

      quantity: quantity_value,
    );
  }

  OrderOpt updateWithJson(JsonObject data) {
    final Option<String?> name_value;

    if (data.containsKey(name)) {
      name_value = Some(data['name']);
    } else {
      name_value = name;
    }

    final Option<double?> price_value;

    if (data.containsKey(price)) {
      price_value = Some(data['price']);
    } else {
      price_value = price;
    }

    final Option<int?> quantity_value;

    if (data.containsKey(quantity)) {
      quantity_value = Some(data['quantity']);
    } else {
      quantity_value = quantity;
    }

    return OrderOpt(
      name: name_value,

      price: price_value,

      quantity: quantity_value,
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

    data["name"] = name;

    data["price"] = price;

    data["quantity"] = quantity;

    return data;
  }

  static fromJson(JsonObject data) {
    final String? name_value;

    final String? name$raw = data['name'];
    if (name$raw != null) {
      name_value = name$raw;
    } else {
      name_value = null;
    }

    final double? price_value;

    final double? price$raw = data['price'];
    if (price$raw != null) {
      price_value = price$raw;
    } else {
      price_value = null;
    }

    final int? quantity_value;

    final int? quantity$raw = data['quantity'];
    if (quantity$raw != null) {
      quantity_value = quantity$raw;
    } else {
      quantity_value = null;
    }

    return OrderOptWithNullDefaults(
      name: name_value,

      price: price_value,

      quantity: quantity_value,
    );
  }

  OrderOptWithNullDefaults updateWithJson(JsonObject data) {
    final String? name_value;

    if (data.containsKey(name)) {
      name_value = data['name'];
    } else {
      name_value = name;
    }

    final double? price_value;

    if (data.containsKey(price)) {
      price_value = data['price'];
    } else {
      price_value = price;
    }

    final int? quantity_value;

    if (data.containsKey(quantity)) {
      quantity_value = data['quantity'];
    } else {
      quantity_value = quantity;
    }

    return OrderOptWithNullDefaults(
      name: name_value,

      price: price_value,

      quantity: quantity_value,
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

    data["name"] = name;

    data["price"] = price;

    data["quantity"] = quantity;

    return data;
  }

  static fromJson(JsonObject data) {
    final String? name_value;

    final String? name$raw = data['name'];
    if (name$raw != null) {
      name_value = name$raw;
    } else {
      name_value = null;
    }

    final double? price_value;

    final double? price$raw = data['price'];
    if (price$raw != null) {
      price_value = price$raw;
    } else {
      price_value = null;
    }

    final int? quantity_value;

    final int? quantity$raw = data['quantity'];
    if (quantity$raw != null) {
      quantity_value = quantity$raw;
    } else {
      quantity_value = null;
    }

    return OrderOptWithSomeDefaults(
      name: name_value,

      price: price_value,

      quantity: quantity_value,
    );
  }

  OrderOptWithSomeDefaults updateWithJson(JsonObject data) {
    final String? name_value;

    if (data.containsKey(name)) {
      name_value = data['name'];
    } else {
      name_value = name;
    }

    final double? price_value;

    if (data.containsKey(price)) {
      price_value = data['price'];
    } else {
      price_value = price;
    }

    final int? quantity_value;

    if (data.containsKey(quantity)) {
      quantity_value = data['quantity'];
    } else {
      quantity_value = quantity;
    }

    return OrderOptWithSomeDefaults(
      name: name_value,

      price: price_value,

      quantity: quantity_value,
    );
  }
}

// ------------ END Input DEFINITIONS -------------
