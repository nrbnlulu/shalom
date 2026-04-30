import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shalom/shalom.dart';
import 'package:shalom_flutter/shalom_flutter.dart';
import '../__graphql__/shalom_init.shalom.dart';
import 'package:flutter_tests/query/user_widget.dart';
import 'package:flutter_tests/query/__graphql__/UserWidget.shalom.dart';
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
            'user': {'id': '1', 'name': 'Alice'},
          },
        ),
      ]),
    );
    await registerShalomDefinitions(_client);
  });

  tearDown(() async {
    await _client.dispose();
  });

  testWidgets('UserWidget: shows loading state then renders user data', (
    tester,
  ) async {
    await tester.runAsync(
      () => tester.pumpWidget(
        ShalomProvider(
          client: _client,
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
  });
}
