// ignore_for_file: non_constant_identifier_names

class RequestGetFloatOptional {
  /// class memberes

  final double? floatOptional;

  // keywordargs constructor

  RequestGetFloatOptional({this.floatOptional});

  static RequestGetFloatOptional fromJson(Map<String, dynamic> data) {
    return RequestGetFloatOptional(
      floatOptional: data['floatOptional'] as double?,
    );
  }

  RequestGetFloatOptional updateWithJson(Map<String, dynamic> data) {
    return RequestGetFloatOptional(
      floatOptional:
          data.containsKey('floatOptional')
              ? data['floatOptional'] as double?
              : this.floatOptional,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is RequestGetFloatOptional &&
            other.floatOptional == floatOptional &&
            true);
  }

  @override
  int get hashCode => Object.hashAll([floatOptional]);

  Map<String, dynamic> toJson() {
    return {'floatOptional': floatOptional};
  }
}
