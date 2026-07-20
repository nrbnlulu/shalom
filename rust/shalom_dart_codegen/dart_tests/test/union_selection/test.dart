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
      "email": "john@example.com",
    },
  };

  final postSearchData = {
    "search": {
      "__typename": "Post",
      "id": "post1",
      "title": "Hello World",
      "content": "This is a test post",
      "author": "Jane Doe",
    },
  };

  final commentSearchData = {
    "search": {
      "__typename": "Comment",
      "id": "comment1",
      "text": "Great post!",
      "author": "Bob Smith",
    },
  };

  group('Test union selection - required', () {
    test('deserialize User', () {
      final variables = GetSearchResultVariables(query: "test");
      final result = GetSearchResultData.fromJson(
        userSearchData,
      );

      expect(result.search, isA<GetSearchResult_search__User>());
      final user = result.search as GetSearchResult_search__User;
      expect(user.id, "user1");
      expect(user.name, "John Doe");
      expect(user.email, "john@example.com");
      expect(user.$__typename, "User");
    });

    test('deserialize Post', () {
      final variables = GetSearchResultVariables(query: "test");
      final result = GetSearchResultData.fromJson(
        postSearchData,
      );

      expect(result.search, isA<GetSearchResult_search__Post>());
      final post = result.search as GetSearchResult_search__Post;
      expect(post.id, "post1");
      expect(post.title, "Hello World");
      expect(post.content, "This is a test post");
      expect(post.author, "Jane Doe");
      expect(post.$__typename, "Post");
    });

    test('deserialize Comment', () {
      final variables = GetSearchResultVariables(query: "test");
      final result = GetSearchResultData.fromJson(
        commentSearchData,
      );

      expect(result.search, isA<GetSearchResult_search__Comment>());
      final comment = result.search as GetSearchResult_search__Comment;
      expect(comment.id, "comment1");
      expect(comment.text, "Great post!");
      expect(comment.author, "Bob Smith");
      expect(comment.$__typename, "Comment");
    });

    test('serialize User', () {
      final variables = GetSearchResultVariables(query: "test");
      final initial = GetSearchResultData.fromJson(
        userSearchData,
      );
      final json = initial.toJson();
      expect(json, userSearchData);
    });

    test('serialize Post', () {
      final variables = GetSearchResultVariables(query: "test");
      final initial = GetSearchResultData.fromJson(
        postSearchData,
      );
      final json = initial.toJson();
      expect(json, postSearchData);
    });

    test('equals User', () {
      final variables = GetSearchResultVariables(query: "test");
      final result1 = GetSearchResultData.fromJson(
        userSearchData,
      );
      final result2 = GetSearchResultData.fromJson(
        userSearchData,
      );
      expect(result1, equals(result2));
    });

    test('equals Post', () {
      final variables = GetSearchResultVariables(query: "test");
      final result1 = GetSearchResultData.fromJson(
        postSearchData,
      );
      final result2 = GetSearchResultData.fromJson(
        postSearchData,
      );
      expect(result1, equals(result2));
    });

    test('not equals different types', () {
      final variables = GetSearchResultVariables(query: "test");
      final result1 = GetSearchResultData.fromJson(
        userSearchData,
      );
      final result2 = GetSearchResultData.fromJson(
        postSearchData,
      );
      expect(result1, isNot(equals(result2)));
    });
  });

  final userSearchOptData = {
    "searchOpt": {
      "__typename": "User",
      "id": "user2",
      "name": "Alice Smith",
      "email": "alice@example.com",
    },
  };

  final searchOptNullData = {"searchOpt": null};

  group('Test union selection - optional', () {
    test('deserialize User', () {
      final variables = GetSearchResultOptVariables(query: "test");
      final result = GetSearchResultOptData.fromJson(
        userSearchOptData,
      );

      expect(result.searchOpt, isNotNull);
      expect(result.searchOpt, isA<GetSearchResultOpt_searchOpt__User>());
      final user = result.searchOpt as GetSearchResultOpt_searchOpt__User;
      expect(user.id, "user2");
      expect(user.name, "Alice Smith");
      expect(user.email, "alice@example.com");
    });

    test('deserialize null', () {
      final variables = GetSearchResultOptVariables(query: "test");
      final result = GetSearchResultOptData.fromJson(
        searchOptNullData,
      );
      expect(result.searchOpt, isNull);
    });

    test('serialize with value', () {
      final variables = GetSearchResultOptVariables(query: "test");
      final initial = GetSearchResultOptData.fromJson(
        userSearchOptData,
      );
      final json = initial.toJson();
      expect(json, userSearchOptData);
    });

    test('serialize null', () {
      final variables = GetSearchResultOptVariables(query: "test");
      final initial = GetSearchResultOptData.fromJson(
        searchOptNullData,
      );
      final json = initial.toJson();
      expect(json, searchOptNullData);
    });
  });

  group('Test union selection - __typename in fragments', () {
    test('deserialize with __typename in fragments', () {
      final variables = GetSearchResultWithoutTopTypenameVariables(
        query: "test",
      );
      final result = GetSearchResultWithoutTopTypenameData.fromJson(
        userSearchData,
      );

      expect(
        result.search,
        isA<GetSearchResultWithoutTopTypename_search__User>(),
      );
      final user =
          result.search as GetSearchResultWithoutTopTypename_search__User;
      expect(
        GetSearchResultWithoutTopTypename_search__User.G__typename,
        "User",
      );
      expect(user.id, "user1");
    });
  });
}
