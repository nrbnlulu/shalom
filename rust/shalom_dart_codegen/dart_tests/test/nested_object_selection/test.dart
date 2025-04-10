import 'package:test/test.dart';
import "__graphql__/GetListinOptWithUserOpt.shalom.dart";
import "__graphql__/GetListingOptWithUser.shalom.dart";
import "__graphql__/GetListingWithUser.shalom.dart";
import "__graphql__/GetListingWithUserOpt.shalom.dart";

void main() {
  group('Nested Object Selection', () {
    test('deserialize', () {
      final json = {
        "listing": {
          "id": "foo",
          "name": "video games",
          "price": 100,
          "user": {
            "id": "user1",
            "name": "John Doe",
            "email": "john.doe@example.com",
            "age": null,
          },
        },
      };
      final result = RequestGetListingWithUser.fromJson(json);
      expect(result.listing.id, "foo");
      expect(result.listing.name, "video games");
      expect(result.listing.price, 100);
      expect(result.listing.user.id, "user1");
      expect(result.listing.user.name, "John Doe");
      expect(result.listing.user.email, "john.doe@example.com");
      expect(result.listing.user.age, null);
    });

    test('serialize', () {
      final data = {
        "listing": {
          "id": "foo",
          "name": "video games",
          "price": 100,
          "user": {
            "id": "user1",
            "name": "John Doe",
            "email": "john.doe@example.com",
            "age": null,
          },
        },
      };
      final initial = RequestGetListingWithUser.fromJson(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("update", () {
      final initial = RequestGetListingWithUser(
        listing: GetListingWithUser_listing(
          id: "foo",
          name: "video games",
          price: 100,
          user: GetListingWithUser_listing_user(
            id: "user1",
            name: "John Doe",
            email: "john.doe@example.com",
          ),
        ),
      );
      final listingJson = initial.listing.toJson();
      listingJson["price"] = 110;
      final updated = initial.updateWithJson({'listing': listingJson});
      expect(updated.listing.price, 110);
      expect(initial, isNot(updated));
    });
  });

  group('Nested Object Selection root optional', () {
    group('deserialize', () {
      test('with value', () {
        final json = {
          "listingOpt": {
            "id": "foo",
            "name": "video games",
            "price": 100,
            "user": {
              "id": "user1",
              "name": "John Doe",
              "email": "john.doe@example.com",
            },
          },
        };
        final result = RequestGetListingOptWithUser.fromJson(json);
        expect(result.listingOpt?.id, "foo");
        expect(result.listingOpt?.name, "video games");
        expect(result.listingOpt?.price, 100);
        expect(result.listingOpt?.user.id, "user1");
        expect(result.listingOpt?.user.name, "John Doe");
        expect(result.listingOpt?.user.email, "john.doe@example.com");
      });

      test('null value', () {
        final json = {"listingOpt": null};
        final result = RequestGetListingOptWithUser.fromJson(json);
        expect(result.listingOpt, null);
      });
    });

    group('serialize', () {
      test('some', () {
        final data = {
          "listingOpt": {
            "id": "foo",
            "name": "video games",
            "price": 100,
            "user": {
              "id": "user1",
              "name": "John Doe",
              "email": "john.doe@example.com",
              "age": null,
            },
          },
        };
        final initial = RequestGetListingOptWithUser.fromJson(data);
        final json = initial.toJson();
        expect(json, data);
      });

      test('null', () {
        final data = {"listingOpt": null};
        final initial = RequestGetListingOptWithUser.fromJson(data);
        final json = initial.toJson();
        expect(json, data);
      });
    });

    group('updateWithJson', () {
      test('null to some', () {
        final initial = RequestGetListingOptWithUser(listingOpt: null);

        final listingJson = {
          "id": "foo",
          "name": "video games",
          "price": 110,
          "user": {
            "id": "user1",
            "name": "John Doe",
            "email": "john.doe@example.com",
          },
        };

        final updated = initial.updateWithJson({"listingOpt": listingJson});
        expect(updated.listingOpt?.price, 110);
        expect(initial, isNot(updated));
      });

      test('some to some', () {
        final initial = RequestGetListingOptWithUser(
          listingOpt: GetListingOptWithUser_listingOpt(
            id: "foo",
            name: "video games",
            price: 100,
            user: GetListingOptWithUser_listingOpt_user(
              id: "user1",
              name: "John Doe",
              email: "john.doe@example.com",
            ),
          ),
        );

        final listingJson = initial.listingOpt?.toJson();
        listingJson?["price"] = 110;

        final updated = initial.updateWithJson({"listingOpt": listingJson});
        expect(updated.listingOpt?.price, 110);
        expect(initial, isNot(updated));
      });

      test('some to null', () {
        final initial = RequestGetListingOptWithUser(
          listingOpt: GetListingOptWithUser_listingOpt(
            id: "foo",
            name: "video games",
            price: 100,
            user: GetListingOptWithUser_listingOpt_user(
              id: "user1",
              name: "John Doe",
              email: "john.doe@example.com",
            ),
          ),
        );

        final updated = initial.updateWithJson({"listingOpt": null});
        expect(updated.listingOpt, null);
        expect(initial, isNot(updated));
      });
    });
  });

  group('Nested object selection root required child nullable', () {
    group('deserialize', () {
      test('child some', () {
        final json = {
          "listing": {
            "id": "foo",
            "name": "video games",
            "price": 100,
            "userOpt": {"id": "user1", "name": "John Doe"},
          },
        };
        final result = RequestGetListingWithUserOpt.fromJson(json);
        expect(result.listing.id, "foo");
        expect(result.listing.name, "video games");
        expect(result.listing.price, 100);
        expect(result.listing.userOpt?.id, "user1");
        expect(result.listing.userOpt?.name, "John Doe");
      });

      test('child null', () {
        final json = {
          "listing": {
            "id": "bar",
            "name": "board games",
            "price": 50,
            "userOpt": null,
          },
        };
        final result = RequestGetListingWithUserOpt.fromJson(json);
        expect(result.listing.id, "bar");
        expect(result.listing.name, "board games");
        expect(result.listing.price, 50);
        expect(result.listing.userOpt, null);
      });
    });

    group('serialize', () {
      test('child some', () {
        final data = {
          "listing": {
            "id": "foo",
            "name": "video games",
            "price": 100,
            "userOpt": {"id": "user1", "name": "John Doe"},
          },
        };
        final initial = RequestGetListingWithUserOpt.fromJson(data);
        final json = initial.toJson();
        expect(json, data);
      });

      test('child null', () {
        final data = {
          "listing": {
            "id": "bar",
            "name": "board games",
            "price": 50,
            "userOpt": null,
          },
        };
        final initial = RequestGetListingWithUserOpt.fromJson(data);
        final json = initial.toJson();
        expect(json, data);
      });
    });

    group('updateWithJson', () {
      test('null to some', () {
        final initial = RequestGetListingWithUserOpt(
          listing: GetListingWithUserOpt_listing(
            id: "bar",
            name: "board games",
            price: 50,
            userOpt: null,
          ),
        );

        final listingJson = {
          "id": "foo",
          "name": "video games",
          "price": 110,
          "userOpt": {"id": "user1", "name": "John Doe"},
        };

        final updated = initial.updateWithJson({"listing": listingJson});
        expect(updated.listing.price, 110);
        expect(updated.listing.userOpt?.id, "user1");
        expect(updated.listing.userOpt?.name, "John Doe");
        expect(initial, isNot(updated));
      });

      test('some to some', () {
        final initial = RequestGetListingWithUserOpt(
          listing: GetListingWithUserOpt_listing(
            id: "foo",
            name: "video games",
            price: 100,
            userOpt: GetListingWithUserOpt_listing_userOpt(
              id: "user1",
              name: "John Doe",
            ),
          ),
        );

        final listingJson = initial.listing.toJson();
        listingJson["price"] = 110;

        final updated = initial.updateWithJson({"listing": listingJson});
        expect(updated.listing.price, 110);
        expect(updated.listing.userOpt?.id, "user1");
        expect(updated.listing.userOpt?.name, "John Doe");
        expect(initial, isNot(updated));
      });

      test('some to null', () {
        final initial = RequestGetListingWithUserOpt(
          listing: GetListingWithUserOpt_listing(
            id: "foo",
            name: "video games",
            price: 100,
            userOpt: GetListingWithUserOpt_listing_userOpt(
              id: "user1",
              name: "John Doe",
            ),
          ),
        );

        final listingJson = initial.listing.toJson();
        listingJson["userOpt"] = null;

        final updated = initial.updateWithJson({"listing": listingJson});
        expect(updated.listing.userOpt, null);
        expect(initial, isNot(updated));
      });
    });
  });

  group('root nullable child nullable', () {
    group('deserialize', () {
      test('with value', () {
        final json = {
          "listingOpt": {
            "id": "foo",
            "name": "video games",
            "price": 100,
            "userOpt": {"id": "user1", "name": "John Doe"},
          },
        };
        final result = RequestGetListinOptWithUserOpt.fromJson(json);
        expect(result.listingOpt?.id, "foo");
        expect(result.listingOpt?.name, "video games");
        expect(result.listingOpt?.price, 100);
        expect(result.listingOpt?.userOpt?.id, "user1");
        expect(result.listingOpt?.userOpt?.name, "John Doe");
      });

      test('null value', () {
        final json = {"listingOpt": null};
        final result = RequestGetListinOptWithUserOpt.fromJson(json);
        expect(result.listingOpt, null);
      });
    });

    group('serialize', () {
      test('with value', () {
        final data = {
          "listingOpt": {
            "id": "foo",
            "name": "video games",
            "price": 100,
            "userOpt": {"id": "user1", "name": "John Doe"},
          },
        };
        final initial = RequestGetListinOptWithUserOpt.fromJson(data);
        final json = initial.toJson();
        expect(json, data);
      });

      test('null value', () {
        final data = {"listingOpt": null};
        final initial = RequestGetListinOptWithUserOpt.fromJson(data);
        final json = initial.toJson();
        expect(json, data);
      });
    });

    group('updateWithJson', () {
      test('null to some', () {
        final initial = RequestGetListinOptWithUserOpt(listingOpt: null);

        final listingJson = {
          "id": "foo",
          "name": "video games",
          "price": 110,
          "userOpt": {"id": "user1", "name": "John Doe"},
        };

        final updated = initial.updateWithJson({"listingOpt": listingJson});
        expect(updated.listingOpt?.price, 110);
        expect(updated.listingOpt?.userOpt?.id, "user1");
        expect(updated.listingOpt?.userOpt?.name, "John Doe");
        expect(initial, isNot(updated));
      });

      test('some to some', () {
        final initial = RequestGetListinOptWithUserOpt(
          listingOpt: GetListinOptWithUserOpt_listingOpt(
            id: "foo",
            name: "video games",
            price: 100,
            userOpt: GetListinOptWithUserOpt_listingOpt_userOpt(
              id: "user1",
              name: "John Doe",
            ),
          ),
        );

        final listingJson = initial.listingOpt?.toJson();
        listingJson?["price"] = 110;

        final updated = initial.updateWithJson({"listingOpt": listingJson});
        expect(updated.listingOpt?.price, 110);
        expect(updated.listingOpt?.userOpt?.id, "user1");
        expect(updated.listingOpt?.userOpt?.name, "John Doe");
        expect(initial, isNot(updated));
      });

      test('some to null', () {
        final initial = RequestGetListinOptWithUserOpt(
          listingOpt: GetListinOptWithUserOpt_listingOpt(
            id: "foo",
            name: "video games",
            price: 100,
            userOpt: GetListinOptWithUserOpt_listingOpt_userOpt(
              id: "user1",
              name: "John Doe",
            ),
          ),
        );

        final updated = initial.updateWithJson({"listingOpt": null});
        expect(updated.listingOpt, null);
        expect(initial, isNot(updated));
      });
    });
  });
}
