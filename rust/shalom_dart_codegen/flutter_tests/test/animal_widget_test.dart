import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shalom/shalom.dart';
import 'package:shalom_flutter/shalom_flutter.dart';
import '../__graphql__/shalom_init.shalom.dart';
import '../lib/union_fragment/animal_query.dart';
import '../lib/union_fragment/__graphql__/AnimalQuery.shalom.dart';
import 'helpers/mock_link.dart';
import 'helpers/test_env.dart';

const _schemaSdl = '''
type Query {
  user(id: ID!): User
  pet(id: ID!): Pet
  animal(id: ID!): Animal
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

void main() {
  setUpAll(() async {
    await initTestEnv();
  });

  late ShalomRuntimeClient _client;

  setUp(() async {
    _client = await ShalomRuntimeClient.init(
      schemaSdl: _schemaSdl,
      link: MockGraphQLLink([
        GraphQLData(
          data: {
            'animal': {
              '__typename': 'Dog',
              'id': '3',
              'breed': 'Golden Retriever',
            },
          },
        ),
      ]),
    );
    await registerShalomDefinitions(_client);
  });

  tearDown(() async {
    await _client.dispose();
  });

  testWidgets('AnimalQuery: renders AnimalWidget (Dog) via ref', (
    tester,
  ) async {
    await tester.runAsync(
      () => tester.pumpWidget(
        ShalomProvider(
          client: _client,
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: AnimalQuery(variables: AnimalQueryVariables(id: '3')),
          ),
        ),
      ),
    );

    expect(find.text('loading'), findsOneWidget);

    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 500)),
    );

    await tester.pump();

    // AnimalQuery renders AnimalWidget which outputs 'dog: Golden Retriever'
    expect(find.text('dog: Golden Retriever'), findsOneWidget);
  });
}
