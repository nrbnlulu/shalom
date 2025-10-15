import 'dart:convert';
import 'package:shalom_core/shalom_core.dart';

/// GraphQL WebSocket protocol message types
/// Based on: https://github.com/enisdenjo/graphql-ws/blob/master/PROTOCOL.md

/// Base class for all WebSocket messages
abstract class WsMessage {
  final String type;

  const WsMessage(this.type);

  JsonObject toJson();

  String toJsonString() => jsonEncode(toJson());
}

/// Base class for messages with an operation ID
abstract class WsMessageWithId extends WsMessage {
  final String id;

  const WsMessageWithId(super.type, this.id);
}

/// ConnectionInit message - Client -> Server
///
/// Indicates that the client wants to establish a connection within the existing socket.
class ConnectionInitMessage extends WsMessage {
  final JsonObject? payload;

  const ConnectionInitMessage({this.payload}) : super('connection_init');

  @override
  JsonObject toJson() {
    final $json = <String, dynamic>{'type': type};
    if (payload != null) {
      $json['payload'] = payload;
    }
    return $json;
  }

  factory ConnectionInitMessage.fromJson(JsonObject json) {
    return ConnectionInitMessage(
      payload: json['payload'] as JsonObject?,
    );
  }
}

/// ConnectionAck message - Server -> Client
///
/// Acknowledges a successful connection with the server.
class ConnectionAckMessage extends WsMessage {
  final JsonObject? payload;

  const ConnectionAckMessage({this.payload}) : super('connection_ack');

  @override
  JsonObject toJson() {
    final $json = <String, dynamic>{'type': type};
    if (payload != null) {
      $json['payload'] = payload;
    }
    return $json;
  }

  factory ConnectionAckMessage.fromJson(JsonObject json) {
    return ConnectionAckMessage(
      payload: json['payload'] as JsonObject?,
    );
  }
}

/// Ping message - Bidirectional
///
/// Useful for detecting failed connections, displaying latency metrics
/// or other types of network probing.
class PingMessage extends WsMessage {
  final JsonObject? payload;

  const PingMessage({this.payload}) : super('ping');

  @override
  JsonObject toJson() {
    final $json = <String, dynamic>{'type': type};
    if (payload != null) {
      $json['payload'] = payload;
    }
    return $json;
  }

  factory PingMessage.fromJson(JsonObject json) {
    return PingMessage(
      payload: json['payload'] as JsonObject?,
    );
  }
}

/// Pong message - Bidirectional
///
/// Response to the Ping message. Must be sent as soon as the Ping message is received.
class PongMessage extends WsMessage {
  final JsonObject? payload;

  const PongMessage({this.payload}) : super('pong');

  @override
  JsonObject toJson() {
    final $json = <String, dynamic>{'type': type};
    if (payload != null) {
      $json['payload'] = payload;
    }
    return $json;
  }

  factory PongMessage.fromJson(JsonObject json) {
    return PongMessage(
      payload: json['payload'] as JsonObject?,
    );
  }
}

/// Subscribe message - Client -> Server
///
/// Requests an operation specified in the message payload.
class SubscribeMessage extends WsMessageWithId {
  final SubscribePayload payload;

  const SubscribeMessage({
    required String id,
    required this.payload,
  }) : super('subscribe', id);

  @override
  JsonObject toJson() {
    return {
      'id': id,
      'type': type,
      'payload': payload.toJson(),
    };
  }

  factory SubscribeMessage.fromJson(JsonObject json) {
    return SubscribeMessage(
      id: json['id'] as String,
      payload: SubscribePayload.fromJson(json['payload'] as JsonObject),
    );
  }
}

/// Payload for Subscribe message
class SubscribePayload {
  final String query;
  final String? operationName;
  final JsonObject? variables;
  final JsonObject? extensions;

  const SubscribePayload({
    required this.query,
    this.operationName,
    this.variables,
    this.extensions,
  });

  JsonObject toJson() {
    final $json = <String, dynamic>{'query': query};

    if (operationName != null && operationName!.isNotEmpty) {
      $json['operationName'] = operationName;
    }

    if (variables != null && variables!.isNotEmpty) {
      $json['variables'] = variables;
    }

    if (extensions != null && extensions!.isNotEmpty) {
      $json['extensions'] = extensions;
    }

    return $json;
  }

  factory SubscribePayload.fromJson(JsonObject json) {
    return SubscribePayload(
      query: json['query'] as String,
      operationName: json['operationName'] as String?,
      variables: json['variables'] as JsonObject?,
      extensions: json['extensions'] as JsonObject?,
    );
  }

  /// Create payload from a Request object
  factory SubscribePayload.fromRequest(Request request) {
    return SubscribePayload(
      query: request.query,
      operationName: request.opName.isNotEmpty ? request.opName : null,
      variables: request.variables.isNotEmpty ? request.variables : null,
    );
  }
}

/// Next message - Server -> Client
///
/// Operation execution result(s) from the source stream.
class NextMessage extends WsMessageWithId {
  final JsonObject payload;

  const NextMessage({
    required String id,
    required this.payload,
  }) : super('next', id);

  @override
  JsonObject toJson() {
    return {
      'id': id,
      'type': type,
      'payload': payload,
    };
  }

  factory NextMessage.fromJson(JsonObject json) {
    return NextMessage(
      id: json['id'] as String,
      payload: json['payload'] as JsonObject,
    );
  }
}

/// Error message - Server -> Client
///
/// Operation execution error(s) in response to the Subscribe message.
/// This message terminates the operation.
class ErrorMessage extends WsMessageWithId {
  final List<JsonObject> payload;

  const ErrorMessage({
    required String id,
    required this.payload,
  }) : super('error', id);

  @override
  JsonObject toJson() {
    return {
      'id': id,
      'type': type,
      'payload': payload,
    };
  }

  factory ErrorMessage.fromJson(JsonObject json) {
    final payloadRaw = json['payload'];
    List<JsonObject> errors;

    if (payloadRaw is List) {
      errors = payloadRaw.map((e) => e as JsonObject).toList();
    } else if (payloadRaw is Map) {
      errors = [Map<String, dynamic>.from(payloadRaw)];
    } else {
      errors = [];
    }

    return ErrorMessage(
      id: json['id'] as String,
      payload: errors,
    );
  }
}

/// Complete message - Bidirectional
///
/// Server -> Client: Indicates operation execution has completed.
/// Client -> Server: Indicates client has stopped listening.
class CompleteMessage extends WsMessageWithId {
  const CompleteMessage({required String id}) : super('complete', id);

  @override
  JsonObject toJson() {
    return {
      'id': id,
      'type': type,
    };
  }

  factory CompleteMessage.fromJson(JsonObject json) {
    return CompleteMessage(
      id: json['id'] as String,
    );
  }
}

/// Parse a JSON string into a WebSocket message
WsMessage? parseWsMessage(String jsonString) {
  try {
    final json = jsonDecode(jsonString) as JsonObject;
    return parseWsMessageFromJson(json);
  } catch (e) {
    return null;
  }
}

/// Parse a JSON object into a WebSocket message
WsMessage? parseWsMessageFromJson(JsonObject json) {
  final type = json['type'] as String?;
  if (type == null) return null;

  try {
    switch (type) {
      case 'connection_init':
        return ConnectionInitMessage.fromJson(json);
      case 'connection_ack':
        return ConnectionAckMessage.fromJson(json);
      case 'ping':
        return PingMessage.fromJson(json);
      case 'pong':
        return PongMessage.fromJson(json);
      case 'subscribe':
        return SubscribeMessage.fromJson(json);
      case 'next':
        return NextMessage.fromJson(json);
      case 'error':
        return ErrorMessage.fromJson(json);
      case 'complete':
        return CompleteMessage.fromJson(json);
      default:
        return null;
    }
  } catch (e) {
    return null;
  }
}

/// WebSocket protocol close codes
class WsCloseCodes {
  /// Normal closure
  static const int normalClosure = 1000;

  /// Invalid message received
  static const int invalidMessage = 4400;

  /// Unauthorized - connection not acknowledged
  static const int unauthorized = 4401;

  /// Forbidden - connection rejected
  static const int forbidden = 4403;

  /// Connection initialization timeout
  static const int connectionInitTimeout = 4408;

  /// Subscriber already exists for operation ID
  static const int subscriberAlreadyExists = 4409;

  /// Too many initialization requests
  static const int tooManyInitRequests = 4429;

  /// Get a human-readable description for a close code
  static String getDescription(int code) {
    switch (code) {
      case normalClosure:
        return 'Normal closure';
      case invalidMessage:
        return 'Invalid message';
      case unauthorized:
        return 'Unauthorized';
      case forbidden:
        return 'Forbidden';
      case connectionInitTimeout:
        return 'Connection initialization timeout';
      case subscriberAlreadyExists:
        return 'Subscriber already exists';
      case tooManyInitRequests:
        return 'Too many initialization requests';
      default:
        return 'Unknown close code: $code';
    }
  }
}
