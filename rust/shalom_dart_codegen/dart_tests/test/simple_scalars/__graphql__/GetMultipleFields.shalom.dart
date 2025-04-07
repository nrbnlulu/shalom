// Then generate classes

/// GetMultipleFields class with selected fields from query
library;

class RequestGetMultipleFields {
  /// Class fields

  final String id;

  final int intField;

  /// Constructor
  RequestGetMultipleFields({required this.id, required this.intField});

  /// Creates from JSON
  factory RequestGetMultipleFields.fromJson(Map<String, dynamic> json) =>
      RequestGetMultipleFields(
        id: json['id'] as String,

        intField: json['intField'] as int,
      );

  /// Updates from JSON
  RequestGetMultipleFields updateWithJson(Map<String, dynamic> data) {
    return RequestGetMultipleFields(
      id: data.containsKey('id') ? data['id'] as String : id,

      intField:
          data.containsKey('intField') ? data['intField'] as int : intField,
    );
  }

  /// Converts to JSON
  Map<String, dynamic> toJson() => {'id': id, 'intField': intField};

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RequestGetMultipleFields &&
          other.id == id &&
          other.intField == intField &&
          true);

  @override
  int get hashCode => Object.hashAll([id, intField]);
}
