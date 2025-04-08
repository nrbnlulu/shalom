// ignore_for_file: non_constant_identifier_names

class RequestGetMultipleFields {
  /// class memberes

  final String id;

  final int intField;

  // keywordargs constructor

  RequestGetMultipleFields({required this.id, required this.intField});

  static RequestGetMultipleFields fromJson(Map<String, dynamic> data) {
    return RequestGetMultipleFields(
      id: data['id'] as String,

      intField: data['intField'] as int,
    );
  }

  RequestGetMultipleFields updateWithJson(Map<String, dynamic> data) {
    return RequestGetMultipleFields(
      id: data.containsKey('id') ? data['id'] as String : this.id,

      intField:
          data.containsKey('intField')
              ? data['intField'] as int
              : this.intField,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is RequestGetMultipleFields &&
            other.id == id &&
            other.intField == intField &&
            true);
  }

  @override
  int get hashCode => Object.hashAll([id, intField]);

  Map<String, dynamic> toJson() {
    return {'id': id, 'intField': intField};
  }
}
