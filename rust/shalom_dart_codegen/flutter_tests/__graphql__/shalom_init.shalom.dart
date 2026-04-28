// ignore_for_file: unused_import
import 'package:shalom/shalom.dart';

/// Register all @Query and @Fragment operations with the Shalom client.
Future<void> registerShalomDefinitions(ShalomRuntimeClient client) async {
  await client.registerOperation(document: r'''
query PetQuery ($id: ID!) @observe {
  pet(id: $id) {
    ...PetWidget
  }
}
''');
  await client.registerFragment(document: r'''
fragment PetWidget on Pet @observe {
  id
  name
}
''');
  await client.registerOperation(document: r'''
query UserWidget ($id: ID!) @observe {
  user(id: $id) {
    id
    name
  }
}
''');
  await client.registerOperation(document: r'''
query AnimalQuery ($id: ID!) @observe {
  animal(id: $id) {
    ...AnimalWidget
  }
}
''');
  await client.registerFragment(document: r'''
fragment AnimalWidget on Animal @observe {
  id
  ... on Dog {
    breed
  }
  ... on Cat {
    color
  }
}
''');
}