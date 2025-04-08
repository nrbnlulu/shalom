class RequestGetFloat {
  final double float;

  // keywordargs constructor
  RequestGetFloat({required this.float});

  factory RequestGetFloat.fromJson(Map<String, dynamic> json) =>
      RequestGetFloat(float: json['float'] as double);

  RequestGetFloat updateWithJson(Map<String, dynamic> data) {
    return RequestGetFloat(
      float: data.containsKey('float') ? data['float'] as double : this.float,
    );
  }

  Map<String, dynamic> toJson() => {'float': float};

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RequestGetFloat && other.float == float && true);

  @override
  int get hashCode => Object.hashAll([float]);
}

/// class memberes
