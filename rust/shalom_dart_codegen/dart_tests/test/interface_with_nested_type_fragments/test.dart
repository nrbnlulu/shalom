import "dart:async";

import "package:shalom_core/shalom_core.dart";
import 'package:test/test.dart';
import "__graphql__/NodeGlobalFrag.shalom.dart";
import "__graphql__/NodeGlobalQuery.shalom.dart";
import "__graphql__/NodeGlobalQueryOpt.shalom.dart";
import "__graphql__/NodesGlobalQuery.shalom.dart";

void main() {
  final fooData = {
    "node": {
      "__typename": "Foo",
      "id": "foo1",
      "createdAt": "2024-01-01T00:00:00Z",
      "fooField": "foo field value",
      "fooValue": 42
    }
  };

  final barData = {
    "node": {
      "__typename": "Bar",
      "id": "bar1",
      "createdAt": "2024-01-02T00:00:00Z",
      "barField": "bar field value",
      "barValue": 3.14
    }
  };

  final bazData = {
    "node": {
      "__typename": "Baz",
      "id": "baz1",
      "createdAt": "2024-01-03T00:00:00Z",
      "bazField": "baz field value",
      "bazValue": true
    }
  };

  group('Test interface with nested type fragments - required', () {
    test('interfaceWithNestedTypeFragmentsRequired - Foo', () {
      final variables = NodeGlobalQueryVariables(id: "foo1");
      final result =
          NodeGlobalQueryResponse.fromResponse(fooData, variables: variables);

      // Verify it's the correct type
      expect(result.node, isA<NodeGlobalQuery_node__Foo>());
      expect(result.node, isA<NodeGlobalFrag>());

      // Access through interface fragment
      final nodeFrag = result.node as NodeGlobalFrag;
      expect(nodeFrag.id, "foo1");
      expect(nodeFrag.createdAt, "2024-01-01T00:00:00Z");

      // Access through concrete type
      final foo = result.node as NodeGlobalQuery_node__Foo;
      expect(foo.id, "foo1");
      expect(foo.createdAt, "2024-01-01T00:00:00Z");
      expect(foo.fooField, "foo field value");
      expect(foo.fooValue, 42);
      expect(foo.$__typename, "Foo");
    });

    test('interfaceWithNestedTypeFragmentsRequired - Bar', () {
      final variables = NodeGlobalQueryVariables(id: "bar1");
      final result =
          NodeGlobalQueryResponse.fromResponse(barData, variables: variables);

      expect(result.node, isA<NodeGlobalQuery_node__Bar>());
      expect(result.node, isA<NodeGlobalFrag>());

      final nodeFrag = result.node as NodeGlobalFrag;
      expect(nodeFrag.id, "bar1");
      expect(nodeFrag.createdAt, "2024-01-02T00:00:00Z");

      final bar = result.node as NodeGlobalQuery_node__Bar;
      expect(bar.id, "bar1");
      expect(bar.createdAt, "2024-01-02T00:00:00Z");
      expect(bar.barField, "bar field value");
      expect(bar.barValue, 3.14);
      expect(bar.$__typename, "Bar");
    });

    test('interfaceWithNestedTypeFragmentsRequired - Baz', () {
      final variables = NodeGlobalQueryVariables(id: "baz1");
      final result =
          NodeGlobalQueryResponse.fromResponse(bazData, variables: variables);

      expect(result.node, isA<NodeGlobalQuery_node__Baz>());
      expect(result.node, isA<NodeGlobalFrag>());

      final nodeFrag = result.node as NodeGlobalFrag;
      expect(nodeFrag.id, "baz1");
      expect(nodeFrag.createdAt, "2024-01-03T00:00:00Z");

      final baz = result.node as NodeGlobalQuery_node__Baz;
      expect(baz.id, "baz1");
      expect(baz.createdAt, "2024-01-03T00:00:00Z");
      expect(baz.bazField, "baz field value");
      expect(baz.bazValue, true);
      expect(baz.$__typename, "Baz");
    });

    test('equals - Foo', () {
      final variables = NodeGlobalQueryVariables(id: "foo1");
      final result1 =
          NodeGlobalQueryResponse.fromResponse(fooData, variables: variables);
      final result2 =
          NodeGlobalQueryResponse.fromResponse(fooData, variables: variables);
      expect(result1, equals(result2));
    });

    test('equals - Bar', () {
      final variables = NodeGlobalQueryVariables(id: "bar1");
      final result1 =
          NodeGlobalQueryResponse.fromResponse(barData, variables: variables);
      final result2 =
          NodeGlobalQueryResponse.fromResponse(barData, variables: variables);
      expect(result1, equals(result2));
    });

    test('not equals - different types', () {
      final variables = NodeGlobalQueryVariables(id: "test");
      final result1 =
          NodeGlobalQueryResponse.fromResponse(fooData, variables: variables);
      final result2 =
          NodeGlobalQueryResponse.fromResponse(barData, variables: variables);
      expect(result1, isNot(equals(result2)));
    });

    test('toJson - Foo', () {
      final variables = NodeGlobalQueryVariables(id: "foo1");
      final initial =
          NodeGlobalQueryResponse.fromResponse(fooData, variables: variables);
      final json = initial.toJson();
      expect(json, fooData);
    });

    test('toJson - Bar', () {
      final variables = NodeGlobalQueryVariables(id: "bar1");
      final initial =
          NodeGlobalQueryResponse.fromResponse(barData, variables: variables);
      final json = initial.toJson();
      expect(json, barData);
    });

    test('toJson - Baz', () {
      final variables = NodeGlobalQueryVariables(id: "baz1");
      final initial =
          NodeGlobalQueryResponse.fromResponse(bazData, variables: variables);
      final json = initial.toJson();
      expect(json, bazData);
    });
  });

  final fooOptData = {
    "nodeOpt": {
      "__typename": "Foo",
      "id": "foo2",
      "createdAt": "2024-01-04T00:00:00Z",
      "fooField": "optional foo",
      "fooValue": 99
    }
  };

  final nodeOptNullData = {"nodeOpt": null};

  group('Test interface with nested type fragments - optional', () {
    test('interfaceWithNestedTypeFragmentsOptional - Foo', () {
      final variables = NodeGlobalQueryOptVariables(id: "foo2");
      final result = NodeGlobalQueryOptResponse.fromResponse(fooOptData,
          variables: variables);

      expect(result.nodeOpt, isNotNull);
      expect(result.nodeOpt, isA<NodeGlobalQueryOpt_nodeOpt__Foo>());
      expect(result.nodeOpt, isA<NodeGlobalFrag>());

      final nodeFrag = result.nodeOpt as NodeGlobalFrag;
      expect(nodeFrag.id, "foo2");
      expect(nodeFrag.createdAt, "2024-01-04T00:00:00Z");

      final foo = result.nodeOpt as NodeGlobalQueryOpt_nodeOpt__Foo;
      expect(foo.id, "foo2");
      expect(foo.fooField, "optional foo");
      expect(foo.fooValue, 99);
    });

    test('interfaceWithNestedTypeFragmentsOptional - null', () {
      final variables = NodeGlobalQueryOptVariables(id: "none");
      final result = NodeGlobalQueryOptResponse.fromResponse(nodeOptNullData,
          variables: variables);
      expect(result.nodeOpt, isNull);
    });

    test('equals - with value', () {
      final variables = NodeGlobalQueryOptVariables(id: "foo2");
      final result1 = NodeGlobalQueryOptResponse.fromResponse(fooOptData,
          variables: variables);
      final result2 = NodeGlobalQueryOptResponse.fromResponse(fooOptData,
          variables: variables);
      expect(result1, equals(result2));
    });

    test('equals - null', () {
      final variables = NodeGlobalQueryOptVariables(id: "none");
      final result1 = NodeGlobalQueryOptResponse.fromResponse(nodeOptNullData,
          variables: variables);
      final result2 = NodeGlobalQueryOptResponse.fromResponse(nodeOptNullData,
          variables: variables);
      expect(result1, equals(result2));
    });

    test('toJson - with value', () {
      final variables = NodeGlobalQueryOptVariables(id: "foo2");
      final initial = NodeGlobalQueryOptResponse.fromResponse(fooOptData,
          variables: variables);
      final json = initial.toJson();
      expect(json, fooOptData);
    });

    test('toJson - null', () {
      final variables = NodeGlobalQueryOptVariables(id: "none");
      final initial = NodeGlobalQueryOptResponse.fromResponse(nodeOptNullData,
          variables: variables);
      final json = initial.toJson();
      expect(json, nodeOptNullData);
    });
  });

  final nodesListData = {
    "nodes": [
      {
        "__typename": "Foo",
        "id": "foo3",
        "createdAt": "2024-01-05T00:00:00Z",
        "fooField": "list foo",
        "fooValue": 10
      },
      {
        "__typename": "Bar",
        "id": "bar3",
        "createdAt": "2024-01-06T00:00:00Z",
        "barField": "list bar",
        "barValue": 2.71
      },
      {
        "__typename": "Baz",
        "id": "baz3",
        "createdAt": "2024-01-07T00:00:00Z",
        "bazField": "list baz",
        "bazValue": false
      }
    ]
  };

  group('Test interface with nested type fragments - list', () {
    test('interfaceWithNestedTypeFragmentsList - mixed types', () {
      final result = NodesGlobalQueryResponse.fromResponse(nodesListData);

      expect(result.nodes.length, 3);
      expect(result.nodes[0], isA<NodesGlobalQuery_nodes__Foo>());
      expect(result.nodes[0], isA<NodeGlobalFrag>());
      expect(result.nodes[1], isA<NodesGlobalQuery_nodes__Bar>());
      expect(result.nodes[1], isA<NodeGlobalFrag>());
      expect(result.nodes[2], isA<NodesGlobalQuery_nodes__Baz>());
      expect(result.nodes[2], isA<NodeGlobalFrag>());

      final foo = result.nodes[0] as NodesGlobalQuery_nodes__Foo;
      expect(foo.id, "foo3");
      expect(foo.fooField, "list foo");
      expect(foo.fooValue, 10);

      final bar = result.nodes[1] as NodesGlobalQuery_nodes__Bar;
      expect(bar.id, "bar3");
      expect(bar.barField, "list bar");
      expect(bar.barValue, 2.71);

      final baz = result.nodes[2] as NodesGlobalQuery_nodes__Baz;
      expect(baz.id, "baz3");
      expect(baz.bazField, "list baz");
      expect(baz.bazValue, false);

      // Test fragment interface access for each item
      for (var node in result.nodes) {
        expect(node, isA<NodeGlobalFrag>());
        final nodeFrag = node as NodeGlobalFrag;
        expect(nodeFrag.id, isNotEmpty);
        expect(nodeFrag.createdAt, isNotEmpty);
      }
    });

    test('toJson - list', () {
      final initial = NodesGlobalQueryResponse.fromResponse(nodesListData);
      final json = initial.toJson();
      expect(json, nodesListData);
    });

    test('equals - list', () {
      final result1 = NodesGlobalQueryResponse.fromResponse(nodesListData);
      final result2 = NodesGlobalQueryResponse.fromResponse(nodesListData);
      expect(result1, equals(result2));
    });
  });

  group('interfaceWithNestedTypeFragmentsCacheNormalization', () {
    test('Foo to Bar type change', () async {
      final ctx = ShalomCtx.withCapacity();
      final variables = NodeGlobalQueryVariables(id: "node1");

      var (result, updateCtx) = NodeGlobalQueryResponse.fromResponseImpl(
        fooData,
        ctx,
        variables,
      );

      expect(result.node, isA<NodeGlobalQuery_node__Foo>());
      expect(result.node, isA<NodeGlobalFrag>());

      final hasChanged = Completer<bool>();
      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = NodeGlobalQueryResponse.fromCache(newCtx, variables);
        hasChanged.complete(true);
      });

      final nextResult = NodeGlobalQueryResponse.fromResponse(
        barData,
        ctx: ctx,
        variables: variables,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.node, isA<NodeGlobalQuery_node__Bar>());
      expect(result.node, isA<NodeGlobalFrag>());
    });

    test('optional - null to Foo', () async {
      final ctx = ShalomCtx.withCapacity();
      final variables = NodeGlobalQueryOptVariables(id: "node1");

      var (result, updateCtx) = NodeGlobalQueryOptResponse.fromResponseImpl(
        nodeOptNullData,
        ctx,
        variables,
      );

      expect(result.nodeOpt, isNull);

      final hasChanged = Completer<bool>();
      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = NodeGlobalQueryOptResponse.fromCache(newCtx, variables);
        hasChanged.complete(true);
      });

      final nextResult = NodeGlobalQueryOptResponse.fromResponse(
        fooOptData,
        ctx: ctx,
        variables: variables,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.nodeOpt, isNotNull);
      expect(result.nodeOpt, isA<NodeGlobalFrag>());
    });

    test('optional - Foo to null', () async {
      final ctx = ShalomCtx.withCapacity();
      final variables = NodeGlobalQueryOptVariables(id: "node1");

      var (result, updateCtx) = NodeGlobalQueryOptResponse.fromResponseImpl(
        fooOptData,
        ctx,
        variables,
      );

      expect(result.nodeOpt, isNotNull);
      expect(result.nodeOpt, isA<NodeGlobalFrag>());

      final hasChanged = Completer<bool>();
      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = NodeGlobalQueryOptResponse.fromCache(newCtx, variables);
        hasChanged.complete(true);
      });

      final nextResult = NodeGlobalQueryOptResponse.fromResponse(
        nodeOptNullData,
        ctx: ctx,
        variables: variables,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.nodeOpt, isNull);
    });

    test('fragment fields update within same type', () async {
      final ctx = ShalomCtx.withCapacity();
      final variables = NodeGlobalQueryVariables(id: "node1");

      final initialFooData = {
        "node": {
          "__typename": "Foo",
          "id": "node1",
          "createdAt": "2024-01-01T00:00:00Z",
          "fooField": "old value",
          "fooValue": 1
        }
      };

      var (result, updateCtx) = NodeGlobalQueryResponse.fromResponseImpl(
        initialFooData,
        ctx,
        variables,
      );

      expect(result.node, isA<NodeGlobalQuery_node__Foo>());
      final foo1 = result.node as NodeGlobalQuery_node__Foo;
      expect(foo1.fooField, "old value");
      expect(foo1.fooValue, 1);

      final hasChanged = Completer<bool>();
      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = NodeGlobalQueryResponse.fromCache(newCtx, variables);
        hasChanged.complete(true);
      });

      final updatedFooData = {
        "node": {
          "__typename": "Foo",
          "id": "node1",
          "createdAt": "2024-01-01T00:00:00Z",
          "fooField": "new value",
          "fooValue": 999
        }
      };

      final nextResult = NodeGlobalQueryResponse.fromResponse(
        updatedFooData,
        ctx: ctx,
        variables: variables,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      final foo2 = result.node as NodeGlobalQuery_node__Foo;
      expect(foo2.fooField, "new value");
      expect(foo2.fooValue, 999);
    });
  });
}
