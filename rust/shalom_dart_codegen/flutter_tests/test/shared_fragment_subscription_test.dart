import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tests/shared_fragment_subscription/__graphql__/DogFrag.shalom.dart'
    as dog_frag;
import 'package:flutter_tests/shared_fragment_subscription/__graphql__/ShelterSubscription.shalom.dart';
import 'package:flutter_tests/shared_fragment_subscription/__graphql__/StreetSubscription.shalom.dart';

void main() {
  test('Flutter subscription variants implement shared fragment', () {
    final shelterDog = ShelterSubscription_shelterAnimals__Dog(
      id: 'dog-1',
      name: 'Rex',
      breed: 'Collie',
    );
    final streetDog = StreetSubscription_streetAnimals__Dog(
      id: 'dog-2',
      name: 'Nina',
      breed: 'Husky',
    );

    final dogFrags = <dog_frag.DogFrag>[shelterDog, streetDog];

    expect(dogFrags.map((dog) => dog.name), ['Rex', 'Nina']);
    expect(dogFrags.map((dog) => dog.breed), ['Collie', 'Husky']);
  });
}
