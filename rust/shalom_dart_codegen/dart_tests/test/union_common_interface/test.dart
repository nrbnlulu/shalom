import 'package:test/test.dart';
import "__graphql__/GetErrorResult.shalom.dart";
import "__graphql__/GetMixedResult.shalom.dart";

void main() {
  group('union with a common interface across every member', () {
    test('sealed base class exposes the shared interface field directly', () {
      final result = GetErrorResultData.fromJson({
        "errorResult": {
          "__typename": "DoesNotExistErr",
          "message": "not found",
        },
      });

      // No downcast required: `message` comes from ErrorInterface, which
      // every member of ErrorUnion implements.
      expect(result.errorResult.message, "not found");
      expect(result.errorResult.$__typename, "DoesNotExistErr");
    });

    test('works the same for the other member of the union', () {
      final result = GetErrorResultData.fromJson({
        "errorResult": {
          "__typename": "AlreadyExistsErr",
          "message": "already there",
        },
      });

      expect(result.errorResult.message, "already there");
      expect(result.errorResult.$__typename, "AlreadyExistsErr");
    });

    test('roundtrips through toJson', () {
      final data = {
        "errorResult": {"__typename": "DoesNotExistErr", "message": "oops"},
      };
      final result = GetErrorResultData.fromJson(data);
      expect(result.toJson(), data);
    });
  });

  group('union with a partially-shared interface', () {
    test(
      'members implementing the interface still expose their field via downcast',
      () {
        final result = GetMixedResultData.fromJson({
          "mixedResult": {
            "__typename": "DoesNotExistErr",
            "message": "not found",
          },
        });

        final err =
            result.mixedResult as GetMixedResult_mixedResult__DoesNotExistErr;
        expect(err.message, "not found");
      },
    );

    test('the member outside the shared interface keeps its own field', () {
      final result = GetMixedResultData.fromJson({
        "mixedResult": {"__typename": "OtherThing", "value": 42},
      });

      final other =
          result.mixedResult as GetMixedResult_mixedResult__OtherThing;
      expect(other.value, 42);
    });
  });
}
