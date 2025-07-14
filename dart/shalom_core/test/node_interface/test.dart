import 'package:shalom_core/shalom_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '__graphql__/SubscribeToAllFields.shalom.dart';
import '__graphql__/SubscribeToSomeFields.shalom.dart';

void main() {
  group("test subscription synchronization", () {
    late NodeManager manager;
    late ShalomContext context;

    setUp(() {
      manager = NodeManager();
      context = ShalomContext(manager: manager);
    });

    testWidgets("all subscribed fields with all fields updated",
        (tester) async {
      const id = "1";
      final initialUserData = {
        "id": id,
        "name": "qtgql",
        "email": "qtgql@gmail.com",
        "age": 2
      };
      final initialUserNode =
          SubscribeToAllFields_user.deserialize(initialUserData, context);
      await runNodeWidget(tester, initialUserNode, context);

      final nextUserData = {
        "id": id,
        "name": "shalom",
        "email": "shalom@gmail.com",
        "age": 1
      };
      SubscribeToAllFields_user.deserialize(nextUserData, context);
      await tester.pump();

      expect(initialUserNode.toJson(), nextUserData);
    });

    testWidgets("some subscribed fields with all fields updated",
        (tester) async {
      const id = "1";
      final initialUserData = {"id": id, "name": "qtgql"};
      final initialUserNode =
          SubscribeToSomeFields_user.deserialize(initialUserData, context);
      await runNodeWidget(tester, initialUserNode, context);

      final nextUserData = {
        "id": id,
        "name": "shalom",
        "email": "shalom@gmail.com",
        "age": 1
      };
      SubscribeToAllFields_user.deserialize(nextUserData, context);
      await tester.pump();

      expect(initialUserNode.toJson(), {"id": id, "name": "shalom"});
    });

    testWidgets("subscribed fields with node with other id updated",
        (tester) async {
      final initialUserData = {
        "id": "1",
        "name": "qtgql",
        "email": "qtgql@gmail.com",
        "age": 2
      };
      final initialUserNode =
          SubscribeToAllFields_user.deserialize(initialUserData, context);
      await runNodeWidget(tester, initialUserNode, context);

      final nextUserData = {"id": "2", "name": "shalom"};
      SubscribeToSomeFields_user.deserialize(nextUserData, context);

      await tester.pump();

      expect(initialUserNode.toJson(), initialUserData);
    });

    testWidgets("no update after widget disposal", (tester) async {
      const id = "1";
      final initialUserData = {
        "id": id,
        "name": "qtgql",
        "email": "qtgql@gmail.com",
        "age": 2
      };
      final initialUserNode =
          SubscribeToAllFields_user.deserialize(initialUserData, context);
      await runNodeWidget(tester, initialUserNode, context);

      await tester.pumpWidget(const SizedBox());
      final nextUserData = {"id": id, "name": "shalom"};
      SubscribeToSomeFields_user.deserialize(nextUserData, context);

      await tester.pump();

      expect(initialUserNode.toJson(), initialUserData);
    });
  });
}

Future<void> runNodeWidget<T extends Node>(
    WidgetTester tester, T node, ShalomContext context) async {
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
