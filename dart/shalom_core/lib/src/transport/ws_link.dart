import 'dart:async';
import 'dart:convert' show json;
import 'dart:developer' show log;

import 'package:shalom_core/shalom_core.dart';

/// Implementation of GraphQL WebSocket protocol as specified in:
/// https://github.com/enisdenjo/graphql-ws/blob/master/PROTOCOL.md
///
/// This link manages WebSocket connections for GraphQL subscriptions,
/// queries, and mutations over WebSocket transport.
class WebSocketLink extends GraphQLLink {
  final WebSocketTransport transport;
  final String url;
  final HeadersType? headers;
  final JsonObject? connectionParams;
  final bool autoReconnect;
  final Duration connectionInitTimeout;
  final Duration reconnectTimeout;
  final Duration pingInterval;
  final Duration pongTimeout;

  /// Active subscriptions mapped by operation ID
  final Map<String, _OperationHandler> _activeOperations = {};

  /// Pending operations waiting for connection acknowledgement
  final Map<String, _OperationHandler> _pendingOperations = {};

  /// Connection state
  bool _isConnected = false;
  bool _connectionAcknowledged = false;
  bool _disposed = false;

  /// Transport components
  StreamController<JsonObject>? _messageStreamController;
  MessageSender? _messageSender;
  StreamSubscription<JsonObject>? _messageSubscription;

  /// Timers
  Timer? _connectionInitTimer;
  Timer? _reconnectTimer;
  Timer? _pingTimer;
  Timer? _pongTimer;

  /// Connection acknowledgement payload from server
  JsonObject? _connectionAckPayload;

  WebSocketLink({
    required this.transport,
    required this.url,
    this.connectionParams,
    this.headers,
    this.autoReconnect = true,
    this.connectionInitTimeout = const Duration(seconds: 10),
    this.reconnectTimeout = const Duration(seconds: 5),
    this.pingInterval = const Duration(seconds: 30),
    this.pongTimeout = const Duration(seconds: 5),
  }) {
    _initialize();
  }

  /// Initialize the WebSocket connection
  void _initialize() {
    _connect();
  }

  /// Connect to the WebSocket server
  Future<void> _connect() async {
    if (_disposed) return;

    try {
      final (streamController, sender) = await transport.connect(
          url: url, protocols: ['graphql-transport-ws'], headers: headers);

      _messageStreamController = streamController;
      _messageSender = sender;
      _isConnected = true;

      // Listen to messages from the stream
      _messageSubscription = streamController.stream.listen(
        _handleMessage,
        onError: _handleTransportError,
        onDone: _onDisconnected,
      );

      _onConnected();
    } catch (e) {
      _isConnected = false;
      _handleConnectionError(e);
    }
  }

  /// Called when WebSocket connection is established
  void _onConnected() {
    // Send connection_init message
    _sendMessage(ConnectionInitMessage(payload: connectionParams));

    // Start connection init timeout
    _connectionInitTimer?.cancel();
    _connectionInitTimer = Timer(connectionInitTimeout, () {
      if (!_connectionAcknowledged) {
        _close(
          WsCloseCodes.connectionInitTimeout,
          'Connection initialization timeout',
        );
      }
    });

    // Cancel reconnect timer if active
    _reconnectTimer?.cancel();
  }

  /// Called when WebSocket connection is lost
  void _onDisconnected() {
    _isConnected = false;
    _connectionAcknowledged = false;
    _connectionInitTimer?.cancel();
    _pingTimer?.cancel();
    _pongTimer?.cancel();

    // Move active operations to pending
    _pendingOperations.addAll(_activeOperations);
    _activeOperations.clear();

    // Clean up transport resources
    _messageSubscription?.cancel();
    _messageStreamController = null;
    _messageSender = null;

    // Attempt reconnection if enabled
    if (autoReconnect && !_disposed) {
      _reconnectTimer?.cancel();
      _reconnectTimer = Timer(reconnectTimeout, () {
        _connect();
      });
    }
  }

  /// Handle incoming WebSocket messages
  void _handleMessage(JsonObject message) {
    final $messageString = json.encode(message);
    final $parsedMessage = parseWsMessage($messageString);

    if ($parsedMessage == null) {
      _close(WsCloseCodes.invalidMessage, 'Invalid message format');
      return;
    }
    switch ($parsedMessage) {
      case ConnectionAckMessage():
        _handleConnectionAck($parsedMessage);
        break;
      case PingMessage():
        _handlePing($parsedMessage);
        break;
      case PongMessage():
        _handlePong($parsedMessage);
        break;
      case NextMessage():
        _handleNext($parsedMessage);
        break;
      case ErrorMessage():
        _handleErrorMessage($parsedMessage);
        break;
      case CompleteMessage():
        _handleComplete($parsedMessage);
        break;
      default:
        _close(WsCloseCodes.invalidMessage, 'Invalid message format');
        break;
    }
  }

  /// Handle ConnectionAck message
  void _handleConnectionAck(ConnectionAckMessage message) {
    if (_connectionAcknowledged) {
      // Already acknowledged, ignore
      return;
    }

    _connectionAcknowledged = true;
    _connectionAckPayload = message.payload;
    _connectionInitTimer?.cancel();

    // Start ping timer
    _startPingTimer();

    // Execute all pending operations
    final $pendingOps = Map<String, _OperationHandler>.from(_pendingOperations);
    _pendingOperations.clear();

    for (final $entry in $pendingOps.entries) {
      final $id = $entry.key;
      final $handler = $entry.value;

      // Re-execute operation
      _executeOperation($id, $handler);
    }
  }

  /// Handle Ping message
  void _handlePing(PingMessage message) {
    // Respond with Pong
    _sendMessage(PongMessage(payload: message.payload));
  }

  /// Handle Pong message
  void _handlePong(PongMessage message) {
    // Cancel pong timeout
    _pongTimer?.cancel();
  }

  /// Handle Next message
  void _handleNext(NextMessage message) {
    final $handler = _activeOperations[message.id];
    if ($handler == null) {
      log('Unknown graphql operation: ${message.id}');
      return;
    }

    // Emit data to the handler's stream
    final $payload = message.payload;

    // Check if this is a valid GraphQL response
    if ($payload.containsKey('data')) {
      final $data = $payload['data'] as JsonObject?;
      final $errors = $payload['errors'] as List?;
      final $extensions = $payload['extensions'] as JsonObject?;

      List<JsonObject>? $parsedErrors;
      if ($errors != null) {
        $parsedErrors = $errors.map((e) => e as JsonObject).toList();
      }

      $handler.controller.add(
        GraphQLData(
          data: $data ?? {},
          errors: $parsedErrors,
          extensions: $extensions ?? {},
        ),
      );
    } else {
      // Invalid response format
      $handler.controller.add(
        LinkErrorResponse([
          ShalomTransportException(
            message: 'Invalid response: missing data field',
            code: 'INVALID_RESPONSE',
          ),
        ]),
      );
    }
  }

  /// Handle Error message
  void _handleErrorMessage(ErrorMessage message) {
    final $handler = _activeOperations[message.id];
    if ($handler == null) {
      // Unknown operation, ignore
      return;
    }

    // Emit error to the handler's stream
    $handler.controller.add(
      LinkErrorResponse([
        ShalomTransportException(
          message: 'GraphQL operation error',
          code: 'GRAPHQL_ERROR',
          details: {'errors': message.payload},
        ),
      ]),
    );

    // Complete the operation
    _completeOperation(message.id);
  }

  /// Handle Complete message
  void _handleComplete(CompleteMessage message) {
    _completeOperation(message.id);
  }

  /// Handle general transport errors
  void _handleTransportError(dynamic error) {
    // Emit error to all active operations
    for (final $handler in _activeOperations.values) {
      if (!$handler.controller.isClosed) {
        $handler.controller.add(
          LinkErrorResponse([
            ShalomTransportException(
              message: 'WebSocket error: ${error.toString()}',
              code: 'WEBSOCKET_ERROR',
            ),
          ]),
        );
      }
    }
  }

  /// Handle connection errors
  void _handleConnectionError(dynamic error) {
    // Emit error to all pending operations
    for (final $handler in _pendingOperations.values) {
      if (!$handler.controller.isClosed) {
        $handler.controller.add(
          LinkErrorResponse([
            ShalomTransportException(
              message: 'Connection error: ${error.toString()}',
              code: 'CONNECTION_ERROR',
            ),
          ]),
        );
      }
    }
  }

  /// Start the ping timer
  void _startPingTimer() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(pingInterval, (_) {
      _sendPing();
    });
  }

  /// Send a ping message
  void _sendPing() {
    if (!_connectionAcknowledged) return;

    _sendMessage(const PingMessage());

    // Start pong timeout
    _pongTimer?.cancel();
    _pongTimer = Timer(pongTimeout, () {
      // Pong timeout - close connection
      _close(1002, 'Pong timeout');
    });
  }

  /// Send a message through the WebSocket
  void _sendMessage(WsMessage message) {
    if (!isConnected || _messageSender == null) return;

    try {
      final $messageJson = json.decode(message.toJsonString()) as JsonObject;
      _messageSender!.send($messageJson);
    } catch (e) {
      // Handle send error
    }
  }

  /// Close the WebSocket connection
  Future<void> _close(int code, String reason) async {
    _isConnected = false;
    // Close the stream controller which should trigger the transport to close
    await _messageStreamController?.close();
    _onDisconnected();
  }

  @override
  Stream<GraphQLResponse<JsonObject>> request({
    required Request request,
    HeadersType? headers,
  }) {
    // Generate unique operation ID
    final $operationId = _generateOperationId();

    // Create operation handler
    final $controller = StreamController<GraphQLResponse<JsonObject>>();
    final $handler = _OperationHandler(
      id: $operationId,
      request: request,
      controller: $controller,
    );

    // Add to pending or execute immediately
    if (_connectionAcknowledged && isConnected) {
      _executeOperation($operationId, $handler);
    } else {
      _pendingOperations[$operationId] = $handler;
    }

    // Set up stream controller callbacks
    $controller.onCancel = () {
      _unsubscribe($operationId);
    };

    return $controller.stream;
  }

  /// Execute an operation by sending Subscribe message
  void _executeOperation(String operationId, _OperationHandler handler) {
    // Check if already active
    if (_activeOperations.containsKey(operationId)) {
      handler.controller.add(
        LinkErrorResponse([
          ShalomTransportException(
            message: 'Operation with ID $operationId already exists',
            code: 'DUPLICATE_OPERATION',
          ),
        ]),
      );
      handler.controller.close();
      return;
    }

    // Add to active operations
    _activeOperations[operationId] = handler;

    // Send Subscribe message
    final $subscribeMessage = SubscribeMessage(
      id: operationId,
      payload: SubscribePayload.fromRequest(handler.request),
    );

    _sendMessage($subscribeMessage);
  }

  /// Unsubscribe from an operation
  void _unsubscribe(String operationId) {
    // Remove from active operations
    final $handler = _activeOperations.remove(operationId);
    _pendingOperations.remove(operationId);

    // Send Complete message if still connected
    if (_connectionAcknowledged && isConnected && !_disposed) {
      try {
        _sendMessage(CompleteMessage(id: operationId));
      } catch (e) {
        // Ignore errors during cleanup
      }
    }

    // Close the stream controller
    if ($handler != null && !$handler.controller.isClosed) {
      $handler.controller.close();
    }
  }

  /// Complete an operation
  void _completeOperation(String operationId) {
    final $handler = _activeOperations.remove(operationId);
    if ($handler != null && !$handler.controller.isClosed) {
      $handler.controller.close();
    }
  }

  /// Generate a unique operation ID
  String _generateOperationId() {
    return DateTime.now().microsecondsSinceEpoch.toString();
  }

  /// Get the connection acknowledgement payload
  JsonObject? get connectionAckPayload => _connectionAckPayload;

  /// Whether the connection is acknowledged
  bool get isConnectionAcknowledged => _connectionAcknowledged;

  /// Whether the WebSocket is connected
  bool get isConnected => _isConnected;

  /// Manually reconnect
  Future<void> reconnect() async {
    await _close(WsCloseCodes.normalClosure, 'Manual reconnect');
    await _connect();
  }

  /// Dispose the WebSocket link
  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    _isConnected = false;

    // Cancel all timers
    _connectionInitTimer?.cancel();
    _reconnectTimer?.cancel();
    _pingTimer?.cancel();
    _pongTimer?.cancel();

    // Close all operation streams
    for (final $handler in _activeOperations.values) {
      if (!$handler.controller.isClosed) {
        $handler.controller.close();
      }
    }
    for (final $handler in _pendingOperations.values) {
      if (!$handler.controller.isClosed) {
        $handler.controller.close();
      }
    }

    _activeOperations.clear();
    _pendingOperations.clear();

    // Cancel subscriptions and close transport
    await _messageSubscription?.cancel();
    await _messageStreamController?.close();

    _messageStreamController = null;
    _messageSender = null;
  }
}

/// Internal class to manage operation handlers
class _OperationHandler {
  final String id;
  final Request request;
  final StreamController<GraphQLResponse<JsonObject>> controller;

  _OperationHandler({
    required this.id,
    required this.request,
    required this.controller,
  });
}
