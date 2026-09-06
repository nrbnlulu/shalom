import 'dart:ffi';
import 'dart:io';

const codegenVersion = '0.1.0'; // x-release-please-version

const _repository = 'https://github.com/nrbnlulu/shalom';

String releaseAssetName([Abi? abi]) => switch (abi ?? Abi.current()) {
  Abi.linuxX64 => 'shalom-linux-x64',
  Abi.linuxArm64 => 'shalom-linux-arm64',
  Abi.macosX64 => 'shalom-macos-x64',
  Abi.macosArm64 => 'shalom-macos-arm64',
  Abi.windowsX64 => 'shalom-windows-x64.exe',
  Abi.windowsArm64 => 'shalom-windows-arm64.exe',
  final unsupported => throw UnsupportedError(
    'Shalom codegen does not provide a binary for $unsupported.',
  ),
};

Uri releaseDownloadUri([Abi? abi]) => Uri.parse(
  '$_repository/releases/download/'
  'shalom_dart_codegen-v$codegenVersion/${releaseAssetName(abi)}',
);

Future<File> codegenBinary({
  Abi? abi,
  String? homeDirectory,
  HttpClient? httpClient,
  Uri? downloadUri,
}) async {
  final override = Platform.environment['SHALOM_CODEGEN_BINARY'];
  if (override != null && override.isNotEmpty) {
    final file = File(override);
    if (!await file.exists()) {
      throw StateError('SHALOM_CODEGEN_BINARY does not exist: $override');
    }
    return file;
  }

  final home =
      homeDirectory ??
      Platform.environment[Platform.isWindows ? 'USERPROFILE' : 'HOME'];
  if (home == null || home.isEmpty) {
    throw StateError('Could not determine the user home directory.');
  }

  final cacheDirectory = Directory.fromUri(
    Directory(home).uri.resolve('.cache/shalom_dart_codegen/$codegenVersion/'),
  );
  final binary = File.fromUri(
    cacheDirectory.uri.resolve(releaseAssetName(abi)),
  );
  if (await binary.exists() && await binary.length() > 0) {
    return binary;
  }

  await cacheDirectory.create(recursive: true);
  final temporary = File('${binary.path}.download-$pid');
  final client = httpClient ?? HttpClient();
  final uri = downloadUri ?? releaseDownloadUri(abi);

  try {
    final request = await client.getUrl(uri);
    request.headers.set(
      HttpHeaders.userAgentHeader,
      'shalom_dart_codegen/$codegenVersion',
    );
    final response = await request.close();
    if (response.statusCode != HttpStatus.ok) {
      await response.drain<void>();
      throw HttpException(
        'Failed to download Shalom codegen '
        '(HTTP ${response.statusCode}).',
        uri: uri,
      );
    }

    await response.pipe(temporary.openWrite());
    if (!Platform.isWindows) {
      final chmod = await Process.run('chmod', ['+x', temporary.path]);
      if (chmod.exitCode != 0) {
        throw ProcessException(
          'chmod',
          ['+x', temporary.path],
          '${chmod.stderr}',
          chmod.exitCode,
        );
      }
    }

    try {
      await temporary.rename(binary.path);
    } on FileSystemException {
      if (!await binary.exists()) rethrow;
    }
    return binary;
  } finally {
    if (httpClient == null) client.close();
    if (await temporary.exists()) await temporary.delete();
  }
}
