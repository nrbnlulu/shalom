import 'dart:async';
import 'package:test/test.dart';
import 'package:shalom_core/shalom_core.dart';
import '__graphql__/GetPostWithDetails.shalom.dart';
import '__graphql__/GetUserWithProfile.shalom.dart';

void main() {
  group('Fragment With Nested Object Selection - PostDetailsFrag', () {
    final postWithDetailsData = {
      "post": {
        "id": "post1",
        "title": "GraphQL Best Practices",
        "content": "Content about GraphQL...",
        "author": {
          "id": "author1",
          "name": "Alice Johnson",
          "email": "alice@example.com",
          "bio": "GraphQL enthusiast",
        },
      },
    };

    final postWithDetailsDataChangedTitle = {
      "post": {
        "id": "post1",
        "title": "GraphQL Advanced Practices",
        "content": "Content about GraphQL...",
        "author": {
          "id": "author1",
          "name": "Alice Johnson",
          "email": "alice@example.com",
          "bio": "GraphQL enthusiast",
        },
      },
    };

    test(
      'fragmentWithNestedObjectRequired - Fragment with nested object deserializes',
      () {
        final variables = GetPostWithDetailsVariables(postId: "post1");
        final result = GetPostWithDetailsResponse.fromResponse(
          postWithDetailsData,
          variables: variables,
        );

        // Test access to top-level fields
        expect(result.post?.id, "post1");
        expect(result.post?.title, "GraphQL Best Practices");
        expect(result.post?.content, "Content about GraphQL...");

        // Test access to nested object fields defined in fragment
        expect(result.post?.author.id, "author1");
        expect(result.post?.author.name, "Alice Johnson");
        expect(result.post?.author.email, "alice@example.com");
        expect(result.post?.author.bio, "GraphQL enthusiast");
      },
    );

    test(
      'fragmentWithNestedObjectOptional - Nested object fields are accessible',
      () {
        final variables = GetPostWithDetailsVariables(postId: "post1");
        final result = GetPostWithDetailsResponse.fromResponse(
          postWithDetailsData,
          variables: variables,
        );

        // Verify nested object can be accessed and used
        final author = result.post?.author;
        expect(author?.id, "author1");
        expect(author?.name, "Alice Johnson");

        // Verify optional field in nested object
        expect(author?.bio, "GraphQL enthusiast");
      },
    );

    test(
      'fragmentWithNestedObjectCacheNormalization - Cache updates work with nested objects',
      () async {
        final ctx = ShalomCtx.withCapacity();
        final variables = GetPostWithDetailsVariables(postId: "post1");

        var (result, updateCtx) = GetPostWithDetailsResponse.fromResponseImpl(
          postWithDetailsData,
          ctx,
          variables,
        );

        final hasChanged = Completer<bool>();

        final sub = ctx.subscribe(updateCtx.dependantRecords);
        sub.streamController.stream.listen((newCtx) {
          result = GetPostWithDetailsResponse.fromCache(newCtx, variables);
          hasChanged.complete(true);
        });

        // Update with changed title
        final nextResult = GetPostWithDetailsResponse.fromResponse(
          postWithDetailsDataChangedTitle,
          ctx: ctx,
          variables: variables,
        );

        await hasChanged.future.timeout(Duration(seconds: 1));
        expect(result, equals(nextResult));
        expect(result.post?.title, "GraphQL Advanced Practices");

        // Verify nested object is still accessible after cache update
        expect(result.post?.author.id, "author1");
        expect(result.post?.author.name, "Alice Johnson");
      },
    );

    test(
      'fragmentWithNestedObjectEquals - Equality works with nested objects',
      () {
        final variables = GetPostWithDetailsVariables(postId: "post1");
        final result1 = GetPostWithDetailsResponse.fromResponse(
          postWithDetailsData,
          variables: variables,
        );
        final result2 = GetPostWithDetailsResponse.fromResponse(
          postWithDetailsData,
          variables: variables,
        );

        expect(result1, equals(result2));
        expect(result1.hashCode, equals(result2.hashCode));

        // Verify nested objects are also equal
        expect(result1.post?.author, equals(result2.post?.author));
      },
    );

    test(
      'fragmentWithNestedObjectToJson - Serialization includes nested objects',
      () {
        final variables = GetPostWithDetailsVariables(postId: "post1");
        final result = GetPostWithDetailsResponse.fromResponse(
          postWithDetailsData,
          variables: variables,
        );
        final json = result.toJson();

        expect(json, postWithDetailsData);

        // Verify nested object is properly serialized
        expect(json["post"]?["author"]?["id"], "author1");
        expect(json["post"]?["author"]?["name"], "Alice Johnson");
      },
    );
  });

  group('Fragment With Nested Object Selection - UserProfileFrag', () {
    final userWithProfileData = {
      "user": {
        "id": "user1",
        "username": "johndoe",
        "profile": {
          "id": "profile1",
          "displayName": "John Doe",
          "avatar": "https://example.com/avatar.jpg",
        },
      },
    };

    final userWithProfileDataChanged = {
      "user": {
        "id": "user1",
        "username": "johndoe",
        "profile": {
          "id": "profile1",
          "displayName": "John D.",
          "avatar": "https://example.com/avatar.jpg",
        },
      },
    };

    final userWithProfileNoAvatar = {
      "user": {
        "id": "user2",
        "username": "janedoe",
        "profile": {
          "id": "profile2",
          "displayName": "Jane Doe",
          "avatar": null,
        },
      },
    };

    test(
      'fragmentWithNestedObjectRequired - Second fragment with nested object',
      () {
        final variables = GetUserWithProfileVariables(userId: "user1");
        final result = GetUserWithProfileResponse.fromResponse(
          userWithProfileData,
          variables: variables,
        );

        expect(result.user?.id, "user1");
        expect(result.user?.username, "johndoe");
        expect(result.user?.profile.id, "profile1");
        expect(result.user?.profile.displayName, "John Doe");
        expect(result.user?.profile.avatar, "https://example.com/avatar.jpg");
      },
    );

    test(
      'fragmentWithNestedObjectOptional - Nested object with optional fields',
      () {
        final variables = GetUserWithProfileVariables(userId: "user2");
        final result = GetUserWithProfileResponse.fromResponse(
          userWithProfileNoAvatar,
          variables: variables,
        );

        expect(result.user?.profile.id, "profile2");
        expect(result.user?.profile.displayName, "Jane Doe");
        expect(result.user?.profile.avatar, null);
      },
    );

    test(
      'fragmentWithNestedObjectCacheNormalization - Cache updates with second fragment',
      () async {
        final ctx = ShalomCtx.withCapacity();
        final variables = GetUserWithProfileVariables(userId: "user1");

        var (result, updateCtx) = GetUserWithProfileResponse.fromResponseImpl(
          userWithProfileData,
          ctx,
          variables,
        );

        final hasChanged = Completer<bool>();

        final sub = ctx.subscribe(updateCtx.dependantRecords);
        sub.streamController.stream.listen((newCtx) {
          result = GetUserWithProfileResponse.fromCache(newCtx, variables);
          hasChanged.complete(true);
        });

        final nextResult = GetUserWithProfileResponse.fromResponse(
          userWithProfileDataChanged,
          ctx: ctx,
          variables: variables,
        );

        await hasChanged.future.timeout(Duration(seconds: 1));
        expect(result, equals(nextResult));
        expect(result.user?.profile.displayName, "John D.");
      },
    );

    test('fragmentWithNestedObjectEquals - Equality with second fragment', () {
      final variables = GetUserWithProfileVariables(userId: "user1");
      final result1 = GetUserWithProfileResponse.fromResponse(
        userWithProfileData,
        variables: variables,
      );
      final result2 = GetUserWithProfileResponse.fromResponse(
        userWithProfileData,
        variables: variables,
      );

      expect(result1, equals(result2));
      expect(result1.hashCode, equals(result2.hashCode));
      expect(result1.user?.profile, equals(result2.user?.profile));
    });

    test(
      'fragmentWithNestedObjectToJson - Serialization with second fragment',
      () {
        final variables = GetUserWithProfileVariables(userId: "user1");
        final result = GetUserWithProfileResponse.fromResponse(
          userWithProfileData,
          variables: variables,
        );
        final json = result.toJson();

        expect(json, userWithProfileData);
        expect(json["user"]?["profile"]?["id"], "profile1");
        expect(json["user"]?["profile"]?["displayName"], "John Doe");
      },
    );
  });
}
