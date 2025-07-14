import 'package:shalom_core/shalom_core.dart';
import '__graphql__/SubscribeToAllFields.shalom.dart';
import '__graphql__/SubscribeToSomeFields.shalom.dart';
import 'package:test/test.dart';

typedef JsonObject = Map<String, dynamic>;

class TestSubscribeToAllFields_user extends SubscribeToAllFields_user {
  int updateCounter = 0;
  TestSubscribeToAllFields_user({
    required super.id,
    required super.name,
    required super.email,
    required super.age,
  });

  @override
  void updateWithJson(
    JsonObject rawData,
    Set<String> changedFields,
    ShalomContext context,
  ) {
    super.updateWithJson(rawData, changedFields, context);
    updateCounter++;
  }

  static TestSubscribeToAllFields_user deserialize(
    JsonObject json,
    ShalomContext context,
  ) {
    final self = TestSubscribeToAllFields_user(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      age: json["age"],
    );
    context.manager.parseNodeData(self.toJson());
    return self;
  }
}

class TestSubscribeToSomeFields_user extends SubscribeToSomeFields_user {
  int updateCounter = 0;
  TestSubscribeToSomeFields_user({required super.id, required super.name});

  @override
  void updateWithJson(
    JsonObject rawData,
    Set<String> changedFields,
    ShalomContext context,
  ) {
    super.updateWithJson(rawData, changedFields, context);
    updateCounter++;
  }

  static TestSubscribeToSomeFields_user deserialize(
    JsonObject json,
    ShalomContext context,
  ) {
    final self = TestSubscribeToSomeFields_user(
      id: json["id"],
      name: json["name"],
    );
    context.manager.parseNodeData(self.toJson());
    return self;
  }
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
      final initialUserNode = TestSubscribeToAllFields_user.deserialize(
        initialUserData,
        context,
      );
      initialUserNode.subscribeToChanges(context);

      manager.parseNodeData(nextUserData);

      await Future.delayed(Duration.zero);
      expect(initialUserNode.updateCounter, 1);
      expect(initialUserNode.toJson(), nextUserData);
    });

    test("some subscribed fields with all fields updated", () async {
      manager.parseNodeData(initialUserData);
      final initialUserNode = TestSubscribeToSomeFields_user.deserialize(
        initialUserData,
        context,
      );
      initialUserNode.subscribeToChanges(context);

      manager.parseNodeData(nextUserData);

      await Future.delayed(Duration.zero);
      expect(initialUserNode.updateCounter, 1);
      expect(initialUserNode.toJson(), {
        "id": id,
        "name": nextUserData["name"],
      });
    });

    test("other node id updated", () async {
      manager.parseNodeData(initialUserData);
      final initialUserNode = TestSubscribeToAllFields_user.deserialize(
        initialUserData,
        context,
      );
      initialUserNode.subscribeToChanges(context);

      final otherNodeData = {"id": "2", "name": "other user"};
      manager.parseNodeData(otherNodeData);

      await Future.delayed(Duration.zero);
      expect(initialUserNode.updateCounter, 0);
      expect(initialUserNode.toJson(), initialUserData);
    });

    test("no changed fields", () async {
      manager.parseNodeData(initialUserData);
      final initialUserNode = TestSubscribeToSomeFields_user.deserialize(
        initialUserData,
        context,
      );
      initialUserNode.subscribeToChanges(context);

      manager.parseNodeData(initialUserData);

      await Future.delayed(Duration.zero);
      expect(initialUserNode.updateCounter, 0);
      expect(initialUserNode.toJson(), {
        "id": initialUserData["id"],
        "name": initialUserData["name"],
      });
    });

    test("unsubscribed", () async {
      manager.parseNodeData(initialUserData);
      final initialUserNode = TestSubscribeToAllFields_user.deserialize(
        initialUserData,
        context,
      );

      manager.parseNodeData(nextUserData);

      await Future.delayed(Duration.zero);
      expect(initialUserNode.updateCounter, 0);
      expect(initialUserNode.toJson(), initialUserData);
    });

    test("subscribed then unsubscribed", () async {
      manager.parseNodeData(initialUserData);
      final initialUserNode = TestSubscribeToAllFields_user.deserialize(
        initialUserData,
        context,
      );
      final subscription = initialUserNode.subscribeToChanges(context);
      subscription.cancel();

      manager.parseNodeData(nextUserData);

      await Future.delayed(Duration.zero);
      expect(initialUserNode.updateCounter, 0);
      expect(initialUserNode.toJson(), initialUserData);
    });
  });
}
