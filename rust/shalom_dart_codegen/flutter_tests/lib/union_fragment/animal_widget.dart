import 'package:flutter/widgets.dart';
import 'package:shalom_annotations/shalom_annotations.dart';
import '__graphql__/AnimalWidget.shalom.dart';

@Fragment(r'''
on Animal {
  id
  ... on Dog {
    breed
  }
  ... on Cat {
    color
  }
}
''')
class AnimalWidget extends $AnimalWidget {
  const AnimalWidget({super.key, required super.ref});

  @override
  Widget buildData(BuildContext context, AnimalWidgetData data) {
    return switch (data) {
      AnimalWidgetData$Dog(:final breed) => Text('dog: $breed', textDirection: TextDirection.ltr),
      AnimalWidgetData$Cat(:final color) => Text('cat: $color', textDirection: TextDirection.ltr),
      AnimalWidgetData$Unknown()         => const SizedBox.shrink(),
    };
  }
}
