import 'package:test/test.dart';
import "__graphql__/GetUser.shalom.dart";
import "__graphql__/GetListing.shalom.dart";

void main() {
  group('Test query object fields', () {
    test('deserialize', () {
      final json = {"user": {"id": "foo", "name": "jacob", "email": "jacob@gmail.com", "age": 10}};
      final result = RequestGetUser.fromJson(json);
      expect(result.user?.id, "foo");
      expect(result.user?.name, "jacob");
      expect(result.user?.email, "jacob@gmail.com");
      expect(result.user?.age, 10); 
    });
    test('serialize', () {
      final data = {"user": {"id": "foo", "name": "jacob", "email": "jacob@gmail.com", "age": 10}};
      final initial = RequestGetUser.fromJson(data);
      final json = initial.toJson();
      expect(json, data); 
    });
    test("update", () {
      final initial = RequestGetUser(user: RequestGetUserUser(id: "foo", name:"jacob", email: "jacob@gamil.com", age: 10));
      final user_json = initial.user?.toJson();
      user_json?["age"] = 11;
      final updated = initial.updateWithJson({'user': user_json});
      expect(updated.user?.age, 11);
      expect(initial, isNot(updated));
    });
   });

  group('Test query nested object fields', () {
  test('deserialize', () {
    final json = {
      "listing": {
        "id": "foo",
        "name": "video games",
        "price": 100,
        "user": {
          "name": "jacob",
          "email": "jacob@gmail.com",
        }
      }
    };
    final result = RequestGetListing.fromJson(json);
    expect(result.listing?.id, "foo");
    expect(result.listing?.name, "video games");
    expect(result.listing?.price, 100);
    expect(result.listing?.user?.name, "jacob");
    expect(result.listing?.user?.email, "jacob@gmail.com");
  });

  test('serialize', () {
    final data = {
      "listing": {
        "id": "foo",
        "name": "video games",
        "price": 100,
        "user": {
          "name": "jacob",
          "email": "jacob@gmail.com",
        }
      }
    };
    final initial = RequestGetListing.fromJson(data);
    final json = initial.toJson();
    expect(json, data);
  });

  test("update", () {
    final initial = RequestGetListing(
      listing: RequestGetListingListing(
        id: "foo",
        name: "video games",
        price: 100,
        user: RequestGetListingUser(
          name: "jacob",
          email: "jacob@gmail.com",
        ),
      ),
    );

    final userJson = initial.listing?.user?.toJson();
    userJson?["name"] = "evan";

    final updated = initial.updateWithJson({
      "listing": {
        "id": "foo",
        "name": "video games",
        "price": 100,
        "user": userJson,
      }
    });

    expect(updated.listing?.user?.name, "evan");
    expect(initial, isNot(equals(updated)));
  });
}); 
}