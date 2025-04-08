class RequestGetBooleanOptional {
  final bool? booleanOptional;

  // keywordargs constructor
  RequestGetBooleanOptional({this.booleanOptional});

  factory RequestGetBooleanOptional.fromJson(Map<String, dynamic> json) =>
      RequestGetBooleanOptional(
        booleanOptional: json['booleanOptional'] as bool?,
      );

  RequestGetBooleanOptional updateWithJson(Map<String, dynamic> data) {
    return RequestGetBooleanOptional(
      booleanOptional:
          data.containsKey('booleanOptional')
              ? data['booleanOptional'] as bool?
              : this.booleanOptional,
    );
  }

  Map<String, dynamic> toJson() => {'booleanOptional': booleanOptional};

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RequestGetBooleanOptional &&
          other.booleanOptional == booleanOptional &&
          true);

  @override
  int get hashCode => Object.hashAll([booleanOptional]);
}

/// class memberes
