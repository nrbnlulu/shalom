import 'Objects.shalom.dart';
// ignore_for_file: non_constant_identifier_names

class RequestGetMultipleFields {
  /// class memberes

  final String id;

  final int intField;

  // keywordargs constructor

  RequestGetMultipleFields({required this.id, required this.intField});

  static RequestGetMultipleFields fromJson(Map<String, dynamic> data) {
    final id_value = data['id'] as String;

    final intField_value = data['intField'] as int;

    return RequestGetMultipleFields(id: id_value, intField: intField_value);
  }

  RequestGetMultipleFields updateWithJson(Map<String, dynamic> data) {
    final String id_value;
    if (data.containsKey('id')) {
      id_value = data['id'] as String;
    } else {
      id_value = id;
    }

    final int intField_value;
    if (data.containsKey('intField')) {
      intField_value = data['intField'] as int;
    } else {
      intField_value = intField;
    }

    return RequestGetMultipleFields(id: id_value, intField: intField_value);
  }

  @override
  bool operator ==(Object other) {
    if (other is! RequestGetMultipleFields) return false;

    if (other.id != id) return false;

    if (other.intField != intField) return false;

    return true;
  }

  @override
  int get hashCode => Object.hash(id, intField);

  Map<String, dynamic> toJson() {
    return {'id': id, 'intField': intField};
  }
}
