class RequestGetUser {
  final GetUserUser? user;

  RequestGetUser({this.user});

  factory RequestGetUser.fromJson(Map<String, dynamic> json) => RequestGetUser(
    user:
        json['user'] != null
            ? GetUserUser.fromJson(json['user'] as Map<String, dynamic>)
            : null,
  );

  RequestGetUser updateWithJson(Map<String, dynamic> data) {
    return RequestGetUser(
      user:
          data.containsKey('user')
              ? (data['user'] != null
                  ? GetUserUser.fromJson(data['user'] as Map<String, dynamic>)
                  : null)
              : this.user,
    );
  }

  Map<String, dynamic> toJson() => {'user': user?.toJson()};

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RequestGetUser && other.user == user && true);

  @override
  int get hashCode => Object.hashAll([user]);
}

class GetUserUser {
  final String id;

  final String name;

  final String email;

  final int? age;

  GetUserUser({
    required this.id,

    required this.name,

    required this.email,

    this.age,
  });

  factory GetUserUser.fromJson(Map<String, dynamic> json) => GetUserUser(
    id: json['id'] as String,

    name: json['name'] as String,

    email: json['email'] as String,

    age: json['age'] as int?,
  );

  GetUserUser updateWithJson(Map<String, dynamic> data) {
    return GetUserUser(
      id: data.containsKey('id') ? data['id'] as String : this.id,

      name: data.containsKey('name') ? data['name'] as String : this.name,

      email: data.containsKey('email') ? data['email'] as String : this.email,

      age: data.containsKey('age') ? data['age'] as int? : this.age,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,

    'name': name,

    'email': email,

    'age': age,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GetUserUser &&
          other.id == id &&
          other.name == name &&
          other.email == email &&
          other.age == age &&
          true);

  @override
  int get hashCode => Object.hashAll([id, name, email, age]);
}
