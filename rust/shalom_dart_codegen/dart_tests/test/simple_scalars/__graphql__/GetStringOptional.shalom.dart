class RequestGetStringOptional {
  final String? stringOptional;

  RequestGetStringOptional({this.stringOptional});

  factory RequestGetStringOptional.fromJson(Map<String, dynamic> json) =>
      RequestGetStringOptional(
        stringOptional: json['stringOptional'] as String?,
      );

  RequestGetStringOptional updateWithJson(Map<String, dynamic> data) {
    return RequestGetStringOptional(
      stringOptional:
          data.containsKey('stringOptional')
              ? data['stringOptional'] as String?
              : this.stringOptional,
    );
  }

  Map<String, dynamic> toJson() => {'stringOptional': stringOptional};

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RequestGetStringOptional &&
          other.stringOptional == stringOptional &&
          true);

  @override
  int get hashCode => Object.hashAll([stringOptional]);
}
