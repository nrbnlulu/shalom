import "dart:async";

import "package:shalom/shalom.dart";
import 'package:test/test.dart';
import "__graphql__/GetSearchResultsRequired.shalom.dart";
import "__graphql__/GetSearchResultsOptional.shalom.dart";
import "__graphql__/GetOptionalSearchResults.shalom.dart";
import "__graphql__/GetSearchResultsFullyOptional.shalom.dart";

void main() {
  // Test data for required list
  final searchResultsRequiredData = {
    "searchResultsRequired": [
      {
        "__typename": "User",
        "id": "user1",
        "name": "Alice",
        "email": "alice@example.com",
      },
      {
        "__typename": "Post",
        "id": "post1",
        "title": "Hello World",
        "content": "First post",
        "author": "Bob",
      },
      {
        "__typename": "Comment",
        "id": "comment1",
        "text": "Great!",
        "author": "Charlie",
      },
    ],
  };

  final searchResultsRequiredDataChanged = {
    "searchResultsRequired": [
      {
        "__typename": "User",
        "id": "user1",
        "name": "Alice Updated",
        "email": "alice@example.com",
      },
      {
        "__typename": "Post",
        "id": "post1",
        "title": "Hello World",
        "content": "First post",
        "author": "Bob",
      },
      {
        "__typename": "Comment",
        "id": "comment1",
        "text": "Great!",
        "author": "Charlie",
      },
    ],
  };

  final searchResultsRequiredTypeChanged = {
    "searchResultsRequired": [
      {
        "__typename": "Post",
        "id": "user1",
        "title": "Now a post",
        "content": "Changed type",
        "author": "Alice",
      },
      {
        "__typename": "Post",
        "id": "post1",
        "title": "Hello World",
        "content": "First post",
        "author": "Bob",
      },
      {
        "__typename": "Comment",
        "id": "comment1",
        "text": "Great!",
        "author": "Charlie",
      },
    ],
  };

  final searchResultsRequiredLengthChanged = {
    "searchResultsRequired": [
      {
        "__typename": "User",
        "id": "user1",
        "name": "Alice",
        "email": "alice@example.com",
      },
      {
        "__typename": "Post",
        "id": "post1",
        "title": "Hello World",
        "content": "First post",
        "author": "Bob",
      },
    ],
  };

  final searchResultsRequiredIdChanged = {
    "searchResultsRequired": [
      {
        "__typename": "User",
        "id": "user1",
        "name": "Alice",
        "email": "alice@example.com",
      },
      {
        "__typename": "User",
        "id": "user2",
        "name": "David",
        "email": "david@example.com",
      },
      {
        "__typename": "Comment",
        "id": "comment1",
        "text": "Great!",
        "author": "Charlie",
      },
    ],
  };

  final searchResultsRequiredEmptyData = {"searchResultsRequired": []};

  group('List of Unions Required - [SearchResult!]!', () {
    test('searchResultsRequired deserialize mixed types', () {
      final result = GetSearchResultsRequiredResponse.fromJson(
        searchResultsRequiredData,
      );
      expect(result.searchResultsRequired.length, 3);

      expect(
        result.searchResultsRequired[0],
        isA<GetSearchResultsRequired_searchResultsRequired__User>(),
      );
      final user = result.searchResultsRequired[0]
          as GetSearchResultsRequired_searchResultsRequired__User;
      expect(user.id, "user1");
      expect(user.name, "Alice");
      expect(user.email, "alice@example.com");
      expect(user.$__typename, "User");

      expect(
        result.searchResultsRequired[1],
        isA<GetSearchResultsRequired_searchResultsRequired__Post>(),
      );
      final post = result.searchResultsRequired[1]
          as GetSearchResultsRequired_searchResultsRequired__Post;
      expect(post.id, "post1");
      expect(post.title, "Hello World");
      expect(post.content, "First post");
      expect(post.author, "Bob");
      expect(post.$__typename, "Post");

      expect(
        result.searchResultsRequired[2],
        isA<GetSearchResultsRequired_searchResultsRequired__Comment>(),
      );
      final comment = result.searchResultsRequired[2]
          as GetSearchResultsRequired_searchResultsRequired__Comment;
      expect(comment.id, "comment1");
      expect(comment.text, "Great!");
      expect(comment.author, "Charlie");
      expect(comment.$__typename, "Comment");
    });

    test('searchResultsRequired deserialize empty list', () {
      final result = GetSearchResultsRequiredResponse.fromJson(
        searchResultsRequiredEmptyData,
      );
      expect(result.searchResultsRequired, []);
    });

    test('searchResultsRequired toJson', () {
      final initial = GetSearchResultsRequiredResponse.fromJson(
        searchResultsRequiredData,
      );
      final json = initial.toJson();
      expect(json, searchResultsRequiredData);
    });

    test('searchResultsRequired toJson empty list', () {
      final initial = GetSearchResultsRequiredResponse.fromJson(
        searchResultsRequiredEmptyData,
      );
      final json = initial.toJson();
      expect(json, searchResultsRequiredEmptyData);
    });

    test('searchResultsRequired equals', () {
      final result1 = GetSearchResultsRequiredResponse.fromJson(
        searchResultsRequiredData,
      );
      final result2 = GetSearchResultsRequiredResponse.fromJson(
        searchResultsRequiredData,
      );
      final result3 = GetSearchResultsRequiredResponse.fromJson(
        searchResultsRequiredDataChanged,
      );

      expect(result1, equals(result2));
      expect(result1, isNot(equals(result3)));
    });

    test(
      'searchResultsRequired cacheNormalization - inner field change',
      () async {
        final ctx = ShalomCtx.withCapacity();
        var (
          result,
          updateCtx,
        ) = GetSearchResultsRequiredResponse.fromJson(
          searchResultsRequiredData,
          ctx,
        );

        final hasChanged = Completer<bool>();

        final sub = ctx.subscribe(updateCtx.dependantRecords);
        sub.streamController.stream.listen((newCtx) {
          result = GetSearchResultsRequiredResponse.fromCache(newCtx);
          hasChanged.complete(true);
        });

        final nextResult = GetSearchResultsRequiredResponse.fromJson(
          searchResultsRequiredDataChanged,
          ctx: ctx,
        );

        await hasChanged.future.timeout(Duration(seconds: 1));
        expect(result, equals(nextResult));
        final user = result.searchResultsRequired[0]
            as GetSearchResultsRequired_searchResultsRequired__User;
        expect(user.name, "Alice Updated");
      },
    );

    test('searchResultsRequired cacheNormalization - type change', () async {
      final ctx = ShalomCtx.withCapacity();
      var (
        result,
        updateCtx,
      ) = GetSearchResultsRequiredResponse.fromJson(
        searchResultsRequiredData,
        ctx,
      );

      expect(
        result.searchResultsRequired[0],
        isA<GetSearchResultsRequired_searchResultsRequired__User>(),
      );

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetSearchResultsRequiredResponse.fromCache(newCtx);
        hasChanged.complete(true);
      });

      final nextResult = GetSearchResultsRequiredResponse.fromJson(
        searchResultsRequiredTypeChanged,
        ctx: ctx,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(
        result.searchResultsRequired[0],
        isA<GetSearchResultsRequired_searchResultsRequired__Post>(),
      );
      final post = result.searchResultsRequired[0]
          as GetSearchResultsRequired_searchResultsRequired__Post;
      expect(post.title, "Now a post");
    });

    test(
      'searchResultsRequired cacheNormalization - list length changed',
      () async {
        final ctx = ShalomCtx.withCapacity();
        var (
          result,
          updateCtx,
        ) = GetSearchResultsRequiredResponse.fromJson(
          searchResultsRequiredData,
          ctx,
        );

        final hasChanged = Completer<bool>();

        final sub = ctx.subscribe(updateCtx.dependantRecords);
        sub.streamController.stream.listen((newCtx) {
          result = GetSearchResultsRequiredResponse.fromCache(newCtx);
          hasChanged.complete(true);
        });

        final nextResult = GetSearchResultsRequiredResponse.fromJson(
          searchResultsRequiredLengthChanged,
          ctx: ctx,
        );

        await hasChanged.future.timeout(Duration(seconds: 1));
        expect(result, equals(nextResult));
        expect(result.searchResultsRequired.length, 2);
      },
    );

    test(
      'searchResultsRequired cacheNormalization - object ID changed at index',
      () async {
        final ctx = ShalomCtx.withCapacity();
        var (
          result,
          updateCtx,
        ) = GetSearchResultsRequiredResponse.fromJson(
          searchResultsRequiredData,
          ctx,
        );

        final hasChanged = Completer<bool>();

        final sub = ctx.subscribe(updateCtx.dependantRecords);
        sub.streamController.stream.listen((newCtx) {
          result = GetSearchResultsRequiredResponse.fromCache(newCtx);
          hasChanged.complete(true);
        });

        final nextResult = GetSearchResultsRequiredResponse.fromJson(
          searchResultsRequiredIdChanged,
          ctx: ctx,
        );

        await hasChanged.future.timeout(Duration(seconds: 1));
        expect(result, equals(nextResult));
        final user = result.searchResultsRequired[1]
            as GetSearchResultsRequired_searchResultsRequired__User;
        expect(user.id, "user2");
        expect(user.name, "David");
      },
    );
  });

  // Test data for optional list
  final searchResultsOptionalData = {
    "searchResultsOptional": [
      {
        "__typename": "User",
        "id": "user1",
        "name": "Alice",
        "email": "alice@example.com",
      },
      {
        "__typename": "Comment",
        "id": "comment1",
        "text": "Nice!",
        "author": "Bob",
      },
    ],
  };

  final searchResultsOptionalDataChanged = {
    "searchResultsOptional": [
      {
        "__typename": "User",
        "id": "user1",
        "name": "Alice Modified",
        "email": "alice@example.com",
      },
      {
        "__typename": "Comment",
        "id": "comment1",
        "text": "Nice!",
        "author": "Bob",
      },
    ],
  };

  final searchResultsOptionalNullData = {"searchResultsOptional": null};
  final searchResultsOptionalEmptyData = {"searchResultsOptional": []};

  group('List of Unions Optional - [SearchResult!]', () {
    test('searchResultsOptional deserialize', () {
      final result = GetSearchResultsOptionalResponse.fromJson(
        searchResultsOptionalData,
      );
      expect(result.searchResultsOptional?.length, 2);

      expect(
        result.searchResultsOptional?[0],
        isA<GetSearchResultsOptional_searchResultsOptional__User>(),
      );
      final user = result.searchResultsOptional?[0]
          as GetSearchResultsOptional_searchResultsOptional__User;
      expect(user.id, "user1");
      expect(user.name, "Alice");

      expect(
        result.searchResultsOptional?[1],
        isA<GetSearchResultsOptional_searchResultsOptional__Comment>(),
      );
      final comment = result.searchResultsOptional?[1]
          as GetSearchResultsOptional_searchResultsOptional__Comment;
      expect(comment.id, "comment1");
      expect(comment.text, "Nice!");
    });

    test('searchResultsOptional deserialize null', () {
      final result = GetSearchResultsOptionalResponse.fromJson(
        searchResultsOptionalNullData,
      );
      expect(result.searchResultsOptional, isNull);
    });

    test('searchResultsOptional deserialize empty list', () {
      final result = GetSearchResultsOptionalResponse.fromJson(
        searchResultsOptionalEmptyData,
      );
      expect(result.searchResultsOptional, []);
    });

    test('searchResultsOptional toJson', () {
      final initial = GetSearchResultsOptionalResponse.fromJson(
        searchResultsOptionalData,
      );
      final json = initial.toJson();
      expect(json, searchResultsOptionalData);
    });

    test('searchResultsOptional toJson null', () {
      final initial = GetSearchResultsOptionalResponse.fromJson(
        searchResultsOptionalNullData,
      );
      final json = initial.toJson();
      expect(json, searchResultsOptionalNullData);
    });

    test('searchResultsOptional toJson empty list', () {
      final initial = GetSearchResultsOptionalResponse.fromJson(
        searchResultsOptionalEmptyData,
      );
      final json = initial.toJson();
      expect(json, searchResultsOptionalEmptyData);
    });

    test('searchResultsOptional equals', () {
      final result1 = GetSearchResultsOptionalResponse.fromJson(
        searchResultsOptionalData,
      );
      final result2 = GetSearchResultsOptionalResponse.fromJson(
        searchResultsOptionalData,
      );
      final result3 = GetSearchResultsOptionalResponse.fromJson(
        searchResultsOptionalNullData,
      );
      final result4 = GetSearchResultsOptionalResponse.fromJson(
        searchResultsOptionalNullData,
      );

      expect(result1, equals(result2));
      expect(result3, equals(result4));
      expect(result1, isNot(equals(result3)));
    });

    test('searchResultsOptional cacheNormalization - null to some', () async {
      final ctx = ShalomCtx.withCapacity();
      var (
        result,
        updateCtx,
      ) = GetSearchResultsOptionalResponse.fromJson(
        searchResultsOptionalNullData,
        ctx,
      );

      expect(result.searchResultsOptional, isNull);

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetSearchResultsOptionalResponse.fromCache(newCtx);
        hasChanged.complete(true);
      });

      final nextResult = GetSearchResultsOptionalResponse.fromJson(
        searchResultsOptionalData,
        ctx: ctx,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.searchResultsOptional?.length, 2);
    });

    test('searchResultsOptional cacheNormalization - some to null', () async {
      final ctx = ShalomCtx.withCapacity();
      var (
        result,
        updateCtx,
      ) = GetSearchResultsOptionalResponse.fromJson(
        searchResultsOptionalData,
        ctx,
      );

      expect(result.searchResultsOptional, isNotNull);

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetSearchResultsOptionalResponse.fromCache(newCtx);
        hasChanged.complete(true);
      });

      final nextResult = GetSearchResultsOptionalResponse.fromJson(
        searchResultsOptionalNullData,
        ctx: ctx,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.searchResultsOptional, isNull);
    });

    test('searchResultsOptional cacheNormalization - some to some', () async {
      final ctx = ShalomCtx.withCapacity();
      var (
        result,
        updateCtx,
      ) = GetSearchResultsOptionalResponse.fromJson(
        searchResultsOptionalData,
        ctx,
      );

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetSearchResultsOptionalResponse.fromCache(newCtx);
        hasChanged.complete(true);
      });

      final nextResult = GetSearchResultsOptionalResponse.fromJson(
        searchResultsOptionalDataChanged,
        ctx: ctx,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      final user = result.searchResultsOptional?[0]
          as GetSearchResultsOptional_searchResultsOptional__User;
      expect(user.name, "Alice Modified");
    });
  });

  // Test data for optional items in list
  final optionalSearchResultsData = {
    "optionalSearchResults": [
      {
        "__typename": "Post",
        "id": "post1",
        "title": "Test",
        "content": "Content",
        "author": "Author",
      },
      null,
      {
        "__typename": "User",
        "id": "user1",
        "name": "Alice",
        "email": "alice@example.com",
      },
    ],
  };

  final optionalSearchResultsDataChanged = {
    "optionalSearchResults": [
      {
        "__typename": "Post",
        "id": "post1",
        "title": "Test Updated",
        "content": "Content",
        "author": "Author",
      },
      null,
      {
        "__typename": "User",
        "id": "user1",
        "name": "Alice",
        "email": "alice@example.com",
      },
    ],
  };

  group('Optional Unions in List - [SearchResult]!', () {
    test('optionalSearchResults deserialize with nulls', () {
      final result = GetOptionalSearchResultsResponse.fromJson(
        optionalSearchResultsData,
      );
      expect(result.optionalSearchResults.length, 3);

      expect(
        result.optionalSearchResults[0],
        isA<GetOptionalSearchResults_optionalSearchResults__Post>(),
      );
      final post = result.optionalSearchResults[0]
          as GetOptionalSearchResults_optionalSearchResults__Post;
      expect(post.id, "post1");
      expect(post.title, "Test");

      expect(result.optionalSearchResults[1], isNull);

      expect(
        result.optionalSearchResults[2],
        isA<GetOptionalSearchResults_optionalSearchResults__User>(),
      );
      final user = result.optionalSearchResults[2]
          as GetOptionalSearchResults_optionalSearchResults__User;
      expect(user.id, "user1");
      expect(user.name, "Alice");
    });

    test('optionalSearchResults toJson', () {
      final initial = GetOptionalSearchResultsResponse.fromJson(
        optionalSearchResultsData,
      );
      final json = initial.toJson();
      expect(json, optionalSearchResultsData);
    });

    test('optionalSearchResults equals', () {
      final result1 = GetOptionalSearchResultsResponse.fromJson(
        optionalSearchResultsData,
      );
      final result2 = GetOptionalSearchResultsResponse.fromJson(
        optionalSearchResultsData,
      );
      final result3 = GetOptionalSearchResultsResponse.fromJson(
        optionalSearchResultsDataChanged,
      );

      expect(result1, equals(result2));
      expect(result1, isNot(equals(result3)));
    });

    test('optionalSearchResults cacheNormalization', () async {
      final ctx = ShalomCtx.withCapacity();
      var (
        result,
        updateCtx,
      ) = GetOptionalSearchResultsResponse.fromJson(
        optionalSearchResultsData,
        ctx,
      );

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetOptionalSearchResultsResponse.fromCache(newCtx);
        hasChanged.complete(true);
      });

      final nextResult = GetOptionalSearchResultsResponse.fromJson(
        optionalSearchResultsDataChanged,
        ctx: ctx,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      final post = result.optionalSearchResults[0]
          as GetOptionalSearchResults_optionalSearchResults__Post;
      expect(post.title, "Test Updated");
    });
  });

  // Test data for fully optional
  final searchResultsFullyOptionalData = {
    "searchResultsFullyOptional": [
      {
        "__typename": "Comment",
        "id": "comment1",
        "text": "Hello",
        "author": "Alice",
      },
      null,
    ],
  };

  final searchResultsFullyOptionalDataChanged = {
    "searchResultsFullyOptional": [
      {
        "__typename": "Comment",
        "id": "comment1",
        "text": "Hello Modified",
        "author": "Alice",
      },
      null,
    ],
  };

  final searchResultsFullyOptionalNullData = {
    "searchResultsFullyOptional": null,
  };
  final searchResultsFullyOptionalEmptyData = {
    "searchResultsFullyOptional": [],
  };

  group('Fully Optional - [SearchResult]', () {
    test('searchResultsFullyOptional deserialize with nulls', () {
      final result = GetSearchResultsFullyOptionalResponse.fromJson(
        searchResultsFullyOptionalData,
      );
      expect(result.searchResultsFullyOptional?.length, 2);

      expect(
        result.searchResultsFullyOptional?[0],
        isA<GetSearchResultsFullyOptional_searchResultsFullyOptional__Comment>(),
      );
      final comment = result.searchResultsFullyOptional?[0]
          as GetSearchResultsFullyOptional_searchResultsFullyOptional__Comment;
      expect(comment.id, "comment1");
      expect(comment.text, "Hello");

      expect(result.searchResultsFullyOptional?[1], isNull);
    });

    test('searchResultsFullyOptional deserialize null', () {
      final result = GetSearchResultsFullyOptionalResponse.fromJson(
        searchResultsFullyOptionalNullData,
      );
      expect(result.searchResultsFullyOptional, isNull);
    });

    test('searchResultsFullyOptional deserialize empty list', () {
      final result = GetSearchResultsFullyOptionalResponse.fromJson(
        searchResultsFullyOptionalEmptyData,
      );
      expect(result.searchResultsFullyOptional, []);
    });

    test('searchResultsFullyOptional toJson', () {
      final initial = GetSearchResultsFullyOptionalResponse.fromJson(
        searchResultsFullyOptionalData,
      );
      final json = initial.toJson();
      expect(json, searchResultsFullyOptionalData);
    });

    test('searchResultsFullyOptional toJson null', () {
      final initial = GetSearchResultsFullyOptionalResponse.fromJson(
        searchResultsFullyOptionalNullData,
      );
      final json = initial.toJson();
      expect(json, searchResultsFullyOptionalNullData);
    });

    test('searchResultsFullyOptional equals', () {
      final result1 = GetSearchResultsFullyOptionalResponse.fromJson(
        searchResultsFullyOptionalData,
      );
      final result2 = GetSearchResultsFullyOptionalResponse.fromJson(
        searchResultsFullyOptionalData,
      );
      final result3 = GetSearchResultsFullyOptionalResponse.fromJson(
        searchResultsFullyOptionalNullData,
      );

      expect(result1, equals(result2));
      expect(result1, isNot(equals(result3)));
    });

    test(
      'searchResultsFullyOptional cacheNormalization - null to some',
      () async {
        final ctx = ShalomCtx.withCapacity();
        var (
          result,
          updateCtx,
        ) = GetSearchResultsFullyOptionalResponse.fromJson(
          searchResultsFullyOptionalNullData,
          ctx,
        );

        expect(result.searchResultsFullyOptional, isNull);

        final hasChanged = Completer<bool>();

        final sub = ctx.subscribe(updateCtx.dependantRecords);
        sub.streamController.stream.listen((newCtx) {
          result = GetSearchResultsFullyOptionalResponse.fromCache(newCtx);
          hasChanged.complete(true);
        });

        final nextResult = GetSearchResultsFullyOptionalResponse.fromJson(
          searchResultsFullyOptionalData,
          ctx: ctx,
        );

        await hasChanged.future.timeout(Duration(seconds: 1));
        expect(result, equals(nextResult));
        expect(result.searchResultsFullyOptional?.length, 2);
      },
    );

    test(
      'searchResultsFullyOptional cacheNormalization - some to null',
      () async {
        final ctx = ShalomCtx.withCapacity();
        var (
          result,
          updateCtx,
        ) = GetSearchResultsFullyOptionalResponse.fromJson(
          searchResultsFullyOptionalData,
          ctx,
        );

        expect(result.searchResultsFullyOptional, isNotNull);

        final hasChanged = Completer<bool>();

        final sub = ctx.subscribe(updateCtx.dependantRecords);
        sub.streamController.stream.listen((newCtx) {
          result = GetSearchResultsFullyOptionalResponse.fromCache(newCtx);
          hasChanged.complete(true);
        });

        final nextResult = GetSearchResultsFullyOptionalResponse.fromJson(
          searchResultsFullyOptionalNullData,
          ctx: ctx,
        );

        await hasChanged.future.timeout(Duration(seconds: 1));
        expect(result, equals(nextResult));
        expect(result.searchResultsFullyOptional, isNull);
      },
    );

    test(
      'searchResultsFullyOptional cacheNormalization - some to some',
      () async {
        final ctx = ShalomCtx.withCapacity();
        var (
          result,
          updateCtx,
        ) = GetSearchResultsFullyOptionalResponse.fromJson(
          searchResultsFullyOptionalData,
          ctx,
        );

        final hasChanged = Completer<bool>();

        final sub = ctx.subscribe(updateCtx.dependantRecords);
        sub.streamController.stream.listen((newCtx) {
          result = GetSearchResultsFullyOptionalResponse.fromCache(newCtx);
          hasChanged.complete(true);
        });

        final nextResult = GetSearchResultsFullyOptionalResponse.fromJson(
          searchResultsFullyOptionalDataChanged,
          ctx: ctx,
        );

        await hasChanged.future.timeout(Duration(seconds: 1));
        expect(result, equals(nextResult));
        final comment = result.searchResultsFullyOptional?[0]
            as GetSearchResultsFullyOptional_searchResultsFullyOptional__Comment;
        expect(comment.text, "Hello Modified");
      },
    );
  });
}
