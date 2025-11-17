import "dart:async";

import "package:shalom_core/shalom_core.dart";
import 'package:test/test.dart';
import "__graphql__/SiteQuery.shalom.dart";

void main() {
  final siteData = {
    "site": {
      "id": "site1",
      "name": "Main Office",
      "location": "New York",
      "address": "123 Main St",
    },
  };

  final siteDataChangedAddress = {
    "site": {
      "id": "site1",
      "name": "Main Office",
      "location": "New York",
      "address": "456 Broadway",
    },
  };

  group('3-level nested fragments', () {
    test(
      'nestedFragmentsRequired - All fields accessible through nested fragments',
      () {
        final variables = SiteQueryVariables(siteId: "site1");
        final result = SiteQueryResponse.fromResponse(
          siteData,
          variables: variables,
        );

        // All fields should be accessible through the 3-level nested fragment chain
        expect(result.site?.id, "site1");
        expect(result.site?.name, "Main Office"); // from SiteWithNameFrag
        expect(
          result.site?.location,
          "New York",
        ); // from SiteWithLocAndNameFrag
        expect(
          result.site?.address,
          "123 Main St",
        ); // from SiteWithAddressAndLocFrag
      },
    );

    test('nestedFragmentsOptional - Null handling works correctly', () {
      final nullData = {"site": null};
      final variables = SiteQueryVariables(siteId: "site1");
      final result = SiteQueryResponse.fromResponse(
        nullData,
        variables: variables,
      );

      expect(result.site, null);
    });

    test('equals - Equality works with nested fragments', () {
      final variables = SiteQueryVariables(siteId: "site1");
      final result1 = SiteQueryResponse.fromResponse(
        siteData,
        variables: variables,
      );
      final result2 = SiteQueryResponse.fromResponse(
        siteData,
        variables: variables,
      );

      expect(result1 == result2, true);
      expect(result1.site == result2.site, true);
    });

    test('toJson - Serialization works with nested fragments', () {
      final variables = SiteQueryVariables(siteId: "site1");
      final result = SiteQueryResponse.fromResponse(
        siteData,
        variables: variables,
      );
      final json = result.toJson();

      expect(json, siteData);
    });

    test(
      'nestedFragmentsCacheNormalization - Cache updates propagate through nested fragments',
      () async {
        final ctx = ShalomCtx.withCapacity();
        final variables = SiteQueryVariables(siteId: "site1");

        var (result, updateCtx) = SiteQueryResponse.fromResponseImpl(
          siteData,
          ctx,
          variables,
        );

        final hasChanged = Completer<bool>();

        final sub = ctx.subscribe(updateCtx.dependantRecords);
        sub.streamController.stream.listen((newCtx) {
          result = SiteQueryResponse.fromCache(newCtx, variables);
          hasChanged.complete(true);
        });

        // Update the site with a changed address
        final nextResult = SiteQueryResponse.fromResponse(
          siteDataChangedAddress,
          ctx: ctx,
          variables: variables,
        );

        await hasChanged.future.timeout(Duration(seconds: 1));

        // The cached result should have been updated
        expect(result, equals(nextResult));
        expect(result.site?.address, "456 Broadway");
        expect(
          result.site?.name,
          "Main Office",
        ); // Other fields remain the same
        expect(result.site?.location, "New York");
      },
    );
  });
}
