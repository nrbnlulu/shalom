import 'package:shalom_core/shalom_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '__graphql__/SubscribeToAllFields.shalom.dart';
import '__graphql__/SubscribeToSomeFields.shalom.dart';

Future<void> runNodeWidget<T extends Node>(WidgetTester tester, T node, ShalomContext context) async {
  await tester.pumpWidget(
      MaterialApp( 
        home: NodeWidget<T>(
          node: node,
          context: context,
          builder: (_, node) => SizedBox()
        ),
      ),
    );
} 

void main() {
  group("test subscription synchronization", () {
    testWidgets("all subscribed fields", (WidgetTester tester) async {
        final manager = NodeManager();
        final context = ShalomContext(manager: manager);
        final id = "1";
        final initialUserData = {"id": id, "name": "qtgql", "email": "qtgql@gmail.com", "age": 2};
        final initialUserNode = SubscribeToAllFields_user.deserialize(initialUserData, context);
        await runNodeWidget(tester, initialUserNode, context);
        final nextUserData = {"id": id, "name": "shalom", "email": "shalom@gmail.com", "age": 1}; 
        SubscribeToAllFields_user.deserialize(nextUserData, context);
        expect(initialUserNode.toJson(), nextUserData);
    });
    testWidgets("some subscribed fields", (WidgetTester tester) async {
        final manager = NodeManager();
        final context = ShalomContext(manager: manager);
        final id = "1";
        final initialUserData = {"id": id, "name": "qtgql", "email": "qtgql@gmail.com", "age": 2};
        final initialUserNode = SubscribeToSomeFields_user.deserialize(initialUserData, context);
        await runNodeWidget(tester, initialUserNode, context);
        final nextUserData = {"id": id, "name": "shalom", "email": "shalom@gmail.com", "age": 1}; 
        SubscribeToSomeFields_user.deserialize(nextUserData, context);
    });
    }
  );
}
