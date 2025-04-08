// ignore_for_file: non_constant_identifier_names

class RequestGetFloat {
  /// class memberes

  final double float;

  // keywordargs constructor

  RequestGetFloat({required this.float});

  static RequestGetFloat fromJson(Map<String, dynamic> data) {
    return RequestGetFloat(float: data['float'] as double);
  }

  RequestGetFloat updateWithJson(Map<String, dynamic> data) {
    return RequestGetFloat(
      float: data.containsKey('float') ? data['float'] as double : this.float,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is RequestGetFloat && other.float == float && true);
  }

  @override
  int get hashCode => Object.hashAll([float]);

  Map<String, dynamic> toJson() {
    return {'float': float};
  }
}
