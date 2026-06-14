import 'package:flutter/widgets.dart';
import 'package:shalom_annotations/shalom_annotations.dart';
import '__graphql__/AnimalWithLocation.shalom.dart';

@Fragment(r'''
on Animal {
  id
  ... on Dog {
    breed
    location {
      lat
      lng
    }
  }
  ... on Cat {
    color
  }
}
''')
class AnimalWithLocation extends $AnimalWithLocation {
  const AnimalWithLocation({super.key, required super.ref});

  @override
  Widget buildData(BuildContext context, AnimalWithLocationData data) {
    return switch (data) {
      AnimalWithLocationData$Dog(:final breed, :final location) => Text(
        'dog: $breed at (${location?.lat}, ${location?.lng})',
        textDirection: TextDirection.ltr,
      ),
      AnimalWithLocationData$Cat(:final color) => Text(
        'cat: $color',
        textDirection: TextDirection.ltr,
      ),
      AnimalWithLocationData$Unknown() => const SizedBox.shrink(),
    };
  }
}
