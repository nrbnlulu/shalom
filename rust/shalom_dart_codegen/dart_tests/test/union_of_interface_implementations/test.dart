import "dart:async";

import "package:shalom_core/shalom_core.dart";
import 'package:test/test.dart';
import "__graphql__/GetError.shalom.dart";
import "__graphql__/GetErrorOpt.shalom.dart";
import "__graphql__/GetErrorWithoutTopTypename.shalom.dart";

void main() {
  final doesNotExistsErrorData = {
    "getError": {
      "__typename": "DoesNotExistsError",
      "message": "The resource does not exist"
    }
  };

  final alreadyExistsErrorData = {
    "getError": {
      "__typename": "AlreadyExistsError",
      "message": "The resource already exists"
    }
  };

  group('Test union of interface implementations - required', () {
    test('doesNotExistsErrorRequired', () {
      final variables = GetErrorVariables(id: "test1");
      final result = GetErrorResponse.fromResponse(doesNotExistsErrorData,
          variables: variables);

      expect(result.getError, isA<GetError_getError_DoesNotExistsError>());
      final error = result.getError as GetError_getError_DoesNotExistsError;
      expect(error.message, "The resource does not exist");
      expect(error.typename, "DoesNotExistsError");
    });

    test('alreadyExistsErrorRequired', () {
      final variables = GetErrorVariables(id: "test1");
      final result = GetErrorResponse.fromResponse(alreadyExistsErrorData,
          variables: variables);

      expect(result.getError, isA<GetError_getError_AlreadyExistsError>());
      final error = result.getError as GetError_getError_AlreadyExistsError;
      expect(error.message, "The resource already exists");
      expect(error.typename, "AlreadyExistsError");
    });

    test('toJson - DoesNotExistsError', () {
      final variables = GetErrorVariables(id: "test1");
      final initial = GetErrorResponse.fromResponse(doesNotExistsErrorData,
          variables: variables);
      final json = initial.toJson();
      expect(json, doesNotExistsErrorData);
    });

    test('toJson - AlreadyExistsError', () {
      final variables = GetErrorVariables(id: "test1");
      final initial = GetErrorResponse.fromResponse(alreadyExistsErrorData,
          variables: variables);
      final json = initial.toJson();
      expect(json, alreadyExistsErrorData);
    });

    test('equals - DoesNotExistsError', () {
      final variables = GetErrorVariables(id: "test1");
      final result1 = GetErrorResponse.fromResponse(doesNotExistsErrorData,
          variables: variables);
      final result2 = GetErrorResponse.fromResponse(doesNotExistsErrorData,
          variables: variables);
      expect(result1, equals(result2));
    });

    test('equals - AlreadyExistsError', () {
      final variables = GetErrorVariables(id: "test1");
      final result1 = GetErrorResponse.fromResponse(alreadyExistsErrorData,
          variables: variables);
      final result2 = GetErrorResponse.fromResponse(alreadyExistsErrorData,
          variables: variables);
      expect(result1, equals(result2));
    });

    test('not equals - different error types', () {
      final variables = GetErrorVariables(id: "test1");
      final result1 = GetErrorResponse.fromResponse(doesNotExistsErrorData,
          variables: variables);
      final result2 = GetErrorResponse.fromResponse(alreadyExistsErrorData,
          variables: variables);
      expect(result1, isNot(equals(result2)));
    });
  });

  final doesNotExistsErrorOptData = {
    "getErrorOpt": {
      "__typename": "DoesNotExistsError",
      "message": "Optional error: does not exist"
    }
  };

  final alreadyExistsErrorOptData = {
    "getErrorOpt": {
      "__typename": "AlreadyExistsError",
      "message": "Optional error: already exists"
    }
  };

  final errorOptNullData = {"getErrorOpt": null};

  group('Test union of interface implementations - optional', () {
    test('doesNotExistsErrorOptional', () {
      final variables = GetErrorOptVariables(id: "test2");
      final result = GetErrorOptResponse.fromResponse(doesNotExistsErrorOptData,
          variables: variables);

      expect(result.getErrorOpt, isNotNull);
      expect(result.getErrorOpt,
          isA<GetErrorOpt_getErrorOpt_DoesNotExistsError>());
      final error =
          result.getErrorOpt as GetErrorOpt_getErrorOpt_DoesNotExistsError;
      expect(error.message, "Optional error: does not exist");
      expect(error.typename, "DoesNotExistsError");
    });

    test('alreadyExistsErrorOptional', () {
      final variables = GetErrorOptVariables(id: "test2");
      final result = GetErrorOptResponse.fromResponse(alreadyExistsErrorOptData,
          variables: variables);

      expect(result.getErrorOpt, isNotNull);
      expect(result.getErrorOpt,
          isA<GetErrorOpt_getErrorOpt_AlreadyExistsError>());
      final error =
          result.getErrorOpt as GetErrorOpt_getErrorOpt_AlreadyExistsError;
      expect(error.message, "Optional error: already exists");
      expect(error.typename, "AlreadyExistsError");
    });

    test('deserialize null', () {
      final variables = GetErrorOptVariables(id: "test2");
      final result = GetErrorOptResponse.fromResponse(errorOptNullData,
          variables: variables);
      expect(result.getErrorOpt, isNull);
    });

    test('toJson with DoesNotExistsError', () {
      final variables = GetErrorOptVariables(id: "test2");
      final initial = GetErrorOptResponse.fromResponse(
          doesNotExistsErrorOptData,
          variables: variables);
      final json = initial.toJson();
      expect(json, doesNotExistsErrorOptData);
    });

    test('toJson with AlreadyExistsError', () {
      final variables = GetErrorOptVariables(id: "test2");
      final initial = GetErrorOptResponse.fromResponse(
          alreadyExistsErrorOptData,
          variables: variables);
      final json = initial.toJson();
      expect(json, alreadyExistsErrorOptData);
    });

    test('toJson null', () {
      final variables = GetErrorOptVariables(id: "test2");
      final initial = GetErrorOptResponse.fromResponse(errorOptNullData,
          variables: variables);
      final json = initial.toJson();
      expect(json, errorOptNullData);
    });

    test('equals with value', () {
      final variables = GetErrorOptVariables(id: "test2");
      final result1 = GetErrorOptResponse.fromResponse(
          doesNotExistsErrorOptData,
          variables: variables);
      final result2 = GetErrorOptResponse.fromResponse(
          doesNotExistsErrorOptData,
          variables: variables);
      expect(result1, equals(result2));
    });

    test('equals null', () {
      final variables = GetErrorOptVariables(id: "test2");
      final result1 = GetErrorOptResponse.fromResponse(errorOptNullData,
          variables: variables);
      final result2 = GetErrorOptResponse.fromResponse(errorOptNullData,
          variables: variables);
      expect(result1, equals(result2));
    });
  });

  group('Test union of interface implementations - __typename in fragments',
      () {
    test('deserialize with __typename in fragments - DoesNotExistsError', () {
      final variables = GetErrorWithoutTopTypenameVariables(id: "test3");
      final result = GetErrorWithoutTopTypenameResponse.fromResponse(
          doesNotExistsErrorData,
          variables: variables);

      expect(result.getError,
          isA<GetErrorWithoutTopTypename_getError_DoesNotExistsError>());
      final error = result.getError
          as GetErrorWithoutTopTypename_getError_DoesNotExistsError;
      expect(error.typename, "DoesNotExistsError");
      expect(error.message, "The resource does not exist");
    });

    test('deserialize with __typename in fragments - AlreadyExistsError', () {
      final variables = GetErrorWithoutTopTypenameVariables(id: "test3");
      final result = GetErrorWithoutTopTypenameResponse.fromResponse(
          alreadyExistsErrorData,
          variables: variables);

      expect(result.getError,
          isA<GetErrorWithoutTopTypename_getError_AlreadyExistsError>());
      final error = result.getError
          as GetErrorWithoutTopTypename_getError_AlreadyExistsError;
      expect(error.typename, "AlreadyExistsError");
      expect(error.message, "The resource already exists");
    });
  });

  group('cacheNormalization', () {
    test('DoesNotExistsError to AlreadyExistsError', () async {
      final ctx = ShalomCtx.withCapacity();
      final variables = GetErrorVariables(id: "test1");

      var (result, updateCtx) = GetErrorResponse.fromResponseImpl(
        doesNotExistsErrorData,
        ctx,
        variables,
      );

      expect(result.getError, isA<GetError_getError_DoesNotExistsError>());

      final hasChanged = Completer<bool>();
      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetErrorResponse.fromCache(newCtx, variables);
        hasChanged.complete(true);
      });

      final nextResult = GetErrorResponse.fromResponse(
        alreadyExistsErrorData,
        ctx: ctx,
        variables: variables,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.getError, isA<GetError_getError_AlreadyExistsError>());
    });

    test('AlreadyExistsError to DoesNotExistsError', () async {
      final ctx = ShalomCtx.withCapacity();
      final variables = GetErrorVariables(id: "test1");

      var (result, updateCtx) = GetErrorResponse.fromResponseImpl(
        alreadyExistsErrorData,
        ctx,
        variables,
      );

      expect(result.getError, isA<GetError_getError_AlreadyExistsError>());

      final hasChanged = Completer<bool>();
      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetErrorResponse.fromCache(newCtx, variables);
        hasChanged.complete(true);
      });

      final nextResult = GetErrorResponse.fromResponse(
        doesNotExistsErrorData,
        ctx: ctx,
        variables: variables,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.getError, isA<GetError_getError_DoesNotExistsError>());
    });

    test('optional - null to DoesNotExistsError', () async {
      final ctx = ShalomCtx.withCapacity();
      final variables = GetErrorOptVariables(id: "test2");

      var (result, updateCtx) = GetErrorOptResponse.fromResponseImpl(
        errorOptNullData,
        ctx,
        variables,
      );

      expect(result.getErrorOpt, isNull);

      final hasChanged = Completer<bool>();
      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetErrorOptResponse.fromCache(newCtx, variables);
        hasChanged.complete(true);
      });

      final nextResult = GetErrorOptResponse.fromResponse(
        doesNotExistsErrorOptData,
        ctx: ctx,
        variables: variables,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.getErrorOpt, isNotNull);
    });

    test('optional - DoesNotExistsError to null', () async {
      final ctx = ShalomCtx.withCapacity();
      final variables = GetErrorOptVariables(id: "test2");

      var (result, updateCtx) = GetErrorOptResponse.fromResponseImpl(
        doesNotExistsErrorOptData,
        ctx,
        variables,
      );

      expect(result.getErrorOpt, isNotNull);

      final hasChanged = Completer<bool>();
      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetErrorOptResponse.fromCache(newCtx, variables);
        hasChanged.complete(true);
      });

      final nextResult = GetErrorOptResponse.fromResponse(
        errorOptNullData,
        ctx: ctx,
        variables: variables,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.getErrorOpt, isNull);
    });

    test('optional - AlreadyExistsError to DoesNotExistsError', () async {
      final ctx = ShalomCtx.withCapacity();
      final variables = GetErrorOptVariables(id: "test2");

      var (result, updateCtx) = GetErrorOptResponse.fromResponseImpl(
        alreadyExistsErrorOptData,
        ctx,
        variables,
      );

      expect(result.getErrorOpt,
          isA<GetErrorOpt_getErrorOpt_AlreadyExistsError>());

      final hasChanged = Completer<bool>();
      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetErrorOptResponse.fromCache(newCtx, variables);
        hasChanged.complete(true);
      });

      final nextResult = GetErrorOptResponse.fromResponse(
        doesNotExistsErrorOptData,
        ctx: ctx,
        variables: variables,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.getErrorOpt,
          isA<GetErrorOpt_getErrorOpt_DoesNotExistsError>());
    });
  });
}
