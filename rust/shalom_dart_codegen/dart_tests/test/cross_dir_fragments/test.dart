import 'dart:io';
import 'package:test/test.dart';
import 'queries/__graphql__/GetUser.shalom.dart';
import 'queries/__graphql__/GetPost.shalom.dart';
import 'nested_queries/__graphql__/GetAuthor.shalom.dart';

void main() {
  group('Cross-Directory Fragment Tests', () {
    test('crossDirImportPaths - Fragment import paths are correctly generated',
        () {
      // Verify that the generated GetUser file imports the fragment with the correct path
      final getUserFile = File(
          'test/cross_dir_fragments/queries/__graphql__/GetUser.shalom.dart');
      expect(getUserFile.existsSync(), isTrue,
          reason: 'GetUser.shalom.dart should exist');

      final content = getUserFile.readAsStringSync();
      expect(
          content.contains(
              "import '../../common_fragments/__graphql__/UserFields.shalom.dart';"),
          isTrue,
          reason:
              'GetUser should import UserFields fragment with correct relative path');

      // Verify that the generated GetPost file imports fragments with correct paths
      final getPostFile = File(
          'test/cross_dir_fragments/queries/__graphql__/GetPost.shalom.dart');
      expect(getPostFile.existsSync(), isTrue,
          reason: 'GetPost.shalom.dart should exist');

      final postContent = getPostFile.readAsStringSync();
      expect(
          postContent.contains(
              "import '../../common_fragments/__graphql__/PostFields.shalom.dart';"),
          isTrue,
          reason:
              'GetPost should import PostFields fragment with correct relative path');
      expect(
          postContent.contains(
              "import '../../common_fragments/__graphql__/UserFields.shalom.dart';"),
          isTrue,
          reason:
              'GetPost should import UserFields fragment (used in nested author) with correct relative path');
    });

    test('crossDirRequired - Fragment imports work across directories', () {
      // Test that fragments from common_fragments can be used in queries
      final userData = {
        "user": {
          "id": "user1",
          "name": "Alice",
          "email": "alice@example.com",
        },
      };

      final variables = GetUserVariables(userId: "user1");
      final response =
          GetUserResponse.fromResponse(userData, variables: variables);

      expect(response.user, isNotNull);
      expect(response.user!.id, equals("user1"));
      expect(response.user!.name, equals("Alice"));
      expect(response.user!.email, equals("alice@example.com"));
    });

    test('crossDirOptional - Optional fields with cross-directory fragments',
        () {
      final userData = {
        "user": null,
      };

      final variables = GetUserVariables(userId: "user999");
      final response =
          GetUserResponse.fromResponse(userData, variables: variables);

      expect(response.user, isNull);
    });

    test('crossDirEquals - Equality works with cross-directory fragments', () {
      final userData1 = {
        "user": {
          "id": "user1",
          "name": "Alice",
          "email": "alice@example.com",
        },
      };

      final userData2 = {
        "user": {
          "id": "user1",
          "name": "Alice",
          "email": "alice@example.com",
        },
      };

      final variables = GetUserVariables(userId: "user1");
      final response1 =
          GetUserResponse.fromResponse(userData1, variables: variables);
      final response2 =
          GetUserResponse.fromResponse(userData2, variables: variables);

      expect(response1, equals(response2));
    });

    test('crossDirToJson - Serialization works with cross-directory fragments',
        () {
      final userData = {
        "user": {
          "id": "user1",
          "name": "Alice",
          "email": "alice@example.com",
        },
      };

      final variables = GetUserVariables(userId: "user1");
      final response =
          GetUserResponse.fromResponse(userData, variables: variables);
      final json = response.toJson();

      expect(json["user"]["id"], equals("user1"));
      expect(json["user"]["name"], equals("Alice"));
      expect(json["user"]["email"], equals("alice@example.com"));
    });

    test(
        'crossDirNestedFragments - GetPost uses fragments from different directory',
        () {
      final postData = {
        "post": {
          "id": "post1",
          "title": "Test Post",
          "content": "Test Content",
          "author": {"id": "user1", "name": "Bob", "email": "bob@example.com"}
        },
      };

      final variables = GetPostVariables(postId: "post1");
      final response =
          GetPostResponse.fromResponse(postData, variables: variables);

      expect(response.post, isNotNull);
      expect(response.post!.id, equals("post1"));
      expect(response.post!.title, equals("Test Post"));
      expect(response.post!.author.id, equals("user1"));
      expect(response.post!.author.name, equals("Bob"));
    });

    test(
        'nestedFragmentRequired - AuthorFields fragment with nested UserFields',
        () {
      final authorData = {
        "user": {
          "id": "author1",
          "name": "Jane Doe",
          "email": "jane@example.com",
          "posts": [
            {"id": "post1", "title": "First Post"},
            {"id": "post2", "title": "Second Post"}
          ]
        },
      };

      final variables = GetAuthorVariables(authorId: "author1");
      final response =
          GetAuthorResponse.fromResponse(authorData, variables: variables);

      expect(response.user, isNotNull);
      expect(response.user!.id, equals("author1"));
      expect(response.user!.name, equals("Jane Doe"));
      expect(response.user!.email, equals("jane@example.com"));
      expect(response.user!.posts.length, equals(2));
      expect(response.user!.posts[0].id, equals("post1"));
      expect(response.user!.posts[0].title, equals("First Post"));
    });

    test('nestedFragmentOptional - Optional author with nested fragments', () {
      final authorData = {
        "user": null,
      };

      final variables = GetAuthorVariables(authorId: "author999");
      final response =
          GetAuthorResponse.fromResponse(authorData, variables: variables);

      expect(response.user, isNull);
    });

    test(
        'nestedFragmentCacheNormalization - Cache normalization with nested fragments',
        () {
      final authorData1 = {
        "user": {
          "id": "author1",
          "name": "Jane Doe",
          "email": "jane@example.com",
          "posts": [
            {"id": "post1", "title": "First Post"}
          ]
        },
      };

      final variables = GetAuthorVariables(authorId: "author1");
      final response =
          GetAuthorResponse.fromResponse(authorData1, variables: variables);

      // Verify that response preserves the data structure from nested fragments
      expect(response.user, isNotNull);
      expect(response.user!.id, equals('author1'));
      expect(response.user!.name, equals('Jane Doe'));
      expect(response.user!.email, equals('jane@example.com'));
      expect(response.user!.posts.length, equals(1));
      expect(response.user!.posts[0].id, equals('post1'));
    });

    test('nestedFragmentEquals - Equality works with nested fragments', () {
      final authorData1 = {
        "user": {
          "id": "author1",
          "name": "Jane Doe",
          "email": "jane@example.com",
          "posts": [
            {"id": "post1", "title": "First Post"}
          ]
        },
      };

      final authorData2 = {
        "user": {
          "id": "author1",
          "name": "Jane Doe",
          "email": "jane@example.com",
          "posts": [
            {"id": "post1", "title": "First Post"}
          ]
        },
      };

      final variables = GetAuthorVariables(authorId: "author1");
      final response1 =
          GetAuthorResponse.fromResponse(authorData1, variables: variables);
      final response2 =
          GetAuthorResponse.fromResponse(authorData2, variables: variables);

      expect(response1, equals(response2));
    });

    test('nestedFragmentToJson - Serialization works with nested fragments',
        () {
      final authorData = {
        "user": {
          "id": "author1",
          "name": "Jane Doe",
          "email": "jane@example.com",
          "posts": [
            {"id": "post1", "title": "First Post"},
            {"id": "post2", "title": "Second Post"}
          ]
        },
      };

      final variables = GetAuthorVariables(authorId: "author1");
      final response =
          GetAuthorResponse.fromResponse(authorData, variables: variables);
      final json = response.toJson();

      expect(json["user"]["id"], equals("author1"));
      expect(json["user"]["name"], equals("Jane Doe"));
      expect(json["user"]["email"], equals("jane@example.com"));
      expect(json["user"]["posts"].length, equals(2));
      expect(json["user"]["posts"][0]["id"], equals("post1"));
    });
  });
}
