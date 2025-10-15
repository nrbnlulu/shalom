import 'package:shalom_core/shalom_core.dart';

/// Abstract WebSocket transport layer that users must implement
/// using their preferred WebSocket library (web_socket_channel, etc.)
///
/// This abstraction allows the WebSocketLink to be transport-agnostic,
/// letting users choose their own WebSocket implementation.
abstract class WebSocketTransport {
  /// Stream of messages received from the WebSocket
  Stream<String> get messages;

  /// Stream of connection state changes
  Stream<WebSocketState> get stateChanges;

  /// Current connection state
  WebSocketState get state;

  /// Connect to the WebSocket server
  ///
  /// [url] - The WebSocket URL to connect to
  /// [headers] - Optional headers to send with the connection request
  /// [protocols] - WebSocket sub-protocols to negotiate (should include 'graphql-transport-ws')
  Future<void> connect({
    required String url,
    JsonObject? headers,
    List<String>? protocols,
  });

  /// Send a text message through the WebSocket
  void send(String message);

  /// Close the WebSocket connection
  ///
  /// [code] - Optional close code (default: 1000 for normal closure)
  /// [reason] - Optional close reason string
  Future<void> close([int code = 1000, String? reason]);

  /// Whether the WebSocket is currently connected
  bool get isConnected;
}

/// WebSocket connection state
enum WebSocketState {
  /// Not connected
  disconnected,

  /// Connection in progress
  connecting,

  /// Connected and ready
  connected,

  /// Closing connection
  closing,

  /// Connection closed
  closed,
}

/// WebSocket close event information
class WebSocketCloseEvent {
  final int code;
  final String? reason;
  final bool wasClean;

  const WebSocketCloseEvent({
    required this.code,
    this.reason,
    this.wasClean = true,
  });

  @override
  String toString() =>
      'WebSocketCloseEvent(code: $code, reason: $reason, wasClean: $wasClean)';
}
