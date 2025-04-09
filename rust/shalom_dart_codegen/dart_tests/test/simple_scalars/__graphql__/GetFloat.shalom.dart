// ignore_for_file: non_constant_identifier_names

class RequestGetFloat {
  /// class memberes

  final double float;

  // keywordargs constructor

  RequestGetFloat({required this.float});

  static RequestGetFloat fromJson(Map<String, dynamic> data) {
    final double float_value;
    float_value = data['float'] as double;

    return RequestGetFloat(float: float_value);
  }

  RequestGetFloat updateWithJson(Map<String, dynamic> data) {
    final double float_value;
    if (data.containsKey('float')) {
      float_value = data['float'] as double;
    } else {
      float_value = float;
    }

    return RequestGetFloat(float: float_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is RequestGetFloat && other.float == float && true);
  }

  @override
  int get hashCode => float.hashCode;

  Map<String, dynamic> toJson() {
    return {'float': float};
  }
}
