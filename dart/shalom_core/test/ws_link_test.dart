import 'dart:async';
import 'dart:convert' show json;

import 'package:shalom_core/shalom_core.dart';
import 'package:test/test.dart';

/// Fake WebSocket transport for testing
class FakeWebSocketTransport extends WebSocketTransport {
  final StreamController<JsonObject> _messageController =
      StreamController<JsonObject>.broadcast();

  final List<JsonObject> sentMessages = [];
  bool _isConnected = false;

  String? lastUrl;
  HeadersType? lastHeaders;
  List<String>? lastProtocols;

  // Configuration
  final bool shouldFailConnection;
  final Duration connectionDelay;

  StreamController<JsonObject>? _currentStreamController;

  FakeWebSocketTransport({
    this.shouldFailConnection = false,
    this.connectionDelay = const Duration(milliseconds: 10),
  });

  @override
  Future<(StreamController<JsonObject>, MessageSender)> connect({
    required String url,
    required List<String> protocols,
    HeadersType? headers,
  }) async {
    lastUrl = url;
    lastHeaders = headers;
    lastProtocols = protocols;

    await Future.delayed(connectionDelay);

    if (shouldFailConnection) {
      throw Exception('Connection failed');
    }

    _isConnected = true;

    // Create a stream controller that forwards to our broadcast controller
    final streamController = StreamController<JsonObject>();

    // Forward messages from broadcast to this specific connection
    final subscription = _messageController.stream.listen((message) {
      if (!streamController.isClosed) {
        streamController.add(message);
      }
    });

    // When the stream controller closes, clean up
    streamController.onCancel = () {
      subscription.cancel();
      _isConnected = false;
      _currentStreamController = null;
    };

    final sender = MessageSender((msg) async {
      if (!_isConnected) {
        throw StateError('WebSocket is not connected');
      }
      sentMessages.add(msg);
    });

    _currentStreamController = streamController;

    return (streamController, sender);
  }

  bool get isConnected => _isConnected;

  /// Simulate receiving a message from the server
  void receiveMessage(String messageString) {
    final messageJson = json.decode(messageString) as JsonObject;
    _messageController.add(messageJson);
  }

  /// Simulate server disconnect
  void simulateDisconnect() {
    _isConnected = false;
    _currentStreamController?.close();
  }

  void dispose() {
    _messageController.close();
    _currentStreamController?.close();
  }
}

void main() {
  group('WebSocketLink', () {
    late FakeWebSocketTransport $fakeTransport;
    late WebSocketLink $wsLink;

    setUp(() {
      $fakeTransport = FakeWebSocketTransport();
    });

    tearDown(() async {
      await $wsLink.dispose();
      $fakeTransport.dispose();
    });

    group('Connection', () {
      test('connects to WebSocket server with correct protocol', () async {
        $wsLink = WebSocketLink(
          transport: $fakeTransport,
          url: 'ws://localhost:4000/graphql',
        );

        await Future.delayed(const Duration(milliseconds: 50));

        expect($fakeTransport.lastUrl, 'ws://localhost:4000/graphql');
        expect($fakeTransport.lastProtocols, contains('graphql-transport-ws'));
      });

      test('passes headers to transport connect', () async {
        $wsLink = WebSocketLink(
          transport: $fakeTransport,
          url: 'ws://localhost:4000/graphql',
          headers: [
            ('Authorization', 'Bearer test-token'),
            ('X-Custom-Header', 'custom-value'),
          ],
        );

        await Future.delayed(const Duration(milliseconds: 50));

        expect($fakeTransport.lastHeaders, isNotNull);
        final $headersMap = Map.fromEntries(
            $fakeTransport.lastHeaders!.map((e) => MapEntry(e.$1, e.$2)));
        expect($headersMap['Authorization'], 'Bearer test-token');
        expect($headersMap['X-Custom-Header'], 'custom-value');
      });

      test('sends ConnectionInit message on connect', () async {
        $wsLink = WebSocketLink(
          transport: $fakeTransport,
          url: 'ws://localhost:4000/graphql',
        );

        await Future.delayed(const Duration(milliseconds: 50));

        expect($fakeTransport.sentMessages.length, greaterThan(0));

        final $initMessageJson = $fakeTransport.sentMessages.first;
        final $initMessage = parseWsMessage(json.encode($initMessageJson));
        expect($initMessage, isA<ConnectionInitMessage>());
      });

      test('sends ConnectionInit with connection params', () async {
        $wsLink = WebSocketLink(
          transport: $fakeTransport,
          url: 'ws://localhost:4000/graphql',
          connectionParams: {
            'authToken': 'test-token',
          },
        );

        await Future.delayed(const Duration(milliseconds: 50));

        final $initMessageJson = $fakeTransport.sentMessages.first;
        final $initMessage = parseWsMessage(json.encode($initMessageJson))
            as ConnectionInitMessage;
        expect($initMessage.payload, isNotNull);
        expect($initMessage.payload!['authToken'], 'test-token');
      });

      test('handles ConnectionAck from server', () async {
        $wsLink = WebSocketLink(
          transport: $fakeTransport,
          url: 'ws://localhost:4000/graphql',
        );

        await Future.delayed(const Duration(milliseconds: 50));

        expect($wsLink.isConnectionAcknowledged, isFalse);

        // Simulate server sending ConnectionAck
        $fakeTransport.receiveMessage(
          const ConnectionAckMessage().toJsonString(),
        );

        await Future.delayed(const Duration(milliseconds: 10));

        expect($wsLink.isConnectionAcknowledged, isTrue);
      });

      test('stores ConnectionAck payload', () async {
        $wsLink = WebSocketLink(
          transport: $fakeTransport,
          url: 'ws://localhost:4000/graphql',
        );

        await Future.delayed(const Duration(milliseconds: 50));

        final $ackPayload = {'serverVersion': '1.0.0'};
        $fakeTransport.receiveMessage(
          ConnectionAckMessage(payload: $ackPayload).toJsonString(),
        );

        await Future.delayed(const Duration(milliseconds: 10));

        expect($wsLink.connectionAckPayload, $ackPayload);
      });

      test('times out if ConnectionAck not received', () async {
        $wsLink = WebSocketLink(
          transport: $fakeTransport,
          url: 'ws://localhost:4000/graphql',
          connectionInitTimeout: const Duration(milliseconds: 100),
        );

        await Future.delayed(const Duration(milliseconds: 50));
        expect($wsLink.isConnected, isTrue);

        // Wait for timeout
        await Future.delayed(const Duration(milliseconds: 100));

        // Connection should be closed
        expect($wsLink.isConnected, isFalse);
      });
    });

    group('Ping/Pong', () {
      test('responds to Ping with Pong', () async {
        $wsLink = WebSocketLink(
          transport: $fakeTransport,
          url: 'ws://localhost:4000/graphql',
        );

        await Future.delayed(const Duration(milliseconds: 50));

        // Send ConnectionAck first
        $fakeTransport.receiveMessage(
          const ConnectionAckMessage().toJsonString(),
        );
        await Future.delayed(const Duration(milliseconds: 10));

        final $messageCountBefore = $fakeTransport.sentMessages.length;

        // Simulate server sending Ping
        $fakeTransport.receiveMessage(const PingMessage().toJsonString());
        await Future.delayed(const Duration(milliseconds: 10));

        final $newMessages =
            $fakeTransport.sentMessages.skip($messageCountBefore).toList();
        final $pongMessage = $newMessages.firstWhere(
          (msg) {
            final parsed = parseWsMessage(json.encode(msg));
            return parsed is PongMessage;
          },
          orElse: () => <String, dynamic>{},
        );

        expect($pongMessage, isNotEmpty);
      });

      test('sends Ping messages periodically', () async {
        $wsLink = WebSocketLink(
          transport: $fakeTransport,
          url: 'ws://localhost:4000/graphql',
          pingInterval: const Duration(milliseconds: 50),
        );

        await Future.delayed(const Duration(milliseconds: 20));

        // Send ConnectionAck
        $fakeTransport.receiveMessage(
          const ConnectionAckMessage().toJsonString(),
        );

        await Future.delayed(const Duration(milliseconds: 10));

        final $messageCountBefore = $fakeTransport.sentMessages.length;

        // Wait for ping
        await Future.delayed(const Duration(milliseconds: 60));

        final $newMessages =
            $fakeTransport.sentMessages.skip($messageCountBefore).toList();
        final $hasPing = $newMessages.any((msg) {
          final parsed = parseWsMessage(json.encode(msg));
          return parsed is PingMessage;
        });

        expect($hasPing, isTrue);
      });

      test('closes connection if Pong not received', () async {
        $wsLink = WebSocketLink(
          transport: $fakeTransport,
          url: 'ws://localhost:4000/graphql',
          pingInterval: const Duration(milliseconds: 50),
          pongTimeout: const Duration(milliseconds: 30),
        );

        await Future.delayed(const Duration(milliseconds: 20));

        // Send ConnectionAck
        $fakeTransport.receiveMessage(
          const ConnectionAckMessage().toJsonString(),
        );

        await Future.delayed(const Duration(milliseconds: 10));
        expect($wsLink.isConnected, isTrue);

        // Wait for ping and pong timeout
        await Future.delayed(const Duration(milliseconds: 100));

        // Connection should be closed due to pong timeout
        expect($wsLink.isConnected, isFalse);
      });

      test('cancels pong timeout when Pong received', () async {
        $wsLink = WebSocketLink(
          transport: $fakeTransport,
          url: 'ws://localhost:4000/graphql',
          pingInterval: const Duration(milliseconds: 50),
          pongTimeout: const Duration(milliseconds: 30),
        );

        await Future.delayed(const Duration(milliseconds: 20));

        // Send ConnectionAck
        $fakeTransport.receiveMessage(
          const ConnectionAckMessage().toJsonString(),
        );

        await Future.delayed(const Duration(milliseconds: 60));

        // Respond with Pong
        $fakeTransport.receiveMessage(const PongMessage().toJsonString());

        await Future.delayed(const Duration(milliseconds: 40));

        // Connection should still be open
        expect($wsLink.isConnected, isTrue);
      });
    });

    group('Operations', () {
      test('sends Subscribe message for query', () async {
        $wsLink = WebSocketLink(
          transport: $fakeTransport,
          url: 'ws://localhost:4000/graphql',
        );

        await Future.delayed(const Duration(milliseconds: 20));

        // Send ConnectionAck
        $fakeTransport.receiveMessage(
          const ConnectionAckMessage().toJsonString(),
        );

        await Future.delayed(const Duration(milliseconds: 10));

        final $messageCountBefore = $fakeTransport.sentMessages.length;

        // Execute query
        final $request = Request(
          query: 'query { hello }',
          variables: const {},
          opType: OperationType.Query,
          opName: 'HelloQuery',
        );

        final $stream = $wsLink.request(request: $request, headers: []);
        final $subscription = $stream.listen((_) {});

        await Future.delayed(const Duration(milliseconds: 10));

        final $newMessages =
            $fakeTransport.sentMessages.skip($messageCountBefore).toList();
        final $subscribeMessage = $newMessages.firstWhere(
          (msg) {
            final parsed = parseWsMessage(json.encode(msg));
            return parsed is SubscribeMessage;
          },
          orElse: () => <String, dynamic>{},
        );

        expect($subscribeMessage, isNotEmpty);

        await $subscription.cancel();
      });

      test('handles Next message from server', () async {
        $wsLink = WebSocketLink(
          transport: $fakeTransport,
          url: 'ws://localhost:4000/graphql',
        );

        await Future.delayed(const Duration(milliseconds: 20));

        // Send ConnectionAck
        $fakeTransport.receiveMessage(
          const ConnectionAckMessage().toJsonString(),
        );

        await Future.delayed(const Duration(milliseconds: 10));

        // Execute query
        final $request = Request(
          query: 'query { hello }',
          variables: const {},
          opType: OperationType.Query,
          opName: 'HelloQuery',
        );

        final $responses = <GraphQLResponse>[];
        final $stream = $wsLink.request(request: $request, headers: []);
        final $subscription = $stream.listen($responses.add);

        await Future.delayed(const Duration(milliseconds: 10));

        // Get the operation ID from the Subscribe message
        final $subscribeMsg = $fakeTransport.sentMessages.lastWhere((msg) {
          final parsed = parseWsMessage(json.encode(msg));
          return parsed is SubscribeMessage;
        });
        final $subscribeParsed =
            parseWsMessage(json.encode($subscribeMsg)) as SubscribeMessage;
        final $operationId = $subscribeParsed.id;

        // Send Next message
        $fakeTransport.receiveMessage(
          NextMessage(
            id: $operationId,
            payload: {
              'data': {'hello': 'world'},
            },
          ).toJsonString(),
        );

        await Future.delayed(const Duration(milliseconds: 10));

        expect($responses.length, 1);
        expect($responses.first, isA<GraphQLData>());
        final $data = $responses.first as GraphQLData;
        expect($data.data['hello'], 'world');

        await $subscription.cancel();
      });

      test('handles Error message from server', () async {
        $wsLink = WebSocketLink(
          transport: $fakeTransport,
          url: 'ws://localhost:4000/graphql',
        );

        await Future.delayed(const Duration(milliseconds: 20));

        // Send ConnectionAck
        $fakeTransport.receiveMessage(
          const ConnectionAckMessage().toJsonString(),
        );

        await Future.delayed(const Duration(milliseconds: 10));

        // Execute query
        final $request = Request(
          query: 'query { hello }',
          variables: const {},
          opType: OperationType.Query,
          opName: 'HelloQuery',
        );

        final $responses = <GraphQLResponse>[];
        final $stream = $wsLink.request(request: $request, headers: []);
        final $subscription = $stream.listen($responses.add);

        await Future.delayed(const Duration(milliseconds: 10));

        // Get the operation ID
        final $subscribeMsg = $fakeTransport.sentMessages.lastWhere((msg) {
          final parsed = parseWsMessage(json.encode(msg));
          return parsed is SubscribeMessage;
        });
        final $subscribeParsed =
            parseWsMessage(json.encode($subscribeMsg)) as SubscribeMessage;
        final $operationId = $subscribeParsed.id;

        // Send Error message
        $fakeTransport.receiveMessage(
          ErrorMessage(
            id: $operationId,
            payload: [
              {'message': 'Something went wrong'},
            ],
          ).toJsonString(),
        );

        await Future.delayed(const Duration(milliseconds: 10));

        expect($responses.length, 1);
        expect($responses.first, isA<LinkErrorResponse>());

        await $subscription.cancel();
      });

      test('handles Complete message from server', () async {
        $wsLink = WebSocketLink(
          transport: $fakeTransport,
          url: 'ws://localhost:4000/graphql',
        );

        await Future.delayed(const Duration(milliseconds: 20));

        // Send ConnectionAck
        $fakeTransport.receiveMessage(
          const ConnectionAckMessage().toJsonString(),
        );

        await Future.delayed(const Duration(milliseconds: 10));

        // Execute query
        final $request = Request(
          query: 'query { hello }',
          variables: const {},
          opType: OperationType.Query,
          opName: 'HelloQuery',
        );

        var $completed = false;
        final $stream = $wsLink.request(request: $request, headers: []);
        final $subscription = $stream.listen(
          (_) {},
          onDone: () => $completed = true,
        );

        await Future.delayed(const Duration(milliseconds: 10));

        // Get the operation ID
        final $subscribeMsg = $fakeTransport.sentMessages.lastWhere((msg) {
          final parsed = parseWsMessage(json.encode(msg));
          return parsed is SubscribeMessage;
        });
        final $subscribeParsed =
            parseWsMessage(json.encode($subscribeMsg)) as SubscribeMessage;
        final $operationId = $subscribeParsed.id;

        // Send Complete message
        $fakeTransport.receiveMessage(
          CompleteMessage(id: $operationId).toJsonString(),
        );

        await Future.delayed(const Duration(milliseconds: 10));

        expect($completed, isTrue);

        await $subscription.cancel();
      });

      test('sends Complete message when subscription cancelled', () async {
        $wsLink = WebSocketLink(
          transport: $fakeTransport,
          url: 'ws://localhost:4000/graphql',
        );

        await Future.delayed(const Duration(milliseconds: 20));

        // Send ConnectionAck
        $fakeTransport.receiveMessage(
          const ConnectionAckMessage().toJsonString(),
        );

        await Future.delayed(const Duration(milliseconds: 10));

        // Execute query
        final $request = Request(
          query: 'subscription { messages }',
          variables: const {},
          opType: OperationType.Subscription,
          opName: 'MessagesSub',
        );

        final $stream = $wsLink.request(request: $request, headers: []);
        final $subscription = $stream.listen((_) {});

        await Future.delayed(const Duration(milliseconds: 10));

        final $messageCountBefore = $fakeTransport.sentMessages.length;

        // Cancel subscription
        await $subscription.cancel();

        await Future.delayed(const Duration(milliseconds: 10));

        final $newMessages =
            $fakeTransport.sentMessages.skip($messageCountBefore).toList();
        final $completeMessage = $newMessages.any((msg) {
          final parsed = parseWsMessage(json.encode(msg));
          return parsed is CompleteMessage;
        });

        expect($completeMessage, isTrue);
      });
    });

    group('Reconnection', () {
      test('reconnects automatically when connection lost', () async {
        $wsLink = WebSocketLink(
          transport: $fakeTransport,
          url: 'ws://localhost:4000/graphql',
          autoReconnect: true,
          reconnectTimeout: const Duration(milliseconds: 50),
        );

        await Future.delayed(const Duration(milliseconds: 20));

        // Send ConnectionAck
        $fakeTransport.receiveMessage(
          const ConnectionAckMessage().toJsonString(),
        );

        await Future.delayed(const Duration(milliseconds: 10));
        expect($wsLink.isConnected, isTrue);

        // Simulate disconnect
        $fakeTransport.simulateDisconnect();

        await Future.delayed(const Duration(milliseconds: 10));
        expect($wsLink.isConnected, isFalse);

        // Wait for reconnection
        await Future.delayed(const Duration(milliseconds: 100));

        // Should have reconnected (fake transport allows successful reconnection)
        // After reconnection, send ConnectionAck to complete the handshake
        $fakeTransport.receiveMessage(
          const ConnectionAckMessage().toJsonString(),
        );

        await Future.delayed(const Duration(milliseconds: 10));
        expect($wsLink.isConnected, isTrue);
        expect($wsLink.isConnectionAcknowledged, isTrue);
      });

      test('does not reconnect when autoReconnect is false', () async {
        $wsLink = WebSocketLink(
          transport: $fakeTransport,
          url: 'ws://localhost:4000/graphql',
          autoReconnect: false,
        );

        await Future.delayed(const Duration(milliseconds: 20));

        // Send ConnectionAck
        $fakeTransport.receiveMessage(
          const ConnectionAckMessage().toJsonString(),
        );

        await Future.delayed(const Duration(milliseconds: 10));
        expect($wsLink.isConnected, isTrue);

        // Simulate disconnect
        $fakeTransport.simulateDisconnect();

        await Future.delayed(const Duration(milliseconds: 100));

        expect($wsLink.isConnected, isFalse);
      });

      test('re-executes pending operations after reconnect', () async {
        $wsLink = WebSocketLink(
          transport: $fakeTransport,
          url: 'ws://localhost:4000/graphql',
          autoReconnect: true,
          reconnectTimeout: const Duration(milliseconds: 50),
        );

        await Future.delayed(const Duration(milliseconds: 20));

        // Start operation before connection is acknowledged
        final $request = Request(
          query: 'subscription { messages }',
          variables: const {},
          opType: OperationType.Subscription,
          opName: 'MessagesSub',
        );

        final $responses = <GraphQLResponse>[];
        final $stream = $wsLink.request(request: $request, headers: []);
        final $subscription = $stream.listen($responses.add);

        await Future.delayed(const Duration(milliseconds: 10));

        // Send ConnectionAck
        $fakeTransport.receiveMessage(
          const ConnectionAckMessage().toJsonString(),
        );

        await Future.delayed(const Duration(milliseconds: 20));

        // Should have sent Subscribe message
        final $hasSubscribe = $fakeTransport.sentMessages.any((msg) {
          final parsed = parseWsMessage(json.encode(msg));
          return parsed is SubscribeMessage;
        });
        expect($hasSubscribe, isTrue);

        await $subscription.cancel();
      });
    });

    group('Disposal', () {
      test('cleans up resources on dispose', () async {
        $wsLink = WebSocketLink(
          transport: $fakeTransport,
          url: 'ws://localhost:4000/graphql',
        );

        await Future.delayed(const Duration(milliseconds: 20));

        // Send ConnectionAck
        $fakeTransport.receiveMessage(
          const ConnectionAckMessage().toJsonString(),
        );

        await Future.delayed(const Duration(milliseconds: 10));

        expect($wsLink.isConnected, isTrue);

        await $wsLink.dispose();

        expect($wsLink.isConnected, isFalse);
      });

      test('closes all active operations on dispose', () async {
        $wsLink = WebSocketLink(
          transport: $fakeTransport,
          url: 'ws://localhost:4000/graphql',
        );

        await Future.delayed(const Duration(milliseconds: 20));

        // Send ConnectionAck
        $fakeTransport.receiveMessage(
          const ConnectionAckMessage().toJsonString(),
        );

        await Future.delayed(const Duration(milliseconds: 10));

        // Start multiple operations
        final $request = Request(
          query: 'subscription { messages }',
          variables: const {},
          opType: OperationType.Subscription,
          opName: 'MessagesSub',
        );

        var $completed1 = false;
        var $completed2 = false;

        final $stream1 = $wsLink.request(request: $request, headers: []);
        final $sub1 = $stream1.listen((_) {}, onDone: () => $completed1 = true);

        final $stream2 = $wsLink.request(request: $request, headers: []);
        final $sub2 = $stream2.listen((_) {}, onDone: () => $completed2 = true);

        await Future.delayed(const Duration(milliseconds: 10));

        await $wsLink.dispose();

        await Future.delayed(const Duration(milliseconds: 10));

        expect($completed1, isTrue);
        expect($completed2, isTrue);

        await $sub1.cancel();
        await $sub2.cancel();
      });
    });
  });
}
