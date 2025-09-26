import 'package:test/test.dart';
import 'package:shalom_core/shalom_core.dart';

import '__graphql__/GetUser.shalom.dart';
import '__graphql__/GetPosts.shalom.dart';

void main() {
  group('Fragment Tests', () {
    test('UserInfo fragment - Required fields', () {
      final userInfo = GetUser_user(
        id: "user1",
        name: "John Doe",
        email: "john@example.com",
      );

      expect(userInfo.id, equals("user1"));
      expect(userInfo.name, equals("John Doe"));
      expect(userInfo.email, equals("john@example.com"));
      expect(userInfo.age, isNull);
    });

    test('UserInfo fragment - Optional fields', () {
      final userInfo = GetUser_user(
        id: "user1",
        name: "John Doe",
        email: "john@example.com",
        age: 30,
      );

      expect(userInfo.age, equals(30));
    });

    test('UserInfo fragment - equals', () {
      final userInfo1 = GetUser_user(
        id: "user1",
        name: "John Doe",
        email: "john@example.com",
        age: 30,
      );

      final userInfo2 = GetUser_user(
        id: "user1",
        name: "John Doe",
        email: "john@example.com",
        age: 30,
      );

      final userInfo3 = GetUser_user(
        id: "user2",
        name: "John Doe",
        email: "john@example.com",
        age: 30,
      );

      expect(userInfo1, equals(userInfo2));
      expect(userInfo1, isNot(equals(userInfo3)));
    });

    test('UserInfo fragment - toJson', () {
      final userInfo = GetUser_user(
        id: "user1",
        name: "John Doe",
        email: "john@example.com",
        age: 30,
      );

      final json = userInfo.toJson();
      expect(json['id'], equals("user1"));
      expect(json['name'], equals("John Doe"));
      expect(json['email'], equals("john@example.com"));
      expect(json['age'], equals(30));
    });

    test('PostSummary fragment - Required fields', () {
      final postSummary = GetPosts_posts(
        id: "post1",
        title: "Test Post",
      );

      expect(postSummary.id, equals("post1"));
      expect(postSummary.title, equals("Test Post"));
      expect(postSummary.publishedAt, isNull);
    });

    test('PostSummary fragment - Optional fields', () {
      final postSummary = GetPosts_posts(
        id: "post1",
        title: "Test Post",
        publishedAt: "2023-01-01",
      );

      expect(postSummary.publishedAt, equals("2023-01-01"));
    });

    test('PostSummary fragment - equals', () {
      final post1 = GetPosts_posts(
        id: "post1",
        title: "Test Post",
        publishedAt: "2023-01-01",
      );

      final post2 = GetPosts_posts(
        id: "post1",
        title: "Test Post",
        publishedAt: "2023-01-01",
      );

      expect(post1, equals(post2));
    });

    test('PostSummary fragment - toJson', () {
      final postSummary = GetPosts_posts(
        id: "post1",
        title: "Test Post",
        publishedAt: "2023-01-01",
      );

      final json = postSummary.toJson();
      expect(json['id'], equals("post1"));
      expect(json['title'], equals("Test Post"));
      expect(json['publishedAt'], equals("2023-01-01"));
    });
  });
}
