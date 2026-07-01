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
      final result = GetUsersRequiredWithFragmentResponse.fromJson(
        usersRequiredFragmentData,
      );
      expect(result.usersRequired.length, 3);
      expect(result.usersRequired[0].id, "1");
      expect(result.usersRequired[0].name, "Alice");
      expect(result.usersRequired[0].email, "alice@example.com");
      expect(result.usersRequired[1].id, "2");
      expect(result.usersRequired[1].name, "Bob");
    });

    test('listFragmentRequired - deserialize empty list', () {
      final result = GetUsersRequiredWithFragmentResponse.fromJson(
        usersRequiredFragmentEmptyData,
      );
      expect(result.usersRequired, []);
    });

    test('listFragmentRequired - toJson', () {
      final initial = GetUsersRequiredWithFragmentResponse.fromJson(
        usersRequiredFragmentData,
      );
      final json = initial.toJson();
      expect(json, usersRequiredFragmentData);
    });

    test('listFragmentRequired - toJson with empty list', () {
      final initial = GetUsersRequiredWithFragmentResponse.fromJson(
        usersRequiredFragmentEmptyData,
      );
      final json = initial.toJson();
      expect(json, usersRequiredFragmentEmptyData);
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
      final result = GetUsersOptionalWithFragmentResponse.fromJson(
        usersOptionalFragmentData,
      );
      expect(result.usersOptional?.length, 2);
      expect(result.usersOptional?[0].id, "1");
      expect(result.usersOptional?[0].name, "Alice");
    });

    test('listFragmentOptional - deserialize null list', () {
      final result = GetUsersOptionalWithFragmentResponse.fromJson(
        usersOptionalFragmentNullData,
      );
      expect(result.usersOptional, isNull);
    });

    test('listFragmentOptional - deserialize empty list', () {
      final result = GetUsersOptionalWithFragmentResponse.fromJson(
        usersOptionalFragmentEmptyData,
      );
      expect(result.usersOptional, []);
    });

    test('listFragmentOptional - toJson', () {
      final initial = GetUsersOptionalWithFragmentResponse.fromJson(
        usersOptionalFragmentData,
      );
      final json = initial.toJson();
      expect(json, usersOptionalFragmentData);
    });

    test('listFragmentOptional - toJson with null', () {
      final initial = GetUsersOptionalWithFragmentResponse.fromJson(
        usersOptionalFragmentNullData,
      );
      final json = initial.toJson();
      expect(json, usersOptionalFragmentNullData);
    });
  });

  final usersMultipleFragmentsData = {
    "usersRequired": [
      {
        "id": "1",
        "name": "Alice",
        "email": "alice@example.com",
        "bio": "Software Engineer",
        "age": 30,
      },
      {
        "id": "2",
        "name": "Bob",
        "email": "bob@example.com",
        "bio": "Designer",
        "age": 25,
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
        "age": 31,
      },
      {
        "id": "2",
        "name": "Bob",
        "email": "bob@example.com",
        "bio": "Designer",
        "age": 25,
      },
    ],
  };

  group('List of Fragments - Multiple Fragments', () {
    test('multipleFragmentsRequired - deserialize', () {
      final result = GetUsersRequiredWithMultipleFragmentsResponse.fromJson(
        usersMultipleFragmentsData,
      );
      expect(result.usersRequired.length, 2);
      expect(result.usersRequired[0].id, "1");
      expect(result.usersRequired[0].name, "Alice");
      expect(result.usersRequired[0].email, "alice@example.com");
      expect(result.usersRequired[0].bio, "Software Engineer");
      expect(result.usersRequired[0].age, 30);
    });

    test('multipleFragmentsRequired - toJson', () {
      final initial = GetUsersRequiredWithMultipleFragmentsResponse.fromJson(
        usersMultipleFragmentsData,
      );
      final json = initial.toJson();
      expect(json, usersMultipleFragmentsData);
    });
  });

  final usersFragmentAndFieldsData = {
    "usersRequired": [
      {
        "id": "1",
        "name": "Alice",
        "email": "alice@example.com",
        "age": 30,
        "bio": "Developer",
      },
      {
        "id": "2",
        "name": "Bob",
        "email": "bob@example.com",
        "age": 25,
        "bio": "Designer",
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
        "bio": "Senior Developer",
      },
      {
        "id": "2",
        "name": "Bob",
        "email": "bob@example.com",
        "age": 25,
        "bio": "Designer",
      },
    ],
  };

  group('List of Fragments - Fragment with Additional Fields', () {
    test('fragmentWithFieldsRequired - deserialize', () {
      final result = GetUsersRequiredWithFragmentAndFieldsResponse.fromJson(
        usersFragmentAndFieldsData,
      );
      expect(result.usersRequired.length, 2);
      expect(result.usersRequired[0].id, "1");
      expect(result.usersRequired[0].name, "Alice");
      expect(result.usersRequired[0].email, "alice@example.com");
      expect(result.usersRequired[0].age, 30);
      expect(result.usersRequired[0].bio, "Developer");
    });

    test('fragmentWithFieldsRequired - toJson', () {
      final initial = GetUsersRequiredWithFragmentAndFieldsResponse.fromJson(
        usersFragmentAndFieldsData,
      );
      final json = initial.toJson();
      expect(json, usersFragmentAndFieldsData);
    });
  });

  final postsWithAuthorFragmentData = {
    "posts": [
      {
        "id": "post1",
        "title": "GraphQL Guide",
        "published": true,
        "author": {"id": "1", "name": "Alice", "email": "alice@example.com"},
      },
      {
        "id": "post2",
        "title": "Dart Tips",
        "published": false,
        "author": {"id": "2", "name": "Bob", "email": "bob@example.com"},
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
          "email": "alice@example.com",
        },
      },
      {
        "id": "post2",
        "title": "Dart Tips",
        "published": false,
        "author": {"id": "2", "name": "Bob", "email": "bob@example.com"},
      },
    ],
  };

  group('List of Fragments - Nested Object with Fragment', () {
    test('nestedFragmentRequired - deserialize', () {
      final result = GetPostsWithAuthorFragmentResponse.fromJson(
        postsWithAuthorFragmentData,
      );
      expect(result.posts.length, 2);
      expect(result.posts[0].id, "post1");
      expect(result.posts[0].title, "GraphQL Guide");
      expect(result.posts[0].published, true);
      expect(result.posts[0].author.id, "1");
      expect(result.posts[0].author.name, "Alice");
      expect(result.posts[0].author.email, "alice@example.com");
    });

    test('nestedFragmentRequired - toJson', () {
      final initial = GetPostsWithAuthorFragmentResponse.fromJson(
        postsWithAuthorFragmentData,
      );
      final json = initial.toJson();
      expect(json, postsWithAuthorFragmentData);
    });
  });

  final postsOptionalMultipleFragmentsData = {
    "postsOptional": [
      {
        "id": "post1",
        "title": "GraphQL Basics",
        "published": true,
        "content": "Content 1",
        "tags": ["graphql", "basics"],
      },
      {
        "id": "post2",
        "title": "Advanced Topics",
        "published": false,
        "content": "Content 2",
        "tags": ["advanced", "topics"],
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
        "tags": ["graphql", "basics", "updated"],
      },
      {
        "id": "post2",
        "title": "Advanced Topics",
        "published": false,
        "content": "Content 2",
        "tags": ["advanced", "topics"],
      },
    ],
  };

  final postsOptionalMultipleFragmentsNullData = {"postsOptional": null};

  group('List of Fragments - Optional List with Multiple Fragments', () {
    test('optionalMultipleFragments - deserialize', () {
      final result = GetPostsOptionalWithMultipleFragmentsResponse.fromJson(
        postsOptionalMultipleFragmentsData,
      );
      expect(result.postsOptional?.length, 2);
      expect(result.postsOptional?[0].id, "post1");
      expect(result.postsOptional?[0].title, "GraphQL Basics");
      expect(result.postsOptional?[0].published, true);
      expect(result.postsOptional?[0].content, "Content 1");
      expect(result.postsOptional?[0].tags, ["graphql", "basics"]);
    });

    test('optionalMultipleFragments - deserialize null', () {
      final result = GetPostsOptionalWithMultipleFragmentsResponse.fromJson(
        postsOptionalMultipleFragmentsNullData,
      );
      expect(result.postsOptional, isNull);
    });

    test('optionalMultipleFragments - toJson', () {
      final initial = GetPostsOptionalWithMultipleFragmentsResponse.fromJson(
        postsOptionalMultipleFragmentsData,
      );
      final json = initial.toJson();
      expect(json, postsOptionalMultipleFragmentsData);
    });
  });

  group(
      'List of Fragments - Cache Normalization with Partial Selection', () {});
}
