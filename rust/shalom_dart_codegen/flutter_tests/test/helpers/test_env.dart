import 'dart:io' show File, Platform;
import 'package:shalom/shalom.dart' as shalom;

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

Future<void> initTestEnv() async {
  await shalom.init(_nativeLibPath());
}

String loadSchemaSdl() {
  return File('lib/graphql/schema.graphql').readAsStringSync();
}
