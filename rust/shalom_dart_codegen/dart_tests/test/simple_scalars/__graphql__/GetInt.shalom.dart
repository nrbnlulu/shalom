class RequestGetInt {
  final int intField;

  // keywordargs constructor
  RequestGetInt({required this.intField});

  factory RequestGetInt.fromJson(Map<String, dynamic> json) =>
      RequestGetInt(intField: json['intField'] as int);

  RequestGetInt updateWithJson(Map<String, dynamic> data) {
    return RequestGetInt(
      intField:
          data.containsKey('intField')
              ? data['intField'] as int
              : this.intField,
    );
  }

  Map<String, dynamic> toJson() => {'intField': intField};

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RequestGetInt && other.intField == intField && true);

  @override
  int get hashCode => Object.hashAll([intField]);
}

/// class memberes
