class RequestGetFloat {
  /// class memberes

  final double float;

  // keywordargs constructor

  RequestGetFloat({required this.float});

  static RequestGetFloat fromJson(Map<String, dynamic> data) {
    final float_value = data['float'] as double;

    return RequestGetFloat(float: float_value);
  }

  RequestGetFloat updateWithJson(Map<String, dynamic> data) {
    final float_value;
    if (data.containsKey('float')) {
      float_value = data['float'] as double;
    } else {
      float_value = float;
    }

    return RequestGetFloat(float: float_value);
  }

  bool operator ==(Object other) {
    if (other is! RequestGetFloat) return false;

    if (other.float != float) return false;

    return true;
  }

  Map<String, dynamic> toJson() {
    return {'float': float};
  }
}
