import 'package:shalom_core/shalom_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class GetSimpleUser_user extends Node {
  String name;
  String email;

  GetSimpleUser_user({
    required super.id,
    required this.name,
    required this.email,
  });
  static GetSimpleUser_user fromJson(
    JsonObject data, {
    ShalomContext? context,
  }) {
    if (context != null) {
      context.manager.parseNodeData(data);
    }

    final String id_value;
    final id$raw = data["id"];
    id_value = id$raw as String;

    final String name_value;
    final name$raw = data["name"];
    name_value = name$raw as String;

    final String email_value;
    final email$raw = data["email"];
    email_value = email$raw as String;

    return GetSimpleUser_user(
      id: id_value,
      name: name_value,
      email: email_value,
    );
  }

  @override
  NodeSubscriptionController subscribeToChanges(ShalomContext context) {
    return context.manager.register(this, {'id', 'name', 'email'}, context);
  }

  @override
  void updateWithJson(JsonObject rawData, Set<String> changedFields) {
    for (final fieldName in changedFields) {
      switch (fieldName) {
        case 'id':
          final id$raw = rawData['id'];
          id = id$raw as String;
          break;

        case 'name':
          final name$raw = rawData['name'];
          name = name$raw as String;
          break;

        case 'email':
          final email$raw = rawData['email'];
          email = email$raw as String;
          break;
      }
    }
    notifyListeners();
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetSimpleUser_user &&
            other.id == id &&
            other.name == name &&
            other.email == email);
  }

  @override
  int get hashCode => Object.hashAll([id, name, email]);

  @override
  JsonObject toJson() {
    return {'id': this.id, 'name': this.name, 'email': this.email};
  }
}

void main() {
  group("test subscription synchronization", () {
    late NodeManager manager;
    late ShalomContext context;

    setUp(() {
      manager = NodeManager();
      context = ShalomContext(manager: manager);
    });

    testWidgets("node is updated by new data with the same id", (tester) async {
      const id = "1";
      final initialUserData = {
        "id": id,
        "name": "qtgql",
        "email": "qtgql@gmail.com",
      };

      final initialUserNode = GetSimpleUser_user.fromJson(
        initialUserData,
        context: context,
      );
      await runNodeWidget(tester, initialUserNode, context);

      final nextUserData = {
        "id": id,
        "name": "shalom",
        "email": "shalom@gmail.com",
      };

      GetSimpleUser_user.fromJson(nextUserData, context: context);
      await tester.pump();

      expect(initialUserNode.toJson(), nextUserData);
    });

    testWidgets("node is not updated by data with a different id", (
      tester,
    ) async {
      final initialUserData = {
        "id": "1",
        "name": "qtgql",
        "email": "qtgql@gmail.com",
      };
      final initialUserNode = GetSimpleUser_user.fromJson(
        initialUserData,
        context: context,
      );
      await runNodeWidget(tester, initialUserNode, context);

      final nextUserData = {
        "id": "2",
        "name": "shalom",
        "email": "shalom@gmail.com",
      };

      GetSimpleUser_user.fromJson(nextUserData, context: context);

      await tester.pump();

      expect(initialUserNode.toJson(), initialUserData);
    });

    testWidgets("no update after widget disposal (subscription is cancelled)", (
      tester,
    ) async {
      const id = "1";
      final initialUserData = {
        "id": id,
        "name": "qtgql",
        "email": "qtgql@gmail.com",
      };
      final initialUserNode = GetSimpleUser_user.fromJson(
        initialUserData,
        context: context,
      );
      await runNodeWidget(tester, initialUserNode, context);

      await tester.pumpWidget(const SizedBox());

      final nextUserData = {
        "id": id,
        "name": "shalom",
        "email": "shalom@gmail.com",
      };

      GetSimpleUser_user.fromJson(nextUserData, context: context);

      await tester.pump();

      expect(initialUserNode.toJson(), initialUserData);
    });
  });
}

Future<void> runNodeWidget<T extends Node>(
  WidgetTester tester,
  T node,
  ShalomContext context,
) async {
  await tester.pumpWidget(
    MaterialApp(
      home: NodeWidget<T>(
        node: node,
        context: context,
        builder: (_, node) => const SizedBox(),
      ),
    ),
  );
}
