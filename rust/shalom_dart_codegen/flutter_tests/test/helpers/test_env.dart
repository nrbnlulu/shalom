import 'dart:io' show File;
import 'package:shalom/shalom.dart' show ShalomRuntimeClient;
import 'package:shalom/testing.dart' show resolveNativeLibPath;

Future<void> initTestEnv() =>
    ShalomRuntimeClient.initFlutterRustBridge(
  nativeLibPath: resolveNativeLibPath(),
);

String loadSchemaSdl() {
  return File('lib/graphql/schema.graphql').readAsStringSync();
}
