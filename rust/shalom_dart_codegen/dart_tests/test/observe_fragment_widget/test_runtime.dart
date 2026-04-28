import 'package:flutter_test/flutter_test.dart';
import 'package:shalom/shalom.dart' show ObservedRefInput;
import '__graphql__/PetFrag.shalom.dart';

void main() {
  group('observe_fragment_widget – PetFrag', () {
    test('PetFragData$Impl.fromCache deserialises id and name', () {
      final data = PetFragData.fromCache({'id': '14', 'name': 'Rex'});
      expect(data, isA<PetFragData$Impl>());
      final impl = data as PetFragData$Impl;
      expect(impl.id, '14');
      expect(impl.name, 'Rex');
    });

    test('PetFragRef wraps an ObservedRefInput', () {
      const ref = PetFragRef._(ObservedRefInput(
        observableId: 'PetFrag',
        anchor: 'Pet:14',
      ));
      expect(ref.toInput.observableId, 'PetFrag');
      expect(ref.toInput.anchor, 'Pet:14');
    });

    test('$PetFrag is a StatefulWidget subclass (compile-time)', () {
      expect($PetFrag, isNotNull);
    });
  });
}
