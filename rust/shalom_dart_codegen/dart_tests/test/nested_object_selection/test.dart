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
      final result = GetListingWithUserData.fromJson(listingWithUserData);
      expect(result.listing.id, "foo");
      expect(result.listing.name, "video games");
      expect(result.listing.price, 100);
      expect(result.listing.user.id, "user1");
      expect(result.listing.user.name, "John Doe");
      expect(result.listing.user.email, "john.doe@example.com");
      expect(result.listing.user.age, null);
    });

    test('nestedObjectSelectionRequired serialize', () {
      final initial = GetListingWithUserData.fromJson(listingWithUserData);
      final json = initial.toJson();
      expect(json, listingWithUserData);
    });

    test('nestedObjectSelectionRequired equals', () {
      final result1 = GetListingWithUserData.fromJson(listingWithUserData);
      final result2 = GetListingWithUserData.fromJson(listingWithUserData);
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
      final result = GetListingOptWithUserData.fromJson(listingOptWithUserData);
      expect(result.listingOpt?.id, "foo");
      expect(result.listingOpt?.name, "video games");
      expect(result.listingOpt?.price, 100);
      expect(result.listingOpt?.user.id, "user1");
      expect(result.listingOpt?.user.name, "John Doe");
      expect(result.listingOpt?.user.email, "john.doe@example.com");
    });

    test('nestedObjectSelectionOptional deserialize null value', () {
      final result = GetListingOptWithUserData.fromJson(listingOptNullData);
      expect(result.listingOpt, null);
    });

    test('nestedObjectSelectionOptional serialize with value', () {
      final initial = GetListingOptWithUserData.fromJson(
        listingOptWithUserData,
      );
      final json = initial.toJson();
      expect(json, listingOptWithUserData);
    });

    test('nestedObjectSelectionOptional serialize null', () {
      final initial = GetListingOptWithUserData.fromJson(listingOptNullData);
      final json = initial.toJson();
      expect(json, listingOptNullData);
    });

    test('nestedObjectSelectionOptional equals', () {
      final result1 = GetListingOptWithUserData.fromJson(
        listingOptWithUserData,
      );
      final result2 = GetListingOptWithUserData.fromJson(
        listingOptWithUserData,
      );
      final result3 = GetListingOptWithUserData.fromJson(listingOptNullData);
      final result4 = GetListingOptWithUserData.fromJson(listingOptNullData);

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
        final result = GetListingWithUserOptData.fromJson(
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
        final result = GetListingWithUserOptData.fromJson(
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
        final initial = GetListingWithUserOptData.fromJson(
          listingWithUserOptData,
        );
        final json = initial.toJson();
        expect(json, listingWithUserOptData);
      },
    );

    test(
      'nestedObjectSelectionRootRequiredChildOptional serialize child null',
      () {
        final initial = GetListingWithUserOptData.fromJson(
          listingWithUserOptNullData,
        );
        final json = initial.toJson();
        expect(json, listingWithUserOptNullData);
      },
    );

    test('nestedObjectSelectionRootRequiredChildOptional equals', () {
      final result1 = GetListingWithUserOptData.fromJson(
        listingWithUserOptData,
      );
      final result2 = GetListingWithUserOptData.fromJson(
        listingWithUserOptData,
      );
      final result3 = GetListingWithUserOptData.fromJson(
        listingWithUserOptNullData,
      );
      final result4 = GetListingWithUserOptData.fromJson(
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
        final result = GetListinOptWithUserOptData.fromJson(
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
        final result = GetListinOptWithUserOptData.fromJson(
          listingOptWithUserOptNullData,
        );
        expect(result.listingOpt, null);
      },
    );

    test(
      'nestedObjectSelectionRootOptionalChildOptional serialize with value',
      () {
        final initial = GetListinOptWithUserOptData.fromJson(
          listingOptWithUserOptData,
        );
        final json = initial.toJson();
        expect(json, listingOptWithUserOptData);
      },
    );

    test(
      'nestedObjectSelectionRootOptionalChildOptional serialize null value',
      () {
        final initial = GetListinOptWithUserOptData.fromJson(
          listingOptWithUserOptNullData,
        );
        final json = initial.toJson();
        expect(json, listingOptWithUserOptNullData);
      },
    );

    test('nestedObjectSelectionRootOptionalChildOptional equals', () {
      final result1 = GetListinOptWithUserOptData.fromJson(
        listingOptWithUserOptData,
      );
      final result2 = GetListinOptWithUserOptData.fromJson(
        listingOptWithUserOptData,
      );
      final result3 = GetListinOptWithUserOptData.fromJson(
        listingOptWithUserOptNullData,
      );
      final result4 = GetListinOptWithUserOptData.fromJson(
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
