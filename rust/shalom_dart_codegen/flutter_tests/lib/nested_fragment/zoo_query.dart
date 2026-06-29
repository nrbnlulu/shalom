import 'package:flutter/widgets.dart';
import 'package:shalom_annotations/shalom_annotations.dart';
import '__graphql__/ZooQuery.widget.shalom.dart';
import 'zoo_widget.dart';

@Query(r'''
($id: ID!) {
  zoo(id: $id) {
    ...ZooWidget
  }
}
''')
class ZooQuery extends $ZooQuery {
  const ZooQuery({super.key, required super.variables});

  @override
  Widget buildLoading(BuildContext context) =>
      const Text('loading', textDirection: TextDirection.ltr);

  @override
  Widget buildError(BuildContext context, Object error) =>
      Text('error: $error', textDirection: TextDirection.ltr);

  @override
  Widget buildData(BuildContext context, ZooQueryData data) => data.zoo == null
      ? const Text('no zoo', textDirection: TextDirection.ltr)
      : ZooWidget(ref: data.zoo!);
}
