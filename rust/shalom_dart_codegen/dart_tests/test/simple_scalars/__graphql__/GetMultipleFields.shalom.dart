class RequestGetMultipleFields {
  final String id;

  final int intField;

  RequestGetMultipleFields({required this.id, required this.intField});

  factory RequestGetMultipleFields.fromJson(Map<String, dynamic> json) =>
      RequestGetMultipleFields(
        id: json['id'] as String,

        intField: json['intField'] as int,
      );

  RequestGetMultipleFields updateWithJson(Map<String, dynamic> data) {
    return RequestGetMultipleFields(
      id: data.containsKey('id') ? data['id'] as String : this.id,

      intField:
          data.containsKey('intField')
              ? data['intField'] as int
              : this.intField,
    );
  }

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
