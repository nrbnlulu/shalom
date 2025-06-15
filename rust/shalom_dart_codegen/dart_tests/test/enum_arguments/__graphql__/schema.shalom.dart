// ignore_for_file: constant_identifier_names

import 'package:shalom_core/shalom_core.dart';

// ------------ Enum DEFINITIONS -------------

enum Status {
  COMPLETED,

  PROCESSING,

  SENT;

  static Status fromString(String name) {
    switch (name) {
      case 'COMPLETED':
        return Status.COMPLETED;
      case 'PROCESSING':
        return Status.PROCESSING;
      case 'SENT':
        return Status.SENT;
      default:
        throw ArgumentError.value(
          name,
          'name',
          'No Status enum member with this name',
        );
    }
  }
}

// ------------ END Enum DEFINITIONS -------------
// ------------ Input DEFINITIONS -------------

class OrderUpdate {
  final Status status;

  final int timeLeft;

  OrderUpdate({required this.status, required this.timeLeft});

  JsonObject toJson() {
    JsonObject data = {};

    data["status"] = status.name;

    data["timeLeft"] = timeLeft;

    return data;
  }
}

class OrderUpdateStatusOpt {
  final Option<Status?> status;

  final int timeLeft;

  OrderUpdateStatusOpt({this.status = const None(), required this.timeLeft});

  JsonObject toJson() {
    JsonObject data = {};

    if (status.isSome()) {
      data["status"] = status.some()?.name;
    }

    data["timeLeft"] = timeLeft;

    return data;
  }
}

// ------------ END Input DEFINITIONS -------------
