import 'dart:io' show Platform;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shalom/shalom.dart';
import 'package:shalom/shalom.dart' as shalom;
import 'package:shalom_flutter/shalom_flutter.dart';
import '../helpers/mock_link.dart';
import '__graphql__/GetUser.widget.shalom.dart';
import '__graphql__/shalom_init.shalom.dart';

const _schemaSdl = '''
type Query {
  user(id: ID!): User
}
type User {
  id: ID!
  name: String!
}
''';

String _nativeLibPath() {
  final libDir =
      Platform.environment['FRB_DART_LOAD_EXTERNAL_LIBRARY_NATIVE_LIB_DIR'];
  if (Platform.isLinux) {
    return libDir != null
        ? '$libDir/libshalom_ffi.so'
        : '.dart_tool/lib/libshalom_ffi.so';
  }
  if (Platform.isMacOS) {
    return libDir != null
        ? '$libDir/libshalom_ffi.dylib'
        : '.dart_tool/lib/libshalom_ffi.dylib';
  }
  if (Platform.isWindows) {
    return libDir != null
        ? '$libDir/shalom_ffi.dll'
        : '.dart_tool/lib/shalom_ffi.dll';
  }
  throw UnsupportedError('Unsupported platform: ${Platform.operatingSystem}');
}

// Concrete test implementation of the generated abstract $GetUser widget.
class _TestGetUser extends $GetUser {
  const _TestGetUser({super.key});

  @override
  Widget buildLoading(BuildContext context) =>
      const Text('loading', textDirection: TextDirection.ltr);

  @override
  Widget buildError(BuildContext context, Object error) =>
      Text('error: $error', textDirection: TextDirection.ltr);

  @override
  Widget buildData(BuildContext context, GetUserData data) =>
      Text('name: ${data.user?.name ?? "(null)"}',
          textDirection: TextDirection.ltr);
}

void main() {
  setUpAll(() async {
    await shalom.init(_nativeLibPath());
  });

  // ---------------------------------------------------------------------------
  // setUp/tearDown run in the REAL async zone (outside testWidgets' FakeAsync),
  // so FRB async calls (which need the real event loop) work here.
  // ---------------------------------------------------------------------------

  late ShalomRuntimeClient _client;

  setUp(() async {
    _client = await ShalomRuntimeClient.init(
      schemaSdl: _schemaSdl,
      link: MockGraphQLLink([
        GraphQLData(data: {
          'user': {'id': '1', 'name': 'Alice'},
        }),
      ]),
    );
    // Uses the generated registration function so the SDL matches exactly
    // what the widget's _subscribe() will reference by name.
    await registerShalomDefinitions(_client);
  });

  tearDown(() async {
    await _client.dispose();
  });

  testWidgets('GetUser widget: shows loading state then renders user data',
      (tester) async {
    // _subscribe() (called from didChangeDependencies) kicks off an FRB async
    // call (rs_runtime.request).  FRB async calls need the REAL event loop to
    // complete their round-trip.  We therefore pump the widget inside
    // tester.runAsync so the real event loop is active when the subscription
    // starts.
    await tester.runAsync(
      () => tester.pumpWidget(
        ShalomProvider(
          client: _client,
          child: const _TestGetUser(),
        ),
      ),
    );

    // After the first frame the stream hasn't emitted yet: loading state.
    expect(find.text('loading'), findsOneWidget);

    // Re-enter the real event loop so the Rust tokio runtime can process the
    // mock-link response and push the first value into the subscription stream.
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(seconds: 3)),
    );

    // Process the queued setState() rebuild.
    await tester.pump();

    expect(find.text('name: Alice'), findsOneWidget);
  });
}
