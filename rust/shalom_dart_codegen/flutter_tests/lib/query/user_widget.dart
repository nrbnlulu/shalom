import 'package:flutter/widgets.dart';
import 'package:shalom_annotations/shalom_annotations.dart';
import '__graphql__/UserWidget.widget.shalom.dart';

@Query(r'''
($id: ID!) {
  user(id: $id) {
    id
    name
  }
}
''')
class UserWidget extends $UserWidget {
  const UserWidget({super.key, required super.variables});

  @override
  Widget buildLoading(BuildContext context) =>
      const Text('loading', textDirection: TextDirection.ltr);

  @override
  Widget buildError(BuildContext context, Object error) =>
      Text('error: $error', textDirection: TextDirection.ltr);

  @override
  Widget buildData(BuildContext context, UserWidgetData data) => Text(
    'name: ${data.user?.name ?? "(null)"}',
    textDirection: TextDirection.ltr,
  );
}
