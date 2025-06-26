// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import

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

class OrderDetails {
  final Option<Review?> firstReview;

  OrderDetails({this.firstReview = const None()});

  JsonObject toJson() {
    JsonObject data = {};

    if (firstReview.isSome()) {
      final value = firstReview.some();

      data["firstReview"] = value?.toJson();
    } else {
      // This is not a list type. Omit the field.
    }

    return data;
  }

  OrderDetails updateWith({
    Option<Option<Review?>> firstReview = const None(),
  }) {
    final Option<Review?> firstReview$next;

    switch (firstReview) {
      case Some(value: final data):
        firstReview$next = data;
      case None():
        firstReview$next = this.firstReview;
    }

    return OrderDetails(firstReview: firstReview$next);
  }
}

class OrderRecursive {
  final Option<OrderRecursive?> order;

  OrderRecursive({this.order = const None()});

  JsonObject toJson() {
    JsonObject data = {};

    if (order.isSome()) {
      final value = order.some();

      data["order"] = value?.toJson();
    } else {
      // This is not a list type. Omit the field.
    }

    return data;
  }

  OrderRecursive updateWith({
    Option<Option<OrderRecursive?>> order = const None(),
  }) {
    final Option<OrderRecursive?> order$next;

    switch (order) {
      case Some(value: final data):
        order$next = data;
      case None():
        order$next = this.order;
    }

    return OrderRecursive(order: order$next);
  }
}

class Review {
  final Option<OrderDetails?> order;

  Review({this.order = const None()});

  JsonObject toJson() {
    JsonObject data = {};

    if (order.isSome()) {
      final value = order.some();

      data["order"] = value?.toJson();
    } else {
      // This is not a list type. Omit the field.
    }

    return data;
  }

  Review updateWith({Option<Option<OrderDetails?>> order = const None()}) {
    final Option<OrderDetails?> order$next;

    switch (order) {
      case Some(value: final data):
        order$next = data;
      case None():
        order$next = this.order;
    }

    return Review(order: order$next);
  }
}

class SpecificOrder {
  final String notes;

  final Order order;

  SpecificOrder({required this.notes, required this.order});

  JsonObject toJson() {
    JsonObject data = {};

    data["notes"] = notes;

    data["order"] = order.toJson();

    return data;
  }

  SpecificOrder updateWith({String? notes, Order? order}) {
    final String notes$next;

    if (notes != null) {
      notes$next = notes;
    } else {
      notes$next = this.notes;
    }

    final Order order$next;

    if (order != null) {
      order$next = order;
    } else {
      order$next = this.order;
    }

    return SpecificOrder(notes: notes$next, order: order$next);
  }
}

// ------------ END Input DEFINITIONS -------------
