import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shalom/shalom.dart';
import 'package:shalom_flutter/shalom_flutter.dart';
import 'helpers/mock_link.dart';
import 'helpers/test_env.dart';

void main() {
  setUpAll(() async {
    await initTestEnv();
  });

  late ShalomRuntimeClient client;

  setUp(() {
    client = ShalomRuntimeClient.create(
      schemaSdl: loadSchemaSdl(),
      link: MockGraphQLLink([]),
    );
  });

  tearDown(() async {
    await client.dispose();
  });

  testWidgets(
    'ShalomDataScope does not resubscribe for provider generation changes',
    (tester) async {
      final updates = StreamController<GraphQLResponse<String>>(sync: true);
      var subscribeCount = 0;

      Widget build({required int generation}) {
        return ShalomInheritedWidget(
          client: client,
          generation: generation,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: ShalomDataScope<String>(
              identity: 'value',
              observe: (_) {
                subscribeCount += 1;
                return updates.stream;
              },
              loadingBuilder: (_) => const Text('loading'),
              builder: (_, data) => Text(data),
            ),
          ),
        );
      }

      await tester.pumpWidget(build(generation: 0));

      expect(subscribeCount, 1);
      expect(find.text('loading'), findsOneWidget);

      await tester.pumpWidget(build(generation: 1));

      expect(subscribeCount, 1);

      updates.add(const GraphQLData(data: 'ready'));
      await tester.pump();

      expect(find.text('ready'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
    },
  );
}
