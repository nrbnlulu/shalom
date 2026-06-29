import 'package:flutter/widgets.dart';
import 'package:shalom_annotations/shalom_annotations.dart';
import '__graphql__/ZooAnimalsWidget.shalom.dart';

@Fragment(r'''
on Zoo {
  id
  name
  animals {
    id
    ... on Dog {
      breed
    }
    ... on Cat {
      color
    }
  }
}
''')
class ZooAnimalsWidget extends $ZooAnimalsWidget {
  const ZooAnimalsWidget({super.key, required super.ref});

  @override
  Widget buildData(BuildContext context, ZooAnimalsWidgetData data) {
    final animalLabels = data.animals
        .map(
          (animal) => switch (animal) {
            ZooAnimalsWidget_animals__Dog(:final breed) => 'dog:$breed',
            ZooAnimalsWidget_animals__Cat(:final color) => 'cat:$color',
          },
        )
        .join(', ');
    return Text(
      'zoo: ${data.name}, animals: $animalLabels',
      textDirection: TextDirection.ltr,
    );
  }
}
