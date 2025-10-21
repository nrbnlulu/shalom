import 'dart:async' show StreamController;

import 'package:shalom_core/shalom_core.dart';

class MessageSender {
  final Future<void> Function(JsonObject) send;
  const MessageSender(this.send);
}

/// Abstract WebSocket transport layer that users must implement
/// using their preferred WebSocket library (web_socket_channel, etc.)
///
/// This abstraction allows the WebSocketLink to be transport-agnostic,
/// letting users choose their own WebSocket implementation.
abstract class WebSocketTransport {
  /// Connect to the WebSocket server.
  /// when the stream is closed the websocket should be closed.
  ///
  /// [url] - The WebSocket URL to connect to
  /// [headers] - Optional headers to send with the connection request
  /// [protocols] - WebSocket sub-protocols to negotiate (should include 'graphql-transport-ws')
  Future<(StreamController<JsonObject>, MessageSender)> connect({
    required String url,
    required List<String> protocols,
    HeadersType? headers,
  });
}
