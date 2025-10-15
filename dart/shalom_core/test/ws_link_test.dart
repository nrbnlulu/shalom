import 'dart:async';

import 'package:shalom_core/shalom_core.dart';
import 'package:test/test.dart';

/// Fake WebSocket transport for testing
class FakeWebSocketTransport extends WebSocketTransport {
  final StreamController<String> _messageController =
      StreamController<String>.broadcast();
  final StreamController<WebSocketState> _stateController =
      StreamController<WebSocketState>.broadcast();

  WebSocketState _currentState = WebSocketState.disconnected;
  final List<String> sentMessages = [];
  bool _isConnected = false;

  String? lastUrl;
  JsonObject? lastHeaders;
  List<String>? lastProtocols;

  // Configuration
  final bool shouldFailConnection;
  final Duration connectionDelay;

  FakeWebSocketTransport({
    this.shouldFailConnection = false,
    this.connectionDelay = const Duration(milliseconds: 10),
  });

  @override
  Stream<String> get messages => _messageController.stream;

  @override
  Stream<WebSocketState> get stateChanges => _stateController.stream;

  @override
  WebSocketState get state => _currentState;

  @override
  bool get isConnected => _isConnected;

  @override
  Future<void> connect({
    required String url,
    JsonObject? headers,
    List<String>? protocols,
  }) async {
    lastUrl = url;
    lastHeaders = headers;
    lastProtocols = protocols;

    _setState(WebSocketState.connecting);

    await Future.delayed(connectionDelay);

    if (shouldFailConnection) {
      _setState(WebSocketState.disconnected);
      throw Exception('Connection failed');
    }

    _isConnected = true;
    _setState(WebSocketState.connected);
  }

  @override
  void send(String message) {
    if (!_isConnected) {
      throw StateError('WebSocket is not connected');
    }
    sentMessages.add(message);
  }

  @override
  Future<void> close([int code = 1000, String? reason]) async {
    _isConnected = false;
    _setState(WebSocketState.closing);
    await Future.delayed(const Duration(milliseconds: 10));
    _setState(WebSocketState.closed);
    _setState(WebSocketState.disconnected);
  }

  void _setState(WebSocketState newState) {
    _currentState = newState;
    if (!_stateController.isClosed) {
      _stateController.add(newState);
    }
  }

  /// Simulate receiving a message from the server
  void receiveMessage(String message) {
    _messageController.add(message);
  }

  /// Simulate server disconnect
  void simulateDisconnect() {
    _isConnected = false;
    _setState(WebSocketState.disconnected);
  }

  void dispose() {
    _messageController.close();
    _stateController.close();
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

      test('sends ConnectionInit message on connect', () async {
        $wsLink = WebSocketLink(
          transport: $fakeTransport,
          url: 'ws://localhost:4000/graphql',
        );

        await Future.delayed(const Duration(milliseconds: 50));

        expect($fakeTransport.sentMessages.length, greaterThan(0));

        final $initMessage = parseWsMessage($fakeTransport.sentMessages.first);
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

        final $initMessage = parseWsMessage($fakeTransport.sentMessages.first)
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
        expect($fakeTransport.state, WebSocketState.disconnected);
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
          (msg) => parseWsMessage(msg) is PongMessage,
          orElse: () => '',
        );

        expect($pongMessage, isNotEmpty);
      });

      test('sends periodic Ping messages after ConnectionAck', () async {
        $wsLink = WebSocketLink(
          transport: $fakeTransport,
          url: 'ws://localhost:4000/graphql',
          pingInterval: const Duration(milliseconds: 100),
        );

        await Future.delayed(const Duration(milliseconds: 50));

        // Send ConnectionAck
        $fakeTransport.receiveMessage(
          const ConnectionAckMessage().toJsonString(),
        );

        final $messageCountBefore = $fakeTransport.sentMessages.length;

        // Wait for ping interval
        await Future.delayed(const Duration(milliseconds: 150));

        final $newMessages =
            $fakeTransport.sentMessages.skip($messageCountBefore).toList();
        final $hasPing =
            $newMessages.any((msg) => parseWsMessage(msg) is PingMessage);

        expect($hasPing, isTrue);
      });

      test('closes connection on Pong timeout', () async {
        $wsLink = WebSocketLink(
          transport: $fakeTransport,
          url: 'ws://localhost:4000/graphql',
          pingInterval: const Duration(milliseconds: 50),
          pongTimeout: const Duration(milliseconds: 30),
        );

        await Future.delayed(const Duration(milliseconds: 50));

        // Send ConnectionAck
        $fakeTransport.receiveMessage(
          const ConnectionAckMessage().toJsonString(),
        );

        // Wait for ping and pong timeout (don't respond with pong)
        await Future.delayed(const Duration(milliseconds: 200));

        // Connection should be closing or closed
        expect(
          $fakeTransport.state,
          anyOf(
            WebSocketState.closing,
            WebSocketState.closed,
            WebSocketState.disconnected,
          ),
        );
      });
    });

    group('Operations', () {
      test('sends Subscribe message for operation', () async {
        $wsLink = WebSocketLink(
          transport: $fakeTransport,
          url: 'ws://localhost:4000/graphql',
        );

        await Future.delayed(const Duration(milliseconds: 50));

        // Send ConnectionAck
        $fakeTransport.receiveMessage(
          const ConnectionAckMessage().toJsonString(),
        );
        await Future.delayed(const Duration(milliseconds: 10));

        final $request = Request(
          query: 'subscription { messageAdded { id text } }',
          variables: {},
          opType: OperationType.Subscription,
          opName: 'MessageSubscription',
        );

        final $stream = $wsLink.request(request: $request, headers: {});
        final $subscription = $stream.listen((_) {});

        await Future.delayed(const Duration(milliseconds: 10));

        // Check that Subscribe message was sent
        final $subscribeMsg = $fakeTransport.sentMessages.lastWhere(
          (msg) => parseWsMessage(msg) is SubscribeMessage,
        );

        final $parsedMsg = parseWsMessage($subscribeMsg) as SubscribeMessage;
        expect($parsedMsg.payload.query, contains('messageAdded'));
        expect($parsedMsg.payload.operationName, 'MessageSubscription');

        await $subscription.cancel();
      });

      test('receives Next message and emits GraphQLData', () async {
        $wsLink = WebSocketLink(
          transport: $fakeTransport,
          url: 'ws://localhost:4000/graphql',
        );

        await Future.delayed(const Duration(milliseconds: 50));

        // Send ConnectionAck
        $fakeTransport.receiveMessage(
          const ConnectionAckMessage().toJsonString(),
        );
        await Future.delayed(const Duration(milliseconds: 10));

        final $request = Request(
          query: 'subscription { messageAdded { id text } }',
          variables: {},
          opType: OperationType.Subscription,
          opName: 'MessageSubscription',
        );

        final $responses = <GraphQLResponse>[];
        final $stream = $wsLink.request(request: $request, headers: {});
        final $subscription = $stream.listen($responses.add);

        await Future.delayed(const Duration(milliseconds: 10));

        // Get the operation ID from the Subscribe message
        final $subscribeMsg = $fakeTransport.sentMessages.lastWhere(
          (msg) => parseWsMessage(msg) is SubscribeMessage,
        );
        final $parsedSubscribe =
            parseWsMessage($subscribeMsg) as SubscribeMessage;
        final $operationId = $parsedSubscribe.id;

        // Send Next message
        $fakeTransport.receiveMessage(
          NextMessage(
            id: $operationId,
            payload: {
              'data': {
                'messageAdded': {'id': '1', 'text': 'Hello'}
              }
            },
          ).toJsonString(),
        );

        await Future.delayed(const Duration(milliseconds: 10));

        expect($responses.length, 1);
        expect($responses[0], isA<GraphQLData>());

        final $data = $responses[0] as GraphQLData;
        expect($data.data['messageAdded']['text'], 'Hello');

        await $subscription.cancel();
      });

      test('receives multiple Next messages', () async {
        $wsLink = WebSocketLink(
          transport: $fakeTransport,
          url: 'ws://localhost:4000/graphql',
        );

        await Future.delayed(const Duration(milliseconds: 50));

        $fakeTransport.receiveMessage(
          const ConnectionAckMessage().toJsonString(),
        );
        await Future.delayed(const Duration(milliseconds: 10));

        final $request = Request(
          query: 'subscription { count }',
          variables: {},
          opType: OperationType.Subscription,
          opName: 'CountSubscription',
        );

        final $responses = <GraphQLResponse>[];
        final $stream = $wsLink.request(request: $request, headers: {});
        final $subscription = $stream.listen($responses.add);

        await Future.delayed(const Duration(milliseconds: 10));

        final $subscribeMsg = $fakeTransport.sentMessages.lastWhere(
          (msg) => parseWsMessage(msg) is SubscribeMessage,
        );
        final $operationId =
            (parseWsMessage($subscribeMsg) as SubscribeMessage).id;

        // Send multiple Next messages
        for (var i = 1; i <= 3; i++) {
          $fakeTransport.receiveMessage(
            NextMessage(
              id: $operationId,
              payload: {
                'data': {'count': i}
              },
            ).toJsonString(),
          );
          await Future.delayed(const Duration(milliseconds: 5));
        }

        expect($responses.length, 3);
        expect(($responses[0] as GraphQLData).data['count'], 1);
        expect(($responses[1] as GraphQLData).data['count'], 2);
        expect(($responses[2] as GraphQLData).data['count'], 3);

        await $subscription.cancel();
      });

      test('handles Error message', () async {
        $wsLink = WebSocketLink(
          transport: $fakeTransport,
          url: 'ws://localhost:4000/graphql',
        );

        await Future.delayed(const Duration(milliseconds: 50));

        $fakeTransport.receiveMessage(
          const ConnectionAckMessage().toJsonString(),
        );
        await Future.delayed(const Duration(milliseconds: 10));

        final $request = Request(
          query: 'subscription { invalid }',
          variables: {},
          opType: OperationType.Subscription,
          opName: 'Invalid',
        );

        final $responses = <GraphQLResponse>[];
        final $completer = Completer<void>();

        final $stream = $wsLink.request(request: $request, headers: {});
        final $subscription = $stream.listen(
          $responses.add,
          onDone: () => $completer.complete(),
        );

        await Future.delayed(const Duration(milliseconds: 10));

        final $subscribeMsg = $fakeTransport.sentMessages.lastWhere(
          (msg) => parseWsMessage(msg) is SubscribeMessage,
        );
        final $operationId =
            (parseWsMessage($subscribeMsg) as SubscribeMessage).id;

        // Send Error message
        $fakeTransport.receiveMessage(
          ErrorMessage(
            id: $operationId,
            payload: [
              {'message': 'Field "invalid" does not exist'}
            ],
          ).toJsonString(),
        );

        await $completer.future.timeout(const Duration(milliseconds: 100));

        expect($responses.length, 1);
        expect($responses[0], isA<LinkErrorResponse>());

        final $error = $responses[0] as LinkErrorResponse;
        expect($error.errors['errors'], isA<List>());

        await $subscription.cancel();
      });

      test('handles Complete message from server', () async {
        $wsLink = WebSocketLink(
          transport: $fakeTransport,
          url: 'ws://localhost:4000/graphql',
        );

        await Future.delayed(const Duration(milliseconds: 50));

        $fakeTransport.receiveMessage(
          const ConnectionAckMessage().toJsonString(),
        );
        await Future.delayed(const Duration(milliseconds: 10));

        final $request = Request(
          query: 'subscription { message }',
          variables: {},
          opType: OperationType.Subscription,
          opName: 'MessageSub',
        );

        final $completer = Completer<void>();
        final $stream = $wsLink.request(request: $request, headers: {});
        final $subscription = $stream.listen(
          (_) {},
          onDone: () => $completer.complete(),
        );

        await Future.delayed(const Duration(milliseconds: 10));

        final $subscribeMsg = $fakeTransport.sentMessages.lastWhere(
          (msg) => parseWsMessage(msg) is SubscribeMessage,
        );
        final $operationId =
            (parseWsMessage($subscribeMsg) as SubscribeMessage).id;

        // Send Complete message
        $fakeTransport.receiveMessage(
          CompleteMessage(id: $operationId).toJsonString(),
        );

        await $completer.future.timeout(const Duration(milliseconds: 100));

        // Stream should be closed
        expect($completer.isCompleted, isTrue);

        await $subscription.cancel();
      });

      test('sends Complete message when subscription is cancelled', () async {
        $wsLink = WebSocketLink(
          transport: $fakeTransport,
          url: 'ws://localhost:4000/graphql',
        );

        await Future.delayed(const Duration(milliseconds: 50));

        $fakeTransport.receiveMessage(
          const ConnectionAckMessage().toJsonString(),
        );
        await Future.delayed(const Duration(milliseconds: 10));

        final $request = Request(
          query: 'subscription { message }',
          variables: {},
          opType: OperationType.Subscription,
          opName: 'MessageSub',
        );

        final $stream = $wsLink.request(request: $request, headers: {});
        final $subscription = $stream.listen((_) {});

        await Future.delayed(const Duration(milliseconds: 10));

        final $subscribeMsg = $fakeTransport.sentMessages.lastWhere(
          (msg) => parseWsMessage(msg) is SubscribeMessage,
        );
        final $operationId =
            (parseWsMessage($subscribeMsg) as SubscribeMessage).id;

        final $messageCountBefore = $fakeTransport.sentMessages.length;

        // Cancel subscription
        await $subscription.cancel();
        await Future.delayed(const Duration(milliseconds: 10));

        final $newMessages =
            $fakeTransport.sentMessages.skip($messageCountBefore).toList();
        final $completeMsg = $newMessages.firstWhere(
          (msg) {
            final parsed = parseWsMessage(msg);
            return parsed is CompleteMessage && parsed.id == $operationId;
          },
          orElse: () => '',
        );

        expect($completeMsg, isNotEmpty);
      });

      test('handles multiple concurrent operations', () async {
        $wsLink = WebSocketLink(
          transport: $fakeTransport,
          url: 'ws://localhost:4000/graphql',
        );

        await Future.delayed(const Duration(milliseconds: 50));

        $fakeTransport.receiveMessage(
          const ConnectionAckMessage().toJsonString(),
        );
        await Future.delayed(const Duration(milliseconds: 10));

        // Create two subscriptions
        final $request1 = Request(
          query: 'subscription { messageAdded }',
          variables: {},
          opType: OperationType.Subscription,
          opName: 'Sub1',
        );

        final $request2 = Request(
          query: 'subscription { userOnline }',
          variables: {},
          opType: OperationType.Subscription,
          opName: 'Sub2',
        );

        final $responses1 = <GraphQLResponse>[];
        final $responses2 = <GraphQLResponse>[];

        final $stream1 = $wsLink.request(request: $request1, headers: {});
        final $subscription1 = $stream1.listen($responses1.add);

        final $stream2 = $wsLink.request(request: $request2, headers: {});
        final $subscription2 = $stream2.listen($responses2.add);

        await Future.delayed(const Duration(milliseconds: 10));

        // Get operation IDs
        final $subscribeMsgs = $fakeTransport.sentMessages
            .where((msg) => parseWsMessage(msg) is SubscribeMessage)
            .toList();

        expect($subscribeMsgs.length, greaterThanOrEqualTo(2));

        final $id1 = (parseWsMessage($subscribeMsgs[$subscribeMsgs.length - 2])
                as SubscribeMessage)
            .id;
        final $id2 =
            (parseWsMessage($subscribeMsgs.last) as SubscribeMessage).id;

        // Send data to both subscriptions
        $fakeTransport.receiveMessage(
          NextMessage(
            id: $id1,
            payload: {
              'data': {'messageAdded': 'Hello'}
            },
          ).toJsonString(),
        );

        $fakeTransport.receiveMessage(
          NextMessage(
            id: $id2,
            payload: {
              'data': {'userOnline': 'User1'}
            },
          ).toJsonString(),
        );

        await Future.delayed(const Duration(milliseconds: 10));

        expect($responses1.length, 1);
        expect($responses2.length, 1);

        await $subscription1.cancel();
        await $subscription2.cancel();
      });
    });

    group('Reconnection', () {
      test('automatically reconnects on disconnect when autoReconnect is true',
          () async {
        $wsLink = WebSocketLink(
          transport: $fakeTransport,
          url: 'ws://localhost:4000/graphql',
          autoReconnect: true,
          reconnectTimeout: const Duration(milliseconds: 50),
        );

        await Future.delayed(const Duration(milliseconds: 50));

        expect($fakeTransport.isConnected, isTrue);

        // Simulate disconnect
        $fakeTransport.simulateDisconnect();

        await Future.delayed(const Duration(milliseconds: 10));
        expect($fakeTransport.isConnected, isFalse);

        // Wait for reconnect
        await Future.delayed(const Duration(milliseconds: 100));

        expect($fakeTransport.lastUrl, 'ws://localhost:4000/graphql');
      });

      test('re-executes pending operations after reconnect', () async {
        $wsLink = WebSocketLink(
          transport: $fakeTransport,
          url: 'ws://localhost:4000/graphql',
          autoReconnect: true,
          reconnectTimeout: const Duration(milliseconds: 50),
        );

        await Future.delayed(const Duration(milliseconds: 50));

        $fakeTransport.receiveMessage(
          const ConnectionAckMessage().toJsonString(),
        );
        await Future.delayed(const Duration(milliseconds: 10));

        // Start a subscription
        final $request = Request(
          query: 'subscription { message }',
          variables: {},
          opType: OperationType.Subscription,
          opName: 'MessageSub',
        );

        final $responses = <GraphQLResponse>[];
        final $stream = $wsLink.request(request: $request, headers: {});
        final $subscription = $stream.listen($responses.add);

        await Future.delayed(const Duration(milliseconds: 10));

        final $messageCountBeforeDisconnect =
            $fakeTransport.sentMessages.length;

        // Simulate disconnect
        $fakeTransport.simulateDisconnect();
        await Future.delayed(const Duration(milliseconds: 10));

        // Reconnect and send ConnectionAck
        await Future.delayed(const Duration(milliseconds: 100));
        $fakeTransport.receiveMessage(
          const ConnectionAckMessage().toJsonString(),
        );
        await Future.delayed(const Duration(milliseconds: 20));

        // Check that Subscribe was sent again
        final $newMessages = $fakeTransport.sentMessages
            .skip($messageCountBeforeDisconnect)
            .toList();
        final $hasNewSubscribe = $newMessages.any(
          (msg) => parseWsMessage(msg) is SubscribeMessage,
        );

        expect($hasNewSubscribe, isTrue);

        await $subscription.cancel();
      });

      test('does not reconnect when autoReconnect is false', () async {
        $wsLink = WebSocketLink(
          transport: $fakeTransport,
          url: 'ws://localhost:4000/graphql',
          autoReconnect: false,
        );

        await Future.delayed(const Duration(milliseconds: 50));

        // Simulate disconnect
        $fakeTransport.simulateDisconnect();

        await Future.delayed(const Duration(milliseconds: 200));

        // Should not have reconnected (no additional connect call)
        expect($fakeTransport.state, WebSocketState.disconnected);
      });
    });

    group('Error Handling', () {
      test('handles connection errors', () async {
        final $failingTransport =
            FakeWebSocketTransport(shouldFailConnection: true);

        $wsLink = WebSocketLink(
          transport: $failingTransport,
          url: 'ws://localhost:4000/graphql',
        );

        await Future.delayed(const Duration(milliseconds: 50));

        expect($failingTransport.isConnected, isFalse);

        $failingTransport.dispose();
      });

      test('handles invalid message format', () async {
        $wsLink = WebSocketLink(
          transport: $fakeTransport,
          url: 'ws://localhost:4000/graphql',
        );

        await Future.delayed(const Duration(milliseconds: 50));

        // Send invalid JSON
        $fakeTransport.receiveMessage('invalid json');

        await Future.delayed(const Duration(milliseconds: 50));

        // Connection should be closed
        expect($fakeTransport.state, WebSocketState.disconnected);
      });
    });

    group('Queries and Mutations', () {
      test('executes query operation', () async {
        $wsLink = WebSocketLink(
          transport: $fakeTransport,
          url: 'ws://localhost:4000/graphql',
        );

        await Future.delayed(const Duration(milliseconds: 50));

        $fakeTransport.receiveMessage(
          const ConnectionAckMessage().toJsonString(),
        );
        await Future.delayed(const Duration(milliseconds: 10));

        final $request = Request(
          query: 'query GetUser { user { id name } }',
          variables: {},
          opType: OperationType.Query,
          opName: 'GetUser',
        );

        final $responses = <GraphQLResponse>[];
        final $completer = Completer<void>();

        final $stream = $wsLink.request(request: $request, headers: {});
        final $subscription = $stream.listen(
          $responses.add,
          onDone: () => $completer.complete(),
        );

        await Future.delayed(const Duration(milliseconds: 10));

        final $subscribeMsg = $fakeTransport.sentMessages.lastWhere(
          (msg) => parseWsMessage(msg) is SubscribeMessage,
        );
        final $operationId =
            (parseWsMessage($subscribeMsg) as SubscribeMessage).id;

        // Send single result and complete
        $fakeTransport.receiveMessage(
          NextMessage(
            id: $operationId,
            payload: {
              'data': {
                'user': {'id': '1', 'name': 'Test User'}
              }
            },
          ).toJsonString(),
        );

        $fakeTransport.receiveMessage(
          CompleteMessage(id: $operationId).toJsonString(),
        );

        await $completer.future.timeout(const Duration(milliseconds: 100));

        expect($responses.length, 1);
        expect($responses[0], isA<GraphQLData>());

        final $data = $responses[0] as GraphQLData;
        expect($data.data['user']['name'], 'Test User');

        await $subscription.cancel();
      });

      test('executes mutation operation', () async {
        $wsLink = WebSocketLink(
          transport: $fakeTransport,
          url: 'ws://localhost:4000/graphql',
        );

        await Future.delayed(const Duration(milliseconds: 50));

        $fakeTransport.receiveMessage(
          const ConnectionAckMessage().toJsonString(),
        );
        await Future.delayed(const Duration(milliseconds: 10));

        final $request = Request(
          query: 'mutation CreateUser { createUser { id } }',
          variables: {},
          opType: OperationType.Mutation,
          opName: 'CreateUser',
        );

        final $responses = <GraphQLResponse>[];
        final $stream = $wsLink.request(request: $request, headers: {});
        final $subscription = $stream.listen($responses.add);

        await Future.delayed(const Duration(milliseconds: 10));

        final $subscribeMsg = $fakeTransport.sentMessages.lastWhere(
          (msg) => parseWsMessage(msg) is SubscribeMessage,
        );
        final $operationId =
            (parseWsMessage($subscribeMsg) as SubscribeMessage).id;

        $fakeTransport.receiveMessage(
          NextMessage(
            id: $operationId,
            payload: {
              'data': {
                'createUser': {'id': '123'}
              }
            },
          ).toJsonString(),
        );

        await Future.delayed(const Duration(milliseconds: 10));

        expect($responses.length, 1);
        expect($responses[0], isA<GraphQLData>());

        await $subscription.cancel();
      });
    });

    group('Cleanup', () {
      test('disposes properly and closes all streams', () async {
        $wsLink = WebSocketLink(
          transport: $fakeTransport,
          url: 'ws://localhost:4000/graphql',
        );

        await Future.delayed(const Duration(milliseconds: 50));

        $fakeTransport.receiveMessage(
          const ConnectionAckMessage().toJsonString(),
        );
        await Future.delayed(const Duration(milliseconds: 10));

        // Create a subscription
        final $request = Request(
          query: 'subscription { message }',
          variables: {},
          opType: OperationType.Subscription,
          opName: 'MessageSub',
        );

        final $completer = Completer<void>();
        final $stream = $wsLink.request(request: $request, headers: {});
        final $subscription = $stream.listen(
          (_) {},
          onDone: () => $completer.complete(),
        );

        await Future.delayed(const Duration(milliseconds: 10));

        // Dispose
        await $wsLink.dispose();

        // Stream should be closed
        await $completer.future.timeout(const Duration(milliseconds: 100));

        expect($completer.isCompleted, isTrue);

        await $subscription.cancel();
      });
    });
  });
}
