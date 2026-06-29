import "dart:async";

import "package:shalom/shalom.dart";
import 'package:test/test.dart';
import "__graphql__/GetListinOptWithUserOpt.shalom.dart";
import "__graphql__/GetListingOptWithUser.shalom.dart";
import "__graphql__/GetListingWithUser.shalom.dart";
import "__graphql__/GetListingWithUserOpt.shalom.dart";

void main() {
  final listingWithUserData = {
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

  final listingWithUserDataChangedPrice = {
    "listing": {
      "id": "foo",
      "name": "video games",
      "price": 110,
      "user": {
        "id": "user1",
        "name": "John Doe",
        "email": "john.doe@example.com",
        "age": null,
      },
    },
  };

  group('Nested Object Selection Required', () {
    test('nestedObjectSelectionRequired deserialize', () {
      final result = GetListingWithUserResponse.fromJson(
        listingWithUserData,
      );
      expect(result.listing.id, "foo");
      expect(result.listing.name, "video games");
      expect(result.listing.price, 100);
      expect(result.listing.user.id, "user1");
      expect(result.listing.user.name, "John Doe");
      expect(result.listing.user.email, "john.doe@example.com");
      expect(result.listing.user.age, null);
    });

    test('nestedObjectSelectionRequired serialize', () {
      final initial = GetListingWithUserResponse.fromJson(
        listingWithUserData,
      );
      final json = initial.toJson();
      expect(json, listingWithUserData);
    });

    test('nestedObjectSelectionRequired equals', () {
      final result1 = GetListingWithUserResponse.fromJson(
        listingWithUserData,
      );
      final result2 = GetListingWithUserResponse.fromJson(
        listingWithUserData,
      );
      expect(result1, equals(result2));
      expect(result1.hashCode, equals(result2.hashCode));
    });
  });

  group('Nested Object Selection Root Optional', () {
    final listingOptWithUserData = {
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

    final listingOptWithUserDataChangedPrice = {
      "listingOpt": {
        "id": "foo",
        "name": "video games",
        "price": 110,
        "user": {
          "id": "user1",
          "name": "John Doe",
          "email": "john.doe@example.com",
          "age": null,
        },
      },
    };

    final listingOptNullData = {"listingOpt": null};

    test('nestedObjectSelectionOptional deserialize with value', () {
      final result = GetListingOptWithUserResponse.fromJson(
        listingOptWithUserData,
      );
      expect(result.listingOpt?.id, "foo");
      expect(result.listingOpt?.name, "video games");
      expect(result.listingOpt?.price, 100);
      expect(result.listingOpt?.user.id, "user1");
      expect(result.listingOpt?.user.name, "John Doe");
      expect(result.listingOpt?.user.email, "john.doe@example.com");
    });

    test('nestedObjectSelectionOptional deserialize null value', () {
      final result = GetListingOptWithUserResponse.fromJson(
        listingOptNullData,
      );
      expect(result.listingOpt, null);
    });

    test('nestedObjectSelectionOptional serialize with value', () {
      final initial = GetListingOptWithUserResponse.fromJson(
        listingOptWithUserData,
      );
      final json = initial.toJson();
      expect(json, listingOptWithUserData);
    });

    test('nestedObjectSelectionOptional serialize null', () {
      final initial = GetListingOptWithUserResponse.fromJson(
        listingOptNullData,
      );
      final json = initial.toJson();
      expect(json, listingOptNullData);
    });

    test('nestedObjectSelectionOptional equals', () {
      final result1 = GetListingOptWithUserResponse.fromJson(
        listingOptWithUserData,
      );
      final result2 = GetListingOptWithUserResponse.fromJson(
        listingOptWithUserData,
      );
      final result3 = GetListingOptWithUserResponse.fromJson(
        listingOptNullData,
      );
      final result4 = GetListingOptWithUserResponse.fromJson(
        listingOptNullData,
      );

      expect(result1, equals(result2));
      expect(result1.hashCode, equals(result2.hashCode));
      expect(result3, equals(result4));
      expect(result3.hashCode, equals(result4.hashCode));
      expect(result1, isNot(equals(result3)));
    });
  });

  group('Nested Object Selection Root Required Child Optional', () {
    final listingWithUserOptData = {
      "listing": {
        "id": "foo",
        "name": "video games",
        "price": 100,
        "userOpt": {"id": "user1", "name": "John Doe"},
      },
    };

    final listingWithUserOptNullData = {
      "listing": {
        "id": "bar",
        "name": "board games",
        "price": 50,
        "userOpt": null,
      },
    };

    test(
      'nestedObjectSelectionRootRequiredChildOptional deserialize child some',
      () {
        final result = GetListingWithUserOptResponse.fromJson(
          listingWithUserOptData,
        );
        expect(result.listing.id, "foo");
        expect(result.listing.name, "video games");
        expect(result.listing.price, 100);
        expect(result.listing.userOpt?.id, "user1");
        expect(result.listing.userOpt?.name, "John Doe");
      },
    );

    test(
      'nestedObjectSelectionRootRequiredChildOptional deserialize child null',
      () {
        final result = GetListingWithUserOptResponse.fromJson(
          listingWithUserOptNullData,
        );
        expect(result.listing.id, "bar");
        expect(result.listing.name, "board games");
        expect(result.listing.price, 50);
        expect(result.listing.userOpt, null);
      },
    );

    test(
      'nestedObjectSelectionRootRequiredChildOptional serialize child some',
      () {
        final initial = GetListingWithUserOptResponse.fromJson(
          listingWithUserOptData,
        );
        final json = initial.toJson();
        expect(json, listingWithUserOptData);
      },
    );

    test(
      'nestedObjectSelectionRootRequiredChildOptional serialize child null',
      () {
        final initial = GetListingWithUserOptResponse.fromJson(
          listingWithUserOptNullData,
        );
        final json = initial.toJson();
        expect(json, listingWithUserOptNullData);
      },
    );

    test('nestedObjectSelectionRootRequiredChildOptional equals', () {
      final result1 = GetListingWithUserOptResponse.fromJson(
        listingWithUserOptData,
      );
      final result2 = GetListingWithUserOptResponse.fromJson(
        listingWithUserOptData,
      );
      final result3 = GetListingWithUserOptResponse.fromJson(
        listingWithUserOptNullData,
      );
      final result4 = GetListingWithUserOptResponse.fromJson(
        listingWithUserOptNullData,
      );

      expect(result1, equals(result2));
      expect(result1.hashCode, equals(result2.hashCode));
      expect(result3, equals(result4));
      expect(result3.hashCode, equals(result4.hashCode));
      expect(result1, isNot(equals(result3)));
    });
  });

  group('Nested Object Selection Root Optional Child Optional', () {
    final listingOptWithUserOptData = {
      "listingOpt": {
        "id": "foo",
        "name": "video games",
        "price": 100,
        "userOpt": {"id": "user1", "name": "John Doe"},
      },
    };
    final listingOptWithUserOptNullData = {"listingOpt": null};

    test(
      'nestedObjectSelectionRootOptionalChildOptional deserialize with value',
      () {
        final result = GetListinOptWithUserOptResponse.fromJson(
          listingOptWithUserOptData,
        );
        expect(result.listingOpt?.id, "foo");
        expect(result.listingOpt?.name, "video games");
        expect(result.listingOpt?.price, 100);
        expect(result.listingOpt?.userOpt?.id, "user1");
        expect(result.listingOpt?.userOpt?.name, "John Doe");
      },
    );

    test(
      'nestedObjectSelectionRootOptionalChildOptional deserialize null value',
      () {
        final result = GetListinOptWithUserOptResponse.fromJson(
          listingOptWithUserOptNullData,
        );
        expect(result.listingOpt, null);
      },
    );

    test(
      'nestedObjectSelectionRootOptionalChildOptional serialize with value',
      () {
        final initial = GetListinOptWithUserOptResponse.fromJson(
          listingOptWithUserOptData,
        );
        final json = initial.toJson();
        expect(json, listingOptWithUserOptData);
      },
    );

    test(
      'nestedObjectSelectionRootOptionalChildOptional serialize null value',
      () {
        final initial = GetListinOptWithUserOptResponse.fromJson(
          listingOptWithUserOptNullData,
        );
        final json = initial.toJson();
        expect(json, listingOptWithUserOptNullData);
      },
    );

    test('nestedObjectSelectionRootOptionalChildOptional equals', () {
      final result1 = GetListinOptWithUserOptResponse.fromJson(
        listingOptWithUserOptData,
      );
      final result2 = GetListinOptWithUserOptResponse.fromJson(
        listingOptWithUserOptData,
      );
      final result3 = GetListinOptWithUserOptResponse.fromJson(
        listingOptWithUserOptNullData,
      );
      final result4 = GetListinOptWithUserOptResponse.fromJson(
        listingOptWithUserOptNullData,
      );

      expect(result1, equals(result2));
      expect(result1.hashCode, equals(result2.hashCode));
      expect(result3, equals(result4));
      expect(result3.hashCode, equals(result4.hashCode));
      expect(result1, isNot(equals(result3)));
    });
  });
}
