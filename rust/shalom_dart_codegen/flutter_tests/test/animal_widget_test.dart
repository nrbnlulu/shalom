import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shalom/shalom.dart';
import 'package:shalom_flutter/shalom_flutter.dart';
import '../__graphql__/shalom_init.shalom.dart';
import 'package:flutter_tests/union_fragment/animal_query.dart';
import 'package:flutter_tests/union_fragment/__graphql__/AnimalQuery.shalom.dart';
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

    await tester.runAsync(() async {
      // Wait for the network round-trip, normalization, and AnimalQuery subscription.
      await Future<void>.delayed(const Duration(milliseconds: 500));
      // First pump inside runAsync: AnimalQuery data arrives → renders AnimalWidget →
      // fragment subscription is created → Rust immediately emits cached fragment data.
      await tester.pump();
      // Give the Rust native-port time to deliver the fragment data to Dart.
      await Future<void>.delayed(const Duration(milliseconds: 300));
      // Second pump: AnimalWidget rebuilds with the fragment data.
      await tester.pump();
    });

    // AnimalQuery renders AnimalWidget which outputs 'dog: Golden Retriever'
    expect(find.text('dog: Golden Retriever'), findsOneWidget);
  });
}
