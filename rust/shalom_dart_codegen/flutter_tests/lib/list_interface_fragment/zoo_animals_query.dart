import 'package:flutter/widgets.dart';
import 'package:shalom_annotations/shalom_annotations.dart';
import '__graphql__/ZooAnimalsQuery.widget.shalom.dart';
import 'zoo_animals_widget.dart';

@Query(r'''
($id: ID!) {
  zoo(id: $id) {
    ...ZooAnimalsWidget
  }
}
''')
class ZooAnimalsQuery extends $ZooAnimalsQuery {
  const ZooAnimalsQuery({super.key, required super.variables});

  @override
  Widget buildLoading(BuildContext context) =>
      const Text('loading', textDirection: TextDirection.ltr);

  @override
  Widget buildError(BuildContext context, Object error) =>
      Text('error: $error', textDirection: TextDirection.ltr);

  @override
  Widget buildData(BuildContext context, ZooAnimalsQueryData data) =>
      data.zoo == null
      ? const Text('no zoo', textDirection: TextDirection.ltr)
      : ZooAnimalsWidget(ref: data.zoo!);
}
