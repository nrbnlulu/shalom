import 'dart:io' show File, Platform;
import 'package:shalom/shalom.dart' show ShalomRuntimeClient;

String _nativeLibPath() {
  if (Platform.isLinux) return '.dart_tool/lib/libshalom_ffi.so';
  if (Platform.isMacOS) return '.dart_tool/lib/libshalom_ffi.dylib';
  if (Platform.isWindows) return '.dart_tool/lib/shalom_ffi.dll';
  throw UnsupportedError('Unsupported platform: ${Platform.operatingSystem}');
}

Future<void> initTestEnv() =>
    ShalomRuntimeClient.initFlutterRustBridge(nativeLibPath: _nativeLibPath());

String loadSchemaSdl() {
  return File('lib/graphql/schema.graphql').readAsStringSync();
}
