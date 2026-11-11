import 'dart:convert';

import 'package:shalom/shalom.dart';
import 'package:test/test.dart';

class _Transport implements ShalomMultipartHttpTransport {
  ShalomMultipartRequest? multipart;
  JsonObject? json;
  HeadersType? headers;
  HttpMethod? method;
  Object? error;

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

void main() {
  final png = ShalomUpload(
    filename: 'photo.png',
    bytes: [137, 80, 78, 71],
    contentType: 'image/png',
  );

  test('nested lists, nulls and repeated files produce multipart paths', () {
    final input = {
      'file': png.toJson(),
      'input': {
        'caption': 'hello',
        'files': [
          null,
          png.toJson(),
          ShalomUpload(filename: 'empty', bytes: []).toJson(),
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
    expect(multipart.files['0']!.bytes, png.bytes);
    expect(multipart.files['1']!.bytes, isEmpty);
    expect(jsonEncode(input), before);
  });

  test('scalar JSON round trip and immutable bytes', () {
    final bytes = [1, 2, 3];
    final upload = ShalomUpload(filename: 'a.bin', bytes: bytes);
    bytes[0] = 99;
    final roundtrip = shalomUploadScalar.deserialize(
      shalomJsonValue(shalomUploadScalar.serialize(upload)).toJsonValue(),
    );
    expect(roundtrip.bytes, [1, 2, 3]);
    expect(roundtrip, upload);
    expect(roundtrip.hashCode, upload.hashCode);
    expect(
      roundtrip,
      isNot(ShalomUpload(filename: 'other.bin', bytes: [1, 2, 3])),
    );
    expect(roundtrip, isNot(ShalomUpload(filename: 'a.bin', bytes: [1, 2, 4])));
    expect(() => upload.bytes[0] = 99, throwsUnsupportedError);
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
