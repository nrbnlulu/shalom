// ignore_for_file: unused_import
import 'package:flutter/widgets.dart';
import 'package:shalom/shalom.dart';
import 'package:shalom_flutter/shalom_flutter.dart' show ShalomInheritedWidget;

/// The GraphQL schema SDL inlined at code-generation time.
///
/// Use this to create the [ShalomRuntimeClient] — no async asset loading needed:
/// ```dart
/// final client = ShalomRuntimeClient.create(schemaSdl: kSchemaSdl, link: link);
/// ```
const String kSchemaSdl = r'''type Query {
  user(id: ID!): User
  pet(id: ID!): Pet
  animal(id: ID!): Animal
  animals: [Animal!]!
  zoo(id: ID!): Zoo
}

type Subscription {
  shelterAnimals: Animal!
  streetAnimals: Animal!
}

type Zoo {
  id: ID!
  name: String!
  cages: [Cage!]!
  animals: [Animal!]!
}

type Cage {
  id: ID!
  name: String!
}

type User {
  id: ID!
  name: String!
  email: String!
}

type Pet {
  id: ID!
  name: String!
}

interface Animal {
  id: ID!
}

interface HasFavoriteToy {
  favoriteToy: Toy!
}

type Toy {
  id: ID!
  label: String!
}

type Owner {
  id: ID!
  name: String!
}

type Dog implements Animal & HasFavoriteToy {
  id: ID!
  name: String!
  breed: String!
  owner: Owner
  favoriteToy: Toy!
}

type Cat implements Animal {
  id: ID!
  name: String!
  color: String!
}
''';

/// Register all @Query, @Fragment, @Mutation, and @Subscription operations with the Shalom client.
void registerShalomDefinitions(ShalomRuntimeClient client) {
  client.registerFragment(
    document: r'''
fragment UserIdentity on User {
  id
  name
}
''',
  );
  client.registerFragment(
    document: r'''
fragment UserCard on User {
  ...UserIdentity
  email
  id
}
''',
  );

  client.registerFragment(
    document: r'''
fragment PetWidget on Pet @observe {
  id
  name
}
''',
  );
  client.registerFragment(
    document: r'''
fragment AnimalWidget on Animal @observe {
  id
  ... on Dog {
    breed
  }
  ... on Cat {
    color
  }
}
''',
  );
  client.registerFragment(
    document: r'''
fragment ZooWidget on Zoo @observe {
  id
  name
  cages {
    id
    name
  }
}
''',
  );
  client.registerFragment(
    document: r'''
fragment DogFrag on Dog @observe {
  name
  breed
}
''',
  );
  client.registerFragment(
    document: r'''
fragment AnimalWithOwnerWidget on Animal @observe {
  id
  ... on Dog {
    breed
    owner {
      name
    }
  }
  ... on Cat {
    color
  }
}
''',
  );
  client.registerFragment(
    document: r'''
fragment ZooAnimalsWidget on Zoo @observe {
  id
  name
  animals {
    id
    ... on Dog {
      breed
    }
    ... on Cat {
      color
    }
  }
}
''',
  );
  client.registerFragment(
    document: r'''
fragment ToyFrag on Toy @observe {
  id
  label
}
''',
  );
  client.registerFragment(
    document: r'''
fragment HasFavoriteToyFrag on HasFavoriteToy @observe {
  favoriteToy {
    ...ToyFrag
  }
}
''',
  );
  client.registerFragment(
    document: r'''
fragment CommonAnimalFrag on Animal @observe {
  __typename
  id
}
''',
  );
  client.registerFragment(
    document: r'''
fragment DogFavoriteFrag on Dog @observe {
  ...CommonAnimalFrag
  breed
  ...HasFavoriteToyFrag
}
''',
  );
  client.registerFragment(
    document: r'''
fragment DogWithFavoriteToyFrag on Dog @observe {
  ...CommonAnimalFrag
  breed
  ...HasFavoriteToyFrag
}
''',
  );
  client.registerOperation(
    document: r'''
query UserWidget ($id: ID!) @observe {
  user(id: $id) {
    id
    name
  }
}
''',
  );
  client.registerOperation(
    document: r'''
query PetQuery ($id: ID!) @observe {
  pet(id: $id) {
    ...PetWidget
  }
}
''',
  );
  client.registerOperation(
    document: r'''
query AnimalQuery ($id: ID!) @observe {
  animal(id: $id) {
    ...AnimalWidget
  }
}
''',
  );
  client.registerOperation(
    document: r'''
query ZooQuery ($id: ID!) @observe {
  zoo(id: $id) {
    ...ZooWidget
  }
}
''',
  );
  client.registerOperation(
    document: r'''
query AnimalWithOwnerQuery ($id: ID!) @observe {
  animal(id: $id) {
    ...AnimalWithOwnerWidget
  }
}
''',
  );
  client.registerOperation(
    document: r'''
query ZooAnimalsQuery ($id: ID!) @observe {
  zoo(id: $id) {
    ...ZooAnimalsWidget
  }
}
''',
  );
  client.registerOperation(
    document: r'''
query ZooAnimalsContractQuery @observe {
  animals {
    __typename
    ...CommonAnimalFrag
    ...DogFavoriteFrag
    ...DogWithFavoriteToyFrag
  }
}
''',
  );
  client.registerOperation(
    document: r'''
query UserCardQuery ($id: ID!) @observe {
  user(id: $id) {
    ...UserCard
  }
}
''',
  );
  client.registerOperation(
    document: r'''
subscription ShelterSubscription @observe {
  shelterAnimals {
    ...DogFrag
  }
}
''',
  );
  client.registerOperation(
    document: r'''
subscription StreetSubscription @observe {
  streetAnimals {
    ...DogFrag
  }
}
''',
  );
}

/// Generated [ShalomProvider] for this app.
///
/// Place this at the root of your widget tree.  On hot-reload it automatically
/// reloads the schema and re-registers all operations and fragments so that any
/// SDL changes take effect without a full restart.
class ShalomProvider extends StatefulWidget {
  final ShalomRuntimeClient client;
  final Widget child;

  const ShalomProvider({super.key, required this.client, required this.child});

  @override
  State<ShalomProvider> createState() => _ShalomProviderState();
}

class _ShalomProviderState extends State<ShalomProvider> {
  @override
  void reassemble() {
    super.reassemble();
    widget.client.reloadSchema(schemaSdl: kSchemaSdl);
    registerShalomDefinitions(widget.client);
  }

  @override
  Widget build(BuildContext context) =>
      ShalomInheritedWidget(client: widget.client, child: widget.child);
}
