class RequestGetFloat {
  /// class memberes

  final double float;

  // keywordargs constructor

  RequestGetFloat({required this.float});

  static RequestGetFloat FromJson(Map<String, dynamic> data) {
    final float_value = data['float'] as double;

    return RequestGetFloat(float: float_value);
  }
}
