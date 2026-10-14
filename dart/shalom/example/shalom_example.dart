import 'package:shalom/shalom.dart' as shalom;
import 'package:shalom/testing.dart';

Future<void> main() async {
  await shalom.ShalomRuntimeClient.initFlutterRustBridge(
    nativeLibPath: resolveNativeLibPath(),
  );
  print('Shalom initialized successfully!');
}
