import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shalom/shalom.dart';
import '../lib/graphql/__graphql__/shalom_init.shalom.dart';
import 'package:flutter_tests/union_fragment/dog_friend_query.dart';
import 'package:flutter_tests/union_fragment/__graphql__/DogFriendQuery.widget.shalom.dart';
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
            'dog': {
              '__typename': 'Dog',
              'id': '1',
              'breed': 'Labrador',
              'friend': {'__typename': 'Cat', 'id': '2', 'color': 'orange'},
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
    'DogFriendQuery: renders DogWithFriend with nested inline interface field',
    (tester) async {
      await tester.runAsync(
        () => tester.pumpWidget(
          ShalomProvider(
            client: _client,
            child: const Directionality(
              textDirection: TextDirection.ltr,
              child: DogFriendQuery(
                variables: DogFriendQueryVariables(id: '1'),
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

      expect(find.text('dog: Labrador, friend: cat: orange'), findsOneWidget);
    },
  );
}
