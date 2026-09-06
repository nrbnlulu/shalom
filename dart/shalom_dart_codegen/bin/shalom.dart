import 'dart:io';

import 'package:shalom_dart_codegen/shalom_dart_codegen.dart';

Future<void> main(List<String> arguments) async {
  try {
    final binary = await codegenBinary();
    final process = await Process.start(
      binary.path,
      arguments,
      mode: ProcessStartMode.inheritStdio,
    );
    exitCode = await process.exitCode;
  } on Object catch (error) {
    stderr.writeln('Failed to run Shalom codegen: $error');
    exitCode = 1;
  }
}
