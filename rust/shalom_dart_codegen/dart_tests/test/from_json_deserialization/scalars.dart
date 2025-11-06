import 'package:shalom_core/shalom_core.dart';

class DateTimeScalar implements CustomScalar<DateTime, String> {
  const DateTimeScalar();

  @override
  DateTime deserialize(String value) {
    return DateTime.parse(value);
  }

  @override
  String serialize(DateTime value) {
    return value.toIso8601String();
  }
}