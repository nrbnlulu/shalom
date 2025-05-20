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
}

// ------------ END Input DEFINITIONS -------------
