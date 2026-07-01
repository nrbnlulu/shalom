import 'package:shalom/shalom.dart' as shalom;

Future<void> main() async {
  await shalom.init(".dart_tool/lib/libshalom_ffi.so");
}
