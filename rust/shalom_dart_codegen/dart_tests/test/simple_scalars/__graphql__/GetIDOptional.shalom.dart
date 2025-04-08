// ignore_for_file: non_constant_identifier_names

class RequestGetIDOptional {
  /// class memberes

  final String? idOptional;

  // keywordargs constructor

  RequestGetIDOptional({this.idOptional});

  static RequestGetIDOptional fromJson(Map<String, dynamic> data) {
    return RequestGetIDOptional(idOptional: data['idOptional'] as String?);
  }

  RequestGetIDOptional updateWithJson(Map<String, dynamic> data) {
    return RequestGetIDOptional(
      idOptional:
          data.containsKey('idOptional')
              ? data['idOptional'] as String?
              : this.idOptional,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is RequestGetIDOptional &&
            other.idOptional == idOptional &&
            true);
  }

  @override
  int get hashCode => Object.hashAll([idOptional]);

  Map<String, dynamic> toJson() {
    return {'idOptional': idOptional};
  }
}
