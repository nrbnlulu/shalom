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
  zoo(id: ID!): Zoo
}

type Zoo {
  id: ID!
  name: String!
  cages: [Cage!]!
}

type Cage {
  id: ID!
  name: String!
}

type User {
  id: ID!
  name: String!
}

type Pet {
  id: ID!
  name: String!
}

interface Animal {
  id: ID!
}

type Dog implements Animal {
  id: ID!
  breed: String!
}

type Cat implements Animal {
  id: ID!
  color: String!
}
''';

/// Register all @Query, @Fragment, @Mutation, and @Subscription operations with the Shalom client.
void registerShalomDefinitions(ShalomRuntimeClient client) {
  client.registerFragment(document: r'''
fragment PetWidget on Pet @observe {
  id
  name
}
''');
  client.registerFragment(document: r'''
fragment ZooWidget on Zoo @observe {
  id
  name
  cages {
    id
    name
  }
}
''');
  client.registerFragment(document: r'''
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
  client.registerOperation(document: r'''
query PetQuery ($id: ID!) @observe {
  pet(id: $id) {
    ...PetWidget
  }
}
''');
  client.registerOperation(document: r'''
query ZooQuery ($id: ID!) @observe {
  zoo(id: $id) {
    ...ZooWidget
  }
}
''');
  client.registerOperation(document: r'''
query UserWidget ($id: ID!) @observe {
  user(id: $id) {
    id
    name
  }
}
''');
  client.registerOperation(document: r'''
query AnimalQuery ($id: ID!) @observe {
  animal(id: $id) {
    ...AnimalWidget
  }
}
''');
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