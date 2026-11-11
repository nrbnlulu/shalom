import 'dart:convert';

import 'package:shalom/shalom.dart';
import 'package:test/test.dart';

class _Transport implements ShalomMultipartHttpTransport {
  ShalomMultipartRequest? multipart;
  JsonObject? json;
  HeadersType? headers;
  HttpMethod? method;
  Object? error;
  bool consumeFiles = false;

  @override
  Future<String> request({
    required HttpMethod method,
    required String url,
    required JsonObject data,
    HeadersType? headers,
    JsonObject? extra,
  }) async {
    this.method = method;
    json = data;
    this.headers = headers;
    return '{"data":{"upload":"ok"}}';
  }

  @override
  Future<String> requestMultipart({
    required String url,
    required ShalomMultipartRequest data,
    HeadersType? headers,
    JsonObject? extra,
  }) async {
    if (error != null) throw error!;
    multipart = data;
    this.headers = headers;
    if (consumeFiles) {
      for (final file in data.files.values) {
        await for (final _ in file.openRead()) {}
      }
    }
    return '{"data":{"upload":"ok"}}';
  }
}

class _JsonOnly implements ShalomHttpTransport {
  @override
  Future<String> request({
    required HttpMethod method,
    required String url,
    required JsonObject data,
    HeadersType? headers,
    JsonObject? extra,
  }) async => throw StateError('Must not send upload as JSON');
}

Request _request(JsonObject variables, {bool query = false}) => Request(
  query: r'mutation Upload($file: Upload!) { upload(file: $file) }',
  variables: variables,
  opType: query ? OperationType.Query : OperationType.Mutation,
  opName: 'Upload',
);

ShalomUpload _upload({
  required String filename,
  required List<int> bytes,
  String contentType = 'application/octet-stream',
}) {
  final upload = ShalomUpload(
    filename: filename,
    bytes: bytes,
    contentType: contentType,
  );
  addTearDown(upload.dispose);
  return upload;
}

Future<List<int>> _read(ShalomUpload upload) =>
    upload.openRead().expand((chunk) => chunk).toList();

void main() {
  late ShalomUpload png;
  setUp(() {
    png = _upload(
      filename: 'photo.png',
      bytes: [137, 80, 78, 71],
      contentType: 'image/png',
    );
  });

  test(
    'nested lists, nulls and repeated files produce multipart paths',
    () async {
      final input = {
        'file': png.toJson(),
        'input': {
          'caption': 'hello',
          'files': [
            null,
            png.toJson(),
            _upload(filename: 'empty', bytes: []).toJson(),
          ],
        },
      };
      final before = jsonEncode(input);
      final multipart = ShalomMultipartRequest.fromRequest(_request(input));
      expect(multipart.operations['variables'], {
        'file': null,
        'input': {
          'caption': 'hello',
          'files': [null, null, null],
        },
      });
      expect(multipart.fileMap, {
        '0': ['variables.file', 'variables.input.files.1'],
        '1': ['variables.input.files.2'],
      });
      expect(multipart.files['0']!.filename, 'photo.png');
      expect(multipart.files['0']!.contentType, 'image/png');
      expect(multipart.files['0'], same(png));
      expect(await _read(multipart.files['0']!), [137, 80, 78, 71]);
      expect(await _read(multipart.files['1']!), isEmpty);
      expect(jsonEncode(input), before);
    },
  );

  test(
    'scalar JSON contains only a stable ID and resolves the same source',
    () async {
      final bytes = [1, 2, 3];
      final upload = _upload(filename: 'a.bin', bytes: bytes);
      bytes[0] = 99;
      final marker = shalomUploadScalar.serialize(upload);
      expect(marker.keys, [r'$shalom.upload']);
      expect(marker[r'$shalom.upload'], isA<String>());
      expect(upload.toJson(), marker);
      final roundtrip = shalomUploadScalar.deserialize(
        shalomJsonValue(marker).toJsonValue(),
      );
      expect(roundtrip, same(upload));
      expect(await _read(roundtrip), [1, 2, 3]);
      expect(
        _upload(filename: 'a.bin', bytes: [1, 2, 3]).toJson(),
        isNot(marker),
      );
    },
  );

  test(
    'huge sources stay lazy through serialization and multipart extraction',
    () async {
      var opens = 0;
      final upload = ShalomUpload.stream(
        filename: 'huge.bin',
        length: 1 << 40,
        openRead: () {
          opens++;
          return Stream.value([1, 2, 3]);
        },
      );
      addTearDown(upload.dispose);
      final variables =
          shalomJsonValue({'file': upload.toJson()}).toJsonValue()
              as JsonObject;
      final multipart = ShalomMultipartRequest.fromRequest(_request(variables));
      expect(opens, 0);
      expect(jsonEncode(variables).length, lessThan(80));
      expect(multipart.files['0']!.length, 1 << 40);
      final results = await Future.wait([
        _read(multipart.files['0']!),
        _read(multipart.files['0']!),
      ]);
      expect(results, [
        [1, 2, 3],
        [1, 2, 3],
      ]);
      expect(opens, 2);
    },
  );

  test('disposal releases the ID and prohibits reuse', () {
    final upload = _upload(filename: 'a', bytes: [1]);
    final marker = upload.toJson();
    upload.dispose();
    upload.dispose();
    expect(() => ShalomUpload.fromJson(marker), throwsFormatException);
    expect(upload.toJson, throwsStateError);
    expect(upload.openRead, throwsStateError);
  });

  test('different sources with identical metadata do not share a part', () {
    final other = _upload(
      filename: png.filename,
      bytes: [137, 80, 78, 71],
      contentType: png.contentType,
    );
    final multipart = ShalomMultipartRequest.fromRequest(
      _request({'first': png.toJson(), 'second': other.toJson()}),
    );
    expect(multipart.files.length, 2);
  });

  test(
    'concurrent HTTP sends open independent streams and retain the ID',
    () async {
      var opens = 0;
      final upload = ShalomUpload.stream(
        filename: 'stream',
        length: 3,
        openRead: () {
          opens++;
          return Stream.fromIterable([
            [1],
            [2, 3],
          ]);
        },
      );
      addTearDown(upload.dispose);
      final marker = upload.toJson();
      final link = HttpLink(
        transportLayer: _Transport()..consumeFiles = true,
        url: '/',
      );
      final results = await Future.wait([
        link.request(request: _request({'file': marker})).single,
        link.request(request: _request({'file': marker})).single,
      ]);
      expect(results, everyElement(isA<GraphQLData>()));
      expect(opens, 2);
      expect(ShalomUpload.fromJson(marker), same(upload));
    },
  );

  test(
    'stream failures become link errors and caller finally releases the ID',
    () async {
      final upload = ShalomUpload.stream(
        filename: 'unreadable',
        length: 1,
        openRead: () => Stream.error(StateError('read failed')),
      );
      final marker = upload.toJson();
      try {
        final result = await HttpLink(
          transportLayer: _Transport()..consumeFiles = true,
          url: '/',
        ).request(request: _request({'file': marker})).single;
        expect(result, isA<LinkExceptionResponse>());
      } finally {
        upload.dispose();
      }
      expect(() => ShalomUpload.fromJson(marker), throwsFormatException);
    },
  );

  test('negative stream lengths are rejected without opening a stream', () {
    expect(
      () => ShalomUpload.stream(
        filename: 'bad',
        length: -1,
        openRead: () => throw StateError('must not open'),
      ),
      throwsArgumentError,
    );
  });

  test('unknown and disposed IDs fail before invoking the transport', () async {
    final stale = png.toJson();
    png.dispose();
    for (final marker in [
      stale,
      {r'$shalom.upload': 'unknown'},
    ]) {
      final transport = _Transport();
      final result = await HttpLink(
        transportLayer: transport,
        url: '/',
      ).request(request: _request({'file': marker})).single;
      expect(result, isA<LinkExceptionResponse>());
      expect(transport.multipart, isNull);
      expect(transport.json, isNull);
    }
  });

  test(
    'multipart overrides GET and strips content type case insensitively',
    () async {
      final transport = _Transport();
      final link = HttpLink(
        transportLayer: transport,
        url: 'http://example.test/graphql',
        useGet: true,
        defaultHeaders: [
          ('Content-Type', 'application/json'),
          ('Authorization', 'Bearer token'),
        ],
      );
      final response = await link
          .request(
            request: _request({'file': png.toJson()}, query: true),
            headers: [
              ('content-type', 'text/plain'),
              ('accept', 'application/json'),
              ('X-Test', 'yes'),
            ],
          )
          .single;
      expect(response, isA<GraphQLData>());
      expect(transport.json, isNull);
      expect(transport.multipart!.operations['operationName'], 'Upload');
      expect(transport.headers, [
        ('Authorization', 'Bearer token'),
        ('accept', 'application/json'),
        ('X-Test', 'yes'),
      ]);
    },
  );

  test('ordinary POST and GET keep their existing encoding', () async {
    final transport = _Transport();
    for (final useGet in [false, true]) {
      await HttpLink(
        transportLayer: transport,
        url: '/',
        useGet: useGet,
      ).request(request: _request({'text': 'hello'}, query: true)).single;
      expect(transport.method, useGet ? HttpMethod.GET : HttpMethod.POST);
      expect(
        transport.json!['variables'],
        useGet ? '{"text":"hello"}' : {'text': 'hello'},
      );
      expect(transport.multipart, isNull);
    }
  });

  test('unsupported transport returns a link error', () async {
    final result = await HttpLink(
      transportLayer: _JsonOnly(),
      url: '/',
    ).request(request: _request({'file': png.toJson()})).single;
    expect(result, isA<LinkExceptionResponse>());
    expect(
      ((result as LinkExceptionResponse).errors.single
              as ShalomTransportException)
          .message,
      contains('ShalomMultipartHttpTransport'),
    );
  });

  test('multipart transport failures return a link error', () async {
    final result = await HttpLink(
      transportLayer: _Transport()..error = StateError('offline'),
      url: '/',
    ).request(request: _request({'file': png.toJson()})).single;
    expect(result, isA<LinkExceptionResponse>());
  });

  test('malformed upload fails before invoking the transport', () async {
    final transport = _Transport();
    final result = await HttpLink(transportLayer: transport, url: '/')
        .request(
          request: _request({
            r'file': {r'$shalom.upload': {}},
          }),
        )
        .single;
    expect(result, isA<LinkExceptionResponse>());
    expect(transport.multipart, isNull);
    expect(transport.json, isNull);
  });
}
