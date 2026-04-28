import 'package:flutter/widgets.dart';
import 'package:shalom_annotations/shalom_annotations.dart';
import '__graphql__/PetWidget.shalom.dart';

@Fragment(r'''
on Pet {
  id
  name
}
''')
class PetWidget extends $PetWidget {
  const PetWidget({super.key, required super.ref});

  @override
  Widget buildData(BuildContext context, PetWidgetData data) {
    if (data is PetWidgetData$Impl) {
      return Text('pet: ${data.name}', textDirection: TextDirection.ltr);
    }
    return const SizedBox.shrink();
  }
}
