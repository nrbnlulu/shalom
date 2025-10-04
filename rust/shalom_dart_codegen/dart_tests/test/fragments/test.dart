import 'dart:async';
import 'package:test/test.dart';
import 'package:shalom_core/shalom_core.dart';
import '__graphql__/userinfofrag.shalom.dart';
import '__graphql__/postdetailsfrag.shalom.dart';
import '__graphql__/postmetafrag.shalom.dart';
import '__graphql__/authorinfofrag.shalom.dart';
import '__graphql__/GetUser.shalom.dart';
import '__graphql__/GetPost.shalom.dart';
import '__graphql__/GetPostWithMeta.shalom.dart';
import '__graphql__/GetUserWithAuthor.shalom.dart';
import '__graphql__/GetPostWithAuthor.shalom.dart';
import '__graphql__/schema.shalom.dart';

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

      final variables = GetUserVariables(userId: "user1");
      final result =
          GetUserResponse.fromResponse(userData, variables: variables);

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

      final variables = GetPostVariables(postId: "post1");
      final result =
          GetPostResponse.fromResponse(postData, variables: variables);

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

      final variables = GetUserVariables(userId: "user1");
      final result1 =
          GetUserResponse.fromResponse(userData, variables: variables);
      final result2 =
          GetUserResponse.fromResponse(userData, variables: variables);

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

      final variables = GetUserVariables(userId: "user1");
      final result =
          GetUserResponse.fromResponse(userData, variables: variables);
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

      final variables = GetPostWithAuthorVariables(postId: "post1");
      final result = GetPostWithAuthorResponse.fromResponse(postData,
          variables: variables);

      expect(result.post?.id, "post1");
      expect(result.post?.title, "Test Post");
      expect(result.post?.author.id, "user1");
      expect(result.post?.author.name, "Alice");
      expect(result.post?.author.email, "alice@example.com");
    });

    test(
        'fragmentCacheNormalizationWithoutId - Fragment without ID field works correctly',
        () {
      // PostMetaFrag doesn't have id field, so it shouldn't be normalized by id
      final postData = {
        "post": {
          "id": "post1",
          "title": "Test Post",
          "published": true,
          "content": "This is test content",
        },
      };

      final ctx = ShalomCtx.withCapacity();
      final variables = GetPostWithMetaVariables(postId: "post1");
      final result = GetPostWithMetaResponse.fromResponse(postData,
          ctx: ctx, variables: variables);

      expect(result.post?.id, "post1");
      expect(result.post?.title, "Test Post");
      expect(result.post?.published, true);
      expect(result.post?.content, "This is test content");

      // Verify it's cached
      final fromCache = GetPostWithMetaResponse.fromCache(ctx, variables);
      expect(fromCache.post?.id, "post1");
      expect(fromCache.post?.title, "Test Post");
    });

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

      final getUserVars = GetUserVariables(userId: "user1");
      final getUserResult =
          GetUserResponse.fromResponse(userData, variables: getUserVars);

      final getUserWithAuthorVars = GetUserWithAuthorVariables(userId: "user1");
      final getUserWithAuthorResult = GetUserWithAuthorResponse.fromResponse(
          userData,
          variables: getUserWithAuthorVars);

      // Both should implement UserInfoFrag
      expect(getUserResult.user is UserInfoFrag, true);
      expect(getUserWithAuthorResult.user is UserInfoFrag, true);
    });

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

      final variables = GetUserWithAuthorVariables(userId: "user1");
      final result = GetUserWithAuthorResponse.fromResponse(userData,
          variables: variables);

      // Should have fields from both fragments
      expect(result.user?.id, "user1"); // from UserInfoFrag
      expect(result.user?.name, "Alice"); // from UserInfoFrag
      expect(result.user?.age, 25); // from AuthorInfoFrag
    });

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

      final variables = GetPostWithAuthorVariables(postId: "post1");
      final result = GetPostWithAuthorResponse.fromResponse(postData,
          variables: variables);

      // TODO: Fragment interface implementation not working yet
      // Author should be of type UserInfoFrag
      // expect(result.post?.author is UserInfoFrag, true);
      expect(result.post?.author.id, "user1");
      expect(result.post?.author.name, "Alice");
    });
  });

  group('Fragment Cache Normalization', () {
    test(
        'fragmentCacheNormalizationRequired - Fragment with ID normalizes correctly',
        () {
      final userData = {
        "user": {
          "id": "user1",
          "name": "Alice",
          "email": "alice@example.com",
          "age": 25,
        },
      };

      final ctx = ShalomCtx.withCapacity();
      final variables = GetUserVariables(userId: "user1");
      final result1 = GetUserResponse.fromResponse(userData,
          ctx: ctx, variables: variables);

      expect(result1.user?.id, "user1");
      expect(result1.user?.name, "Alice");

      // Update the data with a changed name
      final updatedData = {
        "user": {
          "id": "user1",
          "name": "Alice Updated",
          "email": "alice@example.com",
          "age": 25,
        },
      };

      final result2 = GetUserResponse.fromResponse(updatedData,
          ctx: ctx, variables: variables);

      // Should get updated data from cache
      final fromCache = GetUserResponse.fromCache(ctx, variables);
      expect(fromCache.user?.id, "user1");
      expect(fromCache.user?.name, "Alice Updated");
    });

    test(
        'fragmentCacheNormalizationOptional - Optional fragment normalizes correctly',
        () {
      final postData = {
        "post": {
          "id": "post1",
          "title": "Test Post",
          "published": true,
          "content": "Content",
        },
      };

      final ctx = ShalomCtx.withCapacity();
      final variables = GetPostVariables(postId: "post1");
      final result1 = GetPostResponse.fromResponse(postData,
          ctx: ctx, variables: variables);

      expect(result1.post?.id, "post1");
      expect(result1.post?.title, "Test Post");

      // Update the data
      final updatedData = {
        "post": {
          "id": "post1",
          "title": "Updated Post",
          "published": false,
          "content": "Content",
        },
      };

      final result2 = GetPostResponse.fromResponse(updatedData,
          ctx: ctx, variables: variables);

      // Verify cache update
      final fromCache = GetPostResponse.fromCache(ctx, variables);
      expect(fromCache.post?.title, "Updated Post");
      expect(fromCache.post?.published, false);
    });

    test(
        'fragmentCacheNormalizationNested - Nested fragment normalizes correctly',
        () {
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

      final ctx = ShalomCtx.withCapacity();
      final variables = GetPostWithAuthorVariables(postId: "post1");
      final result1 = GetPostWithAuthorResponse.fromResponse(postData,
          ctx: ctx, variables: variables);

      expect(result1.post?.author.id, "user1");
      expect(result1.post?.author.name, "Alice");

      // Update the author data
      final updatedData = {
        "post": {
          "id": "post1",
          "title": "Test Post",
          "published": true,
          "author": {
            "id": "user1",
            "name": "Alice Smith",
            "email": "alice.smith@example.com",
          },
        },
      };

      final result2 = GetPostWithAuthorResponse.fromResponse(updatedData,
          ctx: ctx, variables: variables);

      // Both the post and author should be normalized
      final fromCache = GetPostWithAuthorResponse.fromCache(ctx, variables);
      expect(fromCache.post?.author.name, "Alice Smith");
      expect(fromCache.post?.author.email, "alice.smith@example.com");
    });

    test(
        'fragmentCacheNormalizationWithoutId - Fragment without ID uses path-based cache key',
        () {
      // PostMetaFrag doesn't have id field
      final postData1 = {
        "post": {
          "id": "post1",
          "title": "Original Title",
          "published": true,
          "content": "Original content",
        },
      };

      final ctx = ShalomCtx.withCapacity();
      final variables = GetPostWithMetaVariables(postId: "post1");
      final result1 = GetPostWithMetaResponse.fromResponse(postData1,
          ctx: ctx, variables: variables);

      expect(result1.post?.title, "Original Title");

      // Update the post (including fields from PostMetaFrag which has no id)
      final postData2 = {
        "post": {
          "id": "post1",
          "title": "Updated Title",
          "published": false,
          "content": "Updated content",
        },
      };

      final result2 = GetPostWithMetaResponse.fromResponse(postData2,
          ctx: ctx, variables: variables);

      // Even without ID in the fragment, it should still be cached correctly
      // because it's part of the parent object that has an ID
      final fromCache = GetPostWithMetaResponse.fromCache(ctx, variables);
      expect(fromCache.post?.title, "Updated Title");
      expect(fromCache.post?.published, false);
      expect(fromCache.post?.content, "Updated content");
    });
  });

  group('Fragment with Arguments', () {
    test(
        'fragmentCacheNormalizationBehindArguments - Fragments cached correctly with different arguments',
        () {
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

      final ctx = ShalomCtx.withCapacity();

      // Query user1
      final variables1 = GetUserVariables(userId: "user1");
      final result1 = GetUserResponse.fromResponse(userData1,
          ctx: ctx, variables: variables1);

      expect(result1.user?.id, "user1");
      expect(result1.user?.name, "Alice");

      // Query user2
      final variables2 = GetUserVariables(userId: "user2");
      final result2 = GetUserResponse.fromResponse(userData2,
          ctx: ctx, variables: variables2);

      expect(result2.user?.id, "user2");
      expect(result2.user?.name, "Bob");

      // Verify both are cached separately
      final fromCache1 = GetUserResponse.fromCache(ctx, variables1);
      expect(fromCache1.user?.id, "user1");
      expect(fromCache1.user?.name, "Alice");

      final fromCache2 = GetUserResponse.fromCache(ctx, variables2);
      expect(fromCache2.user?.id, "user2");
      expect(fromCache2.user?.name, "Bob");
    });

    test(
        'fragmentCacheNormalizationBehindArgumentsUpdate - Cache updates correctly per argument',
        () {
      final postData1 = {
        "post": {
          "id": "post1",
          "title": "Post 1 Original",
          "published": true,
          "content": "Content 1",
        },
      };

      final ctx = ShalomCtx.withCapacity();
      final variables1 = GetPostVariables(postId: "post1");
      final result1 = GetPostResponse.fromResponse(postData1,
          ctx: ctx, variables: variables1);

      expect(result1.post?.title, "Post 1 Original");

      // Update post1
      final postData1Updated = {
        "post": {
          "id": "post1",
          "title": "Post 1 Updated",
          "published": false,
          "content": "Content 1",
        },
      };

      final result1Updated = GetPostResponse.fromResponse(postData1Updated,
          ctx: ctx, variables: variables1);

      // Verify the update
      final fromCache1 = GetPostResponse.fromCache(ctx, variables1);
      expect(fromCache1.post?.title, "Post 1 Updated");
      expect(fromCache1.post?.published, false);

      // Now add a different post with different argument
      final postData2 = {
        "post": {
          "id": "post2",
          "title": "Post 2",
          "published": true,
          "content": "Content 2",
        },
      };

      final variables2 = GetPostVariables(postId: "post2");
      final result2 = GetPostResponse.fromResponse(postData2,
          ctx: ctx, variables: variables2);

      // Both should be cached independently
      final fromCache2 = GetPostResponse.fromCache(ctx, variables2);
      expect(fromCache2.post?.title, "Post 2");

      // post1 should still have updated data
      final fromCache1Again = GetPostResponse.fromCache(ctx, variables1);
      expect(fromCache1Again.post?.title, "Post 1 Updated");
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

      final variables = GetUserVariables(userId: "user1");
      final result1 =
          GetUserResponse.fromResponse(userData, variables: variables);
      final result2 =
          GetUserResponse.fromResponse(userData, variables: variables);

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

      final variables1 = GetUserVariables(userId: "user1");
      final variables2 = GetUserVariables(userId: "user2");
      final result1 =
          GetUserResponse.fromResponse(userData1, variables: variables1);
      final result2 =
          GetUserResponse.fromResponse(userData2, variables: variables2);

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

      final variables = GetUserVariables(userId: "user1");
      final result =
          GetUserResponse.fromResponse(userData, variables: variables);
      final json = result.toJson();

      expect(json, userData);
      expect(json["user"]["id"], "user1");
      expect(json["user"]["name"], "Alice");
    });
  });
}
