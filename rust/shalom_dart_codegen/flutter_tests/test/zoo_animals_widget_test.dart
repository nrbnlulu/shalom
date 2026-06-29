import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shalom/shalom.dart';
import '../lib/graphql/__graphql__/shalom_init.shalom.dart';
import 'package:flutter_tests/list_interface_fragment/zoo_animals_query.dart';
import 'package:flutter_tests/list_interface_fragment/__graphql__/ZooAnimalsQuery.shalom.dart';
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
            'zoo': {
              'id': '1',
              'name': 'City Zoo',
              'animals': [
                {'__typename': 'Dog', 'id': 'a1', 'breed': 'Beagle'},
                {'__typename': 'Cat', 'id': 'a2', 'color': 'black'},
              ],
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
    'ZooAnimalsQuery: fragment with list of interface renders animals',
    (tester) async {
      await tester.runAsync(
        () => tester.pumpWidget(
          ShalomProvider(
            client: _client,
            child: const Directionality(
              textDirection: TextDirection.ltr,
              child: ZooAnimalsQuery(
                variables: ZooAnimalsQueryVariables(id: '1'),
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
        find.text('zoo: City Zoo, animals: dog:Beagle, cat:black'),
        findsOneWidget,
      );
    },
  );
}
