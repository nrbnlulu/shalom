class UserSelection {
  bool selectEmail = false;

  bool selectId = false;

  bool selectName = false;

  bool selectAge = false;

  UserSelection({
    this.selectEmail = false,

    this.selectId = false,

    this.selectName = false,

    this.selectAge = false,
  });

  // Method to select fields dynamically
  void selectField(String fieldName) {
    switch (fieldName) {
      case 'email':
        selectEmail = true;
        break;

      case 'id':
        selectId = true;
        break;

      case 'name':
        selectName = true;
        break;

      case 'age':
        selectAge = true;
        break;

      default:
        throw Exception('Unknown field: $fieldName');
    }
  }

  // Convert the selected fields into a map (optional)
  Map<String, bool> getSelectedFields() {
    return {
      'email': selectEmail,

      'id': selectId,

      'name': selectName,

      'age': selectAge,
    };
  }
}

class User {
  final String email;

  final String id;

  final String name;

  final int? age;

  User({required this.email, required this.id, required this.name, this.age});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'] as String,

      id: json['id'] as String,

      name: json['name'] as String,

      age: json['age'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'email': email, 'id': id, 'name': name, 'age': age};
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.email == email &&
        other.id == id &&
        other.name == name &&
        other.age == age;
  }

  @override
  int get hashCode => Object.hashAll([email, id, name, age]);
}

class QuerySelection {
  bool selectUser = false;

  QuerySelection({this.selectUser = false});

  // Method to select fields dynamically
  void selectField(String fieldName) {
    switch (fieldName) {
      case 'user':
        selectUser = true;
        break;

      default:
        throw Exception('Unknown field: $fieldName');
    }
  }

  // Convert the selected fields into a map (optional)
  Map<String, bool> getSelectedFields() {
    return {'user': selectUser};
  }
}

class Query {
  final User? user;

  Query({this.user});

  factory Query.fromJson(Map<String, dynamic> json) {
    return Query(
      user:
          json['user'] != null
              ? User.fromJson(json['user'] as Map<String, dynamic>)
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'user': user?.toJson()};
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Query && other.user == user;
  }

  @override
  int get hashCode => Object.hashAll([user]);
}
