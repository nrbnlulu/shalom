import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tests/graphql/__graphql__/shalom_init.shalom.dart'
    show registerShalomDefinitions, ShalomProvider;
import 'package:shalom/shalom.dart';
import 'package:flutter_tests/query/user_widget.dart';
import 'package:flutter_tests/query/__graphql__/UserWidget.widget.shalom.dart';
import 'package:flutter_tests/mutation/update_user_mutation.dart';
import 'helpers/mock_link.dart';
import 'helpers/test_env.dart';

void main() {
  setUpAll(() async {
    await initTestEnv();
  });

  group('mutation ref with invalidateOperations - subscription stream', () {
    late ShalomRuntimeClient client;

    setUp(() async {
      client = ShalomRuntimeClient.create(
        schemaSdl: loadSchemaSdl(),
        link: MockGraphQLLink([
          // 1. Initial query fetch
          GraphQLData(
            data: {
              'user': {'id': '1', 'name': 'Alice'},
            },
          ),
          // 2. Mutation execution
          GraphQLData(
            data: {
              'updateUser': {'id': '1', 'name': 'Alice Updated'},
            },
          ),
          // 3. Re-fetched query after cache invalidation
          GraphQLData(
            data: {
              'user': {'id': '1', 'name': 'Alice Refetched'},
            },
          ),
        ]),
      );
      registerShalomDefinitions(client);
    });

    tearDown(() async {
      await client.dispose();
    });

    test(
      'refetches fresh data on active subscription stream without closing',
      () async {
        final stream = UserWidgetObservable(
          variables: const UserWidgetVariables(id: '1'),
        ).observe(client);

        final received = <String>[];
        var streamCompleted = false;
        final sub = stream.listen(
          (response) {
            if (response case GraphQLData(data: final data)) {
              received.add(data.user!.name);
            }
          },
          onDone: () {
            streamCompleted = true;
          },
        );

        // Wait for the initial response to arrive so subscription is active
        await Future<void>.delayed(const Duration(milliseconds: 200));

        expect(received, ['Alice']);
        expect(streamCompleted, isFalse);

        // Execute mutation with invalidateOperations targeting UserWidget
        final mutation = UpdateUserMutation(client);
        final response = await mutation.execute(
          id: '1',
          name: 'Alice Updated',
          invalidateOperations: [
            OperationRef(
              operationName: $UserWidget.operation$Name(),
              variables: const UserWidgetVariables(id: '1').toShalomValue(),
            ),
          ],
        );

        expect(response, isA<GraphQLData>());

        // Allow refetched data to arrive on the active subscription
        await Future<void>.delayed(const Duration(milliseconds: 200));

        // Subscription stream must stay open and receive both the normalized mutation
        // update and the fresh refetched data from the network
        expect(streamCompleted, isFalse);
        expect(received, ['Alice', 'Alice Updated', 'Alice Refetched']);

        await sub.cancel();
      },
    );
  });

  group('mutation ref with invalidateOperations - widget refetch', () {
    late ShalomRuntimeClient client;

    setUp(() async {
      client = ShalomRuntimeClient.create(
        schemaSdl: loadSchemaSdl(),
        link: MockGraphQLLink([
          // 1. Initial query fetch
          GraphQLData(
            data: {
              'user': {'id': '1', 'name': 'Alice'},
            },
          ),
          // 2. Mutation execution
          GraphQLData(
            data: {
              'updateUser': {'id': '1', 'name': 'Bob'},
            },
          ),
          // 3. Re-fetched query after invalidation
          GraphQLData(
            data: {
              'user': {'id': '1', 'name': 'Bob'},
            },
          ),
        ]),
      );
      registerShalomDefinitions(client);
    });

    tearDown(() async {
      await client.dispose();
    });

    testWidgets('causes mounted widget to resubscribe and refetch updated data', (
      tester,
    ) async {
      await tester.runAsync(
        () => tester.pumpWidget(
          ShalomProvider(
            client: client,
            child: const Directionality(
              textDirection: TextDirection.ltr,
              child: UserWidget(variables: UserWidgetVariables(id: '1')),
            ),
          ),
        ),
      );

      expect(find.text('loading'), findsOneWidget);

      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 500)),
      );
      await tester.pump();
      expect(find.text('name: Alice'), findsOneWidget);

      // Fire mutation ref with invalidateOperations
      final mutation = UpdateUserMutation(client);
      await tester.runAsync(
        () => mutation.execute(
          id: '1',
          name: 'Bob',
          invalidateOperations: [
            OperationRef(operationName: $UserWidget.operation$Name()),
          ],
        ),
      );

      // Allow active subscription to refetch from the network and emit updated data
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 500)),
      );
      await tester.pump();

      expect(find.text('name: Bob'), findsOneWidget);
    });
  });
}
