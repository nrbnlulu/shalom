import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shalom/shalom.dart';
import 'package:shalom_flutter/shalom_flutter.dart';
import '../lib/graphql/__graphql__/shalom_init.shalom.dart';
import 'package:flutter_tests/nested_fragment/zoo_query.dart';
import 'package:flutter_tests/nested_fragment/__graphql__/ZooQuery.shalom.dart';
import 'helpers/mock_link.dart';
import 'helpers/test_env.dart';

void main() {
  setUpAll(() async {
    await initTestEnv();
  });

  late ShalomRuntimeClient _client;

  setUp(() async {
    _client = await ShalomRuntimeClient.init(
      schemaSdl: loadSchemaSdl(),
      link: MockGraphQLLink([
        GraphQLData(
          data: {
            'zoo': {
              'id': '1',
              'name': 'City Zoo',
              'cages': [
                {'id': 'c1', 'name': 'Lion Cage'},
                {'id': 'c2', 'name': 'Bird Cage'},
              ],
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

  testWidgets('ZooQuery: fragment with nested objects renders cage names', (
    tester,
  ) async {
    await tester.runAsync(
      () => tester.pumpWidget(
        ShalomProvider(
          client: _client,
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: ZooQuery(variables: ZooQueryVariables(id: '1')),
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
      find.text('zoo: City Zoo, cages: Lion Cage, Bird Cage'),
      findsOneWidget,
    );
  });
}
