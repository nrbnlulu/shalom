import "dart:async";

import "package:shalom_core/shalom_core.dart";
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
      final result = GetListingWithUserResponse.fromResponse(
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
      final initial = GetListingWithUserResponse.fromResponse(
        listingWithUserData,
      );
      final json = initial.toJson();
      expect(json, listingWithUserData);
    });

    test('nestedObjectSelectionRequired cacheNormalization', () async {
      final ctx = ShalomCtx.withCapacity();
      var (result, updateCtx) = GetListingWithUserResponse.fromResponseImpl(
        listingWithUserData,
        ctx,
      );

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetListingWithUserResponse.fromCache(newCtx);
        hasChanged.complete(true);
      });

      final nextResult = GetListingWithUserResponse.fromResponse(
        listingWithUserDataChangedPrice,
        ctx: ctx,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.listing.price, 110);
    });

    test('nestedObjectSelectionRequired equals', () {
      final result1 = GetListingWithUserResponse.fromResponse(
        listingWithUserData,
      );
      final result2 = GetListingWithUserResponse.fromResponse(
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
      final result = GetListingOptWithUserResponse.fromResponse(
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
      final result = GetListingOptWithUserResponse.fromResponse(
        listingOptNullData,
      );
      expect(result.listingOpt, null);
    });

    test('nestedObjectSelectionOptional serialize with value', () {
      final initial = GetListingOptWithUserResponse.fromResponse(
        listingOptWithUserData,
      );
      final json = initial.toJson();
      expect(json, listingOptWithUserData);
    });

    test('nestedObjectSelectionOptional serialize null', () {
      final initial = GetListingOptWithUserResponse.fromResponse(
        listingOptNullData,
      );
      final json = initial.toJson();
      expect(json, listingOptNullData);
    });

    test(
      'nestedObjectSelectionOptional cacheNormalization null to some',
      () async {
        final ctx = ShalomCtx.withCapacity();
        var (
          result,
          updateCtx,
        ) = GetListingOptWithUserResponse.fromResponseImpl(
          listingOptNullData,
          ctx,
        );

        final hasChanged = Completer<bool>();

        final sub = ctx.subscribe(updateCtx.dependantRecords);
        sub.streamController.stream.listen((newCtx) {
          result = GetListingOptWithUserResponse.fromCache(newCtx);
          hasChanged.complete(true);
        });

        final nextResult = GetListingOptWithUserResponse.fromResponse(
          listingOptWithUserData,
          ctx: ctx,
        );

        await hasChanged.future.timeout(Duration(seconds: 1));
        expect(result, equals(nextResult));
      },
    );

    test(
      'nestedObjectSelectionOptional cacheNormalization some to none',
      () async {
        final ctx = ShalomCtx.withCapacity();
        var (
          result,
          updateCtx,
        ) = GetListingOptWithUserResponse.fromResponseImpl(
          listingOptWithUserData,
          ctx,
        );

        final hasChanged = Completer<bool>();

        final sub = ctx.subscribe(updateCtx.dependantRecords);
        sub.streamController.stream.listen((newCtx) {
          result = GetListingOptWithUserResponse.fromCache(newCtx);
          hasChanged.complete(true);
        });

        final nextResult = GetListingOptWithUserResponse.fromResponse(
          listingOptNullData,
          ctx: ctx,
        );

        await hasChanged.future.timeout(Duration(seconds: 1));
        expect(result, equals(nextResult));
      },
    );

    test(
      'nestedObjectSelectionOptional cacheNormalization some to some',
      () async {
        final ctx = ShalomCtx.withCapacity();
        var (
          result,
          updateCtx,
        ) = GetListingOptWithUserResponse.fromResponseImpl(
          listingOptWithUserData,
          ctx,
        );

        final hasChanged = Completer<bool>();

        final sub = ctx.subscribe(updateCtx.dependantRecords);
        sub.streamController.stream.listen((newCtx) {
          result = GetListingOptWithUserResponse.fromCache(newCtx);
          hasChanged.complete(true);
        });

        final nextResult = GetListingOptWithUserResponse.fromResponse(
          listingOptWithUserDataChangedPrice,
          ctx: ctx,
        );

        await hasChanged.future.timeout(Duration(seconds: 1));
        expect(result, equals(nextResult));
        expect(result.listingOpt?.price, 110);
      },
    );

    test('nestedObjectSelectionOptional equals', () {
      final result1 = GetListingOptWithUserResponse.fromResponse(
        listingOptWithUserData,
      );
      final result2 = GetListingOptWithUserResponse.fromResponse(
        listingOptWithUserData,
      );
      final result3 = GetListingOptWithUserResponse.fromResponse(
        listingOptNullData,
      );
      final result4 = GetListingOptWithUserResponse.fromResponse(
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

    final listingWithUserOptDataChangedPrice = {
      "listing": {
        "id": "foo",
        "name": "video games",
        "price": 110,
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
        final result = GetListingWithUserOptResponse.fromResponse(
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
        final result = GetListingWithUserOptResponse.fromResponse(
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
        final initial = GetListingWithUserOptResponse.fromResponse(
          listingWithUserOptData,
        );
        final json = initial.toJson();
        expect(json, listingWithUserOptData);
      },
    );

    test(
      'nestedObjectSelectionRootRequiredChildOptional serialize child null',
      () {
        final initial = GetListingWithUserOptResponse.fromResponse(
          listingWithUserOptNullData,
        );
        final json = initial.toJson();
        expect(json, listingWithUserOptNullData);
      },
    );

    test(
      'nestedObjectSelectionRootRequiredChildOptional cacheNormalization',
      () async {
        final ctx = ShalomCtx.withCapacity();
        var (
          result,
          updateCtx,
        ) = GetListingWithUserOptResponse.fromResponseImpl(
          listingWithUserOptData,
          ctx,
        );

        final hasChanged = Completer<bool>();

        final sub = ctx.subscribe(updateCtx.dependantRecords);
        sub.streamController.stream.listen((newCtx) {
          result = GetListingWithUserOptResponse.fromCache(newCtx);
          hasChanged.complete(true);
        });

        final nextResult = GetListingWithUserOptResponse.fromResponse(
          listingWithUserOptDataChangedPrice,
          ctx: ctx,
        );

        await hasChanged.future.timeout(Duration(seconds: 1));
        expect(result, equals(nextResult));
        expect(result.listing.price, 110);
      },
    );

    test('nestedObjectSelectionRootRequiredChildOptional equals', () {
      final result1 = GetListingWithUserOptResponse.fromResponse(
        listingWithUserOptData,
      );
      final result2 = GetListingWithUserOptResponse.fromResponse(
        listingWithUserOptData,
      );
      final result3 = GetListingWithUserOptResponse.fromResponse(
        listingWithUserOptNullData,
      );
      final result4 = GetListingWithUserOptResponse.fromResponse(
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

    final listingOptWithUserOptDataChangedPrice = {
      "listingOpt": {
        "id": "foo",
        "name": "video games",
        "price": 110,
        "userOpt": {"id": "user1", "name": "John Doe"},
      },
    };

    final listingOptWithUserOptNullData = {"listingOpt": null};

    test(
      'nestedObjectSelectionRootOptionalChildOptional deserialize with value',
      () {
        final result = GetListinOptWithUserOptResponse.fromResponse(
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
        final result = GetListinOptWithUserOptResponse.fromResponse(
          listingOptWithUserOptNullData,
        );
        expect(result.listingOpt, null);
      },
    );

    test(
      'nestedObjectSelectionRootOptionalChildOptional serialize with value',
      () {
        final initial = GetListinOptWithUserOptResponse.fromResponse(
          listingOptWithUserOptData,
        );
        final json = initial.toJson();
        expect(json, listingOptWithUserOptData);
      },
    );

    test(
      'nestedObjectSelectionRootOptionalChildOptional serialize null value',
      () {
        final initial = GetListinOptWithUserOptResponse.fromResponse(
          listingOptWithUserOptNullData,
        );
        final json = initial.toJson();
        expect(json, listingOptWithUserOptNullData);
      },
    );

    test(
      'nestedObjectSelectionRootOptionalChildOptional cacheNormalization',
      () async {
        final ctx = ShalomCtx.withCapacity();
        var (
          result,
          updateCtx,
        ) = GetListinOptWithUserOptResponse.fromResponseImpl(
          listingOptWithUserOptData,
          ctx,
        );

        final hasChanged = Completer<bool>();

        final sub = ctx.subscribe(updateCtx.dependantRecords);
        sub.streamController.stream.listen((newCtx) {
          result = GetListinOptWithUserOptResponse.fromCache(newCtx);
          hasChanged.complete(true);
        });

        final nextResult = GetListinOptWithUserOptResponse.fromResponse(
          listingOptWithUserOptDataChangedPrice,
          ctx: ctx,
        );

        await hasChanged.future.timeout(Duration(seconds: 1));
        expect(result, equals(nextResult));
        expect(result.listingOpt?.price, 110);
      },
    );

    test('nestedObjectSelectionRootOptionalChildOptional equals', () {
      final result1 = GetListinOptWithUserOptResponse.fromResponse(
        listingOptWithUserOptData,
      );
      final result2 = GetListinOptWithUserOptResponse.fromResponse(
        listingOptWithUserOptData,
      );
      final result3 = GetListinOptWithUserOptResponse.fromResponse(
        listingOptWithUserOptNullData,
      );
      final result4 = GetListinOptWithUserOptResponse.fromResponse(
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
