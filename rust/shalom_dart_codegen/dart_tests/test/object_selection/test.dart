import 'package:test/test.dart';
import "__graphql__/GetListing.shalom.dart";
import "__graphql__/GetListingOpt.shalom.dart";

void main() {
  group('Test simple object selection', () {
    test('deserialize', () {
      final json = {
        "listing": {"id": "foo", "name": "video games", "price": 100},
      };
      final result = GetListingResponse.fromJson(json);
      expect(result.listing.id, "foo");
      expect(result.listing.name, "video games");
      expect(result.listing.price, 100);
    });

    test('serialize', () {
      final data = {
        "listing": {"id": "foo", "name": "video games", "price": 100},
      };
      final initial = GetListingResponse.fromJson(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("update", () {
      final initial = GetListingResponse(
        listing: GetListing_listing(id: "foo", name: "video games", price: 100),
      );
      final listingJson = initial.listing.toJson();
      listingJson["price"] = 110;
      final updated = initial.updateWithJson({'listing': listingJson});
      expect(updated.listing.price, 110);
      expect(initial, isNot(updated));
    });
  });

  group('simple optional object selection', () {
    group('deserialize', () {
      test('with value', () {
        final json = {
          "listingOpt": {"id": "foo", "name": "video games", "price": 100},
        };
        final result = GetListingOptResponse.fromJson(json);
        expect(result.listingOpt?.id, "foo");
        expect(result.listingOpt?.name, "video games");
        expect(result.listingOpt?.price, 100);
      });

      test('null value', () {
        final json = {"listingOpt": null};
        final result = GetListingOptResponse.fromJson(json);
        expect(result.listingOpt, null);
      });
    });

    group('serialize', () {
      test('with value', () {
        final data = {
          "listingOpt": {"id": "foo", "name": "video games", "price": 100},
        };
        final initial = GetListingOptResponse.fromJson(data);
        final json = initial.toJson();
        expect(json, data);
      });

      test('null value', () {
        final data = {"listingOpt": null};
        final initial = GetListingOptResponse.fromJson(data);
        final json = initial.toJson();
        expect(json, data);
      });
    });

    group('updateWithJson', () {
      test('null to some', () {
        final initial = GetListingOptResponse(listingOpt: null);

        final listingJson = {"id": "foo", "name": "video games", "price": 110};

        final updated = initial.updateWithJson({"listingOpt": listingJson});
        expect(updated.listingOpt?.price, 110);
        expect(initial, isNot(updated));
      });

      test('some to some', () {
        final initial = GetListingOptResponse(
          listingOpt: GetListingOpt_listingOpt(
            id: "foo",
            name: "video games",
            price: 100,
          ),
        );

        final listingJson = initial.listingOpt?.toJson();
        listingJson?["price"] = 110;

        final updated = initial.updateWithJson({"listingOpt": listingJson});
        expect(updated.listingOpt?.price, 110);
        expect(initial, isNot(updated));
      });

      test('some to null', () {
        final initial = GetListingOptResponse(
          listingOpt: GetListingOpt_listingOpt(
            id: "foo",
            name: "video games",
            price: 100,
          ),
        );

        final updated = initial.updateWithJson({"listingOpt": null});
        expect(updated.listingOpt, null);
        expect(initial, isNot(updated));
      });
    });
  });
}
