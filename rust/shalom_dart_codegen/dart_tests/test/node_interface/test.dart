import 'dart:async';
import 'package:test/test.dart';
import 'package:shalom_core/shalom_core.dart';
import '__graphql__/GetSimpleUser.shalom.dart';
import '__graphql__/GetUserWithNestedFields.shalom.dart';

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

class Testable_GetSimpleUser_user extends GetSimpleUser_user
    with UpdateCounterMixin {
  Testable_GetSimpleUser_user({
    required super.id,
    required super.name,
    required super.email,
  });

  static Testable_GetSimpleUser_user fromJson(
    JsonObject data,
    ShalomContext context, [
    List<ID>? parents,
  ]) {
    context.manager.parseNodeData(data);
    return Testable_GetSimpleUser_user(
      id: data["id"] as String,
      name: data["name"] as String,
      email: data["email"] as String,
    );
  }
}

class Testable_Post extends GetUserWithNestedFields_user_post
    with UpdateCounterMixin {
  Testable_Post({required super.id, required super.title});

  static Testable_Post fromJson(JsonObject data, ShalomContext? context) {
    if (context != null) {
      context.manager.parseNodeData(data);
    }
    return Testable_Post(
      id: data["id"] as String,
      title: data["title"] as String,
    );
  }
}

class Testable_User extends GetUserWithNestedFields_user
    with UpdateCounterMixin {
  Testable_User({
    required super.id,
    required super.name,
    super.address,
    required super.post,
  });

  static Testable_User fromJson(JsonObject data, ShalomContext? context) {
    if (context != null) {
      context.manager.parseNodeData(data);
    }
    return Testable_User(
      id: data["id"] as String,
      name: data["name"] as String,
      address:
          data["address"] == null
              ? null
              : GetUserWithNestedFields_user_address.fromJson(
                data["address"],
                context: context,
              ),

      post: Testable_Post.fromJson(data["post"], context),
    );
  }
}

void main() {
  group("test GetSimpleUser_user updateWithJson", () {
    late NodeManager manager;
    late ShalomContext context;

    const id = "1";
    const initialUserData = {
      "id": id,
      "name": "qtgql",
      "email": "qtgql@gmail.com",
    };
    const nextUserData = {
      "id": id,
      "name": "shalom",
      "email": "shalom@gmail.com",
    };

    setUp(() {
      manager = NodeManager();
      context = ShalomContext(manager: manager);
    });

    test("all fields updated on subscribed node", () async {
      final userNode = Testable_GetSimpleUser_user.fromJson(
        initialUserData,
        context,
      );
      userNode.subscribeToChanges(context);

      manager.parseNodeData(nextUserData);

      await pumpEventQueue();
      expect(userNode.updateCounter, 1);
      expect(userNode.toJson(), nextUserData);
    });

    test("one field updated on subscribed node", () async {
      final userNode = Testable_GetSimpleUser_user.fromJson(
        initialUserData,
        context,
      );
      userNode.subscribeToChanges(context);

      manager.parseNodeData({"id": id, "name": "shalom-new"});

      await pumpEventQueue();
      expect(userNode.updateCounter, 1);
      expect(userNode.name, "shalom-new");
    });

    test("update to another node does not trigger update", () async {
      final userNode = Testable_GetSimpleUser_user.fromJson(
        initialUserData,
        context,
      );
      userNode.subscribeToChanges(context);

      manager.parseNodeData({"id": "2", "name": "other user"});

      await pumpEventQueue();
      expect(userNode.updateCounter, 0);
      expect(userNode.toJson(), initialUserData);
    });

    test("no update triggered when data has not changed", () async {
      final userNode = Testable_GetSimpleUser_user.fromJson(
        initialUserData,
        context,
      );
      userNode.subscribeToChanges(context);

      manager.parseNodeData(initialUserData);

      await pumpEventQueue();
      expect(userNode.updateCounter, 0);
    });

    test("unsubscribed node does not receive updates", () async {
      final userNode = Testable_GetSimpleUser_user.fromJson(
        initialUserData,
        context,
      );

      manager.parseNodeData(nextUserData);

      await pumpEventQueue();
      expect(userNode.updateCounter, 0);
      expect(userNode.toJson(), initialUserData);
    });

    test("cancelled subscription does not receive updates", () async {
      final userNode = Testable_GetSimpleUser_user.fromJson(
        initialUserData,
        context,
      );
      final subscription = userNode.subscribeToChanges(context);
      subscription.unsubscribe();

      manager.parseNodeData(nextUserData);

      await pumpEventQueue();
      expect(userNode.updateCounter, 0);
      expect(userNode.toJson(), initialUserData);
    });
  });

  group("test GetUserWithNestedFields updateWithJson", () {
    late NodeManager manager;
    late ShalomContext context;

    const user1Id = "user:1";
    const post1Id = "post:1";

    const initialData = {
      "id": user1Id,
      "name": "Original Name",
      "address": {"street": "123 Main St", "city": "Anytown"},
      "post": {"id": post1Id, "title": "Original Post Title"},
    };

    setUp(() {
      manager = NodeManager();
      context = ShalomContext(manager: manager);
    });

    test("updates top-level field", () async {
      final userNode = Testable_User.fromJson(initialData, context);
      userNode.subscribeToChanges(context);

      manager.parseNodeData({"id": user1Id, "name": "New Name"});

      await pumpEventQueue();
      expect(userNode.updateCounter, 1);
      expect(userNode.name, "New Name");
    });

    test("does not updated when nested node object changes", () async {
      final userNode = Testable_User.fromJson(initialData, context);
      userNode.subscribeToChanges(context);

      final updatedData = {
        "id": user1Id,
        "post": {"id": post1Id, "title": "New Post Title"},
      };
      manager.parseNodeData(updatedData);

      await pumpEventQueue();
      expect(userNode.updateCounter, 0);
      expect(userNode.post.title, "Original Post Title");
    });

    test("updates when nested non-node object changes", () async {
      final userNode = Testable_User.fromJson(initialData, context);
      userNode.subscribeToChanges(context);

      final updatedData = {
        "id": user1Id,
        "address": {"street": "456 Side St", "city": "New City"},
      };
      manager.parseNodeData(updatedData);

      await pumpEventQueue();
      expect(userNode.updateCounter, 1);
      expect(userNode.address?.city, "New City");
    });
  });
}
