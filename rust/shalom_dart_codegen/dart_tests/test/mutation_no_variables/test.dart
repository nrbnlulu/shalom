import 'package:test/test.dart';
import '__graphql__/ResetCache.shalom.dart';

void main() {
  group('mutation_no_variables — Data', () {
    test('fromCache with true', () {
      final data = ResetCacheData.fromCache({'resetCache': true});
      expect(data.resetCache, isTrue);
    });

    test('fromCache with null', () {
      final data = ResetCacheData.fromCache({'resetCache': null});
      expect(data.resetCache, isNull);
    });

    test('toJson roundtrip', () {
      final data = ResetCacheData(resetCache: true);
      expect(data.toJson()['resetCache'], isTrue);
    });

    test('toJson with null', () {
      final data = ResetCacheData(resetCache: null);
      expect(data.toJson()['resetCache'], isNull);
    });
  });
}
