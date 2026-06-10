import 'package:shalom_annotations/shalom_annotations.dart';

@Fragment(r'''
on User {
  id
  email
  profileImage
}
''')
class ProfileCard {}

@Mutation(r'''
($id: ID!, $name: String!) {
  updateUserName(id: $id, name: $name) {
    id
    name
  }
}
''')
class UpdateUserName {}

@Mutation(r'''
($input: UpdateProfileInput!) {
  updateUserProfile(input: $input) {
    id
    ...ProfileCard
  }
}
''')
class UpdateUserProfile {}
