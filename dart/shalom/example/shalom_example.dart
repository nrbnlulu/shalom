import 'package:shalom/shalom.dart' as shalom;

Future<void> main() async {
  await shalom.ShalomRuntimeClient.initFlutterRustBridge(
    nativeLibPath: ".dart_tool/lib/libshalom_ffi.so",
  );
}
