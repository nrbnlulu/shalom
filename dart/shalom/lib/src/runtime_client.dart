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
        ShalomTransportException;
import 'package:shalom/src/transport/link.dart' show GraphQLLink;

import 'rust/api/runtime.dart' as rs_runtime;

export 'rust/api/runtime.dart' show ObservedRefInput;

// ---------------------------------------------------------------------------
// ShalomRuntimeClient
// ---------------------------------------------------------------------------

class ShalomRuntimeClient {
  final rs_runtime.RuntimeHandle _handle;
  final GraphQLLink _link;
  final Map<int, StreamSubscription<GraphQLResponse<JsonObject>>>
  _activeRequests = {};
  StreamSubscription<String>? _requestStream;
  bool _disposed = false;

  ShalomRuntimeClient._(this._handle, this._link);

  /// Initialise the runtime with [schemaSdl].
  ///
  /// After init, register all operations and fragments via
  /// [registerOperation] / [registerFragment] (or call the generated
  /// `registerShalomDefinitions(client)` function).
  static Future<ShalomRuntimeClient> init({
    required String schemaSdl,
    Map<String, dynamic>? config,
    required GraphQLLink link,
  }) async {
    final configJson = config == null ? null : jsonEncode(config);
    final handle = await rs_runtime.initRuntime(
      schemaSdl: schemaSdl,
      configJson: configJson,
    );
    final client = ShalomRuntimeClient._(handle, link);
    client._bindRequests();
    return client;
  }

  // -------------------------------------------------------------------------
  // Registration
  // -------------------------------------------------------------------------

  /// Pre-register a GraphQL operation SDL so it can be executed by name
  /// via [request].
  Future<void> registerOperation({required String document}) {
    return rs_runtime.registerOperation(handle: _handle, document: document);
  }

  /// Pre-register a GraphQL fragment SDL so it can be subscribed to via
  /// [subscribeToFragment].
  Future<void> registerFragment({required String document}) {
    return rs_runtime.registerFragment(handle: _handle, document: document);
  }

  // -------------------------------------------------------------------------
  // Operation subscription — network + cache
  // -------------------------------------------------------------------------

  /// Trigger a network fetch for a pre-registered operation named [name] and
  /// open a cache subscription. Returns a stream of decoded [T] values.
  ///
  /// The first emission arrives after the network response is normalised.
  /// Subsequent emissions are triggered by cache writes to any ref touched by
  /// this operation. Cancelling the returned stream unsubscribes immediately.
  Stream<T> request<T>({
    required String name,
    Map<String, dynamic>? variables,
    required T Function(JsonObject) decoder,
  }) {
    final variablesJson = variables == null ? null : jsonEncode(variables);
    BigInt? subId;
    final controller = StreamController<T>();

    controller.onListen = () {
      Future.microtask(() async {
        try {
          subId = await rs_runtime.request(
            handle: _handle,
            name: name,
            variablesJson: variablesJson,
          );
          if (controller.isClosed) {
            if (subId != null) {
              rs_runtime.unsubscribe(handle: _handle, subscriptionId: subId!);
            }
            return;
          }
          rs_runtime
              .listenSubscription(handle: _handle, subscriptionId: subId!)
              .listen(
                (payload) {
                  if (controller.isClosed) return;
                  try {
                    controller.add(decoder(_RuntimeEnvelope.fromJson(payload).data));
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

  // -------------------------------------------------------------------------
  // Fragment subscription — cache only
  // -------------------------------------------------------------------------

  /// Subscribe to cache updates for a pre-registered fragment at the anchor
  /// identified by [ref].
  ///
  /// Emits the current cached value immediately if available, then re-emits
  /// whenever the underlying cache entries change.
  Stream<T> subscribeToFragment<T>({
    required rs_runtime.ObservedRefInput ref,
    required T Function(JsonObject) decoder,
  }) {
    BigInt? subId;
    final controller = StreamController<T>();

    controller.onListen = () {
      try {
        subId = rs_runtime.observeFragment(handle: _handle, refInput: ref);
      } catch (e, st) {
        if (!controller.isClosed) controller.addError(e, st);
        return;
      }

      rs_runtime
          .listenSubscription(handle: _handle, subscriptionId: subId!)
          .listen(
            (payload) {
              if (controller.isClosed) return;
              try {
                controller.add(decoder(_RuntimeEnvelope.fromJson(payload).data));
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
      if (id == null) return;
      rs_runtime.unsubscribe(handle: _handle, subscriptionId: id);
    };

    return controller.stream;
  }

  /// Rebind an existing fragment subscription identified by [subscriptionId]
  /// to [newRef].
  ///
  /// - Same `observable_id`: fast anchor swap — the Rust side atomically swaps
  ///   the anchor and pushes the new cached value. Returns the SAME
  ///   [subscriptionId]; reconnect the [listenSubscription] stream if needed.
  /// - Different `observable_id`: full teardown + new subscription. Returns a
  ///   new subscription ID.
  ///
  /// Use [subscribeToFragment] directly if you don't need the optimised swap.
  Stream<T> rebindFragmentSubscription<T>({
    required BigInt subscriptionId,
    required rs_runtime.ObservedRefInput newRef,
    required T Function(JsonObject) decoder,
  }) {
    BigInt? newSubId;
    final controller = StreamController<T>();

    controller.onListen = () {
      try {
        newSubId = rs_runtime.rebindSubscription(
          handle: _handle,
          subscriptionId: subscriptionId,
          newRef: newRef,
        );
      } catch (e, st) {
        if (!controller.isClosed) controller.addError(e, st);
        return;
      }

      rs_runtime
          .listenSubscription(handle: _handle, subscriptionId: newSubId!)
          .listen(
            (payload) {
              if (controller.isClosed) return;
              try {
                controller.add(decoder(_RuntimeEnvelope.fromJson(payload).data));
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
      final id = newSubId;
      if (id == null) return;
      rs_runtime.unsubscribe(handle: _handle, subscriptionId: id);
    };

    return controller.stream;
  }

  // -------------------------------------------------------------------------
  // Dispose
  // -------------------------------------------------------------------------

  Future<void> dispose() async {
    if (_disposed) return;
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

  // -------------------------------------------------------------------------
  // Host link plumbing (internal)
  // -------------------------------------------------------------------------

  void _bindRequests() {
    final stream = rs_runtime.listenRequests(handle: _handle);
    _requestStream = stream.listen(_handleRequestEnvelope, onError: (_) {});
  }

  void _handleRequestEnvelope(String payload) {
    if (_disposed) return;
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
        if (response.errors != null) payload['errors'] = response.errors;
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

// ---------------------------------------------------------------------------
// Private helpers
// ---------------------------------------------------------------------------

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
      throw const FormatException('request envelope must be a JSON object');
    }
    final idRaw = decoded['id'];
    if (idRaw is! num) {
      throw const FormatException('request envelope id must be a number');
    }
    final requestRaw = decoded['request'];
    if (requestRaw is! Map) {
      throw const FormatException('request envelope request must be a JSON object');
    }
    final query = requestRaw['query'];
    final opName = requestRaw['operation_name'];
    final opTypeRaw = requestRaw['operation_type'];
    if (query is! String || opName is! String || opTypeRaw is! String) {
      throw const FormatException('request envelope has invalid request fields');
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

  static OperationType _parseOperationType(String raw) => switch (raw) {
    'Query' => OperationType.Query,
    'Mutation' => OperationType.Mutation,
    'Subscription' => OperationType.Subscription,
    _ => throw FormatException('unknown operation type: $raw'),
  };
}

class _RuntimeEnvelope {
  final JsonObject data;

  const _RuntimeEnvelope({required this.data});

  factory _RuntimeEnvelope.fromJson(String payload) {
    final decoded = jsonDecode(payload);
    if (decoded is! Map) {
      throw const FormatException('runtime response must be a JSON object');
    }
    if (decoded.containsKey('data')) {
      final dataRaw = decoded['data'];
      if (dataRaw is! Map) {
        throw const FormatException('runtime response data must be a JSON object');
      }
      return _RuntimeEnvelope(data: dataRaw.cast<String, dynamic>());
    }
    return _RuntimeEnvelope(data: decoded.cast<String, dynamic>());
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
      detailsJson: error.details == null ? null : jsonEncode(error.details),
    );
  }
  if (error is List<Exception>) {
    if (error.isNotEmpty) {
      final first = error.first;
      if (first is ShalomTransportException) {
        return _TransportError(
          message: first.message,
          code: first.code,
          detailsJson: first.details == null ? null : jsonEncode(first.details),
        );
      }
    }
    final message =
        error.isEmpty ? 'Unknown transport error' : error.join('; ');
    return _TransportError(message: message, code: 'LINK_ERROR');
  }
  return _TransportError(message: error.toString(), code: 'LINK_ERROR');
}
