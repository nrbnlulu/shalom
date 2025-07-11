import 'package:test/test.dart';
import 'package:shalom_core/shalom_core.dart';
import '__graphql__/GetUser.shalom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
    test("test sync nodes", () {
        final manager = NodeManager();
        final context = ShalomContext(manager: manager);
        final id = "1";
        final initialUserData = {"id": id, "name": "qtgql", "email": "qtgql@gmail.com", "age": 2};
        final initialUserNode = GetUser_user.deserialize(initialUserData, context);
        NodeWidget<GetUser_user>(node: initialUserNode, builder: (_, node) => SizedBox(width: 16), context: context);  
        final nextUserData = {"id": id, "name": "shalom", "email": "shalom@gmail.com", "age": 1}; 
        GetUser_user.deserialize(nextUserData, context);
        print(initialUserNode.toJson());
    });
}
