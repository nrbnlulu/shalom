# HttpLink - GraphQL over HTTP Implementation

This document describes the `HttpLink` implementation for Shalom, which follows the [GraphQL over HTTP specification](https://github.com/graphql/graphql-over-http/blob/main/spec/GraphQLOverHTTP.md).

## Overview

`HttpLink` is a link implementation that enables GraphQL requests over HTTP. It provides a transport-agnostic way to communicate with GraphQL servers while adhering to the official GraphQL over HTTP protocol.

## Key Features

- ✅ **Spec Compliant**: Fully implements the GraphQL over HTTP specification
- ✅ **Transport Agnostic**: No dependency on specific HTTP libraries - bring your own
- ✅ **POST Support**: Required POST method for queries and mutations (default)
- ✅ **Optional GET Support**: Enable GET requests for queries (mutations always use POST)
- ✅ **Proper Media Types**: Uses `application/graphql-response+json` with `application/json` fallback
- ✅ **Error Handling**: Comprehensive error handling for network and GraphQL errors
- ✅ **Headers Management**: Support for default headers and per-request header overrides
- ✅ **Extensions Support**: Handles GraphQL extensions in responses

## Architecture

### Transport Layer Abstraction

`HttpLink` depends on a `TransportLayer` interface that you must implement using your preferred HTTP library:

```dart
abstract class TransportLayer {
  Stream<dynamic> request({
    required JsonObject request,
    JsonObject? headers,
    JsonObject? extra,
  });
}
```

This design allows you to:
- Use any HTTP client library (http, dio, etc.)
- Implement custom networking logic (retries, interceptors, etc.)
- Mock the transport layer for testing
- Control timeout, caching, and other HTTP-level concerns

### Response Types

Responses are represented as a sealed `GraphQLResponse` class:

- **`GraphQLData`**: Successful response with data (may include field errors)
  - `data`: The response data (JsonObject)
  - `errors`: Optional list of field errors
  - `extensions`: Optional extensions map

- **`LinkErrorResponse`**: Request-level errors (network, parsing, validation)
  - `errors`: Error information

## Usage

### Basic Setup

```dart
import 'package:shalom_core/shalom_core.dart';

// 1. Implement your transport layer
class MyHttpTransport extends TransportLayer {
  @override
  Stream<dynamic> request({
    required JsonObject request,
    JsonObject? headers,
    JsonObject? extra,
  }) async* {
    final url = extra?['url'] as String;
    final method = extra?['method'] as String? ?? 'POST';
    
    // Use your HTTP library here
    final response = await yourHttpClient.send(url, method, request, headers);
    yield jsonDecode(response.body);
  }
}

// 2. Create HttpLink
final httpLink = HttpLink(
  transportLayer: MyHttpTransport(),
  url: 'https://api.example.com/graphql',
);

// 3. Make requests
final request = Request(
  query: 'query { user(id: "123") { name } }',
  variables: {},
  opType: OperationType.Query,
  opName: 'GetUser',
);

await for (final response in httpLink.request(request: request, headers: {})) {
  if (response is GraphQLData) {
    print('Data: ${response.data}');
  } else if (response is LinkErrorResponse) {
    print('Error: ${response.errors}');
  }
}
```

### With Authentication

```dart
final httpLink = HttpLink(
  transportLayer: myTransport,
  url: 'https://api.example.com/graphql',
  defaultHeaders: {
    'Authorization': 'Bearer YOUR_TOKEN',
    'X-API-Key': 'your-api-key',
  },
);
```

### Using GET Requests

```dart
final httpLink = HttpLink(
  transportLayer: myTransport,
  url: 'https://api.example.com/graphql',
  useGet: true, // Use GET for queries
);

// Queries will use GET, mutations will still use POST
```

### Per-Request Headers

```dart
await for (final response in httpLink.request(
  request: myRequest,
  headers: {
    'X-Request-ID': 'unique-id',
    'Authorization': 'Bearer override-token', // Overrides default
  },
)) {
  // Handle response
}
```

## Request Format

### POST Requests

The request body is JSON with the following structure:

```json
{
  "query": "query GetUser($id: ID!) { user(id: $id) { id name } }",
  "operationName": "GetUser",
  "variables": {
    "id": "123"
  }
}
```

Headers set by HttpLink:
- `Content-Type: application/json; charset=utf-8`
- `Accept: application/graphql-response+json, application/json;q=0.9`

### GET Requests

Query parameters are URL-encoded:
- `query`: The GraphQL query string
- `operationName`: The operation name (if provided)
- `variables`: JSON-encoded variables object (if provided)

Example:
```
GET /graphql?query=query%20%7B%20user%20%7B%20id%20%7D%20%7D&operationName=GetUser&variables=%7B%22id%22%3A%22123%22%7D
```

## Response Handling

### Successful Response with Data

```dart
if (response is GraphQLData) {
  final user = response.data['user'];
  print('User: ${user['name']}');
  
  // Check for field errors
  if (response.errors != null) {
    for (final error in response.errors!) {
      print('Field error: ${error['message']}');
    }
  }
}
```

### Request Errors

```dart
if (response is LinkErrorResponse) {
  print('Request failed: ${response.errors['message']}');
  final code = response.errors['extensions']?['code'];
  
  if (code == 'NETWORK_ERROR') {
    // Handle network error
  }
}
```

### Response Extensions

```dart
if (response is GraphQLData) {
  final tracing = response.extensions['tracing'];
  if (tracing != null) {
    print('Query duration: ${tracing['duration']}');
  }
}
```

## Error Codes

HttpLink generates the following error codes in `LinkErrorResponse`:

- **`NETWORK_ERROR`**: Transport layer threw an exception
- **`INVALID_RESPONSE_FORMAT`**: Response is not valid JSON or missing required fields
- **`RESPONSE_PARSE_ERROR`**: Failed to parse the response

## Testing

Use a fake transport layer for testing:

```dart
class FakeTransport extends TransportLayer {
  final JsonObject mockResponse;
  
  FakeTransport(this.mockResponse);
  
  @override
  Stream<dynamic> request({
    required JsonObject request,
    JsonObject? headers,
    JsonObject? extra,
  }) async* {
    yield mockResponse;
  }
}

// In tests
final httpLink = HttpLink(
  transportLayer: FakeTransport({
    'data': {'user': {'id': '123', 'name': 'Test'}}
  }),
  url: 'http://test.com/graphql',
);
```

## Implementing a Transport Layer

### Example with package:http

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class HttpClientTransport extends TransportLayer {
  final http.Client client;
  
  HttpClientTransport(this.client);
  
  @override
  Stream<dynamic> request({
    required JsonObject request,
    JsonObject? headers,
    JsonObject? extra,
  }) async* {
    final url = extra?['url'] as String;
    final method = extra?['method'] as String? ?? 'POST';
    
    http.Response response;
    
    if (method == 'GET') {
      final uri = Uri.parse(url).replace(
        queryParameters: request.map((k, v) => MapEntry(k, v.toString())),
      );
      response = await client.get(uri, headers: _toStringHeaders(headers));
    } else {
      response = await client.post(
        Uri.parse(url),
        headers: _toStringHeaders(headers),
        body: jsonEncode(request),
      );
    }
    
    if (response.statusCode >= 200 && response.statusCode < 300) {
      yield jsonDecode(response.body);
    } else {
      throw Exception('HTTP ${response.statusCode}: ${response.body}');
    }
  }
  
  Map<String, String> _toStringHeaders(JsonObject? headers) {
    if (headers == null) return {};
    return headers.map((k, v) => MapEntry(k, v.toString()));
  }
}
```

### Example with package:dio

```dart
import 'package:dio/dio.dart';

class DioTransport extends TransportLayer {
  final Dio dio;
  
  DioTransport(this.dio);
  
  @override
  Stream<dynamic> request({
    required JsonObject request,
    JsonObject? headers,
    JsonObject? extra,
  }) async* {
    final url = extra?['url'] as String;
    final method = extra?['method'] as String? ?? 'POST';
    
    final options = Options(
      method: method,
      headers: headers,
    );
    
    Response response;
    
    if (method == 'GET') {
      response = await dio.get(url, queryParameters: request, options: options);
    } else {
      response = await dio.post(url, data: request, options: options);
    }
    
    yield response.data;
  }
}
```

## Compliance with GraphQL over HTTP Spec

This implementation follows the official specification:

1. ✅ **URL**: Supports single URL per GraphQL schema
2. ✅ **Serialization**: Uses JSON format with proper media types
3. ✅ **Media Types**: 
   - Accepts: `application/graphql-response+json, application/json`
   - Content-Type: `application/json; charset=utf-8`
4. ✅ **Request Parameters**: Supports query, operationName, variables, extensions
5. ✅ **POST Requests**: Default method with JSON body
6. ✅ **GET Requests**: Optional, URL-encoded, queries only
7. ✅ **Response Format**: Properly handles data, errors, and extensions fields
8. ✅ **Error Handling**: Distinguishes between request errors and field errors

## Best Practices

1. **Reuse HttpLink instances**: Create one instance and reuse it for multiple requests
2. **Use default headers for authentication**: Set auth tokens in default headers
3. **Implement retry logic in TransportLayer**: Handle network retries at the transport level
4. **Enable GET for cacheable queries**: Use `useGet: true` to leverage HTTP caching
5. **Handle both error types**: Always check for both `GraphQLData` with errors and `LinkErrorResponse`
6. **Mock transport in tests**: Use fake transport implementations for deterministic testing

## API Reference

### HttpLink Constructor

```dart
HttpLink({
  required TransportLayer transportLayer,
  required String url,
  bool useGet = false,
  JsonObject defaultHeaders = const {},
})
```

**Parameters:**
- `transportLayer`: Your HTTP implementation
- `url`: GraphQL endpoint URL
- `useGet`: Enable GET for queries (default: false)
- `defaultHeaders`: Headers to include in every request

### request Method

```dart
Stream<GraphQLResponse> request({
  required Request request,
  required JsonObject headers,
})
```

**Parameters:**
- `request`: The GraphQL request to execute
- `headers`: Per-request headers (merged with default headers)

**Returns:** Stream of `GraphQLResponse` objects

## Limitations

- Subscriptions are not supported (beyond spec scope at this time)
- Multipart requests are not supported (file uploads require custom implementation)
- Incremental delivery (@defer, @stream) is not supported yet

## See Also

- [GraphQL over HTTP Specification](https://github.com/graphql/graphql-over-http/blob/main/spec/GraphQLOverHTTP.md)
- [Example usage](./example/http_link_example.dart)
- [Tests](./test/http_link_test.dart)