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

    final data1 = {"processList": "result1"};
    final data2 = {"processList": "result2"};

    test('inputListWithDefaultsCacheNotificationsDontHappen', () async {
      // Make operation, listen for cache updates,
      // make another query with different parameters,
      // verify listener is NOT called

      final ctx = ShalomCtx.withCapacity();
      final variablesDefault =
          ProcessListVariables(input: ListInput()); // uses default items: []
      final variablesDifferent =
          ProcessListVariables(input: ListInput(items: ["c"]));

      // First query with defaults
      var (resultDefault, updateCtxDefault) =
          ProcessListResponse.fromResponseImpl(
        data1,
        ctx,
        variablesDefault,
      );

      //expect(resultDefault.toJson(), data1);

      final defaultGotUpdate = Completer<bool>();

      // sub updateCtxDefault -> true defaultGotUpdate
      final sub1 = ctx.subscribe(updateCtxDefault.dependantRecords);
      sub1.streamController.stream.listen((newCtx) {
        final updated = ProcessListResponse.fromCache(newCtx, variablesDefault);
        expect(updated.processList, "updated1");
        defaultGotUpdate.complete(true);
      });

      // make query for second parameters
      final _ = ProcessListResponse.fromResponse(
        data2,
        ctx: ctx,
        variables: variablesDifferent,
      );

      void checkCacheUpdate() async {
        // Wait for listenerDefault to be called
        await defaultGotUpdate.future.timeout(Duration(seconds: 1));
      }

      // check that listener was not called
      expect(checkCacheUpdate, throwsA(isA<TimeoutException>()));

      // first query should remain unchanged
      expect(
          ProcessListResponse.fromCache(ctx, variablesDefault).toJson(), data1);

      // second query should be updated
      expect(ProcessListResponse.fromCache(ctx, variablesDifferent).toJson(),
          data2);
    });

    test('inputListWithDefaultsCacheNotificationsHappen', () async {
      // Make operation, listen for cache updates,
      // make another query with different results but same parameters,
      // verify listener is called

      final ctx = ShalomCtx.withCapacity();
      final variablesDefault =
          ProcessListVariables(input: ListInput()); // uses default items: []

      // First query with defaults
      var (resultDefault, updateCtxDefault) =
          ProcessListResponse.fromResponseImpl(
        data1,
        ctx,
        variablesDefault,
      );
      expect(resultDefault.toJson(), data1);

      // Set up listener
      final completerDefault = Completer<bool>();

      final subDefault = ctx.subscribe(updateCtxDefault.dependantRecords);
      subDefault.streamController.stream.listen((newCtx) {
        final updated = ProcessListResponse.fromCache(newCtx, variablesDefault);
        expect(updated.toJson(), data2);
        completerDefault.complete(true);
      });

      // Update cache for default query
      ProcessListResponse.fromResponse(
        data2,
        ctx: ctx,
        variables: variablesDefault,
      );

      // Wait for listenerDefault to be called
      await completerDefault.future.timeout(Duration(seconds: 1));

      // Check that cache is updated correctly
      final cachedDefaultAfterUpdate =
          ProcessListResponse.fromCache(ctx, variablesDefault);

      expect(cachedDefaultAfterUpdate.toJson(), data2);
    });
  });
}
