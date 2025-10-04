import 'dart:io';
import 'package:test/test.dart';
import 'package:shalom_core/shalom_core.dart';
import 'queries/__graphql__/GetUser.shalom.dart';
import 'queries/__graphql__/GetPost.shalom.dart';
import '__graphql__/schema.shalom.dart';

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
              "import '../../common_fragments/__graphql__/userfields.shalom.dart';"),
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
              "import '../../common_fragments/__graphql__/postfields.shalom.dart';"),
          isTrue,
          reason:
              'GetPost should import PostFields fragment with correct relative path');
      expect(
          postContent.contains(
              "import '../../common_fragments/__graphql__/userfields.shalom.dart';"),
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
  });
}
