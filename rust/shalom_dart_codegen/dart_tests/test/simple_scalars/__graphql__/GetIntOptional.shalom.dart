class RequestGetIntOptional {
  final int? intOptional;

  // keywordargs constructor
  RequestGetIntOptional({this.intOptional});

  factory RequestGetIntOptional.fromJson(Map<String, dynamic> json) =>
      RequestGetIntOptional(intOptional: json['intOptional'] as int?);

  RequestGetIntOptional updateWithJson(Map<String, dynamic> data) {
    return RequestGetIntOptional(
      intOptional:
          data.containsKey('intOptional')
              ? data['intOptional'] as int?
              : this.intOptional,
    );
  }

  Map<String, dynamic> toJson() => {'intOptional': intOptional};

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RequestGetIntOptional &&
          other.intOptional == intOptional &&
          true);

  @override
  int get hashCode => Object.hashAll([intOptional]);
}

/// class memberes
