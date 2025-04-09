import 'package:test/test.dart';
import "__graphql__/GetUser.shalom.dart";
import "__graphql__/GetListing.shalom.dart";
import "__graphql__/GetListingOpt.shalom.dart";

void main() {
  group('Test query object fields', () {
    test('deserialize', () {
      final json = {
        "user": {
          "id": "foo",
          "name": "jacob",
          "email": "jacob@gmail.com",
          "age": 10,
        },
      };
      final result = RequestGetUser.fromJson(json);
      expect(result.user?.id, "foo");
      expect(result.user?.name, "jacob");
      expect(result.user?.email, "jacob@gmail.com");
      expect(result.user?.age, 10);
    });
    test('serialize', () {
      final data = {
        "user": {
          "id": "foo",
          "name": "jacob",
          "email": "jacob@gmail.com",
          "age": 10,
        },
      };
      final initial = RequestGetUser.fromJson(data);
      final json = initial.toJson();
      expect(json, data);
    });
    test("update", () {
      final initial = RequestGetUser(
        user: GetUserUser(
          id: "foo",
          name: "jacob",
          email: "jacob@gamil.com",
          age: 10,
        ),
      );
      final userJson = initial.user?.toJson();
      userJson?["age"] = 11;
      final updated = initial.updateWithJson({'user': userJson});
      expect(updated.user?.age, 11);
      expect(initial, isNot(updated));
    });
  });

  group('Test query nested object fields', () {
    test('deserialize - listing required', () {
      final json = {
        "listing": {
          "id": "foo",
          "name": "video games",
          "price": 100,
          "user": {"name": "jacob", "email": "jacob@gmail.com"},
        },
      };
      final result = RequestGetListing.fromJson(json);
      expect(result.listing.id, "foo");
      expect(result.listing.name, "video games");
      expect(result.listing.price, 100);
      expect(result.listing.user?.name, "jacob");
      expect(result.listing.user?.email, "jacob@gmail.com");
    });

    test('deserialize - listing optional', () {
      final json = {
        "listingOpt": {
          "id": "foo",
          "name": "video games",
          "price": 100,
          "user": {"name": "jacob", "email": "jacob@gmail.com"},
        },
      };
      final result = RequestGetListingOpt.fromJson(json);
      expect(result.listingOpt?.id, "foo");
      expect(result.listingOpt?.name, "video games");
      expect(result.listingOpt?.price, 100);
      expect(result.listingOpt?.user?.name, "jacob");
      expect(result.listingOpt?.user?.email, "jacob@gmail.com");
    });

    test('serialize - listing required', () {
      final data = {
        "listing": {
          "id": "foo",
          "name": "video games",
          "price": 100,
          "user": {"name": "jacob", "email": "jacob@gmail.com"},
        },
      };
      final initial = RequestGetListing.fromJson(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test('serialize - listing optional', () {
      final data = {
        "listingOpt": {
          "id": "foo",
          "name": "video games",
          "price": 100,
          "user": {"name": "jacob", "email": "jacob@gmail.com"},
        },
      };
      final initial = RequestGetListingOpt.fromJson(data);
      final json = initial.toJson();
      expect(json, data);
    });


    test("update - listing required", () {
      final initial = RequestGetListing(
        listing: GetListingListing(
          id: "foo",
          name: "video games",
          price: 100,
          user: GetListingUser(name: "jacob", email: "jacob@gmail.com"),
        ),
      );

      final userJson = initial.listing.user?.toJson();
      userJson?["name"] = "evan";

      final updated = initial.updateWithJson({
        "listing": {
          "id": "foo",
          "name": "video games",
          "price": 100,
          "user": userJson,
        },
      });

      expect(updated.listing.user?.name, "evan");
      expect(initial, isNot(equals(updated)));
    });

    test("update - listing optional", () {
      final initial = RequestGetListingOpt(
        listingOpt: GetListingOptListingOpt(
          id: "foo",
          name: "video games",
          price: 100,
          user: GetListingOptUser(name: "jacob", email: "jacob@gmail.com"),
        ),
      );

      final userJson = initial.listingOpt?.user?.toJson();
      userJson?["name"] = "evan";

      final updated = initial.updateWithJson({
        "listingOpt": {
          "id": "foo",
          "name": "video games",
          "price": 100,
          "user": userJson,
        },
      });

      expect(updated.listingOpt?.user?.name, "evan");
      expect(initial, isNot(equals(updated)));
    });
 });

  group('Test query nested object fields with null values', () {
   test('deserialize - listing optional', () {
      final json = {
        "listingOpt": null
      };
      final result = RequestGetListingOpt.fromJson(json as Map<String, dynamic>);
      expect(result.listingOpt, null);
    });

    test('deserialize - listing required', () {
      final json = {
        "listing": null 
      };
      expect(() => RequestGetListing.fromJson(json as Map<String, dynamic>), throwsA(TypeMatcher<FormatException>()));
    });

    test('serialize - listing optional', () {
      final json = {
          "listingOpt": null
      };
      final initial = RequestGetListingOpt.fromJson(json as Map<String, dynamic>);
      final result = initial.toJson();
      expect(result, {"listingOpt": null});
    });

     test('serialize - listing required', () {
      final json = {"listing": null};
      expect(() => RequestGetListing.fromJson(json), throwsA(TypeMatcher<FormatException>()));
    });

    test("update - listing optional", () {
      final initial = RequestGetListingOpt(
        listingOpt: GetListingOptListingOpt(
          id: "foo",
          name: "video games",
          price: 99,
          user: GetListingOptUser(name: "jacob", email: "jacob@gmail.com"),
        ),
      );

      final updated = initial.updateWithJson({
        "listingOpt": null 
      });

      expect(updated.listingOpt, null);
      expect(initial, isNot(equals(updated)));
  });

  test("update - listing required", () {
      final initial = RequestGetListing(
        listing: GetListingListing(
          id: "foo",
          name: "video games",
          price: 99,
          user: GetListingUser(name: "jacob", email: "jacob@gmail.com"),
        ),
      );

      expect(() => initial.updateWithJson({
        "listing": null 
      }), throwsA(TypeMatcher<FormatException>()));
  });
  });
}
