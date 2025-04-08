// ignore_for_file: non_constant_identifier_names

class RequestGetUser {
  /// class memberes

  final GetUserUser? user;

  // keywordargs constructor

  RequestGetUser({this.user});

  static RequestGetUser fromJson(Map<String, dynamic> data) {
    return RequestGetUser(
      user:
          data['user'] != null
              ? GetUserUser.fromJson(data['user'] as Map<String, dynamic>)
              : null,
    );
  }

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

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is RequestGetUser && other.user == user && true);
  }

  @override
  int get hashCode => Object.hashAll([user]);

  Map<String, dynamic> toJson() {
    return {'user': user?.toJson()};
  }
}

class GetUserUser {
  /// class memberes

  final String id;

  final String name;

  final String email;

  final int? age;

  // keywordargs constructor
  GetUserUser({
    required this.id,

    required this.name,

    required this.email,

    this.age,
  });

  static GetUserUser fromJson(Map<String, dynamic> data) {
    return GetUserUser(
      id: data['id'] as String,

      name: data['name'] as String,

      email: data['email'] as String,

      age: data['age'] as int?,
    );
  }

  GetUserUser updateWithJson(Map<String, dynamic> data) {
    return GetUserUser(
      id: data.containsKey('id') ? data['id'] as String : this.id,

      name: data.containsKey('name') ? data['name'] as String : this.name,

      email: data.containsKey('email') ? data['email'] as String : this.email,

      age: data.containsKey('age') ? data['age'] as int? : this.age,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetUserUser &&
            other.id == id &&
            other.name == name &&
            other.email == email &&
            other.age == age &&
            true);
  }

  @override
  int get hashCode => Object.hashAll([id, name, email, age]);

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email, 'age': age};
  }
}
