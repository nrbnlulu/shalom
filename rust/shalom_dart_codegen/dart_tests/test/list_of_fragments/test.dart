import "dart:async";

import "package:shalom_core/shalom_core.dart";
import 'package:test/test.dart';
import "__graphql__/GetUsersRequiredWithFragment.shalom.dart";
import "__graphql__/GetUsersOptionalWithFragment.shalom.dart";
import "__graphql__/GetUsersRequiredWithMultipleFragments.shalom.dart";
import "__graphql__/GetUsersRequiredWithFragmentAndFields.shalom.dart";
import "__graphql__/GetPostsWithAuthorFragment.shalom.dart";
import "__graphql__/GetPostsOptionalWithMultipleFragments.shalom.dart";
import "__graphql__/GetUsersRequiredPartialFragment.shalom.dart";

void main() {
  final usersRequiredFragmentData = {
    "usersRequired": [
      {"id": "1", "name": "Alice", "email": "alice@example.com"},
      {"id": "2", "name": "Bob", "email": "bob@example.com"},
      {"id": "3", "name": "Charlie", "email": "charlie@example.com"},
    ],
  };

  final usersRequiredFragmentDataChanged = {
    "usersRequired": [
      {"id": "1", "name": "Alice Updated", "email": "alice@example.com"},
      {"id": "2", "name": "Bob", "email": "bob@example.com"},
      {"id": "3", "name": "Charlie", "email": "charlie@example.com"},
    ],
  };

  final usersRequiredFragmentEmptyData = {"usersRequired": []};

  group('List of Fragments - Required List with Single Fragment', () {
    test('listFragmentRequired - deserialize list with fragment', () {
      final result = GetUsersRequiredWithFragmentResponse.fromResponse(
          usersRequiredFragmentData);
      expect(result.usersRequired.length, 3);
      expect(result.usersRequired[0].id, "1");
      expect(result.usersRequired[0].name, "Alice");
      expect(result.usersRequired[0].email, "alice@example.com");
      expect(result.usersRequired[1].id, "2");
      expect(result.usersRequired[1].name, "Bob");
    });

    test('listFragmentRequired - deserialize empty list', () {
      final result = GetUsersRequiredWithFragmentResponse.fromResponse(
          usersRequiredFragmentEmptyData);
      expect(result.usersRequired, []);
    });

    test('listFragmentRequired - toJson', () {
      final initial = GetUsersRequiredWithFragmentResponse.fromResponse(
          usersRequiredFragmentData);
      final json = initial.toJson();
      expect(json, usersRequiredFragmentData);
    });

    test('listFragmentRequired - toJson with empty list', () {
      final initial = GetUsersRequiredWithFragmentResponse.fromResponse(
          usersRequiredFragmentEmptyData);
      final json = initial.toJson();
      expect(json, usersRequiredFragmentEmptyData);
    });

    test('listFragmentRequired - equals', () {
      final ctx = ShalomCtx.withCapacity();
      final result1 = GetUsersRequiredWithFragmentResponse.fromResponse(
          usersRequiredFragmentData,
          ctx: ctx);
      final result2 = GetUsersRequiredWithFragmentResponse.fromResponse(
          usersRequiredFragmentData,
          ctx: ctx);
      final result3 = GetUsersRequiredWithFragmentResponse.fromResponse(
          usersRequiredFragmentDataChanged,
          ctx: ctx);

      expect(result1, equals(result2));
      expect(result1, isNot(equals(result3)));
    });

    test('listFragmentRequired - cacheNormalization', () async {
      final ctx = ShalomCtx.withCapacity();
      var (result, updateCtx) =
          GetUsersRequiredWithFragmentResponse.fromResponseImpl(
        usersRequiredFragmentData,
        ctx,
      );

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetUsersRequiredWithFragmentResponse.fromCache(newCtx);
        hasChanged.complete(true);
      });

      final nextResult = GetUsersRequiredWithFragmentResponse.fromResponse(
        usersRequiredFragmentDataChanged,
        ctx: ctx,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.usersRequired[0].name, "Alice Updated");
    });
  });

  final usersOptionalFragmentData = {
    "usersOptional": [
      {"id": "1", "name": "Alice", "email": "alice@example.com"},
      {"id": "2", "name": "Bob", "email": "bob@example.com"},
    ],
  };

  final usersOptionalFragmentDataChanged = {
    "usersOptional": [
      {"id": "1", "name": "Alice Modified", "email": "alice@example.com"},
      {"id": "2", "name": "Bob", "email": "bob@example.com"},
    ],
  };

  final usersOptionalFragmentNullData = {"usersOptional": null};
  final usersOptionalFragmentEmptyData = {"usersOptional": []};

  group('List of Fragments - Optional List with Single Fragment', () {
    test('listFragmentOptional - deserialize list with fragment', () {
      final result = GetUsersOptionalWithFragmentResponse.fromResponse(
          usersOptionalFragmentData);
      expect(result.usersOptional?.length, 2);
      expect(result.usersOptional?[0].id, "1");
      expect(result.usersOptional?[0].name, "Alice");
    });

    test('listFragmentOptional - deserialize null list', () {
      final result = GetUsersOptionalWithFragmentResponse.fromResponse(
          usersOptionalFragmentNullData);
      expect(result.usersOptional, isNull);
    });

    test('listFragmentOptional - deserialize empty list', () {
      final result = GetUsersOptionalWithFragmentResponse.fromResponse(
          usersOptionalFragmentEmptyData);
      expect(result.usersOptional, []);
    });

    test('listFragmentOptional - toJson', () {
      final initial = GetUsersOptionalWithFragmentResponse.fromResponse(
          usersOptionalFragmentData);
      final json = initial.toJson();
      expect(json, usersOptionalFragmentData);
    });

    test('listFragmentOptional - toJson with null', () {
      final initial = GetUsersOptionalWithFragmentResponse.fromResponse(
          usersOptionalFragmentNullData);
      final json = initial.toJson();
      expect(json, usersOptionalFragmentNullData);
    });

    test('listFragmentOptional - equals', () {
      final ctx = ShalomCtx.withCapacity();
      final result1 = GetUsersOptionalWithFragmentResponse.fromResponse(
          usersOptionalFragmentData,
          ctx: ctx);
      final result2 = GetUsersOptionalWithFragmentResponse.fromResponse(
          usersOptionalFragmentData,
          ctx: ctx);
      final result3 = GetUsersOptionalWithFragmentResponse.fromResponse(
          usersOptionalFragmentNullData,
          ctx: ctx);

      expect(result1, equals(result2));
      expect(result1, isNot(equals(result3)));
    });

    test('listFragmentOptional - cacheNormalization null to some', () async {
      final ctx = ShalomCtx.withCapacity();
      var (result, updateCtx) =
          GetUsersOptionalWithFragmentResponse.fromResponseImpl(
        usersOptionalFragmentNullData,
        ctx,
      );

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetUsersOptionalWithFragmentResponse.fromCache(newCtx);
        hasChanged.complete(true);
      });

      final nextResult = GetUsersOptionalWithFragmentResponse.fromResponse(
        usersOptionalFragmentData,
        ctx: ctx,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.usersOptional?.length, 2);
    });

    test('listFragmentOptional - cacheNormalization some to some', () async {
      final ctx = ShalomCtx.withCapacity();
      var (result, updateCtx) =
          GetUsersOptionalWithFragmentResponse.fromResponseImpl(
        usersOptionalFragmentData,
        ctx,
      );

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetUsersOptionalWithFragmentResponse.fromCache(newCtx);
        hasChanged.complete(true);
      });

      final nextResult = GetUsersOptionalWithFragmentResponse.fromResponse(
        usersOptionalFragmentDataChanged,
        ctx: ctx,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.usersOptional?[0].name, "Alice Modified");
    });
  });

  final usersMultipleFragmentsData = {
    "usersRequired": [
      {
        "id": "1",
        "name": "Alice",
        "email": "alice@example.com",
        "bio": "Software Engineer",
        "age": 30
      },
      {
        "id": "2",
        "name": "Bob",
        "email": "bob@example.com",
        "bio": "Designer",
        "age": 25
      },
    ],
  };

  final usersMultipleFragmentsDataChanged = {
    "usersRequired": [
      {
        "id": "1",
        "name": "Alice",
        "email": "alice@example.com",
        "bio": "Senior Software Engineer",
        "age": 31
      },
      {
        "id": "2",
        "name": "Bob",
        "email": "bob@example.com",
        "bio": "Designer",
        "age": 25
      },
    ],
  };

  group('List of Fragments - Multiple Fragments', () {
    test('multipleFragmentsRequired - deserialize', () {
      final result = GetUsersRequiredWithMultipleFragmentsResponse.fromResponse(
          usersMultipleFragmentsData);
      expect(result.usersRequired.length, 2);
      expect(result.usersRequired[0].id, "1");
      expect(result.usersRequired[0].name, "Alice");
      expect(result.usersRequired[0].email, "alice@example.com");
      expect(result.usersRequired[0].bio, "Software Engineer");
      expect(result.usersRequired[0].age, 30);
    });

    test('multipleFragmentsRequired - toJson', () {
      final initial =
          GetUsersRequiredWithMultipleFragmentsResponse.fromResponse(
              usersMultipleFragmentsData);
      final json = initial.toJson();
      expect(json, usersMultipleFragmentsData);
    });

    test('multipleFragmentsRequired - equals', () {
      final ctx = ShalomCtx.withCapacity();
      final result1 =
          GetUsersRequiredWithMultipleFragmentsResponse.fromResponse(
              usersMultipleFragmentsData,
              ctx: ctx);
      final result2 =
          GetUsersRequiredWithMultipleFragmentsResponse.fromResponse(
              usersMultipleFragmentsData,
              ctx: ctx);
      final result3 =
          GetUsersRequiredWithMultipleFragmentsResponse.fromResponse(
              usersMultipleFragmentsDataChanged,
              ctx: ctx);

      expect(result1, equals(result2));
      expect(result1, isNot(equals(result3)));
    });

    test('multipleFragmentsRequired - cacheNormalization', () async {
      final ctx = ShalomCtx.withCapacity();
      var (result, updateCtx) =
          GetUsersRequiredWithMultipleFragmentsResponse.fromResponseImpl(
        usersMultipleFragmentsData,
        ctx,
      );

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result =
            GetUsersRequiredWithMultipleFragmentsResponse.fromCache(newCtx);
        hasChanged.complete(true);
      });

      final nextResult =
          GetUsersRequiredWithMultipleFragmentsResponse.fromResponse(
        usersMultipleFragmentsDataChanged,
        ctx: ctx,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.usersRequired[0].bio, "Senior Software Engineer");
      expect(result.usersRequired[0].age, 31);
    });
  });

  final usersFragmentAndFieldsData = {
    "usersRequired": [
      {
        "id": "1",
        "name": "Alice",
        "email": "alice@example.com",
        "age": 30,
        "bio": "Developer"
      },
      {
        "id": "2",
        "name": "Bob",
        "email": "bob@example.com",
        "age": 25,
        "bio": "Designer"
      },
    ],
  };

  final usersFragmentAndFieldsDataChanged = {
    "usersRequired": [
      {
        "id": "1",
        "name": "Alice Updated",
        "email": "alice@example.com",
        "age": 31,
        "bio": "Senior Developer"
      },
      {
        "id": "2",
        "name": "Bob",
        "email": "bob@example.com",
        "age": 25,
        "bio": "Designer"
      },
    ],
  };

  group('List of Fragments - Fragment with Additional Fields', () {
    test('fragmentWithFieldsRequired - deserialize', () {
      final result = GetUsersRequiredWithFragmentAndFieldsResponse.fromResponse(
          usersFragmentAndFieldsData);
      expect(result.usersRequired.length, 2);
      expect(result.usersRequired[0].id, "1");
      expect(result.usersRequired[0].name, "Alice");
      expect(result.usersRequired[0].email, "alice@example.com");
      expect(result.usersRequired[0].age, 30);
      expect(result.usersRequired[0].bio, "Developer");
    });

    test('fragmentWithFieldsRequired - toJson', () {
      final initial =
          GetUsersRequiredWithFragmentAndFieldsResponse.fromResponse(
              usersFragmentAndFieldsData);
      final json = initial.toJson();
      expect(json, usersFragmentAndFieldsData);
    });

    test('fragmentWithFieldsRequired - equals', () {
      final ctx = ShalomCtx.withCapacity();
      final result1 =
          GetUsersRequiredWithFragmentAndFieldsResponse.fromResponse(
              usersFragmentAndFieldsData,
              ctx: ctx);
      final result2 =
          GetUsersRequiredWithFragmentAndFieldsResponse.fromResponse(
              usersFragmentAndFieldsData,
              ctx: ctx);
      final result3 =
          GetUsersRequiredWithFragmentAndFieldsResponse.fromResponse(
              usersFragmentAndFieldsDataChanged,
              ctx: ctx);

      expect(result1, equals(result2));
      expect(result1, isNot(equals(result3)));
    });

    test('fragmentWithFieldsRequired - cacheNormalization', () async {
      final ctx = ShalomCtx.withCapacity();
      var (result, updateCtx) =
          GetUsersRequiredWithFragmentAndFieldsResponse.fromResponseImpl(
        usersFragmentAndFieldsData,
        ctx,
      );

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result =
            GetUsersRequiredWithFragmentAndFieldsResponse.fromCache(newCtx);
        hasChanged.complete(true);
      });

      final nextResult =
          GetUsersRequiredWithFragmentAndFieldsResponse.fromResponse(
        usersFragmentAndFieldsDataChanged,
        ctx: ctx,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.usersRequired[0].name, "Alice Updated");
      expect(result.usersRequired[0].age, 31);
      expect(result.usersRequired[0].bio, "Senior Developer");
    });
  });

  final postsWithAuthorFragmentData = {
    "posts": [
      {
        "id": "post1",
        "title": "GraphQL Guide",
        "published": true,
        "author": {"id": "1", "name": "Alice", "email": "alice@example.com"}
      },
      {
        "id": "post2",
        "title": "Dart Tips",
        "published": false,
        "author": {"id": "2", "name": "Bob", "email": "bob@example.com"}
      },
    ],
  };

  final postsWithAuthorFragmentDataChanged = {
    "posts": [
      {
        "id": "post1",
        "title": "GraphQL Guide Updated",
        "published": true,
        "author": {
          "id": "1",
          "name": "Alice Updated",
          "email": "alice@example.com"
        }
      },
      {
        "id": "post2",
        "title": "Dart Tips",
        "published": false,
        "author": {"id": "2", "name": "Bob", "email": "bob@example.com"}
      },
    ],
  };

  group('List of Fragments - Nested Object with Fragment', () {
    test('nestedFragmentRequired - deserialize', () {
      final result = GetPostsWithAuthorFragmentResponse.fromResponse(
          postsWithAuthorFragmentData);
      expect(result.posts.length, 2);
      expect(result.posts[0].id, "post1");
      expect(result.posts[0].title, "GraphQL Guide");
      expect(result.posts[0].published, true);
      expect(result.posts[0].author.id, "1");
      expect(result.posts[0].author.name, "Alice");
      expect(result.posts[0].author.email, "alice@example.com");
    });

    test('nestedFragmentRequired - toJson', () {
      final initial = GetPostsWithAuthorFragmentResponse.fromResponse(
          postsWithAuthorFragmentData);
      final json = initial.toJson();
      expect(json, postsWithAuthorFragmentData);
    });

    test('nestedFragmentRequired - equals', () {
      final ctx = ShalomCtx.withCapacity();
      final result1 = GetPostsWithAuthorFragmentResponse.fromResponse(
          postsWithAuthorFragmentData,
          ctx: ctx);
      final result2 = GetPostsWithAuthorFragmentResponse.fromResponse(
          postsWithAuthorFragmentData,
          ctx: ctx);
      final result3 = GetPostsWithAuthorFragmentResponse.fromResponse(
          postsWithAuthorFragmentDataChanged,
          ctx: ctx);

      expect(result1, equals(result2));
      expect(result1, isNot(equals(result3)));
    });

    test('nestedFragmentRequired - cacheNormalization', () async {
      final ctx = ShalomCtx.withCapacity();
      var (result, updateCtx) =
          GetPostsWithAuthorFragmentResponse.fromResponseImpl(
        postsWithAuthorFragmentData,
        ctx,
      );

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetPostsWithAuthorFragmentResponse.fromCache(newCtx);
        hasChanged.complete(true);
      });

      final nextResult = GetPostsWithAuthorFragmentResponse.fromResponse(
        postsWithAuthorFragmentDataChanged,
        ctx: ctx,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.posts[0].title, "GraphQL Guide Updated");
      expect(result.posts[0].author.name, "Alice Updated");
    });
  });

  final postsOptionalMultipleFragmentsData = {
    "postsOptional": [
      {
        "id": "post1",
        "title": "GraphQL Basics",
        "published": true,
        "content": "Content 1",
        "tags": ["graphql", "basics"]
      },
      {
        "id": "post2",
        "title": "Advanced Topics",
        "published": false,
        "content": "Content 2",
        "tags": ["advanced", "topics"]
      },
    ],
  };

  final postsOptionalMultipleFragmentsDataChanged = {
    "postsOptional": [
      {
        "id": "post1",
        "title": "GraphQL Basics Updated",
        "published": true,
        "content": "Content 1 Updated",
        "tags": ["graphql", "basics", "updated"]
      },
      {
        "id": "post2",
        "title": "Advanced Topics",
        "published": false,
        "content": "Content 2",
        "tags": ["advanced", "topics"]
      },
    ],
  };

  final postsOptionalMultipleFragmentsNullData = {"postsOptional": null};

  group('List of Fragments - Optional List with Multiple Fragments', () {
    test('optionalMultipleFragments - deserialize', () {
      final result = GetPostsOptionalWithMultipleFragmentsResponse.fromResponse(
          postsOptionalMultipleFragmentsData);
      expect(result.postsOptional?.length, 2);
      expect(result.postsOptional?[0].id, "post1");
      expect(result.postsOptional?[0].title, "GraphQL Basics");
      expect(result.postsOptional?[0].published, true);
      expect(result.postsOptional?[0].content, "Content 1");
      expect(result.postsOptional?[0].tags, ["graphql", "basics"]);
    });

    test('optionalMultipleFragments - deserialize null', () {
      final result = GetPostsOptionalWithMultipleFragmentsResponse.fromResponse(
          postsOptionalMultipleFragmentsNullData);
      expect(result.postsOptional, isNull);
    });

    test('optionalMultipleFragments - toJson', () {
      final initial =
          GetPostsOptionalWithMultipleFragmentsResponse.fromResponse(
              postsOptionalMultipleFragmentsData);
      final json = initial.toJson();
      expect(json, postsOptionalMultipleFragmentsData);
    });

    test('optionalMultipleFragments - equals', () {
      final ctx = ShalomCtx.withCapacity();
      final result1 =
          GetPostsOptionalWithMultipleFragmentsResponse.fromResponse(
              postsOptionalMultipleFragmentsData,
              ctx: ctx);
      final result2 =
          GetPostsOptionalWithMultipleFragmentsResponse.fromResponse(
              postsOptionalMultipleFragmentsData,
              ctx: ctx);
      final result3 =
          GetPostsOptionalWithMultipleFragmentsResponse.fromResponse(
              postsOptionalMultipleFragmentsNullData,
              ctx: ctx);

      expect(result1, equals(result2));
      expect(result1, isNot(equals(result3)));
    });

    test('optionalMultipleFragments - cacheNormalization', () async {
      final ctx = ShalomCtx.withCapacity();
      var (result, updateCtx) =
          GetPostsOptionalWithMultipleFragmentsResponse.fromResponseImpl(
        postsOptionalMultipleFragmentsData,
        ctx,
      );

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result =
            GetPostsOptionalWithMultipleFragmentsResponse.fromCache(newCtx);
        hasChanged.complete(true);
      });

      final nextResult =
          GetPostsOptionalWithMultipleFragmentsResponse.fromResponse(
        postsOptionalMultipleFragmentsDataChanged,
        ctx: ctx,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.postsOptional?[0].title, "GraphQL Basics Updated");
      expect(result.postsOptional?[0].content, "Content 1 Updated");
      expect(result.postsOptional?[0].tags, ["graphql", "basics", "updated"]);
    });
  });

  group('List of Fragments - Cache Normalization with Partial Selection', () {
    test('partialFragmentCacheNormalization - no overlapping deps', () async {
      final ctx = ShalomCtx.withCapacity();
      var (result, updateCtx) =
          GetUsersRequiredPartialFragmentResponse.fromResponseImpl(
        usersRequiredFragmentData,
        ctx,
      );

      final hasChanged = Completer<bool>();
      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetUsersRequiredPartialFragmentResponse.fromCache(newCtx);
        hasChanged.complete(true);
      });

      // Change fields that are not part of the partial query (age, bio)
      final dataWithNonSelectedFieldsChanged = {
        "usersRequired": [
          {
            "id": "1",
            "name": "Alice",
            "email": "alice@example.com",
            "age": 31,
            "bio": "Updated bio"
          },
          {
            "id": "2",
            "name": "Bob",
            "email": "bob@example.com",
            "age": 26,
            "bio": "Updated bio"
          },
          {
            "id": "3",
            "name": "Charlie",
            "email": "charlie@example.com",
            "age": 36,
            "bio": "Updated bio"
          },
        ],
      };

      final _ = GetUsersRequiredWithFragmentAndFieldsResponse.fromResponse(
        dataWithNonSelectedFieldsChanged,
        ctx: ctx,
      );

      // we don't expect any change as the changed fields (age, bio) are not part of the deps
      await Future.delayed(Duration(milliseconds: 500));
      expect(hasChanged.isCompleted, false);

      // But name change should trigger update
      final dataWithNameChange = {
        "usersRequired": [
          {"id": "1", "name": "Alice Changed", "email": "alice@example.com"},
          {"id": "2", "name": "Bob", "email": "bob@example.com"},
          {"id": "3", "name": "Charlie", "email": "charlie@example.com"},
        ],
      };

      final nextResult = GetUsersRequiredPartialFragmentResponse.fromResponse(
        dataWithNameChange,
        ctx: ctx,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.usersRequired[0].name, "Alice Changed");
    });
  });
}
