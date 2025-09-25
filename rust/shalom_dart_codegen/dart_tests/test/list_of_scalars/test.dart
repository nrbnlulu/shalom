import "dart:async";

import "package:shalom_core/shalom_core.dart";
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
      final result = ListofScalarsRequiredResponse.fromResponse(
        listOfScalarsRequiredData,
      );
      expect(result.listOfScalarsRequired, ['hello', 'world', 'test']);
    });

    test('listOfScalarsRequired deserialize with empty list', () {
      final result = ListofScalarsRequiredResponse.fromResponse(
        listOfScalarsRequiredEmptyData,
      );
      expect(result.listOfScalarsRequired, []);
    });

    test('listOfScalarsRequired toJson', () {
      final initial = ListofScalarsRequiredResponse.fromResponse(
        listOfScalarsRequiredData,
      );
      final json = initial.toJson();
      expect(json, listOfScalarsRequiredData);
    });

    test('listOfScalarsRequired toJson with empty list', () {
      final initial = ListofScalarsRequiredResponse.fromResponse(
        listOfScalarsRequiredEmptyData,
      );
      final json = initial.toJson();
      expect(json, listOfScalarsRequiredEmptyData);
    });

    test('listOfScalarsRequired cacheNormalization', () async {
      final ctx = ShalomCtx.withCapacity();
      var (result, updateCtx) = ListofScalarsRequiredResponse.fromResponseImpl(
        listOfScalarsRequiredData,
        ctx,
      );

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = ListofScalarsRequiredResponse.fromCache(newCtx);
        hasChanged.complete(true);
      });

      final nextResult = ListofScalarsRequiredResponse.fromResponse(
        listOfScalarsRequiredDataChanged,
        ctx: ctx,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.listOfScalarsRequired, ['foo', 'bar', 'baz']);
    });

    test('listOfScalarsRequired equals', () {
      final ctx = ShalomCtx.withCapacity();
      final result1 = ListofScalarsRequiredResponse.fromResponse(
        listOfScalarsRequiredData,
        ctx: ctx,
      );
      final result2 = ListofScalarsRequiredResponse.fromResponse(
        listOfScalarsRequiredData,
        ctx: ctx,
      );
      final result3 = ListofScalarsRequiredResponse.fromResponse(
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
      final result = ListOfScalarsOptionalResponse.fromResponse(
        listOfScalarsOptionalData,
      );
      expect(result.listOfScalarsOptional, ['hello', 'world', 'test']);
    });

    test('listOfScalarsOptional deserialize with null', () {
      final result = ListOfScalarsOptionalResponse.fromResponse(
        listOfScalarsOptionalNullData,
      );
      expect(result.listOfScalarsOptional, isNull);
    });

    test('listOfScalarsOptional deserialize with empty list', () {
      final result = ListOfScalarsOptionalResponse.fromResponse(
        listOfScalarsOptionalEmptyData,
      );
      expect(result.listOfScalarsOptional, []);
    });

    test('listOfScalarsOptional toJson', () {
      final initial = ListOfScalarsOptionalResponse.fromResponse(
        listOfScalarsOptionalData,
      );
      final json = initial.toJson();
      expect(json, listOfScalarsOptionalData);
    });

    test('listOfScalarsOptional toJson with null', () {
      final initial = ListOfScalarsOptionalResponse.fromResponse(
        listOfScalarsOptionalNullData,
      );
      final json = initial.toJson();
      expect(json, listOfScalarsOptionalNullData);
    });

    test('listOfScalarsOptional toJson with empty list', () {
      final initial = ListOfScalarsOptionalResponse.fromResponse(
        listOfScalarsOptionalEmptyData,
      );
      final json = initial.toJson();
      expect(json, listOfScalarsOptionalEmptyData);
    });

    test('listOfScalarsOptional cacheNormalization', () async {
      final ctx = ShalomCtx.withCapacity();
      var (result, updateCtx) = ListOfScalarsOptionalResponse.fromResponseImpl(
        listOfScalarsOptionalData,
        ctx,
      );

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = ListOfScalarsOptionalResponse.fromCache(newCtx);
        hasChanged.complete(true);
      });

      final nextResult = ListOfScalarsOptionalResponse.fromResponse(
        listOfScalarsOptionalDataChanged,
        ctx: ctx,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.listOfScalarsOptional, ['foo', 'bar', 'baz']);
    });

    test('listOfScalarsOptional equals', () {
      final ctx = ShalomCtx.withCapacity();
      final result1 = ListOfScalarsOptionalResponse.fromResponse(
        listOfScalarsOptionalData,
        ctx: ctx,
      );
      final result2 = ListOfScalarsOptionalResponse.fromResponse(
        listOfScalarsOptionalData,
        ctx: ctx,
      );
      final result3 = ListOfScalarsOptionalResponse.fromResponse(
        listOfScalarsOptionalNullData,
        ctx: ctx,
      );
      final result4 = ListOfScalarsOptionalResponse.fromResponse(
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
      final result = ListOfOptionalScalarsOptionalResponse.fromResponse(
        listOfOptionalScalarsOptionalData,
      );
      expect(result.listOfOptionalScalarsOptional, [1, 2, 3]);
    });

    test('listOfOptionalScalarsOptional deserialize with null', () {
      final result = ListOfOptionalScalarsOptionalResponse.fromResponse(
        listOfOptionalScalarsOptionalNullData,
      );
      expect(result.listOfOptionalScalarsOptional, isNull);
    });

    test('listOfOptionalScalarsOptional deserialize with empty list', () {
      final result = ListOfOptionalScalarsOptionalResponse.fromResponse(
        listOfOptionalScalarsOptionalEmptyData,
      );
      expect(result.listOfOptionalScalarsOptional, []);
    });

    test('listOfOptionalScalarsOptional toJson', () {
      final initial = ListOfOptionalScalarsOptionalResponse.fromResponse(
        listOfOptionalScalarsOptionalData,
      );
      final json = initial.toJson();
      expect(json, listOfOptionalScalarsOptionalData);
    });

    test('listOfOptionalScalarsOptional toJson with null', () {
      final initial = ListOfOptionalScalarsOptionalResponse.fromResponse(
        listOfOptionalScalarsOptionalNullData,
      );
      final json = initial.toJson();
      expect(json, listOfOptionalScalarsOptionalNullData);
    });

    test('listOfOptionalScalarsOptional toJson with empty list', () {
      final initial = ListOfOptionalScalarsOptionalResponse.fromResponse(
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
      ) = ListOfOptionalScalarsOptionalResponse.fromResponseImpl(
        listOfOptionalScalarsOptionalData,
        ctx,
      );

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = ListOfOptionalScalarsOptionalResponse.fromCache(newCtx);
        hasChanged.complete(true);
      });

      final nextResult = ListOfOptionalScalarsOptionalResponse.fromResponse(
        listOfOptionalScalarsOptionalDataChanged,
        ctx: ctx,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.listOfOptionalScalarsOptional, [4, 5, 6]);
    });

    test('listOfOptionalScalarsOptional equals', () {
      final ctx = ShalomCtx.withCapacity();
      final result1 = ListOfOptionalScalarsOptionalResponse.fromResponse(
        listOfOptionalScalarsOptionalData,
        ctx: ctx,
      );
      final result2 = ListOfOptionalScalarsOptionalResponse.fromResponse(
        listOfOptionalScalarsOptionalData,
        ctx: ctx,
      );
      final result3 = ListOfOptionalScalarsOptionalResponse.fromResponse(
        listOfOptionalScalarsOptionalNullData,
        ctx: ctx,
      );
      final result4 = ListOfOptionalScalarsOptionalResponse.fromResponse(
        listOfOptionalScalarsOptionalNullData,
        ctx: ctx,
      );

      expect(result1, equals(result2));
      expect(result3, equals(result4));
      expect(result1, isNot(equals(result3)));
    });
  });
}
