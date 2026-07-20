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
      final result = GetSearchResultsRequiredData.fromJson(
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
      final result = GetSearchResultsRequiredData.fromJson(
        searchResultsRequiredEmptyData,
      );
      expect(result.searchResultsRequired, []);
    });

    test('searchResultsRequired toJson', () {
      final initial = GetSearchResultsRequiredData.fromJson(
        searchResultsRequiredData,
      );
      final json = initial.toJson();
      expect(json, searchResultsRequiredData);
    });

    test('searchResultsRequired toJson empty list', () {
      final initial = GetSearchResultsRequiredData.fromJson(
        searchResultsRequiredEmptyData,
      );
      final json = initial.toJson();
      expect(json, searchResultsRequiredEmptyData);
    });

    test('searchResultsRequired equals', () {
      final result1 = GetSearchResultsRequiredData.fromJson(
        searchResultsRequiredData,
      );
      final result2 = GetSearchResultsRequiredData.fromJson(
        searchResultsRequiredData,
      );
      final result3 = GetSearchResultsRequiredData.fromJson(
        searchResultsRequiredDataChanged,
      );

      expect(result1, equals(result2));
      expect(result1, isNot(equals(result3)));
    });
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
      final result = GetSearchResultsOptionalData.fromJson(
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
      final result = GetSearchResultsOptionalData.fromJson(
        searchResultsOptionalNullData,
      );
      expect(result.searchResultsOptional, isNull);
    });

    test('searchResultsOptional deserialize empty list', () {
      final result = GetSearchResultsOptionalData.fromJson(
        searchResultsOptionalEmptyData,
      );
      expect(result.searchResultsOptional, []);
    });

    test('searchResultsOptional toJson', () {
      final initial = GetSearchResultsOptionalData.fromJson(
        searchResultsOptionalData,
      );
      final json = initial.toJson();
      expect(json, searchResultsOptionalData);
    });

    test('searchResultsOptional toJson null', () {
      final initial = GetSearchResultsOptionalData.fromJson(
        searchResultsOptionalNullData,
      );
      final json = initial.toJson();
      expect(json, searchResultsOptionalNullData);
    });

    test('searchResultsOptional toJson empty list', () {
      final initial = GetSearchResultsOptionalData.fromJson(
        searchResultsOptionalEmptyData,
      );
      final json = initial.toJson();
      expect(json, searchResultsOptionalEmptyData);
    });

    test('searchResultsOptional equals', () {
      final result1 = GetSearchResultsOptionalData.fromJson(
        searchResultsOptionalData,
      );
      final result2 = GetSearchResultsOptionalData.fromJson(
        searchResultsOptionalData,
      );
      final result3 = GetSearchResultsOptionalData.fromJson(
        searchResultsOptionalNullData,
      );
      final result4 = GetSearchResultsOptionalData.fromJson(
        searchResultsOptionalNullData,
      );

      expect(result1, equals(result2));
      expect(result3, equals(result4));
      expect(result1, isNot(equals(result3)));
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
      final result = GetOptionalSearchResultsData.fromJson(
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
      final initial = GetOptionalSearchResultsData.fromJson(
        optionalSearchResultsData,
      );
      final json = initial.toJson();
      expect(json, optionalSearchResultsData);
    });

    test('optionalSearchResults equals', () {
      final result1 = GetOptionalSearchResultsData.fromJson(
        optionalSearchResultsData,
      );
      final result2 = GetOptionalSearchResultsData.fromJson(
        optionalSearchResultsData,
      );
      final result3 = GetOptionalSearchResultsData.fromJson(
        optionalSearchResultsDataChanged,
      );

      expect(result1, equals(result2));
      expect(result1, isNot(equals(result3)));
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
      final result = GetSearchResultsFullyOptionalData.fromJson(
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
      final result = GetSearchResultsFullyOptionalData.fromJson(
        searchResultsFullyOptionalNullData,
      );
      expect(result.searchResultsFullyOptional, isNull);
    });

    test('searchResultsFullyOptional deserialize empty list', () {
      final result = GetSearchResultsFullyOptionalData.fromJson(
        searchResultsFullyOptionalEmptyData,
      );
      expect(result.searchResultsFullyOptional, []);
    });

    test('searchResultsFullyOptional toJson', () {
      final initial = GetSearchResultsFullyOptionalData.fromJson(
        searchResultsFullyOptionalData,
      );
      final json = initial.toJson();
      expect(json, searchResultsFullyOptionalData);
    });

    test('searchResultsFullyOptional toJson null', () {
      final initial = GetSearchResultsFullyOptionalData.fromJson(
        searchResultsFullyOptionalNullData,
      );
      final json = initial.toJson();
      expect(json, searchResultsFullyOptionalNullData);
    });

    test('searchResultsFullyOptional equals', () {
      final result1 = GetSearchResultsFullyOptionalData.fromJson(
        searchResultsFullyOptionalData,
      );
      final result2 = GetSearchResultsFullyOptionalData.fromJson(
        searchResultsFullyOptionalData,
      );
      final result3 = GetSearchResultsFullyOptionalData.fromJson(
        searchResultsFullyOptionalNullData,
      );

      expect(result1, equals(result2));
      expect(result1, isNot(equals(result3)));
    });
  });
}
