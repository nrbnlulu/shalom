import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tests/shared_fragment_contract/__graphql__/ZooAnimalsContractQuery.shalom.dart';

void main() {
  test(
    'v2 Flutter operation variants keep fragment contract fields inline',
    () {
      final result = ZooAnimalsContractQuery_animals__Dog.fromJson({
        '__typename': 'Dog',
        'id': 'dog-1',
        'breed': 'Collie',
        'favoriteToy': {'id': 'toy-1', 'label': 'Ball'},
      });

      expect(result.favoriteToy.label, 'Ball');
    },
  );
}
