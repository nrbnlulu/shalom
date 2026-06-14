import 'package:flutter/widgets.dart';
import 'package:shalom_annotations/shalom_annotations.dart';
import '__graphql__/DogFriendQuery.widget.shalom.dart';
import 'dog_with_friend_widget.dart';

@Query(r'''
($id: ID!) {
  dog(id: $id) {
    ...DogWithFriendWidget
  }
}
''')
class DogFriendQuery extends $DogFriendQuery {
  const DogFriendQuery({super.key, required super.variables});

  @override
  Widget buildLoading(BuildContext context) =>
      const Text('loading', textDirection: TextDirection.ltr);

  @override
  Widget buildError(BuildContext context, Object error) =>
      Text('error: $error', textDirection: TextDirection.ltr);

  @override
  Widget buildData(BuildContext context, DogFriendQueryData data) =>
      data.dog == null
      ? const Text('no dog', textDirection: TextDirection.ltr)
      : DogWithFriendWidget(ref: data.dog!);
}
