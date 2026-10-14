import 'package:test/test.dart';

import '__graphql__/ElephantWithToysFrag.shalom.dart';

void main() {
  test(
    'concrete fragment data includes fields inherited from interface fragment spreads',
    () {
      final data = ElephantWithToysFragImpl.fromJson({
        'id': 'elephant-1',
        'name': 'Ada',
        'species': 'elephant',
        'trunkLength': 7,
        'toys': [
          {'id': 'toy-1', 'label': 'Ball'},
        ],
      });

      expect(data.id, 'elephant-1');
      expect(data.name, 'Ada');
      expect(data.species, 'elephant');
      expect(data.trunkLength, 7);
      expect(data.toys.single.label, 'Ball');
    },
  );
}
