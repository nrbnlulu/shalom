import "dart:async";

import "package:shalom_core/shalom_core.dart";
import 'package:test/test.dart';
import "__graphql__/GetSearchResult.shalom.dart";
import "__graphql__/GetSearchResultOpt.shalom.dart";
import "__graphql__/GetSearchResultWithoutTopTypename.shalom.dart";

void main() {
  final userSearchData = {
    "search": {
      "__typename": "User",
      "id": "user1",
      "name": "John Doe",
      "email": "john@example.com"
    }
  };

  final postSearchData = {
    "search": {
      "__typename": "Post",
      "id": "post1",
      "title": "Hello World",
      "content": "This is a test post",
      "author": "Jane Doe"
    }
  };

  final commentSearchData = {
    "search": {
      "__typename": "Comment",
      "id": "comment1",
      "text": "Great post!",
      "author": "Bob Smith"
    }
  };

  group('Test union selection - required', () {
    test('deserialize User', () {
      final variables = GetSearchResultVariables(query: "test");
      final result = GetSearchResultResponse.fromResponse(userSearchData,
          variables: variables);

      expect(result.search, isA<GetSearchResult_search_User>());
      final user = result.search as GetSearchResult_search_User;
      expect(user.id, "user1");
      expect(user.name, "John Doe");
      expect(user.email, "john@example.com");
      expect(user.typename, "User");
    });

    test('deserialize Post', () {
      final variables = GetSearchResultVariables(query: "test");
      final result = GetSearchResultResponse.fromResponse(postSearchData,
          variables: variables);

      expect(result.search, isA<GetSearchResult_search_Post>());
      final post = result.search as GetSearchResult_search_Post;
      expect(post.id, "post1");
      expect(post.title, "Hello World");
      expect(post.content, "This is a test post");
      expect(post.author, "Jane Doe");
      expect(post.typename, "Post");
    });

    test('deserialize Comment', () {
      final variables = GetSearchResultVariables(query: "test");
      final result = GetSearchResultResponse.fromResponse(commentSearchData,
          variables: variables);

      expect(result.search, isA<GetSearchResult_search_Comment>());
      final comment = result.search as GetSearchResult_search_Comment;
      expect(comment.id, "comment1");
      expect(comment.text, "Great post!");
      expect(comment.author, "Bob Smith");
      expect(comment.typename, "Comment");
    });

    test('serialize User', () {
      final variables = GetSearchResultVariables(query: "test");
      final initial = GetSearchResultResponse.fromResponse(userSearchData,
          variables: variables);
      final json = initial.toJson();
      expect(json, userSearchData);
    });

    test('serialize Post', () {
      final variables = GetSearchResultVariables(query: "test");
      final initial = GetSearchResultResponse.fromResponse(postSearchData,
          variables: variables);
      final json = initial.toJson();
      expect(json, postSearchData);
    });

    test('equals User', () {
      final variables = GetSearchResultVariables(query: "test");
      final result1 = GetSearchResultResponse.fromResponse(userSearchData,
          variables: variables);
      final result2 = GetSearchResultResponse.fromResponse(userSearchData,
          variables: variables);
      expect(result1, equals(result2));
    });

    test('equals Post', () {
      final variables = GetSearchResultVariables(query: "test");
      final result1 = GetSearchResultResponse.fromResponse(postSearchData,
          variables: variables);
      final result2 = GetSearchResultResponse.fromResponse(postSearchData,
          variables: variables);
      expect(result1, equals(result2));
    });

    test('not equals different types', () {
      final variables = GetSearchResultVariables(query: "test");
      final result1 = GetSearchResultResponse.fromResponse(userSearchData,
          variables: variables);
      final result2 = GetSearchResultResponse.fromResponse(postSearchData,
          variables: variables);
      expect(result1, isNot(equals(result2)));
    });
  });

  final userSearchOptData = {
    "searchOpt": {
      "__typename": "User",
      "id": "user2",
      "name": "Alice Smith",
      "email": "alice@example.com"
    }
  };

  final searchOptNullData = {"searchOpt": null};

  group('Test union selection - optional', () {
    test('deserialize User', () {
      final variables = GetSearchResultOptVariables(query: "test");
      final result = GetSearchResultOptResponse.fromResponse(userSearchOptData,
          variables: variables);

      expect(result.searchOpt, isNotNull);
      expect(result.searchOpt, isA<GetSearchResultOpt_searchOpt_User>());
      final user = result.searchOpt as GetSearchResultOpt_searchOpt_User;
      expect(user.id, "user2");
      expect(user.name, "Alice Smith");
      expect(user.email, "alice@example.com");
    });

    test('deserialize null', () {
      final variables = GetSearchResultOptVariables(query: "test");
      final result = GetSearchResultOptResponse.fromResponse(searchOptNullData,
          variables: variables);
      expect(result.searchOpt, isNull);
    });

    test('serialize with value', () {
      final variables = GetSearchResultOptVariables(query: "test");
      final initial = GetSearchResultOptResponse.fromResponse(userSearchOptData,
          variables: variables);
      final json = initial.toJson();
      expect(json, userSearchOptData);
    });

    test('serialize null', () {
      final variables = GetSearchResultOptVariables(query: "test");
      final initial = GetSearchResultOptResponse.fromResponse(searchOptNullData,
          variables: variables);
      final json = initial.toJson();
      expect(json, searchOptNullData);
    });
  });

  group('Test union selection - __typename in fragments', () {
    test('deserialize with __typename in fragments', () {
      final variables =
          GetSearchResultWithoutTopTypenameVariables(query: "test");
      final result = GetSearchResultWithoutTopTypenameResponse.fromResponse(
          userSearchData,
          variables: variables);

      expect(
          result.search, isA<GetSearchResultWithoutTopTypename_search_User>());
      final user =
          result.search as GetSearchResultWithoutTopTypename_search_User;
      expect(user.typename, "User");
      expect(user.id, "user1");
    });
  });

  group('cacheNormalization', () {
    test('User to Post', () async {
      final ctx = ShalomCtx.withCapacity();
      final variables = GetSearchResultVariables(query: "test");

      var (result, updateCtx) = GetSearchResultResponse.fromResponseImpl(
        userSearchData,
        ctx,
        variables,
      );

      expect(result.search, isA<GetSearchResult_search_User>());

      final hasChanged = Completer<bool>();
      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetSearchResultResponse.fromCache(newCtx, variables);
        hasChanged.complete(true);
      });

      final nextResult = GetSearchResultResponse.fromResponse(
        postSearchData,
        ctx: ctx,
        variables: variables,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.search, isA<GetSearchResult_search_Post>());
    });

    test('Post to Comment', () async {
      final ctx = ShalomCtx.withCapacity();
      final variables = GetSearchResultVariables(query: "test");

      var (result, updateCtx) = GetSearchResultResponse.fromResponseImpl(
        postSearchData,
        ctx,
        variables,
      );

      expect(result.search, isA<GetSearchResult_search_Post>());

      final hasChanged = Completer<bool>();
      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetSearchResultResponse.fromCache(newCtx, variables);
        hasChanged.complete(true);
      });

      final nextResult = GetSearchResultResponse.fromResponse(
        commentSearchData,
        ctx: ctx,
        variables: variables,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.search, isA<GetSearchResult_search_Comment>());
    });

    test('optional - null to User', () async {
      final ctx = ShalomCtx.withCapacity();
      final variables = GetSearchResultOptVariables(query: "test");

      var (result, updateCtx) = GetSearchResultOptResponse.fromResponseImpl(
        searchOptNullData,
        ctx,
        variables,
      );

      expect(result.searchOpt, isNull);

      final hasChanged = Completer<bool>();
      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetSearchResultOptResponse.fromCache(newCtx, variables);
        hasChanged.complete(true);
      });

      final nextResult = GetSearchResultOptResponse.fromResponse(
        userSearchOptData,
        ctx: ctx,
        variables: variables,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.searchOpt, isNotNull);
    });

    test('optional - User to null', () async {
      final ctx = ShalomCtx.withCapacity();
      final variables = GetSearchResultOptVariables(query: "test");

      var (result, updateCtx) = GetSearchResultOptResponse.fromResponseImpl(
        userSearchOptData,
        ctx,
        variables,
      );

      expect(result.searchOpt, isNotNull);

      final hasChanged = Completer<bool>();
      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetSearchResultOptResponse.fromCache(newCtx, variables);
        hasChanged.complete(true);
      });

      final nextResult = GetSearchResultOptResponse.fromResponse(
        searchOptNullData,
        ctx: ctx,
        variables: variables,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.searchOpt, isNull);
    });
  });
}
