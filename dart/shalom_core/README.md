# Shalom Core

Core Dart library for Shalom - a GraphQL code generation library with built-in normalized caching and transport layer support.

## Features

- **Normalized Cache**: Efficient data normalization and caching for GraphQL responses
- **GraphQL over HTTP**: Spec-compliant HTTP link implementation for GraphQL requests
- **GraphQL over WebSocket**: Full implementation of graphql-ws protocol for subscriptions
- **Transport Agnostic**: Bring your own HTTP/WebSocket client implementation
- **Type Safety**: Generated types work seamlessly with the core runtime
- **Reactive Updates**: Stream-based cache updates for reactive UI
- **Flexible Architecture**: Extensible link system for custom transport logic

## Core Components

### 1. Normalized Cache

Shalom includes a powerful normalized cache that:
- Automatically normalizes GraphQL responses by ID
- Tracks dependencies for efficient cache updates
- Supports reactive queries that update when cached data changes
- Handles complex nested object structures

### 2. HttpLink - GraphQL over HTTP

`HttpLink` provides a spec-compliant implementation of [GraphQL over HTTP](https://github.com/graphql/graphql-over-http/blob/main/spec/GraphQLOverHTTP.md):

- ✅ POST and GET request support
- ✅ Proper media types (`application/graphql-response+json`, `application/json`)
- ✅ Configurable headers and authentication
- ✅ Comprehensive error handling
- ✅ Transport layer abstraction

### 3. WebSocketLink - GraphQL over WebSocket

`WebSocketLink` provides a complete implementation of [graphql-ws protocol](https://github.com/enisdenjo/graphql-ws/blob/master/PROTOCOL.md):

- ✅ Real-time subscriptions
- ✅ Queries and mutations over WebSocket
- ✅ Auto-reconnection with operation replay
- ✅ Ping/Pong keep-alive
- ✅ Multiple concurrent operations
- ✅ Transport layer abstraction

## Getting Started

### Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  shalom_core: ^0.1.0
```

### Basic Usage with HttpLink

```dart
import 'package:shalom_core/shalom_core.dart';

// 1. Implement a transport layer with your HTTP client
class MyHttpTransport extends TransportLayer {
  @override
  Stream<dynamic> request({
    required JsonObject request,
    JsonObject? headers,
    JsonObject? extra,
  }) async* {
    final url = extra?['url'] as String;
    final method = extra?['method'] as String? ?? 'POST';
    
    // Use your preferred HTTP library (http, dio, etc.)
    final response = await httpClient.post(url, 
      body: jsonEncode(request),
      headers: headers?.cast<String, String>(),
    );
    
    yield jsonDecode(response.body);
  }
}

// 2. Create an HttpLink
final httpLink = HttpLink(
  transportLayer: MyHttpTransport(),
  url: 'https://api.example.com/graphql',
  defaultHeaders: {
    'Authorization': 'Bearer YOUR_TOKEN',
  },
);

// 3. Make GraphQL requests
final request = Request(
  query: '''
    query GetUser($id: ID!) {
      user(id: $id) {
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

await for (final response in httpLink.request(request: request, headers: {})) {
  if (response is GraphQLData) {
    print('User: ${response.data}');
    
    // Handle field errors if present
    if (response.errors != null) {
      for (final error in response.errors!) {
        print('Error: ${error['message']}');
      }
    }
  } else if (response is LinkErrorResponse) {
    print('Request failed: ${response.errors}');
  }
}
```

## WebSocketLink Usage

### Basic Subscription

```dart
import 'package:shalom_core/shalom_core.dart';

// 1. Implement WebSocket transport (see documentation for examples)
class MyWebSocketTransport extends WebSocketTransport {
  // Implementation using web_socket_channel or similar
}

// 2. Create WebSocketLink
final wsLink = WebSocketLink(
  transport: myWsTransport,
  url: 'ws://localhost:4000/graphql',
  connectionParams: {
    'authToken': 'YOUR_TOKEN',
  },
);

// 3. Subscribe to real-time updates
final request = Request(
  query: '''
    subscription OnMessageAdded {
      messageAdded {
        id
        text
        author
      }
    }
  ''',
  variables: {},
  opType: OperationType.Subscription,
  opName: 'OnMessageAdded',
);

await for (final response in wsLink.request(request: request, headers: {})) {
  if (response is GraphQLData) {
    print('New message: ${response.data}');
  } else if (response is LinkErrorResponse) {
    print('Error: ${response.errors}');
  }
}
```

### With Auto-Reconnection

```dart
final wsLink = WebSocketLink(
  transport: myWsTransport,
  url: 'ws://localhost:4000/graphql',
  autoReconnect: true,
  reconnectTimeout: const Duration(seconds: 5),
  pingInterval: const Duration(seconds: 30),
);

// Subscriptions automatically resume after reconnection
```

## HttpLink Configuration

### Using GET Requests

```dart
final httpLink = HttpLink(
  transportLayer: myTransport,
  url: 'https://api.example.com/graphql',
  useGet: true, // Enable GET for queries (mutations still use POST)
);
```

### Per-Request Headers

```dart
await for (final response in httpLink.request(
  request: myRequest,
  headers: {
    'X-Request-ID': 'unique-id',
    'Authorization': 'Bearer special-token', // Overrides default
  },
)) {
  // Handle response
}
```

## Transport Layer Implementation

You need to provide your own `TransportLayer` implementation using your preferred HTTP client:

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
    
    Response response;
    
    if (method == 'GET') {
      response = await dio.get(url, queryParameters: request, options: Options(headers: headers));
    } else {
      response = await dio.post(url, data: request, options: Options(headers: headers));
    }
    
    yield response.data;
  }
}
```

## Error Handling

HttpLink provides two types of responses:

### GraphQLData - Successful Response

Contains data and optionally field-level errors:

```dart
if (response is GraphQLData) {
  final data = response.data;
  
  // Check for field errors (partial response)
  if (response.errors != null) {
    for (final error in response.errors!) {
      print('Field error: ${error['message']}');
      print('Path: ${error['path']}');
    }
  }
  
  // Access extensions
  final tracing = response.extensions['tracing'];
}
```

### LinkErrorResponse - Request Errors

Network errors, parsing errors, or validation errors:

```dart
if (response is LinkErrorResponse) {
  final message = response.errors['message'];
  final code = response.errors['extensions']?['code'];
  
  switch (code) {
    case 'NETWORK_ERROR':
      // Handle network failure
      break;
    case 'INVALID_RESPONSE_FORMAT':
      // Handle malformed response
      break;
  }
}
```

## Testing

Use a fake transport layer for deterministic tests:

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

// In your tests
final httpLink = HttpLink(
  transportLayer: FakeTransport({
    'data': {'user': {'id': '123', 'name': 'Test User'}}
  }),
  url: 'http://test.com/graphql',
);
```

## Documentation

- [HTTP_LINK.md](./HTTP_LINK.md) - Comprehensive HttpLink documentation
- [WEBSOCKET_LINK.md](./WEBSOCKET_LINK.md) - Comprehensive WebSocketLink documentation
- [example/http_link_example.dart](./example/http_link_example.dart) - Complete HTTP usage examples
- [GraphQL over HTTP Spec](https://github.com/graphql/graphql-over-http/blob/main/spec/GraphQLOverHTTP.md) - Official HTTP specification
- [graphql-ws Protocol](https://github.com/enisdenjo/graphql-ws/blob/master/PROTOCOL.md) - Official WebSocket protocol

## Additional Information

This package is part of the Shalom GraphQL code generation ecosystem. For complete functionality, use with:
- `shalom` - CLI tool and code generator
- `shalom_flutter` - Flutter-specific integrations

For issues, feature requests, or contributions, please visit the [GitHub repository](https://github.com/yourusername/shalom).