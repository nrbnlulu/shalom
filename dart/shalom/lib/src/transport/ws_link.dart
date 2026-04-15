import 'dart:async';
import 'dart:convert' show json;
import 'dart:developer' show log;

import 'package:shalom/src/rust/api/ws.dart';
import 'package:shalom/src/shalom_core_base.dart';
import 'package:shalom/src/transport/link.dart';
import 'package:shalom/src/transport/ws_transport.dart';

/// WebSocket link backed by the Rust sans-IO `graphql-transport-ws` state machine.
///
/// Dart owns the socket (via [WebSocketTransport]); Rust owns the protocol
/// state. On each received frame [wsOnMessage] is called synchronously — no
/// Future overhead on the hot path.
///
/// Dart holds [_ops] only for its [StreamController] handles — Rust's internal
/// `operations` map is the authoritative record of which ops are subscribed.
class WebSocketLink extends GraphQLLink {
  final WebSocketTransport transport;
  final String url;
  final HeadersType? headers;

  /// Serialised JSON of the `connection_init` payload, e.g. `{"auth":"…"}`.
  final String? connectionParamsJson;

  final bool autoReconnect;
  final Duration connectionInitTimeout;
  final Duration reconnectTimeout;

  // ── sans-IO state machine ─────────────────────────────────────────────────
  WsSansIo? _sansio;

  // ── connection state ──────────────────────────────────────────────────────
  bool _acknowledged = false;
  bool _disposed = false;

  // ── operations ────────────────────────────────────────────────────────────
  // Keyed by op id. Subscription state lives in Rust; this map exists only
  // to hold the Dart StreamController handles.
  final Map<String, _OperationHandler> _ops = {};
  int _nextOpId = 0;

  // ── transport handles ─────────────────────────────────────────────────────
  StreamController<JsonObject>? _msgController;
  MessageSender? _sender;
  StreamSubscription<void>? _msgSub;

  // ── timers ────────────────────────────────────────────────────────────────
  Timer? _initTimer;
  Timer? _reconnectTimer;

  WebSocketLink({
    required this.transport,
    required this.url,
    this.headers,
    JsonObject? connectionParams,
    this.autoReconnect = true,
    this.connectionInitTimeout = const Duration(seconds: 10),
    this.reconnectTimeout = const Duration(seconds: 5),
  }) : connectionParamsJson =
           connectionParams != null ? json.encode(connectionParams) : null {
    _connect();
  }

  // ── connection lifecycle ──────────────────────────────────────────────────

  Future<void> _connect() async {
    if (_disposed) return;

    if (_sansio == null) {
      _sansio = createWsSansIo(connectionParamsJson: connectionParamsJson);
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
          .listen((_) {}, onError: _handleTransportError, onDone: _onDisconnected);

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
    _msgSub?.cancel();
    _msgController = null;
    _sender = null;

    if (autoReconnect && !_disposed) {
      _reconnectTimer?.cancel();
      _reconnectTimer = Timer(reconnectTimeout, _connect);
    }
  }

  // ── message handling ──────────────────────────────────────────────────────

  Future<void> _handleMessage(JsonObject message) async {
    final List<WsLinkEvent> events;
    try {
      events = wsOnMessage(sansio: _sansio!, raw: json.encode(message));
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
          await _executeOp(entry.key, entry.value, alreadyInRust: rustKnownSet.contains(entry.key));
        }

      case WsLinkEvent_PingReceived(:final payloadJson):
        await _sendRaw(wsPongFrame(sansio: _sansio!, payloadJson: payloadJson));

      case WsLinkEvent_OperationResponse(
        :final opId,
        :final dataJson,
        :final errorsJson,
        :final extensionsJson,
      ):
        final handler = _ops[opId];
        if (handler == null) {
          log('WebSocketLink: unknown op $opId');
          return;
        }
        final data = dataJson != null ? json.decode(dataJson) as JsonObject : null;
        final errors = errorsJson != null ? (json.decode(errorsJson) as List).cast<JsonObject>() : null;
        final extensions = extensionsJson != null ? json.decode(extensionsJson) as JsonObject : null;
        if (data != null) {
          handler.controller.add(GraphQLData(data: data, errors: errors, extensions: extensions));
        } else if (errors != null) {
          handler.controller.add(GraphQLError(errors: errors, extensions: extensions));
        }

      case WsLinkEvent_OperationComplete(:final opId):
        _completeOp(opId);

      case WsLinkEvent_ProtocolError(:final code, :final reason):
        _closeTransport(code, reason);
    }
  }

  // ── operations ────────────────────────────────────────────────────────────

  @override
  Stream<GraphQLResponse<JsonObject>> request({
    required Request request,
    HeadersType? headers,
  }) {
    final opId = (_nextOpId++).toString();
    final controller = StreamController<GraphQLResponse<JsonObject>>();
    final handler = _OperationHandler(id: opId, request: request, controller: controller);

    controller.onCancel = () => _unsubscribeOp(opId);

    _ops[opId] = handler;
    if (_acknowledged && _sender != null) {
      unawaited(_executeOp(opId, handler));
    }

    return controller.stream;
  }

  Future<void> _executeOp(String opId, _OperationHandler handler, {bool alreadyInRust = false}) async {
    final req = handler.request;
    await _sendRaw(wsSubscribeFrame(
      sansio: _sansio!,
      opId: opId,
      query: req.query,
      variablesJson: req.variables.isNotEmpty ? json.encode(req.variables) : null,
      operationName: req.opName,
    ));
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
  }

  void _completeOp(String opId) {
    final handler = _ops.remove(opId);
    if (handler != null && !handler.controller.isClosed) handler.controller.close();
  }

  // ── helpers ───────────────────────────────────────────────────────────────

  Future<void> _sendRaw(String frame) async {
    if (_sender == null) return;
    try {
      await _sender!.send(json.decode(frame) as JsonObject);
    } catch (_) {}
  }

  void _handleTransportError(dynamic error) {
    for (final h in _ops.values) {
      if (!h.controller.isClosed) {
        h.controller.add(LinkExceptionResponse([
          ShalomTransportException(message: 'WebSocket error: $error', code: 'WEBSOCKET_ERROR'),
        ]));
      }
    }
  }

  void _handleConnectionError(dynamic error) {
    for (final h in _ops.values) {
      if (!h.controller.isClosed) {
        h.controller.add(LinkExceptionResponse([
          ShalomTransportException(message: 'Connection error: $error', code: 'CONNECTION_ERROR'),
        ]));
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
  final StreamController<GraphQLResponse<JsonObject>> controller;

  const _OperationHandler({
    required this.id,
    required this.request,
    required this.controller,
  });
}
