import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

class SubscribeToSomeFields_user extends Node {
  /// class members

  String name;

  // keywordargs constructor
  SubscribeToSomeFields_user({required super.id, required this.name});

  static SubscribeToSomeFields_user deserialize(
    JsonObject data,
    ShalomContext context,
  ) {
    final self = SubscribeToSomeFields_user(id: data['id'], name: data['name']);
    context.manager.parseNodeData(self.toJson());
    return self;
  }

  @override
  void subscribeToChanges(ShalomContext context) {
    if (widgetsSubscribed == 0) {
      context.manager.register(this, {'id', 'name'});
    }
    widgetsSubscribed += 1;
  }

  @override
  void unSubscribeToChanges(ShalomContext context) {
    if (widgetsSubscribed < 2) {
      context.manager.unRegister(this);
    }
    widgetsSubscribed -= 1;
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
      }
    }
    notifyListeners();
  }

  static SubscribeToSomeFields_user fromJson(JsonObject data) {
    final String id_value;
    final id$raw = data["id"];
    id_value = id$raw as String;

    final String name_value;
    final name$raw = data["name"];
    name_value = name$raw as String;

    return SubscribeToSomeFields_user(id: id_value, name: name_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is SubscribeToSomeFields_user &&
            other.id == id &&
            other.name == name);
  }

  @override
  int get hashCode => Object.hashAll([id, name]);

  @override
  JsonObject toJson() {
    return {'id': this.id, 'name': this.name};
  }
}
