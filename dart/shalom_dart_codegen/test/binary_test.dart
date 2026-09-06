import 'dart:ffi';
import 'dart:io';

import 'package:shalom_dart_codegen/shalom_dart_codegen.dart';
import 'package:test/test.dart';

void main() {
  test('maps supported host ABIs to release assets', () {
    expect(releaseAssetName(Abi.linuxX64), 'shalom-linux-x64');
    expect(releaseAssetName(Abi.linuxArm64), 'shalom-linux-arm64');
    expect(releaseAssetName(Abi.macosX64), 'shalom-macos-x64');
    expect(releaseAssetName(Abi.macosArm64), 'shalom-macos-arm64');
    expect(releaseAssetName(Abi.windowsX64), 'shalom-windows-x64.exe');
    expect(releaseAssetName(Abi.windowsArm64), 'shalom-windows-arm64.exe');
  });

  test('uses the package version in the GitHub release URL', () {
    expect(
      releaseDownloadUri(Abi.linuxX64).toString(),
      'https://github.com/nrbnlulu/shalom/releases/download/'
      'shalom_dart_codegen-v$codegenVersion/shalom-linux-x64',
    );
  });

  test('downloads and caches the host binary', () async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    final request = server.first.then((request) async {
      request.response.add([1, 2, 3]);
      await request.response.close();
    });
    final cache = await Directory.systemTemp.createTemp('shalom-codegen-test-');

    try {
      final uri = Uri.parse('http://${server.address.host}:${server.port}/bin');
      final binary = await codegenBinary(
        abi: Abi.linuxX64,
        homeDirectory: cache.path,
        downloadUri: uri,
      );

      expect(await binary.readAsBytes(), [1, 2, 3]);
      expect(
        (await codegenBinary(
          abi: Abi.linuxX64,
          homeDirectory: cache.path,
          downloadUri: Uri.parse('http://invalid.invalid'),
        )).path,
        binary.path,
      );
      await request;
    } finally {
      await server.close(force: true);
      await cache.delete(recursive: true);
    }
  });
}
