import 'package:test/test.dart';
import '__graphql__/UserInfoFrag.shalom.dart';
import '__graphql__/GetUser.shalom.dart';
import '__graphql__/GetPost.shalom.dart';
import '__graphql__/GetUserWithAuthor.shalom.dart';
import '__graphql__/GetPostWithAuthor.shalom.dart';

void main() {
  group('Fragment Basic Functionality', () {
    test('fragmentRequired - Fragment abstract classes exist', () {
      // This test just checks that the fragment classes can be referenced
      // and that the basic structure works

      final userData = {
        "user": {
          "id": "user1",
          "name": "Alice",
          "email": "alice@example.com",
          "age": 25,
        },
      };

      final result = GetUserResponse.fromJson(
        userData,
      );

      // Basic field access should work
      expect(result.user?.id, "user1");
      expect(result.user?.name, "Alice");
      expect(result.user?.email, "alice@example.com");
      expect(result.user?.age, 25);
    });

    test('fragmentOptional - Post fragment basic functionality', () {
      final postData = {
        "post": {
          "id": "post1",
          "title": "GraphQL Best Practices",
          "published": true,
          "content": "Content here...",
        },
      };

      final result = GetPostResponse.fromJson(
        postData,
      );

      expect(result.post?.id, "post1");
      expect(result.post?.title, "GraphQL Best Practices");
      expect(result.post?.published, true);
      expect(result.post?.content, "Content here...");
    });

    test('equals - Basic equality works', () {
      final userData = {
        "user": {
          "id": "user1",
          "name": "Alice",
          "email": "alice@example.com",
          "age": 25,
        },
      };

      final result1 = GetUserResponse.fromJson(
        userData,
      );
      final result2 = GetUserResponse.fromJson(
        userData,
      );

      expect(result1 == result2, true);
      expect(result1.user == result2.user, true);
    });

    test('toJson - Serialization works', () {
      final userData = {
        "user": {
          "id": "user1",
          "name": "Alice",
          "email": "alice@example.com",
          "age": 25,
        },
      };

      final result = GetUserResponse.fromJson(
        userData,
      );
      final json = result.toJson();

      expect(json, userData);
    });

    test(
      'fragmentInNestedObject - Documents intended behavior for nested fragments',
      () {
        // Test fragment usage in nested object
        final postData = {
          "post": {
            "id": "post1",
            "title": "Test Post",
            "published": true,
            "author": {
              "id": "user1",
              "name": "Alice",
              "email": "alice@example.com",
            },
          },
        };

        final result = GetPostWithAuthorResponse.fromJson(
          postData,
        );

        expect(result.post?.id, "post1");
        expect(result.post?.title, "Test Post");
        expect(result.post?.author.id, "user1");
        expect(result.post?.author.name, "Alice");
        expect(result.post?.author.email, "alice@example.com");
      },
    );

    test(
      'fragmentTypeChecking - Same fragment from different operations returns true for is check',
      () {
        final userData = {
          "user": {
            "id": "user1",
            "name": "Alice",
            "email": "alice@example.com",
            "age": 25,
          },
        };

        final getUserResult = GetUserResponse.fromJson(
          userData,
        );

        final getUserWithAuthorResult = GetUserWithAuthorResponse.fromJson(
          userData,
        );

        // Both should implement UserInfoFrag
        expect(getUserResult.user is UserInfoFrag, true);
        expect(getUserWithAuthorResult.user is UserInfoFrag, true);
      },
    );

    test(
      'fragmentExternalImport - Operations should import fragments from other folders',
      () {
        // This test verifies that fragments can be imported across operations
        final userData = {
          "user": {
            "id": "user1",
            "name": "Alice",
            "email": "alice@example.com",
            "age": 25,
          },
        };

        final result = GetUserWithAuthorResponse.fromJson(
          userData,
        );

        // Should have fields from both fragments
        expect(result.user?.id, "user1"); // from UserInfoFrag
        expect(result.user?.name, "Alice"); // from UserInfoFrag
        expect(result.user?.age, 25); // from AuthorInfoFrag
      },
    );

    test('fragmentNestedInObjects - Fragment usage inside nested objects', () {
      final postData = {
        "post": {
          "id": "post1",
          "title": "Test Post",
          "published": true,
          "author": {
            "id": "user1",
            "name": "Alice",
            "email": "alice@example.com",
          },
        },
      };

      final result = GetPostWithAuthorResponse.fromJson(
        postData,
      );

      // TODO: Fragment interface implementation not working yet
      // Author should be of type UserInfoFrag
      // expect(result.post?.author is UserInfoFrag, true);
      expect(result.post?.author.id, "user1");
      expect(result.post?.author.name, "Alice");
    });
  });

  group('Fragment Equality and Serialization', () {
    test('fragmentEquals - Fragments with same data are equal', () {
      final userData = {
        "user": {
          "id": "user1",
          "name": "Alice",
          "email": "alice@example.com",
          "age": 25,
        },
      };

      final result1 = GetUserResponse.fromJson(
        userData,
      );
      final result2 = GetUserResponse.fromJson(
        userData,
      );

      expect(result1 == result2, true);
      expect(result1.user == result2.user, true);
    });

    test('fragmentNotEquals - Fragments with different data are not equal', () {
      final userData1 = {
        "user": {
          "id": "user1",
          "name": "Alice",
          "email": "alice@example.com",
          "age": 25,
        },
      };

      final userData2 = {
        "user": {
          "id": "user2",
          "name": "Bob",
          "email": "bob@example.com",
          "age": 30,
        },
      };

      final result1 = GetUserResponse.fromJson(
        userData1,
      );
      final result2 = GetUserResponse.fromJson(
        userData2,
      );

      expect(result1 == result2, false);
      expect(result1.user == result2.user, false);
    });

    test('fragmentToJson - Fragment serialization works correctly', () {
      final userData = {
        "user": {
          "id": "user1",
          "name": "Alice",
          "email": "alice@example.com",
          "age": 25,
        },
      };

      final result = GetUserResponse.fromJson(
        userData,
      );
      final json = result.toJson();

      expect(json, userData);
      expect(json["user"]["id"], "user1");
      expect(json["user"]["name"], "Alice");
    });
  });
}
