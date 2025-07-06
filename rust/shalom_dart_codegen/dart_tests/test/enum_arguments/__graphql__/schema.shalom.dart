// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, unnecessary_this

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

    data["status"] = this.status.name;

    data["timeLeft"] = this.timeLeft;

    return data;
  }

  OrderUpdate updateWith({Status? status, int? timeLeft}) {
    final Status status$next;

    if (status != null) {
      status$next = status;
    } else {
      status$next = this.status;
    }

    final int timeLeft$next;

    if (timeLeft != null) {
      timeLeft$next = timeLeft;
    } else {
      timeLeft$next = this.timeLeft;
    }

    return OrderUpdate(status: status$next, timeLeft: timeLeft$next);
  }
}

class OrderUpdateStatusOpt {
  final Option<Status?> status;

  final int timeLeft;

  OrderUpdateStatusOpt({this.status = const None(), required this.timeLeft});

  JsonObject toJson() {
    JsonObject data = {};

    if (status.isSome()) {
      final $value = this.status.some();

      data["status"] = $value?.name;
    }

    data["timeLeft"] = this.timeLeft;

    return data;
  }

  OrderUpdateStatusOpt updateWith({
    Option<Option<Status?>> status = const None(),

    int? timeLeft,
  }) {
    final Option<Status?> status$next;

    switch (status) {
      case Some(value: final updateData):
        status$next = updateData;
      case None():
        status$next = this.status;
    }

    final int timeLeft$next;

    if (timeLeft != null) {
      timeLeft$next = timeLeft;
    } else {
      timeLeft$next = this.timeLeft;
    }

    return OrderUpdateStatusOpt(status: status$next, timeLeft: timeLeft$next);
  }
}

// ------------ END Input DEFINITIONS -------------
