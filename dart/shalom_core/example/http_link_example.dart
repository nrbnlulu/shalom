// ignore_for_file: unused_local_variable

import 'dart:async';
import 'package:shalom_core/shalom_core.dart';

/// Example: Custom HTTP transport layer implementation
///
/// Users need to provide their own TransportLayer implementation
/// that uses their preferred HTTP library (http, dio, etc.)
///
/// This example shows how to implement a TransportLayer using
/// the standard dart:io HttpClient (for illustration purposes).
class DartHttpTransportLayer extends TransportLayer {
  @override
  Stream<dynamic> request({
    required JsonObject request,
    JsonObject? headers,
    JsonObject? extra,
  }) async* {
    // In a real implementation, you would:
    // 1. Extract URL and method from extra
    // 2. Create an HTTP request with the appropriate library
    // 3. Set headers
    // 4. Send the request body (for POST) or query params (for GET)
    // 5. Parse the response
    // 6. Yield the parsed JSON response

    // This is a pseudo-implementation for illustration:
    final url = extra?['url'] as String? ?? '';
    final method = extra?['method'] as String? ?? 'POST';

    // Example: Using your HTTP library of choice
    // final response = await httpClient.request(url, method, request, headers);
    // yield jsonDecode(response.body);

    throw UnimplementedError('Implement with your HTTP library of choice');
  }
}

/// Example: Mock transport for testing or demo purposes
class MockTransportLayer extends TransportLayer {
  final JsonObject mockResponse;
  final Duration delay;

  MockTransportLayer({
    required this.mockResponse,
    this.delay = const Duration(milliseconds: 100),
  });

  @override
  Stream<dynamic> request({
    required JsonObject request,
    JsonObject? headers,
    JsonObject? extra,
  }) async* {
    // Simulate network delay
    await Future.delayed(delay);

    // Return mock response
    yield mockResponse;
  }
}

void main() async {
  // Example 1: Basic POST request with mock transport
  print('=== Example 1: Basic POST Request ===');
  {
    final mockTransport = MockTransportLayer(
      mockResponse: {
        'data': {
          'user': {
            'id': '123',
            'name': 'John Doe',
            'email': 'john@example.com',
          }
        }
      },
    );

    final httpLink = HttpLink(
      transportLayer: mockTransport,
      url: 'https://api.example.com/graphql',
    );

    final request = Request(
      query: '''
        query GetUser(\$id: ID!) {
          user(id: \$id) {
            id
            name
            email
          }
        }
      ''',
      variables: {'id': '123'},
      opType: OperationType.Query,
      opName: 'GetUser',
    );

    await for (final response in httpLink.request(
      request: request,
      headers: {},
    )) {
      if (response is GraphQLData) {
        print('Success! Data: ${response.data}');
        print('Errors: ${response.errors}');
      } else if (response is LinkErrorResponse) {
        print('Error: ${response.errors}');
      }
    }
  }

  // Example 2: Request with authentication headers
  print('\n=== Example 2: Authenticated Request ===');
  {
    final mockTransport = MockTransportLayer(
      mockResponse: {
        'data': {
          'me': {
            'id': '456',
            'username': 'janedoe',
          }
        }
      },
    );

    final httpLink = HttpLink(
      transportLayer: mockTransport,
      url: 'https://api.example.com/graphql',
      defaultHeaders: {
        'Authorization': 'Bearer YOUR_TOKEN_HERE',
        'X-Custom-Header': 'custom-value',
      },
    );

    final request = Request(
      query: 'query { me { id username } }',
      variables: {},
      opType: OperationType.Query,
      opName: 'GetCurrentUser',
    );

    await for (final response in httpLink.request(
      request: request,
      headers: {},
    )) {
      if (response is GraphQLData) {
        print('User: ${response.data}');
      }
    }
  }

  // Example 3: Handling errors
  print('\n=== Example 3: Handling Errors ===');
  {
    final mockTransport = MockTransportLayer(
      mockResponse: {
        'data': {
          'user': null,
        },
        'errors': [
          {
            'message': 'User not found',
            'path': ['user'],
            'extensions': {
              'code': 'NOT_FOUND',
            }
          }
        ]
      },
    );

    final httpLink = HttpLink(
      transportLayer: mockTransport,
      url: 'https://api.example.com/graphql',
    );

    final request = Request(
      query: 'query GetUser(\$id: ID!) { user(id: \$id) { id } }',
      variables: {'id': '999'},
      opType: OperationType.Query,
      opName: 'GetUser',
    );

    await for (final response in httpLink.request(
      request: request,
      headers: {},
    )) {
      if (response is GraphQLData) {
        if (response.errors != null) {
          print('Field errors occurred:');
          for (final error in response.errors!) {
            print('  - ${error['message']}');
            print('    Path: ${error['path']}');
            print('    Code: ${error['extensions']?['code']}');
          }
        }
        print('Data (may be partial): ${response.data}');
      }
    }
  }

  // Example 4: Mutation request
  print('\n=== Example 4: Mutation Request ===');
  {
    final mockTransport = MockTransportLayer(
      mockResponse: {
        'data': {
          'createUser': {
            'id': '789',
            'name': 'New User',
            'success': true,
          }
        }
      },
    );

    final httpLink = HttpLink(
      transportLayer: mockTransport,
      url: 'https://api.example.com/graphql',
    );

    final request = Request(
      query: '''
        mutation CreateUser(\$input: CreateUserInput!) {
          createUser(input: \$input) {
            id
            name
            success
          }
        }
      ''',
      variables: {
        'input': {
          'name': 'New User',
          'email': 'newuser@example.com',
        }
      },
      opType: OperationType.Mutation,
      opName: 'CreateUser',
    );

    await for (final response in httpLink.request(
      request: request,
      headers: {},
    )) {
      if (response is GraphQLData) {
        print('Mutation result: ${response.data}');
      }
    }
  }

  // Example 5: Using GET requests for queries
  print('\n=== Example 5: GET Request (for queries only) ===');
  {
    final mockTransport = MockTransportLayer(
      mockResponse: {
        'data': {
          'posts': [
            {'id': '1', 'title': 'First Post'},
            {'id': '2', 'title': 'Second Post'},
          ]
        }
      },
    );

    final httpLink = HttpLink(
      transportLayer: mockTransport,
      url: 'https://api.example.com/graphql',
      useGet: true, // Enable GET requests for queries
    );

    final request = Request(
      query: 'query { posts { id title } }',
      variables: {},
      opType: OperationType.Query,
      opName: 'GetPosts',
    );

    // Note: Even with useGet=true, mutations will still use POST
    await for (final response in httpLink.request(
      request: request,
      headers: {},
    )) {
      if (response is GraphQLData) {
        print('Posts: ${response.data}');
      }
    }
  }

  // Example 6: Request with extensions
  print('\n=== Example 6: Response with Extensions ===');
  {
    final mockTransport = MockTransportLayer(
      mockResponse: {
        'data': {
          'search': ['result1', 'result2']
        },
        'extensions': {
          'tracing': {
            'version': 1,
            'startTime': '2024-01-01T00:00:00Z',
            'endTime': '2024-01-01T00:00:01Z',
            'duration': 1000000000,
          },
          'queryComplexity': 42,
        }
      },
    );

    final httpLink = HttpLink(
      transportLayer: mockTransport,
      url: 'https://api.example.com/graphql',
    );

    final request = Request(
      query: 'query { search(term: "test") }',
      variables: {},
      opType: OperationType.Query,
      opName: 'Search',
    );

    await for (final response in httpLink.request(
      request: request,
      headers: {},
    )) {
      if (response is GraphQLData) {
        print('Data: ${response.data}');
        print('Extensions: ${response.extensions}');

        // Access specific extension data
        final tracing = response.extensions['tracing'];
        if (tracing != null) {
          print('Query took: ${tracing['duration']} nanoseconds');
        }
      }
    }
  }

  // Example 7: Per-request headers
  print('\n=== Example 7: Per-Request Headers ===');
  {
    final mockTransport = MockTransportLayer(
      mockResponse: {
        'data': {'result': 'ok'}
      },
    );

    final httpLink = HttpLink(
      transportLayer: mockTransport,
      url: 'https://api.example.com/graphql',
      defaultHeaders: {
        'Authorization': 'Bearer default-token',
      },
    );

    final request = Request(
      query: 'query { result }',
      variables: {},
      opType: OperationType.Query,
      opName: 'GetResult',
    );

    // Override default headers for this specific request
    await for (final response in httpLink.request(
      request: request,
      headers: {
        'Authorization': 'Bearer special-token',
        'X-Request-ID': 'unique-request-id-123',
      },
    )) {
      if (response is GraphQLData) {
        print('Result: ${response.data}');
      }
    }
  }

  // Example 8: Handling network errors
  print('\n=== Example 8: Handling Network Errors ===');
  {
    final errorTransport = ErrorTransportLayer();

    final httpLink = HttpLink(
      transportLayer: errorTransport,
      url: 'https://api.example.com/graphql',
    );

    final request = Request(
      query: 'query { data }',
      variables: {},
      opType: OperationType.Query,
      opName: 'GetData',
    );

    await for (final response in httpLink.request(
      request: request,
      headers: {},
    )) {
      if (response is LinkErrorResponse) {
        print('Network error occurred:');
        print('Message: ${response.errors['message']}');
        print('Code: ${response.errors['extensions']['code']}');
      }
    }
  }

  print('\n=== All examples completed ===');
}

/// Transport layer that simulates a network error
class ErrorTransportLayer extends TransportLayer {
  @override
  Stream<dynamic> request({
    required JsonObject request,
    JsonObject? headers,
    JsonObject? extra,
  }) async* {
    throw Exception('Network connection failed');
  }
}

/// Example of how to integrate with a real HTTP client (using package:http)
///
/// ```dart
/// import 'package:http/http.dart' as http;
///
/// class HttpClientTransportLayer extends TransportLayer {
///   final http.Client client;
///
///   HttpClientTransportLayer(this.client);
///
///   @override
///   Stream<dynamic> request({
///     required JsonObject request,
///     JsonObject? headers,
///     JsonObject? extra,
///   }) async* {
///     final url = extra?['url'] as String;
///     final method = extra?['method'] as String? ?? 'POST';
///
///     late http.Response response;
///
///     if (method == 'GET') {
///       // Build URL with query parameters
///       final uri = Uri.parse(url).replace(
///         queryParameters: request.map((k, v) => MapEntry(k, v.toString())),
///       );
///       response = await client.get(uri, headers: _convertHeaders(headers));
///     } else {
///       // POST request with JSON body
///       response = await client.post(
///         Uri.parse(url),
///         headers: _convertHeaders(headers),
///         body: jsonEncode(request),
///       );
///     }
///
///     if (response.statusCode >= 200 && response.statusCode < 300) {
///       yield jsonDecode(response.body);
///     } else {
///       throw Exception('HTTP ${response.statusCode}: ${response.body}');
///     }
///   }
///
///   Map<String, String> _convertHeaders(JsonObject? headers) {
///     if (headers == null) return {};
///     return headers.map((k, v) => MapEntry(k, v.toString()));
///   }
/// }
/// ```
