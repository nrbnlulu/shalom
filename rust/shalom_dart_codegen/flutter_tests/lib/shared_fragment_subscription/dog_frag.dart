import 'package:flutter/widgets.dart';
import 'package:shalom_annotations/shalom_annotations.dart';
import '__graphql__/DogFrag.shalom.dart';

@Fragment(r'''
on Dog {
  name
  breed
}
''')
class DogFrag extends $DogFrag {
  const DogFrag({super.key, required super.ref});

  @override
  Widget buildData(BuildContext context, DogFragData data) {
    return Text(data.name, textDirection: TextDirection.ltr);
  }
}
