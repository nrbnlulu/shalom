import 'dart:async';
import 'dart:developer' show log;

import 'package:shalom/src/rust/api/ws.dart';
import 'package:shalom/src/shalom_core_base.dart';
import 'package:shalom/src/transport/link.dart';
import 'package:shalom/src/transport/ws_transport.dart';

/// WebSocket link backed by the Rust sans-IO `graphql-transport-ws` state
/// machine.
///
/// Requests are distributed across a pool of [_Socket]s, each of which owns
/// one physical WebSocket connection and its own protocol state machine. By
/// default ([maxOperationsPerSocket] is `null`) every operation multiplexes
/// onto a single shared connection, matching standard `graphql-transport-ws`
/// behavior. Setting [maxOperationsPerSocket] caps how many concurrently
/// active operations a single connection may carry — once a socket is full,
/// new operations open an additional connection. Set it to `1` to give every
/// concurrent subscription its own dedicated socket, e.g. to avoid tripping
/// server-side limits on active subscriptions per connection.
class WebSocketLink extends GraphQLLink {
  final WebSocketTransport transport;
  final String url;
  final HeadersType? headers;

  final ShalomJsonValue? connectionParamsValue;

  final bool autoReconnect;
  final Duration connectionInitTimeout;
  final Duration reconnectTimeout;
  final Duration heartbeatInterval;
  final Duration heartbeatTimeout;

  /// Maximum number of concurrently active operations allowed on a single
  /// WebSocket connection. `null` (default) means unlimited — all
  /// operations share one connection. A socket that drops back to zero
  /// active operations is closed once another socket exists, keeping
  /// exactly one warm connection when idle.
  final int? maxOperationsPerSocket;

  bool _disposed = false;
  final List<_Socket> _sockets = [];
  int _nextOpId = 0;

  WebSocketLink({
    required this.transport,
    required this.url,
    this.headers,
    JsonObject? connectionParams,
    this.autoReconnect = true,
    this.connectionInitTimeout = const Duration(seconds: 10),
    this.reconnectTimeout = const Duration(seconds: 5),
    this.heartbeatInterval = const Duration(seconds: 5),
    this.heartbeatTimeout = const Duration(seconds: 3),
    this.maxOperationsPerSocket,
  }) : connectionParamsValue = connectionParams == null
           ? null
           : shalomJsonValue(connectionParams) {
    _sockets.add(_createSocket());
  }

  // ── pool management ───────────────────────────────────────────────────────

  _Socket _createSocket() {
    final socket = _Socket(
      transport: transport,
      url: url,
      headers: headers,
      connectionParamsValue: connectionParamsValue,
      autoReconnect: autoReconnect,
      connectionInitTimeout: connectionInitTimeout,
      reconnectTimeout: reconnectTimeout,
      heartbeatInterval: heartbeatInterval,
      heartbeatTimeout: heartbeatTimeout,
      onIdle: _onSocketIdle,
    );
    socket.connect();
    return socket;
  }

  /// Picks a socket with spare capacity, or opens a new one if all existing
  /// sockets are full (or none exist yet).
  _Socket _pickSocket() {
    final max = maxOperationsPerSocket;
    for (final socket in _sockets) {
      if (max == null || socket.activeOpCount < max) return socket;
    }
    final socket = _createSocket();
    _sockets.add(socket);
    return socket;
  }

  /// Called by a [_Socket] once it has no active operations left. Unlimited
  /// pools never close their single socket; bounded pools close and drop
  /// idle sockets, keeping exactly one warm connection alive.
  void _onSocketIdle(_Socket socket) {
    if (_disposed) return;
    if (maxOperationsPerSocket == null) return;
    if (_sockets.length <= 1) return;
    _sockets.remove(socket);
    unawaited(socket.dispose());
  }

  // ── operations ────────────────────────────────────────────────────────────

  @override
  Stream<GraphQLResponse<GraphQLLinkPayload>> request({
    required Request request,
    HeadersType? headers,
  }) {
    final opId = (_nextOpId++).toString();
    return _pickSocket().subscribe(opId, request);
  }

  // ── public API ────────────────────────────────────────────────────────────

  Future<void> reconnect() async {
    for (final socket in List<_Socket>.of(_sockets)) {
      await socket.reconnect();
    }
  }

  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    for (final socket in _sockets) {
      await socket.dispose();
    }
    _sockets.clear();
  }
}

/// Owns a single physical WebSocket connection and its `graphql-transport-ws`
/// protocol state. Dart owns the socket (via [WebSocketTransport]); Rust owns
/// the protocol state. On each received frame [wsOnMessage] is called
/// synchronously — no Future overhead on the hot path.
///
/// [_ops] holds only the Dart [StreamController] handles — Rust's internal
/// `operations` map is the authoritative record of which ops are subscribed
/// on this connection.
class _Socket {
  final WebSocketTransport transport;
  final String url;
  final HeadersType? headers;
  final ShalomJsonValue? connectionParamsValue;
  final bool autoReconnect;
  final Duration connectionInitTimeout;
  final Duration reconnectTimeout;
  final Duration heartbeatInterval;
  final Duration heartbeatTimeout;

  /// Invoked whenever this socket's active operation count drops to zero.
  final void Function(_Socket socket) onIdle;

  // ── sans-IO state machine ─────────────────────────────────────────────────
  WsSansIo? _sansio;

  // ── connection state ──────────────────────────────────────────────────────
  bool _acknowledged = false;
  bool _disposed = false;

  // ── operations ────────────────────────────────────────────────────────────
  final Map<String, _OperationHandler> _ops = {};

  // ── transport handles ─────────────────────────────────────────────────────
  StreamController<String>? _msgController;
  MessageSender? _sender;
  StreamSubscription<void>? _msgSub;

  // ── timers ────────────────────────────────────────────────────────────────
  Timer? _initTimer;
  Timer? _reconnectTimer;
  Timer? _heartbeatTimer;
  Timer? _pongTimeoutTimer;

  _Socket({
    required this.transport,
    required this.url,
    required this.headers,
    required this.connectionParamsValue,
    required this.autoReconnect,
    required this.connectionInitTimeout,
    required this.reconnectTimeout,
    required this.heartbeatInterval,
    required this.heartbeatTimeout,
    required this.onIdle,
  });

  int get activeOpCount => _ops.length;

  void connect() => unawaited(_connect());

  // ── connection lifecycle ──────────────────────────────────────────────────

  Future<void> _connect() async {
    if (_disposed) return;

    if (_sansio == null) {
      _sansio = createWsSansIo(connectionParams: connectionParamsValue);
    } else {
      // Resets to AwaitingAck while preserving the operations map so
      // wsActiveOperationIds() still returns prior op ids after reset.
      wsReset(sansio: _sansio!);
    }

    try {
      final (controller, sender) = await transport.connect(
        url: url,
        protocols: ['graphql-transport-ws'],
        headers: headers,
      );

      _msgController = controller;
      _sender = sender;

      _msgSub = controller.stream
          .asyncMap(_handleMessage)
          .listen(
            (_) {},
            onError: _handleTransportError,
            onDone: _onDisconnected,
          );

      await _onConnected();
    } catch (e) {
      _handleConnectionError(e);
    }
  }

  Future<void> _onConnected() async {
    await _sendRaw(wsConnectionInitFrame(sansio: _sansio!));

    _initTimer?.cancel();
    _initTimer = Timer(connectionInitTimeout, () {
      if (!_acknowledged) {
        _closeTransport(4408, 'Connection initialisation timeout');
      }
    });

    _reconnectTimer?.cancel();
  }

  void _onDisconnected() {
    _acknowledged = false;
    _initTimer?.cancel();
    _stopHeartbeat();
    _msgSub?.cancel();
    _msgController = null;
    _sender = null;

    if (autoReconnect && !_disposed) {
      _reconnectTimer?.cancel();
      _reconnectTimer = Timer(reconnectTimeout, _connect);
    }
  }

  // ── heartbeat (client-initiated liveness ping/pong) ──────────────────────

  void _startHeartbeat() {
    _stopHeartbeat();
    _heartbeatTimer = Timer.periodic(heartbeatInterval, (_) => _sendPing());
  }

  void _stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
    _pongTimeoutTimer?.cancel();
    _pongTimeoutTimer = null;
  }

  Future<void> _sendPing() async {
    final heartbeatTimerAtSend = _heartbeatTimer;
    await _sendRaw(wsPingFrame());
    // If the heartbeat was stopped (disconnect/dispose/reconnect) while the
    // send was in flight, don't arm a timeout for a heartbeat cycle that no
    // longer applies.
    if (!identical(_heartbeatTimer, heartbeatTimerAtSend)) return;
    _pongTimeoutTimer?.cancel();
    _pongTimeoutTimer = Timer(heartbeatTimeout, () {
      _closeTransport(4408, 'Heartbeat pong timeout');
    });
  }

  // ── message handling ──────────────────────────────────────────────────────

  Future<void> _handleMessage(String message) async {
    final List<WsLinkEvent> events;
    try {
      events = wsOnMessage(sansio: _sansio!, raw: message);
    } catch (e) {
      _closeTransport(4400, e.toString());
      return;
    }
    for (final event in events) {
      await _dispatch(event);
    }
  }

  Future<void> _dispatch(WsLinkEvent event) async {
    switch (event) {
      case WsLinkEvent_Connected():
        _initTimer?.cancel();
        _acknowledged = true;
        final rustKnownSet = wsActiveOperationIds(sansio: _sansio!).toSet();
        for (final entry in _ops.entries) {
          await _executeOp(
            entry.key,
            entry.value,
            alreadyInRust: rustKnownSet.contains(entry.key),
          );
        }
        _startHeartbeat();

      case WsLinkEvent_PingReceived(:final payload):
        await _sendRaw(wsPongFrame(sansio: _sansio!, payload: payload));

      case WsLinkEvent_PongReceived():
        _pongTimeoutTimer?.cancel();

      case WsLinkEvent_OperationResponse(:final opId, :final response):
        final handler = _ops[opId];
        if (handler == null) {
          log('WebSocketLink: unknown op $opId');
          return;
        }
        handler.controller.add(
          GraphQLData(data: ParsedGraphQLLinkPayload(response: response)),
        );

      case WsLinkEvent_OperationComplete(:final opId):
        _completeOp(opId);

      case WsLinkEvent_ProtocolError(:final code, :final reason):
        _closeTransport(code, reason);
    }
  }

  // ── operations ────────────────────────────────────────────────────────────

  Stream<GraphQLResponse<GraphQLLinkPayload>> subscribe(
    String opId,
    Request request,
  ) {
    final controller = StreamController<GraphQLResponse<GraphQLLinkPayload>>();
    final handler = _OperationHandler(
      id: opId,
      request: request,
      controller: controller,
    );

    controller.onCancel = () => _unsubscribeOp(opId);

    _ops[opId] = handler;
    if (_acknowledged && _sender != null) {
      unawaited(_executeOp(opId, handler));
    }

    return controller.stream;
  }

  Future<void> _executeOp(
    String opId,
    _OperationHandler handler, {
    bool alreadyInRust = false,
  }) async {
    final req = handler.request;
    await _sendRaw(
      wsSubscribeFrame(
        sansio: _sansio!,
        opId: opId,
        query: req.query,
        variables: req.variables.isNotEmpty
            ? shalomJsonValue(req.variables)
            : null,
        operationName: req.opName,
      ),
    );
  }

  Future<void> _unsubscribeOp(String opId) async {
    final handler = _ops.remove(opId);
    if (handler == null) return;

    if (_acknowledged && _sender != null && _sansio != null) {
      try {
        await _sendRaw(wsCompleteFrame(sansio: _sansio!, opId: opId));
      } catch (_) {}
    }

    if (!handler.controller.isClosed) handler.controller.close();
    _checkIdle();
  }

  void _completeOp(String opId) {
    final handler = _ops.remove(opId);
    if (handler != null && !handler.controller.isClosed) {
      handler.controller.close();
    }
    _checkIdle();
  }

  void _checkIdle() {
    if (!_disposed && _ops.isEmpty) onIdle(this);
  }

  // ── helpers ───────────────────────────────────────────────────────────────

  Future<void> _sendRaw(String frame) async {
    if (_sender == null) return;
    try {
      await _sender!.send(frame);
    } catch (_) {}
  }

  void _handleTransportError(dynamic error) {
    for (final h in _ops.values) {
      if (!h.controller.isClosed) {
        h.controller.add(
          LinkExceptionResponse([
            ShalomTransportException(
              message: 'WebSocket error: $error',
              code: 'WEBSOCKET_ERROR',
            ),
          ]),
        );
      }
    }
  }

  void _handleConnectionError(dynamic error) {
    for (final h in _ops.values) {
      if (!h.controller.isClosed) {
        h.controller.add(
          LinkExceptionResponse([
            ShalomTransportException(
              message: 'Connection error: $error',
              code: 'CONNECTION_ERROR',
            ),
          ]),
        );
      }
    }
    if (autoReconnect && !_disposed) {
      _reconnectTimer?.cancel();
      _reconnectTimer = Timer(reconnectTimeout, _connect);
    }
  }

  void _closeTransport(int code, String reason) {
    log('WebSocketLink: closing ($code) $reason');
    _msgController?.close();
  }

  // ── public API ────────────────────────────────────────────────────────────

  Future<void> reconnect() async {
    _closeTransport(1000, 'Manual reconnect');
    await _connect();
  }

  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    _acknowledged = false;

    _initTimer?.cancel();
    _reconnectTimer?.cancel();
    _stopHeartbeat();

    for (final h in _ops.values) {
      if (!h.controller.isClosed) h.controller.close();
    }
    _ops.clear();

    await _msgSub?.cancel();
    await _msgController?.close();
    _msgController = null;
    _sender = null;
  }
}

class _OperationHandler {
  final String id;
  final Request request;
  final StreamController<GraphQLResponse<GraphQLLinkPayload>> controller;

  const _OperationHandler({
    required this.id,
    required this.request,
    required this.controller,
  });
}
