# WebSocketLink - GraphQL WebSocket Protocol Implementation

This document describes the `WebSocketLink` implementation for Shalom, which follows the [graphql-ws protocol specification](https://github.com/enisdenjo/graphql-ws/blob/master/PROTOCOL.md).

## Overview

`WebSocketLink` provides a complete implementation of the GraphQL WebSocket protocol (`graphql-transport-ws`) for real-time GraphQL operations including subscriptions, queries, and mutations over WebSocket connections.

## Key Features

- ✅ **Protocol Compliant**: Fully implements the graphql-ws protocol specification
- ✅ **Transport Agnostic**: No dependency on specific WebSocket libraries - bring your own
- ✅ **Auto-Reconnection**: Configurable automatic reconnection on disconnect
- ✅ **Keep-Alive**: Ping/Pong mechanism for connection health monitoring
- ✅ **Multiple Operations**: Support for concurrent operations with unique IDs
- ✅ **Operation Types**: Handles subscriptions, queries, and mutations
- ✅ **Pending Operations Queue**: Re-executes operations after reconnection
- ✅ **Comprehensive Error Handling**: Proper handling of all protocol error scenarios

## Architecture

### Transport Layer Abstraction

`WebSocketLink` depends on a `WebSocketTransport` interface that you must implement using your preferred WebSocket library:

```dart
abstract class WebSocketTransport {
  Stream<String> get messages;
  Stream<WebSocketState> get stateChanges;
  WebSocketState get state;
  bool get isConnected;
  
  Future<void> connect({
    required String url,
    JsonObject? headers,
    List<String>? protocols,
  });
  
  void send(String message);
  Future<void> close([int code = 1000, String? reason]);
}
```

This design allows you to:
- Use any WebSocket library (web_socket_channel, socket_io, etc.)
- Implement platform-specific WebSocket logic
- Mock the transport layer for testing
- Control connection behavior and error handling

### Message Types

The protocol defines the following message types:

**Connection Messages:**
- `ConnectionInit` - Client initiates connection
- `ConnectionAck` - Server acknowledges connection

**Operation Messages:**
- `Subscribe` - Request an operation
- `Next` - Operation result data
- `Error` - Operation errors
- `Complete` - Operation completion

**Keep-Alive Messages:**
- `Ping` - Connection health check
- `Pong` - Response to ping

### WebSocket Close Codes

The protocol defines specific close codes:

- `1000` - Normal closure
- `4400` - Invalid message format
- `4401` - Unauthorized (no ConnectionAck)
- `4403` - Forbidden (connection rejected)
- `4408` - Connection initialization timeout
- `4409` - Subscriber already exists for operation ID
- `4429` - Too many initialization requests

## Usage

### Basic Setup

```dart
import 'package:shalom_core/shalom_core.dart';

// 1. Implement your WebSocket transport
class MyWebSocketTransport extends WebSocketTransport {
  // Implementation using your preferred WebSocket library
}

// 2. Create WebSocketLink
final wsLink = WebSocketLink(
  transport: myTransport,
  url: 'ws://localhost:4000/graphql',
);

// 3. Subscribe to operations
final request = Request(
  query: 'subscription { messageAdded { id text } }',
  variables: {},
  opType: OperationType.Subscription,
  opName: 'MessageSubscription',
);

await for (final response in wsLink.request(request: request, headers: {})) {
  if (response is GraphQLData) {
    print('New message: ${response.data}');
  } else if (response is LinkErrorResponse) {
    print('Error: ${response.errors}');
  }
}
```

### With Connection Parameters

```dart
final wsLink = WebSocketLink(
  transport: myTransport,
  url: 'ws://localhost:4000/graphql',
  connectionParams: {
    'authToken': 'YOUR_AUTH_TOKEN',
    'clientId': 'my-client',
  },
);
```

### Custom Configuration

```dart
final wsLink = WebSocketLink(
  transport: myTransport,
  url: 'ws://localhost:4000/graphql',
  autoReconnect: true,                                    // Enable auto-reconnect
  connectionInitTimeout: const Duration(seconds: 10),     // ConnectionAck timeout
  reconnectTimeout: const Duration(seconds: 5),           // Delay before reconnect
  pingInterval: const Duration(seconds: 30),              // Ping frequency
  pongTimeout: const Duration(seconds: 5),                // Pong response timeout
);
```

## Connection Lifecycle

### 1. Initialization

```dart
final wsLink = WebSocketLink(
  transport: myTransport,
  url: 'ws://localhost:4000/graphql',
);

// Automatically:
// 1. Connects WebSocket
// 2. Sends ConnectionInit message
// 3. Waits for ConnectionAck
// 4. Starts ping/pong keep-alive
```

### 2. Operation Execution

```dart
// Start subscription
final stream = wsLink.request(request: myRequest, headers: {});
final subscription = stream.listen((response) {
  // Handle response
});

// Automatically:
// 1. Generates unique operation ID
// 2. Sends Subscribe message
// 3. Streams Next messages to listener
// 4. Handles Complete or Error messages
```

### 3. Cancellation

```dart
// Cancel subscription
await subscription.cancel();

// Automatically:
// 1. Sends Complete message to server
// 2. Removes operation from active list
// 3. Closes the response stream
```

### 4. Disconnection

```dart
// On disconnect:
// 1. Moves active operations to pending queue
// 2. Attempts reconnection (if autoReconnect=true)
// 3. Re-executes pending operations after reconnect
```

### 5. Disposal

```dart
// Clean shutdown
await wsLink.dispose();

// Automatically:
// 1. Cancels all timers
// 2. Closes all operation streams
// 3. Closes WebSocket connection
```

## Implementing a WebSocket Transport

### Example with web_socket_channel

```dart
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketChannelTransport extends WebSocketTransport {
  WebSocketChannel? _channel;
  final StreamController<String> _messageController = 
      StreamController<String>.broadcast();
  final StreamController<WebSocketState> _stateController = 
      StreamController<WebSocketState>.broadcast();
  
  WebSocketState _currentState = WebSocketState.disconnected;
  
  @override
  Stream<String> get messages => _messageController.stream;
  
  @override
  Stream<WebSocketState> get stateChanges => _stateController.stream;
  
  @override
  WebSocketState get state => _currentState;
  
  @override
  bool get isConnected => 
      _currentState == WebSocketState.connected && _channel != null;
  
  @override
  Future<void> connect({
    required String url,
    JsonObject? headers,
    List<String>? protocols,
  }) async {
    _setState(WebSocketState.connecting);
    
    try {
      _channel = WebSocketChannel.connect(
        Uri.parse(url),
        protocols: protocols,
      );
      
      _channel!.stream.listen(
        (message) {
          if (message is String) {
            _messageController.add(message);
          }
        },
        onError: (error) {
          _setState(WebSocketState.disconnected);
        },
        onDone: () {
          _setState(WebSocketState.disconnected);
        },
      );
      
      _setState(WebSocketState.connected);
    } catch (e) {
      _setState(WebSocketState.disconnected);
      rethrow;
    }
  }
  
  @override
  void send(String message) {
    _channel?.sink.add(message);
  }
  
  @override
  Future<void> close([int code = 1000, String? reason]) async {
    _setState(WebSocketState.closing);
    await _channel?.sink.close(code, reason);
    _setState(WebSocketState.closed);
    _setState(WebSocketState.disconnected);
  }
  
  void _setState(WebSocketState newState) {
    _currentState = newState;
    _stateController.add(newState);
  }
  
  void dispose() {
    _messageController.close();
    _stateController.close();
  }
}
```

### Example with socket_io_client

```dart
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketIOTransport extends WebSocketTransport {
  IO.Socket? _socket;
  final StreamController<String> _messageController = 
      StreamController<String>.broadcast();
  final StreamController<WebSocketState> _stateController = 
      StreamController<WebSocketState>.broadcast();
  
  WebSocketState _currentState = WebSocketState.disconnected;
  
  @override
  Stream<String> get messages => _messageController.stream;
  
  @override
  Stream<WebSocketState> get stateChanges => _stateController.stream;
  
  @override
  WebSocketState get state => _currentState;
  
  @override
  bool get isConnected => _socket?.connected ?? false;
  
  @override
  Future<void> connect({
    required String url,
    JsonObject? headers,
    List<String>? protocols,
  }) async {
    _setState(WebSocketState.connecting);
    
    _socket = IO.io(url, <String, dynamic>{
      'transports': ['websocket'],
      'extraHeaders': headers,
    });
    
    _socket!.on('connect', (_) {
      _setState(WebSocketState.connected);
    });
    
    _socket!.on('disconnect', (_) {
      _setState(WebSocketState.disconnected);
    });
    
    _socket!.on('message', (data) {
      if (data is String) {
        _messageController.add(data);
      }
    });
  }
  
  @override
  void send(String message) {
    _socket?.emit('message', message);
  }
  
  @override
  Future<void> close([int code = 1000, String? reason]) async {
    _setState(WebSocketState.closing);
    _socket?.disconnect();
    _setState(WebSocketState.disconnected);
  }
  
  void _setState(WebSocketState newState) {
    _currentState = newState;
    _stateController.add(newState);
  }
}
```

## Operation Types

### Subscriptions

Long-lived operations that stream multiple results:

```dart
final request = Request(
  query: '''
    subscription OnMessageAdded {
      messageAdded {
        id
        text
        author
        timestamp
      }
    }
  ''',
  variables: {},
  opType: OperationType.Subscription,
  opName: 'OnMessageAdded',
);

await for (final response in wsLink.request(request: request, headers: {})) {
  if (response is GraphQLData) {
    final message = response.data['messageAdded'];
    print('New message: ${message['text']} from ${message['author']}');
  }
}
```

### Queries

Single-result operations (useful for real-time data):

```dart
final request = Request(
  query: '''
    query GetUser($id: ID!) {
      user(id: $id) {
        id
        name
        status
      }
    }
  ''',
  variables: {'id': '123'},
  opType: OperationType.Query,
  opName: 'GetUser',
);

final responses = <GraphQLResponse>[];
await for (final response in wsLink.request(request: request, headers: {})) {
  responses.add(response);
  if (response is GraphQLData) {
    print('User: ${response.data['user']}');
  }
}
```

### Mutations

Single-result modification operations:

```dart
final request = Request(
  query: '''
    mutation CreateMessage($text: String!) {
      createMessage(text: $text) {
        id
        text
        success
      }
    }
  ''',
  variables: {'text': 'Hello, World!'},
  opType: OperationType.Mutation,
  opName: 'CreateMessage',
);

await for (final response in wsLink.request(request: request, headers: {})) {
  if (response is GraphQLData) {
    print('Created: ${response.data['createMessage']}');
  }
}
```

## Error Handling

### Connection Errors

```dart
wsLink.transport.stateChanges.listen((state) {
  if (state == WebSocketState.disconnected) {
    print('WebSocket disconnected');
    // Handle reconnection UI
  } else if (state == WebSocketState.connected) {
    print('WebSocket connected');
    // Update UI
  }
});
```

### Operation Errors

```dart
await for (final response in wsLink.request(request: myRequest, headers: {})) {
  if (response is GraphQLData) {
    // Check for field errors
    if (response.errors != null) {
      for (final error in response.errors!) {
        print('Field error: ${error['message']}');
        print('Path: ${error['path']}');
      }
    }
    
    // Process data (may be partial)
    print('Data: ${response.data}');
  } else if (response is LinkErrorResponse) {
    // Request-level errors
    final code = response.errors['extensions']?['code'];
    
    switch (code) {
      case 'WEBSOCKET_ERROR':
        // WebSocket connection error
        break;
      case 'CONNECTION_ERROR':
        // Failed to establish connection
        break;
      case 'GRAPHQL_ERROR':
        // GraphQL execution error
        final errors = response.errors['errors'] as List;
        for (final error in errors) {
          print('GraphQL error: ${error['message']}');
        }
        break;
    }
  }
}
```

## Multiple Concurrent Operations

```dart
// Start multiple subscriptions simultaneously
final stream1 = wsLink.request(
  request: Request(
    query: 'subscription { messages { id text } }',
    variables: {},
    opType: OperationType.Subscription,
    opName: 'Messages',
  ),
  headers: {},
);

final stream2 = wsLink.request(
  request: Request(
    query: 'subscription { notifications { id type } }',
    variables: {},
    opType: OperationType.Subscription,
    opName: 'Notifications',
  ),
  headers: {},
);

// Listen to both streams independently
final sub1 = stream1.listen((response) {
  print('Message: $response');
});

final sub2 = stream2.listen((response) {
  print('Notification: $response');
});

// Cancel individually when done
await sub1.cancel();
await sub2.cancel();
```

## Reconnection Behavior

### Automatic Reconnection

When `autoReconnect` is enabled:

1. On disconnect, all active operations are moved to pending queue
2. After `reconnectTimeout`, connection is re-established
3. `ConnectionInit` is sent again
4. After `ConnectionAck`, all pending operations are re-executed
5. Streams continue to emit data seamlessly

```dart
final wsLink = WebSocketLink(
  transport: myTransport,
  url: 'ws://localhost:4000/graphql',
  autoReconnect: true,
  reconnectTimeout: const Duration(seconds: 3),
);

// Start subscription
final subscription = wsLink.request(
  request: myRequest,
  headers: {},
).listen((response) {
  // Will continue receiving data even after reconnects
  print('Data: $response');
});
```

### Manual Reconnection

```dart
// Manually trigger reconnection
await wsLink.reconnect();
```

## Connection State Monitoring

```dart
// Check connection state
if (wsLink.isConnected) {
  print('WebSocket is connected');
}

if (wsLink.isConnectionAcknowledged) {
  print('Connection is acknowledged and ready for operations');
}

// Access connection acknowledgement payload
final ackPayload = wsLink.connectionAckPayload;
if (ackPayload != null) {
  print('Server version: ${ackPayload['serverVersion']}');
}
```

## Testing

Use a fake transport for deterministic tests:

```dart
class FakeWebSocketTransport extends WebSocketTransport {
  final StreamController<String> _messageController = 
      StreamController<String>.broadcast();
  final StreamController<WebSocketState> _stateController = 
      StreamController<WebSocketState>.broadcast();
  
  WebSocketState _currentState = WebSocketState.disconnected;
  final List<String> sentMessages = [];
  
  @override
  Stream<String> get messages => _messageController.stream;
  
  @override
  Stream<WebSocketState> get stateChanges => _stateController.stream;
  
  @override
  WebSocketState get state => _currentState;
  
  @override
  bool get isConnected => _currentState == WebSocketState.connected;
  
  @override
  Future<void> connect({
    required String url,
    JsonObject? headers,
    List<String>? protocols,
  }) async {
    _currentState = WebSocketState.connected;
    _stateController.add(_currentState);
  }
  
  @override
  void send(String message) {
    sentMessages.add(message);
  }
  
  @override
  Future<void> close([int code = 1000, String? reason]) async {
    _currentState = WebSocketState.disconnected;
    _stateController.add(_currentState);
  }
  
  // Test helper: simulate receiving a message
  void receiveMessage(String message) {
    _messageController.add(message);
  }
}

// In tests
test('receives subscription data', () async {
  final fakeTransport = FakeWebSocketTransport();
  final wsLink = WebSocketLink(
    transport: fakeTransport,
    url: 'ws://test.com/graphql',
  );
  
  await Future.delayed(Duration(milliseconds: 50));
  
  // Simulate ConnectionAck
  fakeTransport.receiveMessage(
    ConnectionAckMessage().toJsonString(),
  );
  
  // Start subscription
  final responses = <GraphQLResponse>[];
  final stream = wsLink.request(request: myRequest, headers: {});
  final subscription = stream.listen(responses.add);
  
  await Future.delayed(Duration(milliseconds: 10));
  
  // Simulate Next message
  final subscribeMsg = parseWsMessage(fakeTransport.sentMessages.last) 
      as SubscribeMessage;
  
  fakeTransport.receiveMessage(
    NextMessage(
      id: subscribeMsg.id,
      payload: {'data': {'result': 'test'}},
    ).toJsonString(),
  );
  
  await Future.delayed(Duration(milliseconds: 10));
  
  expect(responses.length, 1);
  expect(responses[0], isA<GraphQLData>());
});
```

## Best Practices

1. **Reuse WebSocketLink instances**: Create one instance and reuse it for multiple operations
2. **Handle disconnections gracefully**: Use `autoReconnect` for better UX
3. **Monitor connection state**: Update UI based on connection status
4. **Cancel subscriptions properly**: Always cancel stream subscriptions when done
5. **Implement exponential backoff**: For production, consider exponential backoff for reconnects
6. **Use connection params for auth**: Pass authentication tokens via `connectionParams`
7. **Test with fake transport**: Use mock transport for reliable unit tests
8. **Dispose on cleanup**: Call `dispose()` when the link is no longer needed

## Compliance with graphql-ws Protocol

This implementation follows the official specification:

1. ✅ **Sub-protocol**: Uses `graphql-transport-ws`
2. ✅ **Message Types**: Implements all required message types
3. ✅ **Connection Flow**: Proper ConnectionInit/ConnectionAck handshake
4. ✅ **Operation IDs**: Unique IDs for each operation
5. ✅ **Multiplexing**: Multiple concurrent operations on one connection
6. ✅ **Ping/Pong**: Bidirectional keep-alive mechanism
7. ✅ **Error Handling**: Proper error messages and close codes
8. ✅ **Graceful Completion**: Complete messages for operation termination

## Limitations

- Server-initiated operations (reverse subscriptions) are not supported
- Custom WebSocket extensions are not implemented
- Binary message format is not supported (JSON only)

## See Also

- [graphql-ws Protocol Specification](https://github.com/enisdenjo/graphql-ws/blob/master/PROTOCOL.md)
- [Tests](./test/ws_link_test.dart)
- [HttpLink Documentation](./HTTP_LINK.md) - For HTTP-based GraphQL operations