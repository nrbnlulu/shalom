import "dart:async";

import "package:shalom_core/shalom_core.dart";
import 'package:test/test.dart';
import "__graphql__/GetListing.shalom.dart";
import "__graphql__/GetListingNoPrice.shalom.dart";
import "__graphql__/GetListingOpt.shalom.dart";

void main() {
  final listingData = {
    "listing": {"id": "foo", "name": "video games", "price": 100},
  };
  final listingDataChangedPrice = {
    "listing": {"id": "foo", "name": "video games", "price": 110},
  };
  group('Test simple object selection', () {
    test('deserialize', () {
      final json = {
        "listing": {"id": "foo", "name": "video games", "price": 100},
      };
      final result = GetListingResponse.fromResponse(json);
      expect(result.listing.id, "foo");
      expect(result.listing.name, "video games");
      expect(result.listing.price, 100);
    });

    test('serialize', () {
      final initial = GetListingResponse.fromResponse(listingData);
      final json = initial.toJson();
      expect(json, listingData);
    });
  });
  final listingOptSome = {
    "listingOpt": {"id": "foo", "name": "video games", "price": 100},
  };
  final listingOptSome2ChangedPrice = {
    "listingOpt": {"id": "foo", "name": "video games", "price": 110},
  };

  final dataNull = {"listingOpt": null};

  group('simple optional object selection', () {
    group('deserialize', () {
      test('with value', () {
        final json = {
          "listingOpt": {"id": "foo", "name": "video games", "price": 100},
        };
        final result = GetListingOptResponse.fromResponse(json);
        expect(result.listingOpt?.id, "foo");
        expect(result.listingOpt?.name, "video games");
        expect(result.listingOpt?.price, 100);
      });

      test('null value', () {
        final json = {"listingOpt": null};
        final result = GetListingOptResponse.fromResponse(json);
        expect(result.listingOpt, null);
      });
    });

    group('serialize', () {
      test('with value', () {
        final initial = GetListingOptResponse.fromResponse(listingOptSome);
        final json = initial.toJson();
        expect(json, listingOptSome);
      });

      test('null value', () {
        final initial = GetListingOptResponse.fromResponse(dataNull);
        final json = initial.toJson();
        expect(json, dataNull);
      });
    });
  });

  group('cacheUpdate', () {
    test('null to some', () async {
      final ctx = ShalomCtx.withCapacity();
      var (result, updateCtx) = GetListingOptResponse.fromResponseImpl(
        dataNull,
        ctx,
      );

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetListingOptResponse.fromCache(newCtx);
        hasChanged.complete(true);
      });

      final nextResult = GetListingOptResponse.fromResponse(
        listingOptSome,
        ctx: ctx,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
    });

    test("some to none", () async {
      final ctx = ShalomCtx.withCapacity();
      var (result, updateCtx) = GetListingOptResponse.fromResponseImpl(
        listingOptSome,
        ctx,
      );

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetListingOptResponse.fromCache(newCtx);
        hasChanged.complete(true);
      });

      final nextResult = GetListingOptResponse.fromResponse(dataNull, ctx: ctx);

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
    });
    test("some to some", () async {
      final ctx = ShalomCtx.withCapacity();
      var (result, updateCtx) = GetListingOptResponse.fromResponseImpl(
        listingOptSome,
        ctx,
      );

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetListingOptResponse.fromCache(newCtx);
        hasChanged.complete(true);
      });

      final nextResult = GetListingOptResponse.fromResponse(
        listingOptSome2ChangedPrice,
        ctx: ctx,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
    });

    test("some to some no overlapping deps", () async {
      final ctx = ShalomCtx.withCapacity();
      var (result, updateCtx) = GetListingNoPriceResponse.fromResponseImpl(
        listingData,
        ctx,
      );
      final hasChanged = Completer<bool>();
      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetListingNoPriceResponse.fromCache(newCtx);
        hasChanged.complete(true);
      });
      final _ = GetListingResponse.fromResponse(
        listingDataChangedPrice,
        ctx: ctx,
      );
      // we don't expect any change as the price field is not part of the deps
      await Future.delayed(Duration(milliseconds: 500));
      expect(hasChanged.isCompleted, false);
      expect(
        result,
        equals(GetListingNoPriceResponse.fromResponse(listingData)),
      );
    });
  });
}
