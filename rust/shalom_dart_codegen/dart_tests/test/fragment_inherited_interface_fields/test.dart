import 'package:test/test.dart';

import '__graphql__/ElephantWithToysFrag.shalom.dart';
import '__graphql__/ExtendedAnimalNestedFrag.shalom.dart';
import '__graphql__/MileSightChannelAlertFrag.shalom.dart';
import '__graphql__/MinimalAnimalNestedFrag.shalom.dart';
import '__graphql__/MovementStatusWithChannelAlertFrag.shalom.dart';

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
  });

  test(
      'fragment spreading another fragment merges matching nested object and union fields',
      () {
    final data = ExtendedAnimalNestedFragImpl.fromJson({
      'id': 'elephant-1',
      'favoriteToy': {'id': 'toy-1', 'label': 'Ball'},
      'status': {
        '__typename': 'MovementStatus',
        'originMessage': 'camera-1',
        'motionType': 'person',
        'sensitivity': 8,
        'channelAlert': {
          '__typename': 'MileSightChannelAlert',
          'channelName': 'north gate',
          'confidence': 91,
        },
      },
    });

    final MinimalAnimalNestedFrag minimal = data;
    expect(minimal.favoriteToy.id, 'toy-1');
    expect(data.favoriteToy.label, 'Ball');

    expect(minimal.status, isA<ExtendedAnimalNestedFrag_status__MovementStatus>());
    final status =
        minimal.status as ExtendedAnimalNestedFrag_status__MovementStatus;
    expect(status.$__typename, 'MovementStatus');
    expect(status.motionType, 'person');
    expect(status.originMessage, 'camera-1');
    expect(status.sensitivity, 8);

    final MileSightChannelAlertFrag channelAlert = status.channelAlert;
    expect(channelAlert.channelName, 'north gate');
    expect(
      (channelAlert
              as MovementStatusWithChannelAlertFrag_channelAlert__MileSightChannelAlert)
          .confidence,
      91,
    );
  });
}
