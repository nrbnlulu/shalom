// ignore_for_file: non_constant_identifier_names

class RequestGetStringOptional {
  /// class memberes

  final String? stringOptional;

  // keywordargs constructor

  RequestGetStringOptional({this.stringOptional});

  static RequestGetStringOptional fromJson(Map<String, dynamic> data) {
    return RequestGetStringOptional(
      stringOptional: data['stringOptional'] as String?,
    );
  }

  RequestGetStringOptional updateWithJson(Map<String, dynamic> data) {
    return RequestGetStringOptional(
      stringOptional:
          data.containsKey('stringOptional')
              ? data['stringOptional'] as String?
              : this.stringOptional,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is RequestGetStringOptional &&
            other.stringOptional == stringOptional &&
            true);
  }

  @override
  int get hashCode => Object.hashAll([stringOptional]);

  Map<String, dynamic> toJson() {
    return {'stringOptional': stringOptional};
  }
}
