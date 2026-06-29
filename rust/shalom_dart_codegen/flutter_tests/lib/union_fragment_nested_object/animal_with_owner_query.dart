import 'package:flutter/widgets.dart';
import 'package:shalom_annotations/shalom_annotations.dart';
import '__graphql__/AnimalWithOwnerQuery.widget.shalom.dart';
import 'animal_with_owner_widget.dart';

@Query(r'''
($id: ID!) {
  animal(id: $id) {
    ...AnimalWithOwnerWidget
  }
}
''')
class AnimalWithOwnerQuery extends $AnimalWithOwnerQuery {
  const AnimalWithOwnerQuery({super.key, required super.variables});

  @override
  Widget buildLoading(BuildContext context) =>
      const Text('loading', textDirection: TextDirection.ltr);

  @override
  Widget buildError(BuildContext context, Object error) =>
      Text('error: $error', textDirection: TextDirection.ltr);

  @override
  Widget buildData(BuildContext context, AnimalWithOwnerQueryData data) =>
      data.animal == null
      ? const Text('no animal', textDirection: TextDirection.ltr)
      : AnimalWithOwnerWidget(ref: data.animal!);
}
