import 'Objects.shalom.dart';
// ignore_for_file: non_constant_identifier_names

class RequestGetBooleanOptional {
  /// class memberes

  final bool? booleanOptional;

  // keywordargs constructor

  RequestGetBooleanOptional({required this.booleanOptional});

  static RequestGetBooleanOptional fromJson(Map<String, dynamic> data) {
    final booleanOptional_value = data['booleanOptional'] as bool?;

    return RequestGetBooleanOptional(booleanOptional: booleanOptional_value);
  }

  RequestGetBooleanOptional updateWithJson(Map<String, dynamic> data) {
    final bool? booleanOptional_value;
    if (data.containsKey('booleanOptional')) {
      booleanOptional_value = data['booleanOptional'] as bool?;
    } else {
      booleanOptional_value = booleanOptional;
    }

    return RequestGetBooleanOptional(booleanOptional: booleanOptional_value);
  }

  @override
  bool operator ==(Object other) {
    if (other is! RequestGetBooleanOptional) return false;

    if (other.booleanOptional != booleanOptional) return false;

    return true;
  }

  @override
  int get hashCode => booleanOptional.hashCode;

  Map<String, dynamic> toJson() {
    return {'booleanOptional': booleanOptional};
  }
}
