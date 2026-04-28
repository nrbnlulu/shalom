import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shalom/shalom.dart';
import 'package:shalom_flutter/shalom_flutter.dart';
import '../__graphql__/shalom_init.shalom.dart';
import '../lib/fragment/pet_query.dart';
import '../lib/fragment/__graphql__/PetQuery.shalom.dart';
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
        GraphQLData(data: {
          'pet': {'id': '2', 'name': 'Rex'},
        }),
      ]),
    );
    await registerShalomDefinitions(_client);
  });

  tearDown(() async {
    await _client.dispose();
  });

  testWidgets('PetQuery: renders PetWidget via ref', (tester) async {
    await tester.runAsync(
      () => tester.pumpWidget(
        ShalomProvider(
          client: _client,
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: PetQuery(variables: PetQueryVariables(id: '2')),
          ),
        ),
      ),
    );

    expect(find.text('loading'), findsOneWidget);

    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 500)),
    );

    await tester.pump();

    // PetQuery will render PetWidget which outputs 'pet: Rex'
    expect(find.text('pet: Rex'), findsOneWidget);
  });
}
