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
        final result = SiteQueryData.fromJson(
          siteData,
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
      final result = SiteQueryData.fromJson(
        nullData,
      );

      expect(result.site, null);
    });

    test('equals - Equality works with nested fragments', () {
      final variables = SiteQueryVariables(siteId: "site1");
      final result1 = SiteQueryData.fromJson(
        siteData,
      );
      final result2 = SiteQueryData.fromJson(
        siteData,
      );

      expect(result1 == result2, true);
      expect(result1.site == result2.site, true);
    });

    test('toJson - Serialization works with nested fragments', () {
      final variables = SiteQueryVariables(siteId: "site1");
      final result = SiteQueryData.fromJson(
        siteData,
      );
      final json = result.toJson();

      expect(json, siteData);
    });
  });
}
