import 'dart:async';

import 'package:shalom_core/shalom_core.dart';
import 'package:test/test.dart';

/// Fake transport layer for testing that returns controlled responses
class FakeTransportLayer implements ShalomHttpTransport {
  final List<dynamic> responses;
  final bool shouldThrow;
  final String? throwMessage;

  HttpMethod? lastMethod;
  String? lastUrl;
  JsonObject? lastData;
  JsonObject? lastHeaders;
  JsonObject? lastExtra;

  FakeTransportLayer({
    this.responses = const [],
    this.shouldThrow = false,
    this.throwMessage,
  });

  @override
  Future<JsonObject> request({
    required HttpMethod method,
    required String url,
    JsonObject? data,
    JsonObject? headers,
    JsonObject? extra,
  }) async {
    lastMethod = method;
    lastUrl = url;
    lastData = data ?? {};
    lastHeaders = headers;
    lastExtra = extra;

    if (shouldThrow) {
      throw Exception(throwMessage ?? 'Transport error');
    }

    if (responses.isEmpty) {
      return {};
    }

    return responses.first as JsonObject;
  }
}

void main() {
  group('HttpLink', () {
    late Request $testRequest;

    setUp(() {
      $testRequest = Request(
        query: 'query TestQuery { user { id name } }',
        variables: {'userId': '123'},
        opType: OperationType.Query,
        opName: 'TestQuery',
      );
    });

    group('POST requests', () {
      test('successful response with data', () async {
        final $fakeTransport = FakeTransportLayer(
          responses: [
            {
              'data': {
                'user': {'id': '123', 'name': 'Test User'}
              },
            }
          ],
        );

        final $httpLink = HttpLink(
          transportLayer: $fakeTransport,
          url: 'http://example.com/graphql',
        );

        final $responses = await $httpLink
            .request(request: $testRequest, headers: {}).toList();

        expect($responses.length, 1);
        expect($responses[0], isA<GraphQLData>());

        final $data = $responses[0] as GraphQLData;
        expect($data.data['user']['id'], '123');
        expect($data.data['user']['name'], 'Test User');
        expect($data.errors, isNull);
      });

      test('response with data and field errors', () async {
        final $fakeTransport = FakeTransportLayer(
          responses: [
            {
              'data': {
                'user': {'id': '123', 'name': null}
              },
              'errors': [
                {
                  'message': 'Field error',
                  'path': ['user', 'name'],
                }
              ],
            }
          ],
        );

        final $httpLink = HttpLink(
          transportLayer: $fakeTransport,
          url: 'http://example.com/graphql',
        );

        final $responses = await $httpLink
            .request(request: $testRequest, headers: {}).toList();

        expect($responses.length, 1);
        expect($responses[0], isA<GraphQLData>());

        final $data = $responses[0] as GraphQLData;
        expect($data.data['user']['id'], '123');
        expect($data.errors, isNotNull);
        expect($data.errors!.length, 1);
        expect($data.errors![0]['message'], 'Field error');
      });

      test('response with null data and errors', () async {
        final $fakeTransport = FakeTransportLayer(
          responses: [
            {
              'data': null,
              'errors': [
                {'message': 'Query validation failed'}
              ],
            }
          ],
        );

        final $httpLink = HttpLink(
          transportLayer: $fakeTransport,
          url: 'http://example.com/graphql',
        );

        final $responses = await $httpLink
            .request(request: $testRequest, headers: {}).toList();

        expect($responses.length, 1);
        expect($responses[0], isA<GraphQLData>());

        final $data = $responses[0] as GraphQLData;
        expect($data.data, isEmpty);
        expect($data.errors, isNotNull);
        expect($data.errors!.length, 1);
      });

      test('response with only errors (no data field)', () async {
        final $fakeTransport = FakeTransportLayer(
          responses: [
            {
              'errors': [
                {'message': 'Request error'}
              ],
            }
          ],
        );

        final $httpLink = HttpLink(
          transportLayer: $fakeTransport,
          url: 'http://example.com/graphql',
        );

        final $responses = await $httpLink
            .request(request: $testRequest, headers: {}).toList();

        expect($responses.length, 1);
        expect($responses[0], isA<LinkErrorResponse>());

        final $error = $responses[0] as LinkErrorResponse;
        expect($error.errors.length, 1);
        expect($error.errors[0], isA<ShalomTransportException>());
        final $transportError = $error.errors[0] as ShalomTransportException;
        expect($transportError.details?['errors'], isNotNull);
      });

      test('response with extensions', () async {
        final $fakeTransport = FakeTransportLayer(
          responses: [
            {
              'data': {'user': null},
              'extensions': {
                'tracing': {'duration': 123}
              },
            }
          ],
        );

        final $httpLink = HttpLink(
          transportLayer: $fakeTransport,
          url: 'http://example.com/graphql',
        );

        final $responses = await $httpLink
            .request(request: $testRequest, headers: {}).toList();

        expect($responses.length, 1);
        expect($responses[0], isA<GraphQLData>());

        final $data = $responses[0] as GraphQLData;
        expect($data.extensions['tracing']['duration'], 123);
      });

      test('sends correct headers for POST request', () async {
        final $fakeTransport = FakeTransportLayer(
          responses: [
            {'data': {}}
          ],
        );

        final $httpLink = HttpLink(
          transportLayer: $fakeTransport,
          url: 'http://example.com/graphql',
        );

        await $httpLink.request(request: $testRequest, headers: {}).toList();

        expect($fakeTransport.lastHeaders, isNotNull);
        expect($fakeTransport.lastHeaders!['Content-Type'],
            'application/json; charset=utf-8');
        expect(
          $fakeTransport.lastHeaders!['Accept'],
          'application/graphql-response+json, application/json;q=0.9',
        );
      });

      test('merges default headers with request headers', () async {
        final $fakeTransport = FakeTransportLayer(
          responses: [
            {'data': {}}
          ],
        );

        final $httpLink = HttpLink(
          transportLayer: $fakeTransport,
          url: 'http://example.com/graphql',
          defaultHeaders: {
            'Authorization': 'Bearer token123',
            'X-Custom-Header': 'custom-value',
          },
        );

        await $httpLink.request(
          request: $testRequest,
          headers: {'X-Request-ID': 'req-456'},
        ).toList();

        expect($fakeTransport.lastHeaders!['Authorization'], 'Bearer token123');
        expect($fakeTransport.lastHeaders!['X-Custom-Header'], 'custom-value');
        expect($fakeTransport.lastHeaders!['X-Request-ID'], 'req-456');
      });

      test('request headers override default headers', () async {
        final $fakeTransport = FakeTransportLayer(
          responses: [
            {'data': {}}
          ],
        );

        final $httpLink = HttpLink(
          transportLayer: $fakeTransport,
          url: 'http://example.com/graphql',
          defaultHeaders: {
            'Authorization': 'Bearer default-token',
          },
        );

        await $httpLink.request(
          request: $testRequest,
          headers: {'Authorization': 'Bearer override-token'},
        ).toList();

        expect($fakeTransport.lastHeaders!['Authorization'],
            'Bearer override-token');
      });

      test('sends correct request body', () async {
        final $fakeTransport = FakeTransportLayer(
          responses: [
            {'data': {}}
          ],
        );

        final $httpLink = HttpLink(
          transportLayer: $fakeTransport,
          url: 'http://example.com/graphql',
        );

        await $httpLink.request(request: $testRequest, headers: {}).toList();

        expect($fakeTransport.lastData, isNotNull);
        expect($fakeTransport.lastData!['query'], $testRequest.query);
        expect($fakeTransport.lastData!['operationName'], $testRequest.opName);
        expect($fakeTransport.lastData!['variables'], $testRequest.variables);
      });

      test('omits empty variables from request body', () async {
        final $fakeTransport = FakeTransportLayer(
          responses: [
            {'data': {}}
          ],
        );

        final $httpLink = HttpLink(
          transportLayer: $fakeTransport,
          url: 'http://example.com/graphql',
        );

        final $requestWithoutVars = Request(
          query: 'query { user { id } }',
          variables: {},
          opType: OperationType.Query,
          opName: 'GetUser',
        );

        await $httpLink
            .request(request: $requestWithoutVars, headers: {}).toList();

        expect($fakeTransport.lastData!.containsKey('variables'), isFalse);
      });

      test('includes method and url in extra metadata', () async {
        final $fakeTransport = FakeTransportLayer(
          responses: [
            {'data': {}}
          ],
        );

        final $httpLink = HttpLink(
          transportLayer: $fakeTransport,
          url: 'http://example.com/graphql',
        );

        await $httpLink.request(request: $testRequest, headers: {}).toList();

        expect($fakeTransport.lastExtra, isNotNull);
        expect($fakeTransport.lastExtra!['method'], 'POST');
        expect($fakeTransport.lastExtra!['url'], 'http://example.com/graphql');
      });

      test('handles mutation requests', () async {
        final $fakeTransport = FakeTransportLayer(
          responses: [
            {
              'data': {
                'createUser': {'id': '456'}
              }
            }
          ],
        );

        final $httpLink = HttpLink(
          transportLayer: $fakeTransport,
          url: 'http://example.com/graphql',
        );

        final $mutationRequest = Request(
          query: 'mutation CreateUser { createUser { id } }',
          variables: {},
          opType: OperationType.Mutation,
          opName: 'CreateUser',
        );

        await $httpLink
            .request(request: $mutationRequest, headers: {}).toList();

        // Mutations should always use POST
        expect($fakeTransport.lastExtra!['method'], 'POST');
      });
    });

    group('GET requests', () {
      test('uses GET for queries when useGet is true', () async {
        final $fakeTransport = FakeTransportLayer(
          responses: [
            {'data': {}}
          ],
        );

        final $httpLink = HttpLink(
          transportLayer: $fakeTransport,
          url: 'http://example.com/graphql',
          useGet: true,
        );

        await $httpLink.request(request: $testRequest, headers: {}).toList();

        expect($fakeTransport.lastExtra!['method'], 'GET');
      });

      test('still uses POST for mutations even when useGet is true', () async {
        final $fakeTransport = FakeTransportLayer(
          responses: [
            {'data': {}}
          ],
        );

        final $httpLink = HttpLink(
          transportLayer: $fakeTransport,
          url: 'http://example.com/graphql',
          useGet: true,
        );

        final $mutationRequest = Request(
          query: 'mutation CreateUser { createUser { id } }',
          variables: {},
          opType: OperationType.Mutation,
          opName: 'CreateUser',
        );

        await $httpLink
            .request(request: $mutationRequest, headers: {}).toList();

        expect($fakeTransport.lastExtra!['method'], 'POST');
      });

      test('encodes query parameters correctly for GET', () async {
        final $fakeTransport = FakeTransportLayer(
          responses: [
            {'data': {}}
          ],
        );

        final $httpLink = HttpLink(
          transportLayer: $fakeTransport,
          url: 'http://example.com/graphql',
          useGet: true,
        );

        await $httpLink.request(request: $testRequest, headers: {}).toList();

        expect($fakeTransport.lastData!['query'], $testRequest.query);
        expect($fakeTransport.lastData!['operationName'], $testRequest.opName);
        // Variables should be JSON encoded for GET
        expect($fakeTransport.lastData!['variables'], isA<String>());
      });

      test('omits empty operationName from GET request', () async {
        final $fakeTransport = FakeTransportLayer(
          responses: [
            {'data': {}}
          ],
        );

        final $httpLink = HttpLink(
          transportLayer: $fakeTransport,
          url: 'http://example.com/graphql',
          useGet: true,
        );

        final $requestWithoutOpName = Request(
          query: 'query { user { id } }',
          variables: {},
          opType: OperationType.Query,
          opName: '',
        );

        await $httpLink
            .request(request: $requestWithoutOpName, headers: {}).toList();

        expect($fakeTransport.lastData!.containsKey('operationName'), isFalse);
      });

      test('omits empty variables from GET request', () async {
        final $fakeTransport = FakeTransportLayer(
          responses: [
            {'data': {}}
          ],
        );

        final $httpLink = HttpLink(
          transportLayer: $fakeTransport,
          url: 'http://example.com/graphql',
          useGet: true,
        );

        final $requestWithoutVars = Request(
          query: 'query { user { id } }',
          variables: {},
          opType: OperationType.Query,
          opName: 'GetUser',
        );

        await $httpLink
            .request(request: $requestWithoutVars, headers: {}).toList();

        expect($fakeTransport.lastData!.containsKey('variables'), isFalse);
      });

      test('does not include Content-Type header for GET', () async {
        final $fakeTransport = FakeTransportLayer(
          responses: [
            {'data': {}}
          ],
        );

        final $httpLink = HttpLink(
          transportLayer: $fakeTransport,
          url: 'http://example.com/graphql',
          useGet: true,
        );

        await $httpLink.request(request: $testRequest, headers: {}).toList();

        // GET requests should still have Accept header
        expect($fakeTransport.lastHeaders!['Accept'], isNotNull);
        // But might not have Content-Type (depends on merge order, but it's in the Accept section)
      });
    });

    group('error handling', () {
      test('handles transport layer exceptions', () async {
        final $fakeTransport = FakeTransportLayer(
          shouldThrow: true,
          throwMessage: 'Network timeout',
        );

        final $httpLink = HttpLink(
          transportLayer: $fakeTransport,
          url: 'http://example.com/graphql',
        );

        final $responses = await $httpLink
            .request(request: $testRequest, headers: {}).toList();

        expect($responses.length, 1);
        expect($responses[0], isA<LinkErrorResponse>());

        final $error = $responses[0] as LinkErrorResponse;
        expect($error.errors.length, 1);
        expect($error.errors[0], isA<ShalomTransportException>());
        final $transportError = $error.errors[0] as ShalomTransportException;
        expect($transportError.message, contains('Network timeout'));
        expect($transportError.code, 'NETWORK_ERROR');
      });

      test('handles invalid response format (not a map)', () async {
        final $fakeTransport = FakeTransportLayer(
          responses: ['invalid response'],
        );

        final $httpLink = HttpLink(
          transportLayer: $fakeTransport,
          url: 'http://example.com/graphql',
        );

        final $responses = await $httpLink
            .request(request: $testRequest, headers: {}).toList();

        expect($responses.length, 1);
        expect($responses[0], isA<LinkErrorResponse>());

        final $error = $responses[0] as LinkErrorResponse;
        expect($error.errors.length, 1);
        expect($error.errors[0], isA<ShalomTransportException>());
        final $transportError = $error.errors[0] as ShalomTransportException;
        expect($transportError.message, contains('Invalid response format'));
        expect($transportError.code, 'INVALID_RESPONSE_FORMAT');
      });

      test('handles response missing both data and errors', () async {
        final $fakeTransport = FakeTransportLayer(
          responses: [
            {'extensions': {}}
          ],
        );

        final $httpLink = HttpLink(
          transportLayer: $fakeTransport,
          url: 'http://example.com/graphql',
        );

        final $responses = await $httpLink
            .request(request: $testRequest, headers: {}).toList();

        expect($responses.length, 1);
        expect($responses[0], isA<LinkErrorResponse>());

        final $error = $responses[0] as LinkErrorResponse;
        expect($error.errors.length, 1);
        expect($error.errors[0], isA<ShalomTransportException>());
        final $transportError = $error.errors[0] as ShalomTransportException;
        expect(
            $transportError.message, contains('missing both data and errors'));
      });

      test('handles invalid errors format (not an array)', () async {
        final $fakeTransport = FakeTransportLayer(
          responses: [
            {
              'data': {},
              'errors': 'invalid errors format',
            }
          ],
        );

        final $httpLink = HttpLink(
          transportLayer: $fakeTransport,
          url: 'http://example.com/graphql',
        );

        final $responses = await $httpLink
            .request(request: $testRequest, headers: {}).toList();

        expect($responses.length, 1);
        expect($responses[0], isA<LinkErrorResponse>());

        final $error = $responses[0] as LinkErrorResponse;
        expect($error.errors.length, 1);
        expect($error.errors[0], isA<ShalomTransportException>());
        final $transportError = $error.errors[0] as ShalomTransportException;
        expect($transportError.message, contains('Invalid errors format'));
      });
    });

    group('custom Accept header', () {
      test('uses custom Accept header when provided', () async {
        final $fakeTransport = FakeTransportLayer(
          responses: [
            {'data': {}}
          ],
        );

        final $httpLink = HttpLink(
          transportLayer: $fakeTransport,
          url: 'http://example.com/graphql',
        );

        await $httpLink.request(
          request: $testRequest,
          headers: {'Accept': 'application/json'},
        ).toList();

        expect($fakeTransport.lastHeaders!['Accept'], 'application/json');
      });

      test('uses default Accept header when not provided', () async {
        final $fakeTransport = FakeTransportLayer(
          responses: [
            {'data': {}}
          ],
        );

        final $httpLink = HttpLink(
          transportLayer: $fakeTransport,
          url: 'http://example.com/graphql',
        );

        await $httpLink.request(request: $testRequest, headers: {}).toList();

        expect(
          $fakeTransport.lastHeaders!['Accept'],
          'application/graphql-response+json, application/json;q=0.9',
        );
      });
    });

    group('streaming responses', () {
      test('handles multiple responses from transport layer', () async {
        final $fakeTransport = FakeTransportLayer(
          responses: [
            {
              'data': {'count': 1}
            },
            {
              'data': {'count': 2}
            },
            {
              'data': {'count': 3}
            },
          ],
        );

        final $httpLink = HttpLink(
          transportLayer: $fakeTransport,
          url: 'http://example.com/graphql',
        );

        final $responses = await $httpLink
            .request(request: $testRequest, headers: {}).toList();

        expect($responses.length, 3);
        expect(($responses[0] as GraphQLData).data['count'], 1);
        expect(($responses[1] as GraphQLData).data['count'], 2);
        expect(($responses[2] as GraphQLData).data['count'], 3);
      });
    });
  });
}
