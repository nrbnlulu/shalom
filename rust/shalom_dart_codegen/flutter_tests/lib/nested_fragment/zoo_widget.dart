import 'package:flutter/widgets.dart';
import 'package:shalom_annotations/shalom_annotations.dart';
import '__graphql__/ZooWidget.shalom.dart';

@Fragment(r'''
on Zoo {
  id
  name
  cages {
    id
    name
  }
}
''')
class ZooWidget extends $ZooWidget {
  const ZooWidget({super.key, required super.ref});

  @override
  Widget buildData(BuildContext context, ZooWidgetData data) {
    final cageNames = data.cages.map((c) => c.name).join(', ');
    return Text(
      'zoo: ${data.name}, cages: $cageNames',
      textDirection: TextDirection.ltr,
    );
  }
}
