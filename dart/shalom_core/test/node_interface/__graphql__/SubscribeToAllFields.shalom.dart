import 'dart:async';

import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

class SubscribeToAllFields_user extends Node {
  /// class members

  String name;

  String email;

  int? age;

  // keywordargs constructor
  SubscribeToAllFields_user({
    required super.id,
    required this.name,
    required this.email,
    this.age,
  });
  static SubscribeToAllFields_user fromJson(JsonObject data) {
    final String id_value;
    final id$raw = data["id"];
    id_value = id$raw as String;

    final String name_value;
    final name$raw = data["name"];
    name_value = name$raw as String;

    final String email_value;
    final email$raw = data["email"];
    email_value = email$raw as String;

    final int? age_value;
    final age$raw = data["age"];
    age_value = age$raw as int?;

    return SubscribeToAllFields_user(
      id: id_value,
      name: name_value,
      email: email_value,
      age: age_value,
    );
  }

  static SubscribeToAllFields_user deserialize(
    JsonObject data,
    ShalomContext context,
  ) {
    final self = SubscribeToAllFields_user.fromJson(data);

    context.manager.parseNodeData(self.toJson());

    return self;
  }

  @override
  StreamSubscription<Event> subscribeToChanges(ShalomContext context) {
    return context.manager.register(this, {'id', 'name', 'email', 'age'});
  }

  @override
  void updateWithJson(JsonObject rawData, Set<String> changedFields) {
    for (final fieldName in changedFields) {
      switch (fieldName) {
        case 'id':
          id = rawData['id'];
          break;

        case 'name':
          name = rawData['name'];
          break;

        case 'email':
          email = rawData['email'];
          break;

        case 'age':
          age = rawData['age'];
          break;
      }
    }
    notifyListeners();
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is SubscribeToAllFields_user &&
            other.id == id &&
            other.name == name &&
            other.email == email &&
            other.age == age);
  }

  @override
  int get hashCode => Object.hashAll([id, name, email, age]);

  @override
  JsonObject toJson() {
    return {
      'id': this.id,
      'name': this.name,
      'email': this.email,
      'age': this.age,
    };
  }
}
