import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shalom/shalom.dart';
import '../lib/graphql/__graphql__/shalom_init.shalom.dart';
import 'package:flutter_tests/union_fragment_nested_object/animal_with_owner_query.dart';
import 'package:flutter_tests/union_fragment_nested_object/__graphql__/AnimalWithOwnerQuery.shalom.dart';
import 'helpers/mock_link.dart';
import 'helpers/test_env.dart';

void main() {
  setUpAll(() async {
    await initTestEnv();
  });

  late ShalomRuntimeClient _client;

  setUp(() async {
    _client = ShalomRuntimeClient.create(
      schemaSdl: loadSchemaSdl(),
      link: MockGraphQLLink([
        GraphQLData(
          data: {
            'animal': {
              '__typename': 'Dog',
              'id': '7',
              'breed': 'Labrador',
              'owner': {'id': '42', 'name': 'Alice'},
            },
          },
        ),
      ]),
    );
    registerShalomDefinitions(_client);
  });

  tearDown(() async {
    await _client.dispose();
  });

  testWidgets('AnimalWithOwnerQuery: renders Dog with nested owner object', (
    tester,
  ) async {
    await tester.runAsync(
      () => tester.pumpWidget(
        ShalomProvider(
          client: _client,
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: AnimalWithOwnerQuery(
              variables: AnimalWithOwnerQueryVariables(id: '7'),
            ),
          ),
        ),
      ),
    );

    expect(find.text('loading'), findsOneWidget);

    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 500));
      await tester.pump();
      await Future<void>.delayed(const Duration(milliseconds: 300));
      await tester.pump();
    });

    expect(find.text('dog: Labrador, owner: Alice'), findsOneWidget);
  });
}
