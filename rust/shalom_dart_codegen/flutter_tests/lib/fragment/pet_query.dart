import 'package:flutter/widgets.dart';
import 'package:shalom_annotations/shalom_annotations.dart';
import '__graphql__/PetQuery.widget.shalom.dart';
import 'pet_widget.dart';

@Query(r'''
($id: ID!) {
  pet(id: $id) {
    ...PetWidget
  }
}
''')
class PetQuery extends $PetQuery {
  const PetQuery({super.key, required super.variables});

  @override
  Widget buildLoading(BuildContext context) =>
      const Text('loading', textDirection: TextDirection.ltr);

  @override
  Widget buildError(BuildContext context, Object error) =>
      Text('error: $error', textDirection: TextDirection.ltr);

  @override
  Widget buildData(BuildContext context, PetQueryData data) =>
      data.pet == null
          ? const Text('no pet', textDirection: TextDirection.ltr)
          : PetWidget(ref: data.pet!);
}
