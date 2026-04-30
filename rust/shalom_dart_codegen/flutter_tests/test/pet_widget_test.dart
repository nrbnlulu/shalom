import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shalom/shalom.dart';
import 'package:shalom_flutter/shalom_flutter.dart';
import '../__graphql__/shalom_init.shalom.dart';
import 'package:flutter_tests/fragment/pet_query.dart';
import 'package:flutter_tests/fragment/__graphql__/PetQuery.shalom.dart';
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
            'pet': {'id': '2', 'name': 'Rex'},
          },
        ),
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

    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 500));
      await tester.pump();
      await Future<void>.delayed(const Duration(milliseconds: 300));
      await tester.pump();
    });

    expect(find.text('pet: Rex'), findsOneWidget);
  });
}
