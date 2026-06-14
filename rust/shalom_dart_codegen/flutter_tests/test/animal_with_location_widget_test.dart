import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shalom/shalom.dart';
import '../lib/graphql/__graphql__/shalom_init.shalom.dart';
import 'package:flutter_tests/union_fragment/animal_location_query.dart';
import 'package:flutter_tests/union_fragment/__graphql__/AnimalLocationQuery.shalom.dart';
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
              'id': '3',
              'breed': 'Golden Retriever',
              'location': {'lat': 1.23, 'lng': 4.56},
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

  testWidgets(
    'AnimalLocationQuery: renders AnimalWithLocation (Dog) with nested location object',
    (tester) async {
      await tester.runAsync(
        () => tester.pumpWidget(
          ShalomProvider(
            client: _client,
            child: const Directionality(
              textDirection: TextDirection.ltr,
              child: AnimalLocationQuery(
                variables: AnimalLocationQueryVariables(id: '3'),
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

      expect(
        find.text('dog: Golden Retriever at (1.23, 4.56)'),
        findsOneWidget,
      );
    },
  );
}
