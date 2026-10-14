import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shalom/shalom.dart';
import '../lib/graphql/__graphql__/shalom_init.shalom.dart';
import 'package:flutter_tests/unwrap_fragment/unwrap_query.dart';
import 'package:flutter_tests/unwrap_fragment/__graphql__/UnwrapQuery.shalom.dart';
import 'package:flutter_tests/fragment/__graphql__/PetWidget.shalom.dart';
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
            'pet': {'id': '2', 'name': 'Rex'},
            'petUnwrapped': {'id': '2', 'name': 'Rex'},
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
    'UnwrapQuery: renders both the observed ref spread and the @unwrap spread',
    (tester) async {
      await tester.runAsync(
        () => tester.pumpWidget(
          ShalomProvider(
            client: _client,
            child: const Directionality(
              textDirection: TextDirection.ltr,
              child: UnwrapQuery(variables: UnwrapQueryVariables(id: '2')),
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

      // pet is resolved through the PetWidget's own ref/cache subscription.
      expect(find.text('pet: Rex'), findsOneWidget);
      // petUnwrapped is flattened directly onto UnwrapQueryData, no ref needed.
      expect(find.text('inline: Rex'), findsOneWidget);
    },
  );

  test(
    'UnwrapQueryData.fromJson decodes the @unwrap spread as plain fields',
    () {
      final data = UnwrapQueryData.fromJson({
        'pet': {
          r'$PetWidget': {
            '__shalom_observed_ref': {
              'observable_id': 'PetWidget',
              'anchor': 'Pet:2',
            },
          },
        },
        'petUnwrapped': {'id': '2', 'name': 'Rex'},
      });

      expect(data.petUnwrapped?.id, '2');
      expect(data.petUnwrapped?.name, 'Rex');
      // The inlined @unwrap type still implements the fragment interface.
      expect(data.petUnwrapped is PetWidget, true);
    },
  );
}
