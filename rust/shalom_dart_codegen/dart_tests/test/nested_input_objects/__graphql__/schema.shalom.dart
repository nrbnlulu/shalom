// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

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

class OrderDetails {
  final Option<Review?> firstReview;

  OrderDetails({this.firstReview = const None()});

  JsonObject toJson() {
    JsonObject data = {};

    if (firstReview.isSome()) {
      final value = this.firstReview.some();
      data["firstReview"] = value?.toJson();
    }

    return data;
  }

  OrderDetails updateWith({Option<Option<Review?>> firstReview = const None()}) {
    final Option<Review?> firstReview$next;

    switch (firstReview) {
      case Some(value: final updateData):
        firstReview$next = updateData;
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
      final value = this.order.some();
      data["order"] = value?.toJson();
    }

    return data;
  }

  OrderRecursive updateWith({Option<Option<OrderRecursive?>> order = const None()}) {
    final Option<OrderRecursive?> order$next;

    switch (order) {
      case Some(value: final updateData):
        order$next = updateData;
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
      final value = this.order.some();
      data["order"] = value?.toJson();
    }

    return data;
  }

  Review updateWith({Option<Option<OrderDetails?>> order = const None()}) {
    final Option<OrderDetails?> order$next;

    switch (order) {
      case Some(value: final updateData):
        order$next = updateData;
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

    data["notes"] = this.notes;

    data["order"] = this.order.toJson();

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
