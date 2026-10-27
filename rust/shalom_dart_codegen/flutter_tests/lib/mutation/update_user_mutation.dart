import 'package:shalom_annotations/shalom_annotations.dart';
import '__graphql__/UpdateUserMutation.mutation.shalom.dart';

@Mutation(r'''
($id: ID!, $name: String!) {
  updateUser(id: $id, name: $name) {
    id
    name
  }
}
''')
class UpdateUserMutation extends $UpdateUserMutation {
  const UpdateUserMutation(super.client);
}
