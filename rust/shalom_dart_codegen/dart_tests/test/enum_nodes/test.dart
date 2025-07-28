import 'package:test/test.dart';
import 'package:shalom_core/shalom_core.dart';
import '__graphql__/GetUserWithStatus.shalom.dart';
import '__graphql__/GetUserWithOptionalNameAndStatus.shalom.dart';
import '__graphql__/schema.shalom.dart';

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

class Testable_GetUserWithStatus_user extends GetUserWithStatus_user
    with UpdateCounterMixin {
  Testable_GetUserWithStatus_user({
    required super.id,
    required super.name,
    required super.status,
  });

  static Testable_GetUserWithStatus_user fromJson(
      JsonObject data, ShalomContext context) {
    context.manager.parseNodeData(data);
    return Testable_GetUserWithStatus_user(
      id: data['id'] as String,
      name: data['name'] as String,
      status: Status.fromString(data['status'] as String),
    );
  }
}

class Testable_GetUserWithOptionalNameAndStatus_userOptional
    extends GetUserWithOptionalNameAndStatus_userOptional with UpdateCounterMixin {
  Testable_GetUserWithOptionalNameAndStatus_userOptional({
    required super.id,
    super.name,
    required super.status,
  });

  static Testable_GetUserWithOptionalNameAndStatus_userOptional fromJson(
      JsonObject data, ShalomContext context) {
    context.manager.parseNodeData(data);
    return Testable_GetUserWithOptionalNameAndStatus_userOptional(
      id: data['id'] as String,
      name: data['name'] as String?,
      status: Status.fromString(data['status'] as String),
    );
  }
}

void main() {
  group("test GetUserWithStatus_user updateWithJson", () {
    late NodeManager manager;
    late ShalomContext context;

    const id = "user:status:1";
    final initialUserData = {
      "id": id,
      "name": "qtgql",
      "status": "ACTIVE",
    };
    final nextUserData = {
      "id": id,
      "name": "shalom",
      "status": "INACTIVE",
    };

    setUp(() {
      manager = NodeManager();
      context = ShalomContext(manager: manager);
    });

    test("all fields updated on subscribed node", () async {
      final userNode =
          Testable_GetUserWithStatus_user.fromJson(initialUserData, context);
      userNode.subscribeToChanges(context);

      manager.parseNodeData(nextUserData);

      await pumpEventQueue();
      expect(userNode.updateCounter, 1);
      expect(userNode.toJson(), nextUserData);
    });

    test("unsubscribed node does not receive updates", () async {
      final userNode =
          Testable_GetUserWithStatus_user.fromJson(initialUserData, context);

      manager.parseNodeData(nextUserData);

      await pumpEventQueue();
      expect(userNode.updateCounter, 0);
      expect(userNode.toJson(), initialUserData);
    });
  });

  group("test GetUserWithOptionalNameAndStatus_userOptional updateWithJson",
      () {
    late NodeManager manager;
    late ShalomContext context;

    const id = "user:optional_status:1";
    final initialData = {
      "id": id,
      "name": "Initial Name",
      "status": "PENDING",
    };

    setUp(() {
      manager = NodeManager();
      context = ShalomContext(manager: manager);
    });

    test("updates status on subscribed node", () async {
      final userNode =
          Testable_GetUserWithOptionalNameAndStatus_userOptional.fromJson(
              initialData, context);
      userNode.subscribeToChanges(context);

      final updatedData = {
        "id": id,
        "status": "ACTIVE",
      };
      manager.parseNodeData(updatedData);

      await pumpEventQueue();
      expect(userNode.updateCounter, 1);
      expect(userNode.status, Status.ACTIVE);
      expect(userNode.name, "Initial Name"); // Name should not change
    });

    test("no update triggered when data has not changed", () async {
       final userNode =
          Testable_GetUserWithOptionalNameAndStatus_userOptional.fromJson(
              initialData, context);
      userNode.subscribeToChanges(context);

      manager.parseNodeData(initialData);

      await pumpEventQueue();
      expect(userNode.updateCounter, 0);
    });
  });
}