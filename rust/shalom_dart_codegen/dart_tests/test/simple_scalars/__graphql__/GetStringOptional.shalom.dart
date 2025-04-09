// ignore_for_file: non_constant_identifier_names

class RequestGetStringOptional {
  /// class memberes

  final String? stringOptional;

  // keywordargs constructor

  RequestGetStringOptional({this.stringOptional});
  static RequestGetStringOptional fromJson(Map<String, dynamic> data) {
    final String? stringOptional_value;
    stringOptional_value = data['stringOptional'] as String?;

    return RequestGetStringOptional(stringOptional: stringOptional_value);
  }

  RequestGetStringOptional updateWithJson(Map<String, dynamic> data) {
    final String? stringOptional_value;
    if (data.containsKey('stringOptional')) {
      stringOptional_value = data['stringOptional'] as String?;
    } else {
      stringOptional_value = stringOptional;
    }

    return RequestGetStringOptional(stringOptional: stringOptional_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is RequestGetStringOptional &&
            other.stringOptional == stringOptional &&
            true);
  }

  @override
  int get hashCode => stringOptional.hashCode;

  Map<String, dynamic> toJson() {
    return {'stringOptional': stringOptional};
  }
}
