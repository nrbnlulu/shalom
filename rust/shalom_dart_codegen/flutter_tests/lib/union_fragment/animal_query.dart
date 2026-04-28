import 'package:flutter/widgets.dart';
import 'package:shalom_annotations/shalom_annotations.dart';
import '__graphql__/AnimalQuery.widget.shalom.dart';
import 'animal_widget.dart';

@Query(r'''
($id: ID!) {
  animal(id: $id) {
    ...AnimalWidget
  }
}
''')
class AnimalQuery extends $AnimalQuery {
  const AnimalQuery({super.key, required super.variables});

  @override
  Widget buildLoading(BuildContext context) =>
      const Text('loading', textDirection: TextDirection.ltr);

  @override
  Widget buildError(BuildContext context, Object error) =>
      Text('error: $error', textDirection: TextDirection.ltr);

  @override
  Widget buildData(BuildContext context, AnimalQueryData data) =>
      data.animal == null
          ? const Text('no animal', textDirection: TextDirection.ltr)
          : AnimalWidget(ref: data.animal!);
}
