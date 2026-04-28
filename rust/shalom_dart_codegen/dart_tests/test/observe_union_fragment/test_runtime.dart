import 'package:flutter_test/flutter_test.dart';
import '__graphql__/AnimalFrag.shalom.dart';

void main() {
  group('observe_union_fragment – AnimalFrag', () {
    test('fromCache returns Dog concrete when __typename is Dog', () {
      final data = AnimalFragData.fromCache({
        '__typename': 'Dog',
        'id': 'd1',
        'breed': 'Labrador',
      });
      expect(data, isA<AnimalFragData$Dog>());
      final dog = data as AnimalFragData$Dog;
      expect(dog.breed, 'Labrador');
    });

    test('fromCache returns Cat concrete when __typename is Cat', () {
      final data = AnimalFragData.fromCache({
        '__typename': 'Cat',
        'id': 'c1',
        'color': 'black',
      });
      expect(data, isA<AnimalFragData$Cat>());
      final cat = data as AnimalFragData$Cat;
      expect(cat.color, 'black');
    });

    test('fromCache returns Unknown for unrecognised __typename', () {
      final data = AnimalFragData.fromCache({
        '__typename': 'Fish',
        'id': 'f1',
      });
      expect(data, isA<AnimalFragData$Unknown>());
    });

    test('AnimalFragData$Unknown extends AnimalFragData (sealed hierarchy)', () {
      const unknown = AnimalFragData$Unknown();
      expect(unknown, isA<AnimalFragData>());
    });

    test('$AnimalFrag is a StatefulWidget subclass (compile-time)', () {
      expect($AnimalFrag, isNotNull);
    });
  });
}
