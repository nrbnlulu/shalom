import 'package:shalom_annotations/shalom_annotations.dart';

@Mutation(r'''
($id: ID!, $name: String!) {
  updateUserName(id: $id, name: $name) {
    id
    name
  }
}
''')
class UpdateUserName {}
