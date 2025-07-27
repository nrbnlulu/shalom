import 'package:shalom_core/shalom_core.dart';
import '__graphql__/SubscribeToAllFields.shalom.dart';
import '__graphql__/SubscribeToSomeFields.shalom.dart';
import 'package:test/test.dart';

typedef JsonObject = Map<String, dynamic>;

mixin UpdateCounterMixin on Node {
  int updateCounter = 0;

  @override
  void updateWithJson(
    JsonObject rawData,
    Set<String> changedFields,
    ShalomContext context,
  ) {
    super.updateWithJson(rawData, changedFields, context);
    updateCounter++;
  }
}

class TestSubscribeToAllFields_user extends SubscribeToAllFields_user
    with UpdateCounterMixin {
  TestSubscribeToAllFields_user({
    required super.id,
    required super.name,
    required super.email,
    required super.age,
  });
}

class TestSubscribeToSomeFields_user extends SubscribeToSomeFields_user
    with UpdateCounterMixin {
  TestSubscribeToSomeFields_user({required super.id, required super.name});
}

void main() {
  group("test updateWithJson", () {
    late NodeManager manager;
    late ShalomContext context;

    const id = "1";
    const initialUserData = {
      "id": id,
      "name": "qtgql",
      "email": "qtgql@gmail.com",
      "age": 2,
    };
    const nextUserData = {
      "id": id,
      "name": "shalom",
      "email": "shalom@gmail.com",
      "age": 1,
    };

    setUp(() {
      manager = NodeManager();
      context = ShalomContext(manager: manager);
    });

    test("all subscribed fields with all fields updated", () async {
      manager.parseNodeData(initialUserData);
      final initialUserNode = TestSubscribeToAllFields_user(
        id: initialUserData['id'] as String,
        name: initialUserData['name'] as String,
        email: initialUserData['email'] as String,
        age: initialUserData['age'] as int,
      );
      initialUserNode.subscribeToChanges(context);

      manager.parseNodeData(nextUserData);

      await pumpEventQueue();
      expect(initialUserNode.updateCounter, 1);
      expect(initialUserNode.toJson(), nextUserData);
    });

    test("some subscribed fields with all fields updated", () async {
      manager.parseNodeData(initialUserData);
      final initialUserNode = TestSubscribeToSomeFields_user(
        id: initialUserData['id'] as String,
        name: initialUserData['name'] as String,
      );
      initialUserNode.subscribeToChanges(context);

      manager.parseNodeData(nextUserData);

      await pumpEventQueue();
      expect(initialUserNode.updateCounter, 1);
      expect(initialUserNode.toJson(), {
        "id": id,
        "name": nextUserData["name"],
      });
    });

    test("other node id updated", () async {
      manager.parseNodeData(initialUserData);
      final initialUserNode = TestSubscribeToAllFields_user(
        id: initialUserData['id'] as String,
        name: initialUserData['name'] as String,
        email: initialUserData['email'] as String,
        age: initialUserData['age'] as int,
      );
      initialUserNode.subscribeToChanges(context);

      final otherNodeData = {"id": "2", "name": "other user"};
      manager.parseNodeData(otherNodeData);

      expect(initialUserNode.updateCounter, 0);
      expect(initialUserNode.toJson(), initialUserData);
    });

    test("no changed fields", () async {
      manager.parseNodeData(initialUserData);
      final initialUserNode = TestSubscribeToSomeFields_user(
        id: initialUserData['id'] as String,
        name: initialUserData['name'] as String,
      );
      initialUserNode.subscribeToChanges(context);

      manager.parseNodeData(initialUserData);

      expect(initialUserNode.updateCounter, 0);
      expect(initialUserNode.toJson(), {
        "id": initialUserData["id"],
        "name": initialUserData["name"],
      });
    });

    test("unsubscribed", () async {
      manager.parseNodeData(initialUserData);
      final initialUserNode = TestSubscribeToAllFields_user(
        id: initialUserData['id'] as String,
        name: initialUserData['name'] as String,
        email: initialUserData['email'] as String,
        age: initialUserData['age'] as int,
      );

      manager.parseNodeData(nextUserData);

      await pumpEventQueue();
      expect(initialUserNode.updateCounter, 0);
      expect(initialUserNode.toJson(), initialUserData);
    });

    test("subscribed then unsubscribed", () async {
      manager.parseNodeData(initialUserData);
      final initialUserNode = TestSubscribeToAllFields_user(
        id: initialUserData['id'] as String,
        name: initialUserData['name'] as String,
        email: initialUserData['email'] as String,
        age: initialUserData['age'] as int,
      );
      final subscription = initialUserNode.subscribeToChanges(context);
      subscription.cancel();

      manager.parseNodeData(nextUserData);

      await pumpEventQueue();
      expect(initialUserNode.updateCounter, 0);
      expect(initialUserNode.toJson(), initialUserData);
    });
  });
}
