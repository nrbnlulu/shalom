import 'dart:ui' show Size;

import 'package:flutter_test/flutter_test.dart';
import 'package:gif_search/graphql/__graphql__/shalom_init.shalom.dart';
import 'package:gif_search/main.dart';
import 'package:shalom/shalom.dart';
import 'package:shalom/testing.dart';

class _DummyLink extends GraphQLLink {
  _DummyLink();

  @override
  Stream<GraphQLResponse<GraphQLLinkPayload>> request({
    required Request request,
    HeadersType? headers,
  }) {
    return const Stream.empty();
  }
}

void main() {
  setUpAll(() async {
    await ShalomRuntimeClient.initFlutterRustBridge(
      nativeLibPath: resolveNativeLibPath(),
    );
  });

  late ShalomRuntimeClient client;

  setUp(() {
    client = ShalomRuntimeClient.create(
      schemaSdl: kSchemaSdl,
      link: _DummyLink(),
    );
    registerShalomDefinitions(client);
  });

  tearDown(() async {
    await client.dispose();
  });

  testWidgets('renders main app widget', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.runAsync(() async {
      await tester.pumpWidget(MyApp(client: client));
    });

    expect(find.byType(MyApp), findsOneWidget);
  });
}

