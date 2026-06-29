import 'package:flutter/widgets.dart';
import 'package:shalom_annotations/shalom_annotations.dart';
import '__graphql__/AnimalWithOwnerWidget.shalom.dart';

@Fragment(r'''
on Animal {
  id
  ... on Dog {
    breed
    owner {
      name
    }
  }
  ... on Cat {
    color
  }
}
''')
class AnimalWithOwnerWidget extends $AnimalWithOwnerWidget {
  const AnimalWithOwnerWidget({super.key, required super.ref});

  @override
  Widget buildData(BuildContext context, AnimalWithOwnerWidgetData data) {
    return switch (data) {
      AnimalWithOwnerWidgetData$Dog(:final breed, :final owner) => Text(
        'dog: $breed, owner: ${owner?.name ?? 'unknown'}',
        textDirection: TextDirection.ltr,
      ),
      AnimalWithOwnerWidgetData$Cat(:final color) => Text(
        'cat: $color',
        textDirection: TextDirection.ltr,
      ),
      AnimalWithOwnerWidgetData$Unknown() => const SizedBox.shrink(),
    };
  }
}
