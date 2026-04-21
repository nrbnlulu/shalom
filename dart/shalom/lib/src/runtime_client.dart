import 'dart:async';
import 'dart:convert';

import 'package:shalom/src/shalom_core_base.dart'
    show
        GraphQLData,
        GraphQLError,
        GraphQLResponse,
        JsonObject,
        LinkExceptionResponse,
        OperationType,
        Request,
        Requestable,
        ShalomTransportException;
import 'package:shalom/src/transport/link.dart' show GraphQLLink;

import 'rust/api/runtime.dart' as rs_runtime;

export 'rust/api/runtime.dart' show NetworkPolicy;

Set<String> collectRuntimeRefs(JsonObject data) {
  final refs = <String>{};
  final raw = data['__used_refs'];
  if (raw is List) {
    for (final entry in raw) {
      if (entry is String) {
        refs.add(entry);
      }
    }
  }
  return refs;
}

class ShalomRuntimeClient {
  final rs_runtime.RuntimeHandle _handle;
  final GraphQLLink _link;
  final Map<int, StreamSubscription<GraphQLResponse<JsonObject>>>
  _activeRequests = {};
  StreamSubscription<String>? _requestStream;
  bool _disposed = false;

  ShalomRuntimeClient._(this._handle, this._link);

  static Future<ShalomRuntimeClient> init({
    required String schemaSdl,
    required List<String> fragmentSdls,
    Map<String, dynamic>? config,
    required GraphQLLink link,
  }) async {
    final configJson = config == null ? null : jsonEncode(config);
    final handle = await rs_runtime.initRuntime(
      schemaSdl: schemaSdl,
      fragmentSdls: fragmentSdls,
      configJson: configJson,
    );
    final client = ShalomRuntimeClient._(handle, link);
    client._bindRequests();
    return client;
  }

  /// Fetch via network then keep the stream alive via a cache subscription.
  ///
  /// The first emission is the normalized network response. Subsequent
  /// emissions are triggered by cache writes to any ref touched by this
  /// operation. Cancelling the returned stream unsubscribes immediately.
  Stream<T> request<T>({required Requestable<T> requestable}) {
    final meta = requestable.getRequestMeta();
    final req = meta.request;
    final variablesJson =
        req.variables.isEmpty ? null : jsonEncode(req.variables);

    BigInt? subId;
    final controller = StreamController<T>();

    controller.onListen = () {
      // Fire-and-forget async setup: fetch once then subscribe for updates.
      Future.microtask(() async {
        try {
          final payload = await rs_runtime
              .requestOp(
                handle: _handle,
                operation: req.query,
                variablesJson: variablesJson,
                networkPolicy: rs_runtime.NetworkPolicy.networkOnly,
              )
              .first;
          if (controller.isClosed) return;

          final envelope = _RuntimeEnvelope.fromJson(payload);
          controller.add(meta.parseFn(envelope.data));

          subId = rs_runtime.initSubscription(
            handle: _handle,
            targetName: req.opName,
          );
          rs_runtime
              .listenSubscription(handle: _handle, subscriptionId: subId!)
              .listen(
                (p) {
                  if (controller.isClosed) return;
                  try {
                    controller.add(
                      meta.parseFn(_RuntimeEnvelope.fromJson(p).data),
                    );
                  } catch (e, st) {
                    controller.addError(e, st);
                  }
                },
                onError: (Object e, StackTrace st) {
                  if (!controller.isClosed) controller.addError(e, st);
                },
                onDone: () {
                  if (!controller.isClosed) controller.close();
                },
              );
        } catch (e, st) {
          if (!controller.isClosed) controller.addError(e, st);
        }
      });
    };

    controller.onCancel = () {
      final id = subId;
      if (id == null) return;
      rs_runtime.unsubscribe(handle: _handle, subscriptionId: id);
    };

    return controller.stream;
  }

  /// Subscribe to cache updates for a specific fragment on a specific entity.
  ///
  /// [fragmentName] must match the name of a `@subscribeable` fragment defined
  /// in the `fragmentSdls` passed to [init].
  /// [rootRef] is the cache key anchor of the entity (e.g. `"User:1"`).
  /// [parseFn] converts the raw fragment data map to [T].
  Stream<T> subscribeToFragment<T>({
    required String fragmentName,
    required String rootRef,
    required T Function(Map<String, dynamic>) parseFn,
  }) {
    BigInt? subId;
    final controller = StreamController<T>();
    controller.onListen = () {
      subId = rs_runtime.initSubscription(
        handle: _handle,
        targetName: fragmentName,
        anchor: rootRef,
      );
      rs_runtime
          .listenSubscription(handle: _handle, subscriptionId: subId!)
          .listen(
            (payload) {
              if (controller.isClosed) return;
              try {
                final envelope = _RuntimeEnvelope.fromJson(payload);
                controller.add(parseFn(envelope.data));
              } catch (e, st) {
                controller.addError(e, st);
              }
            },
            onError: (Object e, StackTrace st) {
              if (!controller.isClosed) controller.addError(e, st);
            },
            onDone: () {
              if (!controller.isClosed) controller.close();
            },
          );
    };
    controller.onCancel = () {
      final id = subId;
      if (id == null) return null;
      return rs_runtime.unsubscribe(handle: _handle, subscriptionId: id);
    };
    return controller.stream;
  }

  Future<void> dispose() async {
    if (_disposed) {
      return;
    }
    _disposed = true;
    final stream = _requestStream;
    if (stream != null) {
      unawaited(stream.cancel());
    }
    final subs = _activeRequests.values.toList(growable: false);
    _activeRequests.clear();
    for (final sub in subs) {
      await sub.cancel();
    }
  }

  void _bindRequests() {
    final stream = rs_runtime.listenRequests(handle: _handle);
    _requestStream = stream.listen(_handleRequestEnvelope, onError: (_) {});
  }

  void _handleRequestEnvelope(String payload) {
    if (_disposed) {
      return;
    }
    final envelope = _RequestEnvelope.fromJson(payload);
    final previous = _activeRequests.remove(envelope.id);
    if (previous != null) {
      unawaited(previous.cancel());
    }
    final request = Request(
      query: envelope.query,
      variables: envelope.variables,
      opType: envelope.operationType,
      opName: envelope.operationName,
    );

    // Track the last push future so we can chain completeTransport after it.
    // This prevents a race where complete_transport drops the Rust sender
    // before push_response has been processed.
    Future<void>? lastPush;

    final subscription = _link
        .request(request: request)
        .listen(
          (response) {
            lastPush = _dispatchResponse(envelope.id, response);
          },
          onError: (error) => _dispatchTransportError(envelope.id, error),
          onDone: () {
            _activeRequests.remove(envelope.id);
            (lastPush ?? Future<void>.value()).then((_) {
              unawaited(rs_runtime.completeTransport(
                handle: _handle,
                requestId: BigInt.from(envelope.id),
              ));
            });
          },
        );
    _activeRequests[envelope.id] = subscription;
  }

  Future<void> _dispatchResponse(
    int requestId,
    GraphQLResponse<JsonObject> response,
  ) {
    switch (response) {
      case GraphQLData():
        final payload = <String, dynamic>{'data': response.data};
        if (response.errors != null) {
          payload['errors'] = response.errors;
        }
        if (response.extensions != null) {
          payload['extensions'] = response.extensions;
        }
        return _pushResponse(requestId, payload);
      case GraphQLError():
        final payload = <String, dynamic>{'errors': response.errors};
        if (response.extensions != null) {
          payload['extensions'] = response.extensions;
        }
        return _pushResponse(requestId, payload);
      case LinkExceptionResponse():
        _dispatchTransportError(requestId, response.errors);
        return Future<void>.value();
    }
  }

  Future<void> _pushResponse(int requestId, Map<String, dynamic> payload) {
    return rs_runtime.pushResponse(
      handle: _handle,
      requestId: BigInt.from(requestId),
      responseJson: jsonEncode(payload),
    );
  }

  void _dispatchTransportError(int requestId, Object error) {
    final transport = _toTransportError(error);
    unawaited(
      rs_runtime.pushTransportError(
        handle: _handle,
        requestId: BigInt.from(requestId),
        message: transport.message,
        code: transport.code,
        detailsJson: transport.detailsJson,
      ),
    );
  }
}

class _RequestEnvelope {
  final int id;
  final String query;
  final Map<String, dynamic> variables;
  final String operationName;
  final OperationType operationType;

  const _RequestEnvelope({
    required this.id,
    required this.query,
    required this.variables,
    required this.operationName,
    required this.operationType,
  });

  factory _RequestEnvelope.fromJson(String payload) {
    final decoded = jsonDecode(payload);
    if (decoded is! Map) {
      throw FormatException('request envelope must be a JSON object');
    }
    final idRaw = decoded['id'];
    if (idRaw is! num) {
      throw FormatException('request envelope id must be a number');
    }
    final requestRaw = decoded['request'];
    if (requestRaw is! Map) {
      throw FormatException('request envelope request must be a JSON object');
    }
    final query = requestRaw['query'];
    final opName = requestRaw['operation_name'];
    final opTypeRaw = requestRaw['operation_type'];
    if (query is! String || opName is! String || opTypeRaw is! String) {
      throw FormatException('request envelope has invalid request fields');
    }
    final variablesRaw = requestRaw['variables'];
    final variables = variablesRaw is Map
        ? variablesRaw.cast<String, dynamic>()
        : <String, dynamic>{};
    return _RequestEnvelope(
      id: idRaw.toInt(),
      query: query,
      variables: variables,
      operationName: opName,
      operationType: _parseOperationType(opTypeRaw),
    );
  }

  static OperationType _parseOperationType(String raw) {
    switch (raw) {
      case 'Query':
        return OperationType.Query;
      case 'Mutation':
        return OperationType.Mutation;
      case 'Subscription':
        return OperationType.Subscription;
      default:
        throw FormatException('unknown operation type: $raw');
    }
  }
}

class _RuntimeEnvelope {
  final Map<String, dynamic> data;
  final String? operationId;

  const _RuntimeEnvelope({required this.data, required this.operationId});

  factory _RuntimeEnvelope.fromJson(String payload) {
    final decoded = jsonDecode(payload);
    if (decoded is! Map) {
      throw FormatException('runtime response must be a JSON object');
    }
    if (decoded.containsKey('data')) {
      final dataRaw = decoded['data'];
      if (dataRaw is! Map) {
        throw FormatException('runtime response data must be a JSON object');
      }
      final operationIdRaw = decoded['operation_id'];
      if (operationIdRaw != null && operationIdRaw is! String) {
        throw FormatException('runtime response operation_id must be a string');
      }
      return _RuntimeEnvelope(
        data: dataRaw.cast<String, dynamic>(),
        operationId: operationIdRaw as String?,
      );
    }
    return _RuntimeEnvelope(
      data: decoded.cast<String, dynamic>(),
      operationId: null,
    );
  }
}

class _TransportError {
  final String message;
  final String code;
  final String? detailsJson;

  const _TransportError({
    required this.message,
    required this.code,
    this.detailsJson,
  });
}

_TransportError _toTransportError(Object error) {
  if (error is ShalomTransportException) {
    return _TransportError(
      message: error.message,
      code: error.code,
      detailsJson:
          error.details == null ? null : jsonEncode(error.details),
    );
  }
  if (error is List<Exception>) {
    if (error.isNotEmpty) {
      final first = error.first;
      if (first is ShalomTransportException) {
        return _TransportError(
          message: first.message,
          code: first.code,
          detailsJson:
              first.details == null ? null : jsonEncode(first.details),
        );
      }
    }
    final message = error.isEmpty ? 'Unknown transport error' : error.join('; ');
    return _TransportError(message: message, code: 'LINK_ERROR');
  }
  return _TransportError(message: error.toString(), code: 'LINK_ERROR');
}
