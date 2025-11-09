import 'package:shalom_core/shalom_core.dart';

class DateTime {
  final int year;
  final int month;
  final int day;
  final int hour;
  final int minute;
  final int second;

  const DateTime({
    required this.year,
    required this.month,
    required this.day,
    this.hour = 0,
    this.minute = 0,
    this.second = 0,
  });

  @override
  String toString() =>
      'DateTime($year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')} ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:${second.toString().padLeft(2, '0')})';

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is DateTime &&
            other.year == year &&
            other.month == month &&
            other.day == day &&
            other.hour == hour &&
            other.minute == minute &&
            other.second == second);
  }

  @override
  int get hashCode => Object.hash(year, month, day, hour, minute, second);

  String toIso8601String() {
    return '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}T${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:${second.toString().padLeft(2, '0')}Z';
  }
}

class _DateTimeScalarImpl implements CustomScalarImpl<DateTime> {
  const _DateTimeScalarImpl();

  @override
  DateTime deserialize(dynamic raw) {
    if (raw is! String) {
      throw FormatException(
        "Expected String for DateTime, got ${raw.runtimeType}",
      );
    }

    // Parse ISO 8601 format: 2024-01-15T10:30:45Z or 2024-01-15T10:30:45
    final regex = RegExp(
        r'^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})(?:Z|[+-]\d{2}:\d{2})?$');
    final match = regex.firstMatch(raw);
    if (match == null) {
      throw FormatException("Invalid DateTime format: $raw");
    }

    return DateTime(
      year: int.parse(match[1]!),
      month: int.parse(match[2]!),
      day: int.parse(match[3]!),
      hour: int.parse(match[4]!),
      minute: int.parse(match[5]!),
      second: int.parse(match[6]!),
    );
  }

  @override
  dynamic serialize(DateTime value) {
    return value.toIso8601String();
  }
}

// This is referenced in shalom.yml
const dateTimeScalarImpl = _DateTimeScalarImpl();
