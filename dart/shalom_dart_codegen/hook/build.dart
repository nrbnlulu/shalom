import 'package:hooks/hooks.dart';
import 'package:shalom_dart_codegen/shalom_dart_codegen.dart';

Future<void> main(List<String> arguments) async {
  await build(arguments, (input, _) async {
    if (input.userDefines['skip_download'] == true) return;
    await codegenBinary();
  });
}
