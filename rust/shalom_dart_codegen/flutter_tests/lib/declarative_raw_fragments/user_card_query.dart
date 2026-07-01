import 'package:shalom_annotations/shalom_annotations.dart';

@Query(r'''
($id: ID!) {
  user(id: $id) {
    ...UserCard
  }
}
''')
class UserCardQuery {}
