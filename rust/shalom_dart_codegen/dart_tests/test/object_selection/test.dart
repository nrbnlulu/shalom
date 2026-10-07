import 'package:shalom/shalom.dart' as shalom_core;
import 'package:test/test.dart';
import "__graphql__/GetListing.shalom.dart";
import "__graphql__/GetListingOpt.shalom.dart";

void main() {
  final listingData = {
    "listing": {"id": "foo", "name": "video games", "price": 100},
  };
  group('Test simple object selection', () {
    test('deserialize', () {
      final json = {
        "listing": {"id": "foo", "name": "video games", "price": 100},
      };
      final result = GetListingData.fromJson(json);
      expect(result.listing.id, "foo");
      expect(result.listing.name, "video games");
      expect(result.listing.price, 100);
    });

    test('serialize', () {
      final initial = GetListingData.fromJson(listingData);
      final json = initial.toJson();
      expect(json, listingData);
    });

    test('direct bridge codec', () {
      final initial = GetListingData.fromShalomValue(
        shalom_core.shalomJsonValue(listingData),
      );

      expect(initial.listing.name, 'video games');
      expect(initial.toShalomValue().toJsonValue(), listingData);
    });
  });
  final listingOptSome = {
    "listingOpt": {"id": "foo", "name": "video games", "price": 100},
  };
  final dataNull = {"listingOpt": null};

  group('simple optional object selection', () {
    group('deserialize', () {
      test('with value', () {
        final json = {
          "listingOpt": {"id": "foo", "name": "video games", "price": 100},
        };
        final result = GetListingOptData.fromJson(json);
        expect(result.listingOpt?.id, "foo");
        expect(result.listingOpt?.name, "video games");
        expect(result.listingOpt?.price, 100);
      });

      test('null value', () {
        final json = {"listingOpt": null};
        final result = GetListingOptData.fromJson(json);
        expect(result.listingOpt, null);
      });
    });

    group('serialize', () {
      test('with value', () {
        final initial = GetListingOptData.fromJson(listingOptSome);
        final json = initial.toJson();
        expect(json, listingOptSome);
      });

      test('null value', () {
        final initial = GetListingOptData.fromJson(dataNull);
        final json = initial.toJson();
        expect(json, dataNull);
      });

      test('direct bridge codec with null', () {
        final initial = GetListingOptData.fromShalomValue(
          shalom_core.shalomJsonValue(dataNull),
        );

        expect(initial.listingOpt, isNull);
        expect(initial.toShalomValue().toJsonValue(), dataNull);
      });
    });
  });
}
