import 'package:shalom_annotations/shalom_annotations.dart';

@Fragment(r'''
on Animal {
  id
  ... on Dog {
    breed
  }
  ... on Cat {
    color
  }
}
''')
class AnimalFrag {}
