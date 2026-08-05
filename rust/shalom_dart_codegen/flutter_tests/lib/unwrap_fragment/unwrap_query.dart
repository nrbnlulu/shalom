import 'package:flutter/widgets.dart';
import 'package:shalom_annotations/shalom_annotations.dart';
import '__graphql__/UnwrapQuery.widget.shalom.dart';
import '../fragment/pet_widget.dart';

@Query(r'''
($id: ID!) {
  pet(id: $id) {
    ...PetWidget
  }
  petUnwrapped(id: $id) {
    ...PetWidget @unwrap
  }
}
''')
class UnwrapQuery extends $UnwrapQuery {
  const UnwrapQuery({super.key, required super.variables});

  @override
  Widget buildLoading(BuildContext context) =>
      const Text('loading', textDirection: TextDirection.ltr);

  @override
  Widget buildError(BuildContext context, Object error) =>
      Text('error: $error', textDirection: TextDirection.ltr);

  @override
  Widget buildData(BuildContext context, UnwrapQueryData data) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        children: [
          if (data.pet != null) PetWidget(ref: data.pet!),
          Text('inline: ${data.petUnwrapped?.name}'),
        ],
      ),
    );
  }
}
