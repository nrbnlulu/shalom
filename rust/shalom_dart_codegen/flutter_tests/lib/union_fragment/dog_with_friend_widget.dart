import 'package:flutter/widgets.dart';
import 'package:shalom_annotations/shalom_annotations.dart';
import '__graphql__/DogWithFriendWidget.shalom.dart';

@Fragment(r'''
on Dog {
  id
  breed
  friend {
    ... on Cat {
      id
      color
    }
    ... on Dog {
      id
      breed
    }
  }
}
''')
class DogWithFriendWidget extends $DogWithFriendWidget {
  const DogWithFriendWidget({super.key, required super.ref});

  @override
  Widget buildData(BuildContext context, DogWithFriendWidgetData data) {
    final friend = data.friend;
    String friendText;
    if (friend == null) {
      friendText = 'no friend';
    } else if (friend is DogWithFriendWidget_friend$Cat) {
      friendText = 'cat: ${friend.color}';
    } else if (friend is DogWithFriendWidget_friend$Dog) {
      friendText = 'dog: ${friend.breed}';
    } else {
      friendText = 'unknown friend';
    }
    return Text(
      'dog: ${data.breed}, friend: $friendText',
      textDirection: TextDirection.ltr,
    );
  }
}
