import 'package:flutter/widgets.dart';
import 'package:shalom_annotations/shalom_annotations.dart';
import '__graphql__/AnimalLocationQuery.widget.shalom.dart';
import 'animal_with_location_widget.dart';

@Query(r'''
($id: ID!) {
  animal(id: $id) {
    ...AnimalWithLocation
  }
}
''')
class AnimalLocationQuery extends $AnimalLocationQuery {
  const AnimalLocationQuery({super.key, required super.variables});

  @override
  Widget buildLoading(BuildContext context) =>
      const Text('loading', textDirection: TextDirection.ltr);

  @override
  Widget buildError(BuildContext context, Object error) =>
      Text('error: $error', textDirection: TextDirection.ltr);

  @override
  Widget buildData(BuildContext context, AnimalLocationQueryData data) =>
      data.animal == null
      ? const Text('no animal', textDirection: TextDirection.ltr)
      : AnimalWithLocation(ref: data.animal!);
}
