import "dart:async";
import 'package:test/test.dart';
import 'package:shalom_core/shalom_core.dart';
import '__graphql__/nodefields.shalom.dart';
import '__graphql__/authorfields.shalom.dart';
import '__graphql__/timestampedfields.shalom.dart';
import '__graphql__/GetNode.shalom.dart';
import '__graphql__/GetAuthors.shalom.dart';
import '__graphql__/GetUser.shalom.dart';
import '__graphql__/GetPost.shalom.dart';
import '__graphql__/GetComment.shalom.dart';
import '__graphql__/GetNodes.shalom.dart';

void main() {
  group('Interface Fragments', () {
    test(
        'interfaceFragmentRequired - Node interface fragment basic functionality',
        () {
      final data = {
        "node": {
          "id": "node1",
          "__typename": "User",
        },
      };

      final variables = GetNodeVariables(id: "node1");
      final result = GetNodeResponse.fromResponse(data, variables: variables);

      expect(result.node, isNotNull);
      expect(result.node!.id, "node1");
    });

    test(
        'interfaceFragmentRequired - Author interface fragment basic functionality',
        () {
      final data = {
        "authors": [
          {
            "name": "Alice",
            "email": "alice@example.com",
            "__typename": "User",
          },
          {
            "name": "Bob",
            "email": "bob@example.com",
            "__typename": "User",
          },
        ],
      };

      final result = GetAuthorsResponse.fromResponse(data);

      expect(result.authors.length, 2);
      expect(result.authors[0].name, "Alice");
      expect(result.authors[0].email, "alice@example.com");
      expect(result.authors[1].name, "Bob");
      expect(result.authors[1].email, "bob@example.com");
    });

    test('interfaceFragmentOptional - Node interface with nullable response',
        () {
      final data = {
        "node": null,
      };

      final variables = GetNodeVariables(id: "nonexistent");
      final result = GetNodeResponse.fromResponse(data, variables: variables);

      expect(result.node, isNull);
    });

    test(
        'interfaceFragmentRequired - Multiple interface fragments on same type',
        () {
      final data = {
        "user": {
          "id": "user1",
          "name": "Alice",
          "email": "alice@example.com",
          "age": 30,
          "role": "admin",
          "__typename": "User",
        },
      };

      final variables = GetUserVariables(id: "user1");
      final result = GetUserResponse.fromResponse(data, variables: variables);

      expect(result.user, isNotNull);
      // From NodeFields fragment
      expect(result.user!.id, "user1");
      // From AuthorFields fragment
      expect(result.user!.name, "Alice");
      expect(result.user!.email, "alice@example.com");
      // Direct fields
      expect(result.user!.age, 30);
      expect(result.user!.role, "admin");
    });

    test('interfaceFragmentRequired - Timestamped interface fragment', () {
      final data = {
        "post": {
          "id": "post1",
          "createdAt": "2024-01-01T00:00:00Z",
          "updatedAt": "2024-01-02T00:00:00Z",
          "title": "Test Post",
          "content": "Content here",
          "published": true,
          "__typename": "Post",
        },
      };

      final variables = GetPostVariables(id: "post1");
      final result = GetPostResponse.fromResponse(data, variables: variables);

      expect(result.post, isNotNull);
      expect(result.post!.id, "post1");
      expect(result.post!.createdAt, "2024-01-01T00:00:00Z");
      expect(result.post!.updatedAt, "2024-01-02T00:00:00Z");
      expect(result.post!.title, "Test Post");
      expect(result.post!.content, "Content here");
      expect(result.post!.published, true);
    });

    test('interfaceFragmentRequired - Nested interface fragments', () {
      final data = {
        "comment": {
          "id": "comment1",
          "createdAt": "2024-01-01T00:00:00Z",
          "updatedAt": "2024-01-02T00:00:00Z",
          "text": "Great post!",
          "author": {
            "id": "user1",
            "name": "Alice",
            "email": "alice@example.com",
            "__typename": "User",
          },
          "__typename": "Comment",
        },
      };

      final variables = GetCommentVariables(id: "comment1");
      final result =
          GetCommentResponse.fromResponse(data, variables: variables);

      expect(result.comment, isNotNull);
      expect(result.comment!.id, "comment1");
      expect(result.comment!.createdAt, "2024-01-01T00:00:00Z");
      expect(result.comment!.updatedAt, "2024-01-02T00:00:00Z");
      expect(result.comment!.text, "Great post!");

      // Nested author with interface fragments
      expect(result.comment!.author.id, "user1");
      expect(result.comment!.author.name, "Alice");
      expect(result.comment!.author.email, "alice@example.com");
    });

    test('interfaceFragmentRequired - List of interface type', () {
      final data = {
        "nodes": [
          {
            "id": "node1",
            "__typename": "User",
          },
          {
            "id": "node2",
            "__typename": "Post",
          },
          {
            "id": "node3",
            "__typename": "Comment",
          },
        ],
      };

      final result = GetNodesResponse.fromResponse(data);

      expect(result.nodes.length, 3);
      expect(result.nodes[0].id, "node1");
      expect(result.nodes[1].id, "node2");
      expect(result.nodes[2].id, "node3");
    });

    test('equals - Interface fragment equality works', () {
      final data1 = {
        "user": {
          "id": "user1",
          "name": "Alice",
          "email": "alice@example.com",
          "age": 30,
          "role": "admin",
          "__typename": "User",
        },
      };

      final data2 = {
        "user": {
          "id": "user1",
          "name": "Alice",
          "email": "alice@example.com",
          "age": 30,
          "role": "admin",
          "__typename": "User",
        },
      };

      final variables = GetUserVariables(id: "user1");
      final result1 = GetUserResponse.fromResponse(data1, variables: variables);
      final result2 = GetUserResponse.fromResponse(data2, variables: variables);

      expect(result1 == result2, true);
      expect(result1.user == result2.user, true);
    });

    test('equals - Different values are not equal', () {
      final data1 = {
        "user": {
          "id": "user1",
          "name": "Alice",
          "email": "alice@example.com",
          "age": 30,
          "role": "admin",
          "__typename": "User",
        },
      };

      final data2 = {
        "user": {
          "id": "user2",
          "name": "Bob",
          "email": "bob@example.com",
          "age": 25,
          "role": "user",
          "__typename": "User",
        },
      };

      final variables1 = GetUserVariables(id: "user1");
      final variables2 = GetUserVariables(id: "user2");
      final result1 =
          GetUserResponse.fromResponse(data1, variables: variables1);
      final result2 =
          GetUserResponse.fromResponse(data2, variables: variables2);

      expect(result1 == result2, false);
      expect(result1.user == result2.user, false);
    });

    test('toJson - Interface fragment serialization works', () {
      final data = {
        "user": {
          "id": "user1",
          "name": "Alice",
          "email": "alice@example.com",
          "age": 30,
          "role": "admin",
          "__typename": "User",
        },
      };

      final variables = GetUserVariables(id: "user1");
      final result = GetUserResponse.fromResponse(data, variables: variables);
      final json = result.toJson();

      // __typename is not part of the selection set, so it won't be in toJson output
      final expectedJson = {
        "user": {
          "id": "user1",
          "name": "Alice",
          "email": "alice@example.com",
          "age": 30,
          "role": "admin",
        },
      };
      expect(json, expectedJson);
    });

    test('toJson - List of interface fragments serialization', () {
      final data = {
        "authors": [
          {
            "name": "Alice",
            "email": "alice@example.com",
            "__typename": "User",
          },
          {
            "name": "Bob",
            "email": "bob@example.com",
            "__typename": "User",
          },
        ],
      };

      final result = GetAuthorsResponse.fromResponse(data);
      final json = result.toJson();

      // __typename is not part of the selection set, so it won't be in toJson output
      final expectedJson = {
        "authors": [
          {
            "name": "Alice",
            "email": "alice@example.com",
          },
          {
            "name": "Bob",
            "email": "bob@example.com",
          },
        ],
      };
      expect(json, expectedJson);
    });

    test(
        'interfaceFragmentCacheNormalization - Node interface fragment cache works',
        () {
      final ctx = ShalomCtx.withCapacity();

      final data = {
        "user": {
          "id": "user1",
          "name": "Alice",
          "email": "alice@example.com",
          "age": 30,
          "role": "admin",
          "__typename": "User",
        },
      };

      final variables = GetUserVariables(id: "user1");
      final (result, updateCtx) = GetUserResponse.fromResponseImpl(
        data,
        ctx,
        variables,
      );

      // Read back from cache
      final readResult = GetUserResponse.fromCache(ctx, variables);

      expect(readResult, isNotNull);
      expect(readResult!.user, isNotNull);
      expect(readResult.user!.id, "user1");
      expect(readResult.user!.name, "Alice");
      expect(readResult.user!.email, "alice@example.com");
      expect(readResult.user!.age, 30);
      expect(readResult.user!.role, "admin");
      expect(readResult, equals(result));
    });

    test('interfaceFragmentCacheNormalization - Update via different query',
        () async {
      final ctx = ShalomCtx.withCapacity();

      // First query - GetUser
      final data1 = {
        "user": {
          "id": "user1",
          "name": "Alice",
          "email": "alice@example.com",
          "age": 30,
          "role": "admin",
          "__typename": "User",
        },
      };

      final variables1 = GetUserVariables(id: "user1");
      var (result1, updateCtx1) = GetUserResponse.fromResponseImpl(
        data1,
        ctx,
        variables1,
      );

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx1.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result1 = GetUserResponse.fromCache(newCtx, variables1)!;
        hasChanged.complete(true);
      });

      // Second query - GetNode that fetches the same node with only id field
      final data2 = {
        "node": {
          "id": "user1",
          "__typename": "User",
        },
      };

      final variables2 = GetNodeVariables(id: "user1");
      final result2 = GetNodeResponse.fromResponse(
        data2,
        ctx: ctx,
        variables: variables2,
      );

      // The node should still have the same ID
      final readResult = GetNodeResponse.fromCache(ctx, variables2);
      expect(readResult, isNotNull);
      expect(readResult!.node, isNotNull);
      expect(readResult.node!.id, "user1");
      expect(readResult, equals(result2));
    });

    test('interfaceFragmentCacheNormalization - Nested interface fragments',
        () {
      final ctx = ShalomCtx.withCapacity();

      final data = {
        "comment": {
          "id": "comment1",
          "createdAt": "2024-01-01T00:00:00Z",
          "updatedAt": "2024-01-02T00:00:00Z",
          "text": "Great post!",
          "author": {
            "id": "user1",
            "name": "Alice",
            "email": "alice@example.com",
            "__typename": "User",
          },
          "__typename": "Comment",
        },
      };

      final variables = GetCommentVariables(id: "comment1");
      final (result, updateCtx) = GetCommentResponse.fromResponseImpl(
        data,
        ctx,
        variables,
      );

      // Read back from cache
      final readResult = GetCommentResponse.fromCache(ctx, variables);

      expect(readResult, isNotNull);
      expect(readResult!.comment, isNotNull);
      expect(readResult.comment!.id, "comment1");
      expect(readResult.comment!.text, "Great post!");
      expect(readResult.comment!.author.id, "user1");
      expect(readResult.comment!.author.name, "Alice");
      expect(readResult.comment!.author.email, "alice@example.com");
      expect(readResult, equals(result));
    });

    test('interfaceFragmentCacheNormalization - List of interface type', () {
      final ctx = ShalomCtx.withCapacity();

      final data = {
        "nodes": [
          {
            "id": "node1",
            "__typename": "User",
          },
          {
            "id": "node2",
            "__typename": "Post",
          },
        ],
      };

      final (result, updateCtx) = GetNodesResponse.fromResponseImpl(data, ctx);

      // Read back from cache
      final readResult = GetNodesResponse.fromCache(ctx);

      expect(readResult, isNotNull);
      expect(readResult!.nodes.length, 2);
      expect(readResult.nodes[0].id, "node1");
      expect(readResult.nodes[1].id, "node2");
      expect(readResult, equals(result));
    });

    test(
        'interfaceFragmentCacheNormalization - Cache update notification works',
        () async {
      final ctx = ShalomCtx.withCapacity();

      final data1 = {
        "user": {
          "id": "user1",
          "name": "Alice",
          "email": "alice@example.com",
          "age": 30,
          "role": "admin",
          "__typename": "User",
        },
      };

      final variables = GetUserVariables(id: "user1");
      var (result, updateCtx) = GetUserResponse.fromResponseImpl(
        data1,
        ctx,
        variables,
      );

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetUserResponse.fromCache(newCtx, variables)!;
        hasChanged.complete(true);
      });

      // Update with new data
      final data2 = {
        "user": {
          "id": "user1",
          "name": "Alice Updated",
          "email": "alice.updated@example.com",
          "age": 31,
          "role": "superadmin",
          "__typename": "User",
        },
      };

      final nextResult = GetUserResponse.fromResponse(
        data2,
        ctx: ctx,
        variables: variables,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.user!.name, "Alice Updated");
      expect(result.user!.email, "alice.updated@example.com");
      expect(result.user!.age, 31);
      expect(result.user!.role, "superadmin");
    });
  });
}
