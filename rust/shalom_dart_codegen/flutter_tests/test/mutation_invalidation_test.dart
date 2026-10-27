import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shalom/shalom.dart';
import '../lib/graphql/__graphql__/shalom_init.shalom.dart';
import 'package:flutter_tests/query/user_widget.dart';
import 'package:flutter_tests/query/__graphql__/UserWidget.shalom.dart';
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
          GraphQLData(
            data: {
              'user': {'id': '1', 'name': 'Alice'},
            },
          ),
          GraphQLData(
            data: {
              'updateUser': {'id': '1', 'name': 'Alice Updated'},
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
      'completes matching active subscription stream (fires onDone)',
      () async {
        final stream = UserWidgetObservable(
          variables: const UserWidgetVariables(id: '1'),
        ).observe(client);

        final streamDone = Completer<void>();
        final sub = stream.listen(
          (_) {},
          onDone: () {
            streamDone.complete();
          },
        );

        // Wait for the initial response to arrive so subscription is active
        await Future<void>.delayed(const Duration(milliseconds: 200));

        expect(streamDone.isCompleted, isFalse);

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

        // Subscription stream must complete (fire onDone)
        await expectLater(
          streamDone.future.timeout(const Duration(seconds: 2)),
          completes,
        );

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

    testWidgets(
      'causes mounted widget to resubscribe and refetch updated data',
      (tester) async {
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

        // Allow widget's onDone to trigger resubscribe and network refetch
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 500)),
        );
        await tester.pump();

        expect(find.text('name: Bob'), findsOneWidget);
      },
    );
  });
}
