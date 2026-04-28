import 'package:shalom_annotations/shalom_annotations.dart';

@Query(r'''
{
  user(id: "1") {
    id
    name
  }
}
''')
class GetUser {}
