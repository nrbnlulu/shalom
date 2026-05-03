import "dart:async";

import "package:shalom/shalom.dart";
import 'package:test/test.dart';
import "__graphql__/ListofScalarsRequired.shalom.dart";
import "__graphql__/ListOfScalarsOptional.shalom.dart";
import "__graphql__/ListOfOptionalScalarsOptional.shalom.dart";

void main() {
  group('List of Scalars Required', () {
    final listOfScalarsRequiredData = {
      'listOfScalarsRequired': ['hello', 'world', 'test'],
    };
    final listOfScalarsRequiredDataChanged = {
      'listOfScalarsRequired': ['foo', 'bar', 'baz'],
    };
    final listOfScalarsRequiredEmptyData = {'listOfScalarsRequired': []};

    test('listOfScalarsRequired deserialize', () {
      final result = ListofScalarsRequiredResponse.fromJson(
        listOfScalarsRequiredData,
      );
      expect(result.listOfScalarsRequired, ['hello', 'world', 'test']);
    });

    test('listOfScalarsRequired deserialize with empty list', () {
      final result = ListofScalarsRequiredResponse.fromJson(
        listOfScalarsRequiredEmptyData,
      );
      expect(result.listOfScalarsRequired, []);
    });

    test('listOfScalarsRequired toJson', () {
      final initial = ListofScalarsRequiredResponse.fromJson(
        listOfScalarsRequiredData,
      );
      final json = initial.toJson();
      expect(json, listOfScalarsRequiredData);
    });

    test('listOfScalarsRequired toJson with empty list', () {
      final initial = ListofScalarsRequiredResponse.fromJson(
        listOfScalarsRequiredEmptyData,
      );
      final json = initial.toJson();
      expect(json, listOfScalarsRequiredEmptyData);
    });

    test('listOfScalarsRequired cacheNormalization', () async {
      final ctx = ShalomCtx.withCapacity();
      var (result, updateCtx) = ListofScalarsRequiredResponse.fromJson(
        listOfScalarsRequiredData,
        ctx,
      );

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = ListofScalarsRequiredResponse.fromCache(newCtx);
        hasChanged.complete(true);
      });

      final nextResult = ListofScalarsRequiredResponse.fromJson(
        listOfScalarsRequiredDataChanged,
        ctx: ctx,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.listOfScalarsRequired, ['foo', 'bar', 'baz']);
    });

    test('listOfScalarsRequired equals', () {
      final ctx = ShalomCtx.withCapacity();
      final result1 = ListofScalarsRequiredResponse.fromJson(
        listOfScalarsRequiredData,
        ctx: ctx,
      );
      final result2 = ListofScalarsRequiredResponse.fromJson(
        listOfScalarsRequiredData,
        ctx: ctx,
      );
      final result3 = ListofScalarsRequiredResponse.fromJson(
        listOfScalarsRequiredDataChanged,
        ctx: ctx,
      );

      expect(result1, equals(result2));
      expect(result1, isNot(equals(result3)));
    });
  });

  group('List of Scalars Optional', () {
    final listOfScalarsOptionalData = {
      'listOfScalarsOptional': ['hello', 'world', 'test'],
    };
    final listOfScalarsOptionalDataChanged = {
      'listOfScalarsOptional': ['foo', 'bar', 'baz'],
    };
    final listOfScalarsOptionalNullData = {'listOfScalarsOptional': null};
    final listOfScalarsOptionalEmptyData = {'listOfScalarsOptional': []};

    test('listOfScalarsOptional deserialize', () {
      final result = ListOfScalarsOptionalResponse.fromJson(
        listOfScalarsOptionalData,
      );
      expect(result.listOfScalarsOptional, ['hello', 'world', 'test']);
    });

    test('listOfScalarsOptional deserialize with null', () {
      final result = ListOfScalarsOptionalResponse.fromJson(
        listOfScalarsOptionalNullData,
      );
      expect(result.listOfScalarsOptional, isNull);
    });

    test('listOfScalarsOptional deserialize with empty list', () {
      final result = ListOfScalarsOptionalResponse.fromJson(
        listOfScalarsOptionalEmptyData,
      );
      expect(result.listOfScalarsOptional, []);
    });

    test('listOfScalarsOptional toJson', () {
      final initial = ListOfScalarsOptionalResponse.fromJson(
        listOfScalarsOptionalData,
      );
      final json = initial.toJson();
      expect(json, listOfScalarsOptionalData);
    });

    test('listOfScalarsOptional toJson with null', () {
      final initial = ListOfScalarsOptionalResponse.fromJson(
        listOfScalarsOptionalNullData,
      );
      final json = initial.toJson();
      expect(json, listOfScalarsOptionalNullData);
    });

    test('listOfScalarsOptional toJson with empty list', () {
      final initial = ListOfScalarsOptionalResponse.fromJson(
        listOfScalarsOptionalEmptyData,
      );
      final json = initial.toJson();
      expect(json, listOfScalarsOptionalEmptyData);
    });

    test('listOfScalarsOptional cacheNormalization', () async {
      final ctx = ShalomCtx.withCapacity();
      var (result, updateCtx) = ListOfScalarsOptionalResponse.fromJson(
        listOfScalarsOptionalData,
        ctx,
      );

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = ListOfScalarsOptionalResponse.fromCache(newCtx);
        hasChanged.complete(true);
      });

      final nextResult = ListOfScalarsOptionalResponse.fromJson(
        listOfScalarsOptionalDataChanged,
        ctx: ctx,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.listOfScalarsOptional, ['foo', 'bar', 'baz']);
    });

    test('listOfScalarsOptional equals', () {
      final ctx = ShalomCtx.withCapacity();
      final result1 = ListOfScalarsOptionalResponse.fromJson(
        listOfScalarsOptionalData,
        ctx: ctx,
      );
      final result2 = ListOfScalarsOptionalResponse.fromJson(
        listOfScalarsOptionalData,
        ctx: ctx,
      );
      final result3 = ListOfScalarsOptionalResponse.fromJson(
        listOfScalarsOptionalNullData,
        ctx: ctx,
      );
      final result4 = ListOfScalarsOptionalResponse.fromJson(
        listOfScalarsOptionalNullData,
        ctx: ctx,
      );

      expect(result1, equals(result2));
      expect(result3, equals(result4));
      expect(result1, isNot(equals(result3)));
    });
  });

  group('List of Optional Scalars Optional', () {
    final listOfOptionalScalarsOptionalData = {
      'listOfOptionalScalarsOptional': [1, 2, 3],
    };
    final listOfOptionalScalarsOptionalDataChanged = {
      'listOfOptionalScalarsOptional': [4, 5, 6],
    };
    final listOfOptionalScalarsOptionalNullData = {
      'listOfOptionalScalarsOptional': null,
    };
    final listOfOptionalScalarsOptionalEmptyData = {
      'listOfOptionalScalarsOptional': [],
    };

    test('listOfOptionalScalarsOptional deserialize', () {
      final result = ListOfOptionalScalarsOptionalResponse.fromJson(
        listOfOptionalScalarsOptionalData,
      );
      expect(result.listOfOptionalScalarsOptional, [1, 2, 3]);
    });

    test('listOfOptionalScalarsOptional deserialize with null', () {
      final result = ListOfOptionalScalarsOptionalResponse.fromJson(
        listOfOptionalScalarsOptionalNullData,
      );
      expect(result.listOfOptionalScalarsOptional, isNull);
    });

    test('listOfOptionalScalarsOptional deserialize with empty list', () {
      final result = ListOfOptionalScalarsOptionalResponse.fromJson(
        listOfOptionalScalarsOptionalEmptyData,
      );
      expect(result.listOfOptionalScalarsOptional, []);
    });

    test('listOfOptionalScalarsOptional toJson', () {
      final initial = ListOfOptionalScalarsOptionalResponse.fromJson(
        listOfOptionalScalarsOptionalData,
      );
      final json = initial.toJson();
      expect(json, listOfOptionalScalarsOptionalData);
    });

    test('listOfOptionalScalarsOptional toJson with null', () {
      final initial = ListOfOptionalScalarsOptionalResponse.fromJson(
        listOfOptionalScalarsOptionalNullData,
      );
      final json = initial.toJson();
      expect(json, listOfOptionalScalarsOptionalNullData);
    });

    test('listOfOptionalScalarsOptional toJson with empty list', () {
      final initial = ListOfOptionalScalarsOptionalResponse.fromJson(
        listOfOptionalScalarsOptionalEmptyData,
      );
      final json = initial.toJson();
      expect(json, listOfOptionalScalarsOptionalEmptyData);
    });

    test('listOfOptionalScalarsOptional cacheNormalization', () async {
      final ctx = ShalomCtx.withCapacity();
      var (
        result,
        updateCtx,
      ) = ListOfOptionalScalarsOptionalResponse.fromJson(
        listOfOptionalScalarsOptionalData,
        ctx,
      );

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = ListOfOptionalScalarsOptionalResponse.fromCache(newCtx);
        hasChanged.complete(true);
      });

      final nextResult = ListOfOptionalScalarsOptionalResponse.fromJson(
        listOfOptionalScalarsOptionalDataChanged,
        ctx: ctx,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.listOfOptionalScalarsOptional, [4, 5, 6]);
    });

    test('listOfOptionalScalarsOptional equals', () {
      final ctx = ShalomCtx.withCapacity();
      final result1 = ListOfOptionalScalarsOptionalResponse.fromJson(
        listOfOptionalScalarsOptionalData,
        ctx: ctx,
      );
      final result2 = ListOfOptionalScalarsOptionalResponse.fromJson(
        listOfOptionalScalarsOptionalData,
        ctx: ctx,
      );
      final result3 = ListOfOptionalScalarsOptionalResponse.fromJson(
        listOfOptionalScalarsOptionalNullData,
        ctx: ctx,
      );
      final result4 = ListOfOptionalScalarsOptionalResponse.fromJson(
        listOfOptionalScalarsOptionalNullData,
        ctx: ctx,
      );

      expect(result1, equals(result2));
      expect(result3, equals(result4));
      expect(result1, isNot(equals(result3)));
    });
  });
}
