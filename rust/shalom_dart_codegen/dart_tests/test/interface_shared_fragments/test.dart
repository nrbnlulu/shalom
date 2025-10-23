import "dart:async";

import "package:shalom_core/shalom_core.dart";
import 'package:test/test.dart';
import "__graphql__/NodeTimestamps.shalom.dart";
import "__graphql__/UserInfo.shalom.dart";
import "__graphql__/PostInfo.shalom.dart";
import "__graphql__/GetNode.shalom.dart";
import "__graphql__/GetNodeOpt.shalom.dart";
import "__graphql__/GetNodes.shalom.dart";
import "__graphql__/GetNodeAllTypes.shalom.dart";

void main() {
  final userData = {
    "node": {
      "__typename": "User",
      "id": "user1",
      "createdAt": "2024-01-01T00:00:00Z",
      "updatedAt": "2024-01-02T00:00:00Z",
      "username": "john_doe",
      "email": "john@example.com",
      "age": 30
    }
  };

  final postData = {
    "node": {
      "__typename": "Post",
      "id": "post1",
      "createdAt": "2024-01-03T00:00:00Z",
      "updatedAt": "2024-01-04T00:00:00Z",
      "title": "Hello World",
      "content": "This is my first post",
      "views": 100
    }
  };

  final commentData = {
    "node": {
      "__typename": "Comment",
      "id": "comment1",
      "createdAt": "2024-01-05T00:00:00Z",
      "updatedAt": "2024-01-06T00:00:00Z",
      "text": "Great post!",
      "likes": 5
    }
  };

  group('Test interface shared fragments - required', () {
    test('interfaceSharedFragmentsRequired - User', () {
      final variables = GetNodeVariables(id: "user1");
      final result =
          GetNodeResponse.fromResponse(userData, variables: variables);

      expect(result.node, isA<GetNode_node_User>());
      expect(result.node, isA<NodeTimestamps>());
      expect(result.node, isA<UserInfo>());

      final user = result.node as GetNode_node_User;
      expect(user.id, "user1");
      expect(user.createdAt, "2024-01-01T00:00:00Z");
      expect(user.updatedAt, "2024-01-02T00:00:00Z");
      expect(user.username, "john_doe");
      expect(user.email, "john@example.com");
      expect(user.age, 30);
      expect(user.typename, "User");

      // Test fragment interface access - NodeTimestamps
      final nodeTimestamps = result.node as NodeTimestamps;
      expect(nodeTimestamps.id, "user1");
      expect(nodeTimestamps.createdAt, "2024-01-01T00:00:00Z");
      expect(nodeTimestamps.updatedAt, "2024-01-02T00:00:00Z");

      // Test fragment interface access - UserInfo
      final userInfo = result.node as UserInfo;
      expect(userInfo.id, "user1");
      expect(userInfo.username, "john_doe");
      expect(userInfo.email, "john@example.com");
      expect(userInfo.age, 30);
    });

    test('interfaceSharedFragmentsRequired - Post', () {
      final variables = GetNodeVariables(id: "post1");
      final result =
          GetNodeResponse.fromResponse(postData, variables: variables);

      expect(result.node, isA<GetNode_node_Post>());
      expect(result.node, isA<NodeTimestamps>());
      expect(result.node, isA<PostInfo>());

      final post = result.node as GetNode_node_Post;
      expect(post.id, "post1");
      expect(post.createdAt, "2024-01-03T00:00:00Z");
      expect(post.updatedAt, "2024-01-04T00:00:00Z");
      expect(post.title, "Hello World");
      expect(post.content, "This is my first post");
      expect(post.views, 100);
      expect(post.typename, "Post");

      // Test fragment interface access - NodeTimestamps
      final nodeTimestamps = result.node as NodeTimestamps;
      expect(nodeTimestamps.id, "post1");
      expect(nodeTimestamps.createdAt, "2024-01-03T00:00:00Z");
      expect(nodeTimestamps.updatedAt, "2024-01-04T00:00:00Z");

      // Test fragment interface access - PostInfo
      final postInfo = result.node as PostInfo;
      expect(postInfo.id, "post1");
      expect(postInfo.title, "Hello World");
      expect(postInfo.content, "This is my first post");
      expect(postInfo.views, 100);
    });

    test('interfaceSharedFragmentsRequired - Comment (fallback)', () {
      final variables = GetNodeVariables(id: "comment1");
      final result =
          GetNodeResponse.fromResponse(commentData, variables: variables);

      expect(result.node, isA<GetNode_node_Fallback>());
      expect(result.node, isA<NodeTimestamps>());

      final comment = result.node as GetNode_node_Fallback;
      expect(comment.id, "comment1");
      expect(comment.createdAt, "2024-01-05T00:00:00Z");
      expect(comment.updatedAt, "2024-01-06T00:00:00Z");
      expect(comment.typename, "Comment");

      // Test fragment interface access - NodeTimestamps
      final nodeTimestamps = result.node as NodeTimestamps;
      expect(nodeTimestamps.id, "comment1");
      expect(nodeTimestamps.createdAt, "2024-01-05T00:00:00Z");
      expect(nodeTimestamps.updatedAt, "2024-01-06T00:00:00Z");
    });

    test('interfaceSharedFragmentsRequired - equals', () {
      final variables = GetNodeVariables(id: "user1");
      final result1 =
          GetNodeResponse.fromResponse(userData, variables: variables);
      final result2 =
          GetNodeResponse.fromResponse(userData, variables: variables);
      expect(result1, equals(result2));
      expect(result1.node, equals(result2.node));
    });

    test('interfaceSharedFragmentsRequired - toJson', () {
      final variables = GetNodeVariables(id: "user1");
      final result =
          GetNodeResponse.fromResponse(userData, variables: variables);
      final json = result.toJson();
      expect(json, userData);
    });
  });

  final userOptData = {
    "nodeOpt": {
      "__typename": "User",
      "id": "user1",
      "createdAt": "2024-01-01T00:00:00Z",
      "updatedAt": "2024-01-02T00:00:00Z",
      "username": "john_doe",
      "email": "john@example.com",
      "age": 30
    }
  };

  final postOptData = {
    "nodeOpt": {
      "__typename": "Post",
      "id": "post1",
      "createdAt": "2024-01-03T00:00:00Z",
      "updatedAt": "2024-01-04T00:00:00Z",
      "title": "Hello World",
      "content": "This is my first post",
      "views": 100
    }
  };

  final nodeOptNull = {"nodeOpt": null};

  group('Test interface shared fragments - optional', () {
    test('interfaceSharedFragmentsOptional - User', () {
      final variables = GetNodeOptVariables(id: "user1");
      final result =
          GetNodeOptResponse.fromResponse(userOptData, variables: variables);

      expect(result.nodeOpt, isNotNull);
      expect(result.nodeOpt, isA<GetNodeOpt_nodeOpt_User>());
      expect(result.nodeOpt, isA<NodeTimestamps>());
      expect(result.nodeOpt, isA<UserInfo>());

      final user = result.nodeOpt as GetNodeOpt_nodeOpt_User;
      expect(user.id, "user1");
      expect(user.createdAt, "2024-01-01T00:00:00Z");
      expect(user.updatedAt, "2024-01-02T00:00:00Z");
      expect(user.username, "john_doe");
      expect(user.email, "john@example.com");
      expect(user.age, 30);
      expect(user.typename, "User");

      // Test fragment interface access
      final nodeTimestamps = result.nodeOpt as NodeTimestamps;
      expect(nodeTimestamps.id, "user1");
      expect(nodeTimestamps.createdAt, "2024-01-01T00:00:00Z");
      expect(nodeTimestamps.updatedAt, "2024-01-02T00:00:00Z");

      final userInfo = result.nodeOpt as UserInfo;
      expect(userInfo.id, "user1");
      expect(userInfo.username, "john_doe");
      expect(userInfo.email, "john@example.com");
      expect(userInfo.age, 30);
    });

    test('interfaceSharedFragmentsOptional - Post', () {
      final variables = GetNodeOptVariables(id: "post1");
      final result =
          GetNodeOptResponse.fromResponse(postOptData, variables: variables);

      expect(result.nodeOpt, isNotNull);
      expect(result.nodeOpt, isA<GetNodeOpt_nodeOpt_Post>());
      expect(result.nodeOpt, isA<NodeTimestamps>());
      expect(result.nodeOpt, isA<PostInfo>());

      final post = result.nodeOpt as GetNodeOpt_nodeOpt_Post;
      expect(post.id, "post1");
      expect(post.createdAt, "2024-01-03T00:00:00Z");
      expect(post.updatedAt, "2024-01-04T00:00:00Z");
      expect(post.title, "Hello World");
      expect(post.content, "This is my first post");
      expect(post.views, 100);
      expect(post.typename, "Post");
    });

    test('interfaceSharedFragmentsOptional - null', () {
      final variables = GetNodeOptVariables(id: "null");
      final result =
          GetNodeOptResponse.fromResponse(nodeOptNull, variables: variables);
      expect(result.nodeOpt, isNull);
    });

    test('interfaceSharedFragmentsOptional - equals', () {
      final variables = GetNodeOptVariables(id: "user1");
      final result1 =
          GetNodeOptResponse.fromResponse(userOptData, variables: variables);
      final result2 =
          GetNodeOptResponse.fromResponse(userOptData, variables: variables);
      expect(result1, equals(result2));
      expect(result1.nodeOpt, equals(result2.nodeOpt));
    });

    test('interfaceSharedFragmentsOptional - toJson', () {
      final variables = GetNodeOptVariables(id: "user1");
      final result =
          GetNodeOptResponse.fromResponse(userOptData, variables: variables);
      final json = result.toJson();
      expect(json, userOptData);
    });

    test('interfaceSharedFragmentsOptional - toJson null', () {
      final variables = GetNodeOptVariables(id: "null");
      final result =
          GetNodeOptResponse.fromResponse(nodeOptNull, variables: variables);
      final json = result.toJson();
      expect(json, nodeOptNull);
    });
  });

  group('Test interface shared fragments - cache normalization', () {
    test('interfaceSharedFragmentsCacheNormalization - User update', () async {
      final ctx = ShalomCtx.withCapacity();
      final variables = GetNodeVariables(id: "user1");

      var (result, updateCtx) = GetNodeResponse.fromResponseImpl(
        userData,
        ctx,
        variables,
      );

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetNodeResponse.fromCache(newCtx, variables);
        hasChanged.complete(true);
      });

      final updatedUserData = {
        "node": {
          "__typename": "User",
          "id": "user1",
          "createdAt": "2024-01-01T00:00:00Z",
          "updatedAt": "2024-01-10T00:00:00Z",
          "username": "john_doe_updated",
          "email": "john.updated@example.com",
          "age": 31
        }
      };

      final nextResult = GetNodeResponse.fromResponse(
        updatedUserData,
        ctx: ctx,
        variables: variables,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));

      final user = result.node as GetNode_node_User;
      expect(user.username, "john_doe_updated");
      expect(user.email, "john.updated@example.com");
      expect(user.age, 31);
      expect(user.updatedAt, "2024-01-10T00:00:00Z");
    });

    test('interfaceSharedFragmentsCacheNormalization - Post update', () async {
      final ctx = ShalomCtx.withCapacity();
      final variables = GetNodeVariables(id: "post1");

      var (result, updateCtx) = GetNodeResponse.fromResponseImpl(
        postData,
        ctx,
        variables,
      );

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetNodeResponse.fromCache(newCtx, variables);
        hasChanged.complete(true);
      });

      final updatedPostData = {
        "node": {
          "__typename": "Post",
          "id": "post1",
          "createdAt": "2024-01-03T00:00:00Z",
          "updatedAt": "2024-01-10T00:00:00Z",
          "title": "Hello World Updated",
          "content": "This is my updated post",
          "views": 200
        }
      };

      final nextResult = GetNodeResponse.fromResponse(
        updatedPostData,
        ctx: ctx,
        variables: variables,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));

      final post = result.node as GetNode_node_Post;
      expect(post.title, "Hello World Updated");
      expect(post.content, "This is my updated post");
      expect(post.views, 200);
      expect(post.updatedAt, "2024-01-10T00:00:00Z");
    });

    test('interfaceSharedFragmentsCacheNormalization - Optional null to some',
        () async {
      final ctx = ShalomCtx.withCapacity();
      final variables = GetNodeOptVariables(id: "user1");

      var (result, updateCtx) = GetNodeOptResponse.fromResponseImpl(
        nodeOptNull,
        ctx,
        variables,
      );

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetNodeOptResponse.fromCache(newCtx, variables);
        hasChanged.complete(true);
      });

      final nextResult = GetNodeOptResponse.fromResponse(
        userOptData,
        ctx: ctx,
        variables: variables,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.nodeOpt, isNotNull);
    });

    test('interfaceSharedFragmentsCacheNormalization - Optional some to null',
        () async {
      final ctx = ShalomCtx.withCapacity();
      final variables = GetNodeOptVariables(id: "user1");

      var (result, updateCtx) = GetNodeOptResponse.fromResponseImpl(
        userOptData,
        ctx,
        variables,
      );

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetNodeOptResponse.fromCache(newCtx, variables);
        hasChanged.complete(true);
      });

      final nextResult = GetNodeOptResponse.fromResponse(
        nodeOptNull,
        ctx: ctx,
        variables: variables,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.nodeOpt, isNull);
    });
  });

  final nodesData = {
    "nodes": [
      {
        "__typename": "User",
        "id": "user1",
        "createdAt": "2024-01-01T00:00:00Z",
        "updatedAt": "2024-01-02T00:00:00Z",
        "username": "john_doe",
        "email": "john@example.com",
        "age": 30
      },
      {
        "__typename": "Post",
        "id": "post1",
        "createdAt": "2024-01-03T00:00:00Z",
        "updatedAt": "2024-01-04T00:00:00Z",
        "title": "Hello World",
        "content": "This is my first post",
        "views": 100
      },
      {
        "__typename": "Comment",
        "id": "comment1",
        "createdAt": "2024-01-05T00:00:00Z",
        "updatedAt": "2024-01-06T00:00:00Z"
      }
    ]
  };

  group('Test interface shared fragments - list', () {
    test('interfaceSharedFragmentsList', () {
      final result = GetNodesResponse.fromResponse(nodesData);

      expect(result.nodes.length, 3);

      // Check User
      expect(result.nodes[0], isA<GetNodes_nodes_User>());
      expect(result.nodes[0], isA<NodeTimestamps>());
      expect(result.nodes[0], isA<UserInfo>());
      final user = result.nodes[0] as GetNodes_nodes_User;
      expect(user.id, "user1");
      expect(user.username, "john_doe");

      // Check Post
      expect(result.nodes[1], isA<GetNodes_nodes_Post>());
      expect(result.nodes[1], isA<NodeTimestamps>());
      expect(result.nodes[1], isA<PostInfo>());
      final post = result.nodes[1] as GetNodes_nodes_Post;
      expect(post.id, "post1");
      expect(post.title, "Hello World");

      // Check Comment (fallback)
      expect(result.nodes[2], isA<GetNodes_nodes_Fallback>());
      expect(result.nodes[2], isA<NodeTimestamps>());
      final comment = result.nodes[2] as GetNodes_nodes_Fallback;
      expect(comment.id, "comment1");
      expect(comment.typename, "Comment");
    });

    test('interfaceSharedFragmentsList - equals', () {
      final result1 = GetNodesResponse.fromResponse(nodesData);
      final result2 = GetNodesResponse.fromResponse(nodesData);
      expect(result1, equals(result2));
    });

    test('interfaceSharedFragmentsList - toJson', () {
      final result = GetNodesResponse.fromResponse(nodesData);
      final json = result.toJson();
      expect(json, nodesData);
    });
  });

  final commentAllTypesData = {
    "node": {
      "__typename": "Comment",
      "id": "comment1",
      "createdAt": "2024-01-05T00:00:00Z",
      "updatedAt": "2024-01-06T00:00:00Z",
      "text": "Great post!",
      "likes": 5
    }
  };

  group('Test interface shared fragments - all types', () {
    test('interfaceSharedFragmentsAllTypes - Comment', () {
      final variables = GetNodeAllTypesVariables(id: "comment1");
      final result = GetNodeAllTypesResponse.fromResponse(
        commentAllTypesData,
        variables: variables,
      );

      expect(result.node, isA<GetNodeAllTypes_node_Comment>());
      expect(result.node, isA<NodeTimestamps>());

      final comment = result.node as GetNodeAllTypes_node_Comment;
      expect(comment.id, "comment1");
      expect(comment.createdAt, "2024-01-05T00:00:00Z");
      expect(comment.updatedAt, "2024-01-06T00:00:00Z");
      expect(comment.text, "Great post!");
      expect(comment.likes, 5);
      expect(comment.typename, "Comment");

      // Test fragment interface access
      final nodeTimestamps = result.node as NodeTimestamps;
      expect(nodeTimestamps.id, "comment1");
      expect(nodeTimestamps.createdAt, "2024-01-05T00:00:00Z");
      expect(nodeTimestamps.updatedAt, "2024-01-06T00:00:00Z");
    });

    test('interfaceSharedFragmentsAllTypes - equals', () {
      final variables = GetNodeAllTypesVariables(id: "comment1");
      final result1 = GetNodeAllTypesResponse.fromResponse(
        commentAllTypesData,
        variables: variables,
      );
      final result2 = GetNodeAllTypesResponse.fromResponse(
        commentAllTypesData,
        variables: variables,
      );
      expect(result1, equals(result2));
      expect(result1.node, equals(result2.node));
    });

    test('interfaceSharedFragmentsAllTypes - toJson', () {
      final variables = GetNodeAllTypesVariables(id: "comment1");
      final result = GetNodeAllTypesResponse.fromResponse(
        commentAllTypesData,
        variables: variables,
      );
      final json = result.toJson();
      expect(json, commentAllTypesData);
    });
  });
}
