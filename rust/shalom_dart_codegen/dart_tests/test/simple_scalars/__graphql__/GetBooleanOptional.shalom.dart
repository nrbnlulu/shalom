// ignore_for_file: non_constant_identifier_names

class RequestGetBooleanOptional {
  /// class memberes

  final bool? booleanOptional;

  // keywordargs constructor

  RequestGetBooleanOptional({this.booleanOptional});

  static RequestGetBooleanOptional fromJson(Map<String, dynamic> data) {
    return RequestGetBooleanOptional(
      booleanOptional: data['booleanOptional'] as bool?,
    );
  }

  RequestGetBooleanOptional updateWithJson(Map<String, dynamic> data) {
    return RequestGetBooleanOptional(
      booleanOptional:
          data.containsKey('booleanOptional')
              ? data['booleanOptional'] as bool?
              : this.booleanOptional,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is RequestGetBooleanOptional &&
            other.booleanOptional == booleanOptional &&
            true);
  }

  @override
  int get hashCode => Object.hashAll([booleanOptional]);

  Map<String, dynamic> toJson() {
    return {'booleanOptional': booleanOptional};
  }
}
