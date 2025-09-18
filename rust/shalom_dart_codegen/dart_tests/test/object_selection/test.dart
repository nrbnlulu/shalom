import "dart:async";

import "package:shalom_core/shalom_core.dart";
import 'package:test/test.dart';
import "__graphql__/GetListing.shalom.dart";
import "__graphql__/GetListingOpt.shalom.dart";

void main() {
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
      final data = {
        "listing": {"id": "foo", "name": "video games", "price": 100},
      };
      final initial = GetListingResponse.fromResponse(data);
      final json = initial.toJson();
      expect(json, data);
    });
  });

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
    final dataSome = {
      "listingOpt": {"id": "foo", "name": "video games", "price": 100},
    };
    final dataNull = {"listingOpt": null};

    group('serialize', () {
      test('with value', () {
        final initial = GetListingOptResponse.fromResponse(dataSome);
        final json = initial.toJson();
        expect(json, dataSome);
      });

      test('null value', () {
        final initial = GetListingOptResponse.fromResponse(dataNull);
        final json = initial.toJson();
        expect(json, dataNull);
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
        sub.streamController.stream.listen((ctx) {
          result = GetListingOptResponse.fromCache(ctx);
          hasChanged.complete(true);
        });

        final next = GetListingOptResponse.fromResponse(dataSome, ctx: ctx);

        await hasChanged.future.timeout(Duration(seconds: 1));
        expect(result, equals(next));
      });

      //   test('some to some', () {
      //     final initial = GetListingOptResponse(
      //       listingOpt: GetListingOpt_listingOpt(
      //         id: "foo",
      //         name: "video games",
      //         price: 100,
      //       ),
      //     );

      //     final listingJson = initial.listingOpt?.toJson();
      //     listingJson?["price"] = 110;

      //     final updated = initial.updateWithJson({"listingOpt": listingJson});
      //     expect(updated.listingOpt?.price, 110);
      //     expect(initial, isNot(updated));
      //   });

      //   test('some to null', () {
      //     final initial = GetListingOptResponse(
      //       listingOpt: GetListingOpt_listingOpt(
      //         id: "foo",
      //         name: "video games",
      //         price: 100,
      //       ),
      //     );

      //     final updated = initial.updateWithJson({"listingOpt": null});
      //     expect(updated.listingOpt, null);
      //     expect(initial, isNot(updated));
      //   });
    });
  });
}
