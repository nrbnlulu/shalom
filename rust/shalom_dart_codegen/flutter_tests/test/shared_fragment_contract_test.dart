import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tests/shared_fragment_contract/__graphql__/ExtendedDogStatusFrag.shalom.dart';
import 'package:flutter_tests/shared_fragment_contract/__graphql__/MinimalDogStatusFrag.shalom.dart';
import 'package:flutter_tests/shared_fragment_contract/__graphql__/ZooAnimalsContractQuery.shalom.dart';

void main() {
  test('Spread-target concrete variant contracts are not final', () {
    final generated = File(
      'lib/shared_fragment_contract/__graphql__/MinimalDogStatusFrag.shalom.dart',
    ).readAsStringSync();

    expect(
      generated,
      isNot(contains('final class MinimalDogStatusFrag_status__IdleStatus')),
    );
    expect(
      generated,
      isNot(
        contains('final class MinimalDogStatusFrag_status__MovementStatus'),
      ),
    );
  });

  test('Flutter operation variants keep fragment contract fields inline', () {
    final result = ZooAnimalsContractQuery_animals__Dog.fromJson({
      '__typename': 'Dog',
      'id': 'dog-1',
      'breed': 'Collie',
      'favoriteToy': {'id': 'toy-1', 'label': 'Ball'},
      'status': {
        '__typename': 'MovementStatus',
        'originMessage': 'camera-1',
        'motionType': 'person',
        'sensitivity': 8,
      },
    });

    expect(result.favoriteToy.label, 'Ball');
    expect(result.status.$__typename, 'MovementStatus');
  });

  test(
    'Flutter fragment nested unions use extendable contracts when spread',
    () {
      final data = ExtendedDogStatusFragData.fromCache({
        'id': 'dog-1',
        'status': {
          '__typename': 'MovementStatus',
          'originMessage': 'camera-1',
          'motionType': 'person',
          'sensitivity': 8,
        },
      });

      final MinimalDogStatusFrag minimal = data;
      final status =
          minimal.status as ExtendedDogStatusFrag_status__MovementStatus;
      expect(status.motionType, 'person');
      expect(status.originMessage, 'camera-1');
      expect(status.sensitivity, 8);
    },
  );

  test('A concrete member produced via a spreading fragment still matches '
      'switch patterns written against the spread-target fragment (regression '
      'for helpers like MinimalAlertFragKindDisplay that pattern-match on '
      "MinimalDogStatusFrag's member types)", () {
    final data = ExtendedDogStatusFragData.fromCache({
      'id': 'dog-1',
      'status': {
        '__typename': 'MovementStatus',
        'originMessage': 'camera-1',
        'motionType': 'person',
        'sensitivity': 8,
      },
    });

    final MinimalDogStatusFrag minimal = data;
    final MinimalDogStatusFrag_status status = minimal.status;

    final label = switch (status) {
      MinimalDogStatusFrag_status__IdleStatus() => 'idle',
      MinimalDogStatusFrag_status__MovementStatus(:final motionType) =>
        'moving:$motionType',
      _ => 'unknown',
    };

    expect(label, 'moving:person');
  });
}
