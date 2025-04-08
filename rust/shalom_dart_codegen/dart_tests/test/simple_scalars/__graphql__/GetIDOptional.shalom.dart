class RequestGetIDOptional {
  final String? idOptional;

  // keywordargs constructor
  RequestGetIDOptional({this.idOptional});

  factory RequestGetIDOptional.fromJson(Map<String, dynamic> json) =>
      RequestGetIDOptional(idOptional: json['idOptional'] as String?);

  RequestGetIDOptional updateWithJson(Map<String, dynamic> data) {
    return RequestGetIDOptional(
      idOptional:
          data.containsKey('idOptional')
              ? data['idOptional'] as String?
              : this.idOptional,
    );
  }

  Map<String, dynamic> toJson() => {'idOptional': idOptional};

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RequestGetIDOptional && other.idOptional == idOptional && true);

  @override
  int get hashCode => Object.hashAll([idOptional]);
}

/// class memberes
