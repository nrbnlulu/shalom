import 'dart:async';
import 'dart:convert' show utf8;

import 'package:web_socket/web_socket.dart' as ws;

import 'package:shalom/src/shalom_core_base.dart';
import 'package:shalom/src/transport/ws_transport.dart';

/// [WebSocketTransport] implementation backed by the `web_socket` package.
///
/// Works on all platforms (native, web, Flutter) because `web_socket` abstracts
/// over `dart:io` WebSocket and the browser's native WebSocket API.
///
/// Usage:
/// ```dart
/// final link = WebSocketLink(
///   transport: WebSocketPackageTransport(),
///   url: 'wss://api.example.com/graphql',
/// );
/// ```
class WebSocketPackageTransport implements WebSocketTransport {
  const WebSocketPackageTransport();

  @override
  Future<(StreamController<String>, MessageSender)> connect({
    required String url,
    required List<String> protocols,
    HeadersType? headers,
  }) async {
    final socket = await ws.WebSocket.connect(
      Uri.parse(url),
      protocols: protocols,
      // `web_socket` does not expose a headers parameter in its public API;
      // headers are only available on native via a custom HttpClient. Auth
      // should be passed via `connection_init` payload instead.
    );

    final controller = StreamController<String>();

    final subscription = socket.events.listen(
      (event) {
        if (controller.isClosed) return;
        switch (event) {
          case ws.TextDataReceived(:final text):
            controller.add(text);
          case ws.BinaryDataReceived(:final data):
            // graphql-transport-ws uses text frames only; treat binary as text.
            controller.add(utf8.decode(data));
          case ws.CloseReceived():
            if (!controller.isClosed) controller.close();
        }
      },
      onError: (Object error) {
        if (!controller.isClosed) {
          controller.addError(error);
          controller.close();
        }
      },
      onDone: () {
        if (!controller.isClosed) controller.close();
      },
    );

    // When the consumer closes the controller (e.g. ws_link dispose),
    // tear down the underlying socket too.
    controller.onCancel = () async {
      await subscription.cancel();
      await socket.close();
    };

    final sender = MessageSender((String message) async {
      socket.sendText(message);
    });

    return (controller, sender);
  }
}
