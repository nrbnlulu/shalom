// ignore_for_file: non_constant_identifier_names

class RequestGetIDOptional {
  /// class memberes

  final String? idOptional;

  // keywordargs constructor

  RequestGetIDOptional({this.idOptional});
  static RequestGetIDOptional fromJson(Map<String, dynamic> data) {
    final String? idOptional_value;
    idOptional_value = data['idOptional'] as String?;

    return RequestGetIDOptional(idOptional: idOptional_value);
  }

  RequestGetIDOptional updateWithJson(Map<String, dynamic> data) {
    final String? idOptional_value;
    if (data.containsKey('idOptional')) {
      idOptional_value = data['idOptional'] as String?;
    } else {
      idOptional_value = idOptional;
    }

    return RequestGetIDOptional(idOptional: idOptional_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is RequestGetIDOptional &&
            other.idOptional == idOptional &&
            true);
  }

  @override
  int get hashCode => idOptional.hashCode;

  Map<String, dynamic> toJson() {
    return {'idOptional': idOptional};
  }
}
