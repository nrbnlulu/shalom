import 'package:test/test.dart';
import 'package:shalom_core/shalom_core.dart';
import '__graphql__/GetUser.shalom.dart';
import '__graphql__/GetUserWithOptionalName.shalom.dart';
import '__graphql__/GetUserNotAllSelected.shalom.dart';

typedef JsonObject = Map<String, dynamic>;

Future<void> pumpEventQueue() => Future.delayed(Duration.zero);

mixin UpdateCounterMixin on Node {
  int updateCounter = 0;

  @override
  void updateWithJson(JsonObject rawData, Set<String> changedFields) {
    super.updateWithJson(rawData, changedFields);
    if (changedFields.isNotEmpty) {
      updateCounter++;
    }
  }
}

class Testable_GetUser_user extends GetUser_user with UpdateCounterMixin {
  Testable_GetUser_user({
    required super.id,
    required super.name,
    required super.password,
  });

  static Testable_GetUser_user fromJson(
    JsonObject data,
    ShalomContext context,
  ) {
    context.manager.parseNodeData(data);
    return Testable_GetUser_user(
      id: data['id'] as String,
      name: data['name'] as String,
      password: data['password'] as String,
    );
  }
}

class Testable_GetUserWithOptionalName_userOptional
    extends GetUserWithOptionalName_userOptional
    with UpdateCounterMixin {
  Testable_GetUserWithOptionalName_userOptional({
    required super.id,
    super.name,
    required super.password,
  });

  static Testable_GetUserWithOptionalName_userOptional fromJson(
    JsonObject data,
    ShalomContext context,
  ) {
    context.manager.parseNodeData(data);
    return Testable_GetUserWithOptionalName_userOptional(
      id: data['id'] as String,
      name: data['name'] as String?,
      password: data['password'] as String,
    );
  }
}

class Testable_GetUserNotAllSelected_user extends GetUserNotAllSelected_user
    with UpdateCounterMixin {
  Testable_GetUserNotAllSelected_user({required super.id, required super.name});

  static Testable_GetUserNotAllSelected_user fromJson(
    JsonObject data,
    ShalomContext context,
  ) {
    context.manager.parseNodeData(data);
    return Testable_GetUserNotAllSelected_user(
      id: data['id'] as String,
      name: data['name'] as String,
    );
  }
}

void main() {
  group("test GetUser_user updateWithJson", () {
    late NodeManager manager;
    late ShalomContext context;

    const id = "user:1";
    const initialUserData = {"id": id, "name": "qtgql", "password": "123"};
    const nextUserData = {"id": id, "name": "shalom", "password": "456"};

    setUp(() {
      manager = NodeManager();
      context = ShalomContext(manager: manager);
    });

    test("all fields updated on subscribed node", () async {
      final userNode = Testable_GetUser_user.fromJson(initialUserData, context);
      userNode.subscribeToChanges(context);

      manager.parseNodeData(nextUserData);

      await pumpEventQueue();
      expect(userNode.updateCounter, 1);
      expect(userNode.toJson(), nextUserData);
    });

    test("unsubscribed node does not receive updates", () async {
      final userNode = Testable_GetUser_user.fromJson(initialUserData, context);

      manager.parseNodeData(nextUserData);

      await pumpEventQueue();
      expect(userNode.updateCounter, 0);
      expect(userNode.toJson(), initialUserData);
    });
  });

  group("test GetUserWithOptionalName_userOptional updateWithJson", () {
    late NodeManager manager;
    late ShalomContext context;

    const id = "useropt:1";
    const initialData = {"id": id, "name": null, "password": "abc"};

    setUp(() {
      manager = NodeManager();
      context = ShalomContext(manager: manager);
    });

    test("updates optional field from null to value", () async {
      final userNode = Testable_GetUserWithOptionalName_userOptional.fromJson(
        initialData,
        context,
      );
      userNode.subscribeToChanges(context);

      final updatedData = {"id": id, "name": "new name"};
      manager.parseNodeData(updatedData);

      await pumpEventQueue();
      expect(userNode.updateCounter, 1);
      expect(userNode.name, "new name");
      expect(userNode.password, "abc");
    });
  });

  group("test GetUserNotAllSelected_user updateWithJson", () {
    late NodeManager manager;
    late ShalomContext context;

    const id = "userpartial:1";
    const initialData = {"id": id, "name": "Initial Partial Name"};

    setUp(() {
      manager = NodeManager();
      context = ShalomContext(manager: manager);
    });

    test("updates selected field", () async {
      final userNode = Testable_GetUserNotAllSelected_user.fromJson(
        initialData,
        context,
      );
      userNode.subscribeToChanges(context);

      final updatedData = {"id": id, "name": "Updated Partial Name"};
      manager.parseNodeData(updatedData);

      await pumpEventQueue();
      expect(userNode.updateCounter, 1);
      expect(userNode.name, "Updated Partial Name");
    });

    test("does not update on changes to unselected fields", () async {
      final userNode = Testable_GetUserNotAllSelected_user.fromJson(
        initialData,
        context,
      );
      userNode.subscribeToChanges(context);

      final updatedData = {
        "id": id,
        "name": "Initial Partial Name",
        "password": "some_new_password",
      };
      manager.parseNodeData(updatedData);

      await pumpEventQueue();

      expect(userNode.updateCounter, 0);
    });
  });
}
