import 'dart:async';
import 'package:test/test.dart';
import 'package:shalom_core/shalom_core.dart';
import "__graphql__/ProcessList.shalom.dart";
import "__graphql__/schema.shalom.dart";

void main() {
  group("input list with defaults", () {
    test("inputListWithDefaultsRequired", () {
      final req = RequestProcessList(
        variables: ProcessListVariables(
          input: ListInput(),
        ),
      ).toRequest();
      expect(req.variables, {
        "input": {"items": []},
      });
    });

    test("inputListWithDefaultsOverride", () {
      final req = RequestProcessList(
        variables: ProcessListVariables(
          input: ListInput(items: ["a", "b"]),
        ),
      ).toRequest();
      expect(req.variables, {
        "input": {
          "items": ["a", "b"]
        },
      });
    });

    test("toJson", () {
      final input = ListInput();
      expect(input.toJson(), {"items": []});
    });

    test("equals", () {
      final input1 = ListInput();
      final input2 = ListInput();
      expect(input1.toJson(), equals(input2.toJson()));
    });

    test(
        'inputListWithDefaultsCacheNormalization - different parameters use separate cache entries',
        () async {
      final ctx = ShalomCtx.withCapacity();
      final variables1 = ProcessListVariables(input: ListInput(items: ["a"]));
      final variables2 = ProcessListVariables(input: ListInput(items: ["b"]));

      final data1 = {"processList": "result1"};
      final data2 = {"processList": "result2"};

      // First query
      var (result1, updateCtx1) = ProcessListResponse.fromResponseImpl(
        data1,
        ctx,
        variables1,
      );
      expect(result1.processList, "result1");

      // Second query with different params
      var (result2, updateCtx2) = ProcessListResponse.fromResponseImpl(
        data2,
        ctx,
        variables2,
      );
      expect(result2.processList, "result2");

      // Both should be cached separately
      final cached1 = ProcessListResponse.fromCache(ctx, variables1);
      final cached2 = ProcessListResponse.fromCache(ctx, variables2);
      expect(cached1.processList, "result1");
      expect(cached2.processList, "result2");

      // Set up listeners for both
      final completer1 = Completer<bool>();
      final completer2 = Completer<bool>();
      bool listener1Called = false;
      bool listener2Called = false;

      final sub1 = ctx.subscribe(updateCtx1.dependantRecords);
      sub1.streamController.stream.listen((newCtx) {
        final updated = ProcessListResponse.fromCache(newCtx, variables1);
        expect(updated.processList, "updated1");
        listener1Called = true;
        completer1.complete(true);
      });

      final sub2 = ctx.subscribe(updateCtx2.dependantRecords);
      sub2.streamController.stream.listen((newCtx) {
        listener2Called = true;
        completer2.complete(true);
      });

      // Update cache for first query
      final updatedData1 = {"processList": "updated1"};
      ProcessListResponse.fromResponse(
        updatedData1,
        ctx: ctx,
        variables: variables1,
      );

      // Wait for listener1 to be called
      await completer1.future.timeout(Duration(seconds: 1));

      // Listener1 should be called, listener2 should not
      expect(listener1Called, isTrue);
      expect(listener2Called, isFalse);

      // Second query should remain unchanged
      final finalCached2 = ProcessListResponse.fromCache(ctx, variables2);
      expect(finalCached2.processList, "result2");
    });
    test(
        'inputListWithDefaultsCacheNormalizationDefaults - update default and check different value stays same',
        () async {
      final ctx = ShalomCtx.withCapacity();
      final variablesDefault =
          ProcessListVariables(input: ListInput()); // uses default items: []
      final variablesDifferent =
          ProcessListVariables(input: ListInput(items: ["c"]));

      final dataDefault = {"processList": "defaultResult"};
      final dataDifferent = {"processList": "differentResult"};

      // First query with defaults
      var (resultDefault, updateCtxDefault) =
          ProcessListResponse.fromResponseImpl(
        dataDefault,
        ctx,
        variablesDefault,
      );
      expect(resultDefault.processList, "defaultResult");

      // Second query with different params
      var (resultDifferent, updateCtxDifferent) =
          ProcessListResponse.fromResponseImpl(
        dataDifferent,
        ctx,
        variablesDifferent,
      );
      expect(resultDifferent.processList, "differentResult");

      // Both should be cached separately
      final cachedDefault =
          ProcessListResponse.fromCache(ctx, variablesDefault);
      final cachedDifferent =
          ProcessListResponse.fromCache(ctx, variablesDifferent);
      expect(cachedDefault.processList, "defaultResult");
      expect(cachedDifferent.processList, "differentResult");

      // Set up listeners for both
      final completerDefault = Completer<bool>();
      final completerDifferent = Completer<bool>();
      bool listenerDefaultCalled = false;
      bool listenerDifferentCalled = false;

      final subDefault = ctx.subscribe(updateCtxDefault.dependantRecords);
      subDefault.streamController.stream.listen((newCtx) {
        final updated = ProcessListResponse.fromCache(newCtx, variablesDefault);
        expect(updated.processList, "updatedDefault");
        listenerDefaultCalled = true;
        completerDefault.complete(true);
      });

      final subDifferent = ctx.subscribe(updateCtxDifferent.dependantRecords);
      subDifferent.streamController.stream.listen((newCtx) {
        listenerDifferentCalled = true;
        completerDifferent.complete(true);
      });

      // Update cache for default query
      final updatedDataDefault = {"processList": "updatedDefault"};
      ProcessListResponse.fromResponse(
        updatedDataDefault,
        ctx: ctx,
        variables: variablesDefault,
      );

      // Wait for listenerDefault to be called
      await completerDefault.future.timeout(Duration(seconds: 1));

      // listenerDefault should be called, listenerDifferent should not
      expect(listenerDefaultCalled, isTrue);
      expect(listenerDifferentCalled, isFalse);

      // Different query should remain unchanged
      final finalCachedDifferent =
          ProcessListResponse.fromCache(ctx, variablesDifferent);
      expect(finalCachedDifferent.processList, "differentResult");
    });
  });
}
