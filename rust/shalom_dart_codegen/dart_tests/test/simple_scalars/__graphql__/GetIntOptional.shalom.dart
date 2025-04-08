// ignore_for_file: non_constant_identifier_names

class RequestGetIntOptional {
  /// class memberes

  final int? intOptional;

  // keywordargs constructor

  RequestGetIntOptional({this.intOptional});

  static RequestGetIntOptional fromJson(Map<String, dynamic> data) {
    return RequestGetIntOptional(intOptional: data['intOptional'] as int?);
  }

  RequestGetIntOptional updateWithJson(Map<String, dynamic> data) {
    return RequestGetIntOptional(
      intOptional:
          data.containsKey('intOptional')
              ? data['intOptional'] as int?
              : this.intOptional,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is RequestGetIntOptional &&
            other.intOptional == intOptional &&
            true);
  }

  @override
  int get hashCode => Object.hashAll([intOptional]);

  Map<String, dynamic> toJson() {
    return {'intOptional': intOptional};
  }
}
