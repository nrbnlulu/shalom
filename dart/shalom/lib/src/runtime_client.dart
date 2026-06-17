import 'dart:async';
import 'dart:convert';

import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart'
    show ExternalLibrary;
import 'package:shalom/shalom.dart';
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

export 'rust/api/runtime.dart'
    show ExecutionPolicyInput, ObservedRefInput, RuntimeConfigInput, SubscriberInfo;

// Thin wrapper so this file compiles without a Flutter dependency.
// In Flutter apps the real debugPrint throttles long lines; for our purposes
// a plain print is sufficient.
void debugPrint(String? message, {int? wrapWidth}) => print(message);

// ---------------------------------------------------------------------------
// ObservedRefInput helpers (exported so codegen templates can use them via
// `shalom_core.observedRefInputFromJson(...)`)
// ---------------------------------------------------------------------------

/// Deserialise an [ObservedRefInput] from a JSON map produced by the Rust cache.
///
/// The cache serialises refs as `{"observable_id": "...", "anchor": "..."}`.
rs_runtime.ObservedRefInput observedRefInputFromJson(JsonObject json) {
  return rs_runtime.ObservedRefInput(
    observableId: json['observable_id'] as String,
    anchor: json['anchor'] as String,
  );
}

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

  /// Initialize the Flutter-Rust bridge (loads the native library).
  ///
  /// Call this once in `main()` before creating any links or the runtime:
  /// ```dart
  /// void main() async {
  ///   WidgetsFlutterBinding.ensureInitialized();
  ///   await ShalomRuntimeClient.initFlutterRustBridge();
  ///   final client = ShalomRuntimeClient.create(schemaSdl: ..., link: ...);
  ///   registerShalomDefinitions(client);
  ///   runApp(ShalomProvider(client: client, child: const MyApp()));
  /// }
  /// ```
  static Future<void> initFlutterRustBridge({
    String? nativeLibPath,
    rs_runtime.LogLevel? logLevel,
  }) async {
    await RustLib.init(
      externalLibrary: nativeLibPath != null
          ? ExternalLibrary.open(nativeLibPath)
          : null,
    );
    if (logLevel != null) {
      rs_runtime.setLogLevel(level: logLevel);
    }
  }

  /// Create a runtime for [schemaSdl].  Synchronous — call after
  /// [initFlutterRustBridge] has completed.
  ///
  /// Register operations/fragments via [registerOperation] /
  /// [registerFragment] (or the generated `registerShalomDefinitions(client)`).
  static ShalomRuntimeClient create({
    required String schemaSdl,
    rs_runtime.RuntimeConfigInput? config,
    required GraphQLLink link,
  }) {
    final handle = rs_runtime.initRuntime(schemaSdl: schemaSdl, config: config);
    final client = ShalomRuntimeClient._(handle, link);
    client._bindRequests();
    return client;
  }

  // -------------------------------------------------------------------------
  // Registration
  // -------------------------------------------------------------------------

  /// Replace the GraphQL schema with a new SDL.
  ///
  /// Clears all registered operations/fragments and invalidates the cache.
  /// Call this on hot-reload before [registerOperation]/[registerFragment]
  /// when the schema file itself has changed.
  void reloadSchema({required String schemaSdl}) {
    debugPrint('[shalom] reloadSchema called');
    rs_runtime.reloadSchema(handle: _handle, schemaSdl: schemaSdl);
    debugPrint('[shalom] reloadSchema done');
  }

  /// Pre-register a GraphQL operation SDL so it can be executed by name
  /// via [request].
  void registerOperation({required String document}) =>
      rs_runtime.registerOperation(handle: _handle, document: document);

  /// Pre-register a GraphQL fragment SDL so it can be subscribed to via
  /// [subscribeToFragment].
  void registerFragment({required String document}) =>
      rs_runtime.registerFragment(handle: _handle, document: document);

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
    rs_runtime.ExecutionPolicyInput executionPolicy =
        rs_runtime.ExecutionPolicyInput.networkFirst,
  }) {
    final variablesJson = variables == null ? null : jsonEncode(variables);
    BigInt? subId;
    final controller = StreamController<T>();

    controller.onListen = () {
      Future.microtask(() async {
        try {
          debugPrint('[shalom] executing operation: $name');
          subId = await rs_runtime.request(
            handle: _handle,
            name: name,
            variablesJson: variablesJson,
            executionPolicy: executionPolicy,
          );
          if (controller.isClosed) {
            if (subId != null) {
              rs_runtime.unsubscribe(handle: _handle, subscriptionId: subId!);
            }
            return;
          }
          _bindSubscriptionStream(
            subId: subId!,
            controller: controller,
            decoder: decoder,
            debugName: name,
          );
        } catch (e, st) {
          debugPrint('[shalom] request($name): ERROR $e');
          if (!controller.isClosed) controller.addError(e, st);
        }
      });
    };

    controller.onCancel = () {
      debugPrint('[shalom] request($name): onCancel fired, subId=$subId');
      final id = subId;
      if (id == null) return;
      rs_runtime.unsubscribe(handle: _handle, subscriptionId: id);
    };

    return controller.stream;
  }

  // -------------------------------------------------------------------------
  // Mutations
  // -------------------------------------------------------------------------

  /// Fire a pre-registered mutation named [name] and return the normalised
  /// result as a one-shot [Future].  The mutation response is written into the
  /// shared entity cache, triggering reactive updates on any query subscriptions
  /// that watch the same entities.
  Future<T> mutate<T>({
    required String name,
    Map<String, dynamic>? variables,
    required T Function(JsonObject) decoder,
  }) => request<T>(
    name: name,
    variables: variables,
    decoder: decoder,
    executionPolicy: rs_runtime.ExecutionPolicyInput.networkFirst,
  ).first;

  /// Write [data] to the cache immediately as an optimistic response for the
  /// mutation named [name].  Returns an opaque write ID that can be passed to
  /// [rollbackOptimistic] to undo the write if the real response indicates
  /// failure.
  Future<BigInt> writeOptimistic({
    required String name,
    required JsonObject data,
  }) => rs_runtime.writeOptimistic(
    handle: _handle,
    opName: name,
    dataJson: jsonEncode(data),
  );

  /// Undo a previous [writeOptimistic] call, restoring the cache to its
  /// pre-write state and re-notifying affected subscribers.  Idempotent — safe
  /// to call more than once for the same [writeId].
  void rollbackOptimistic(BigInt writeId) =>
      rs_runtime.rollbackOptimistic(handle: _handle, writeId: writeId);

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
        debugPrint('[shalom] subscribeToFragment: observableId=${ref.observableId} anchor=${ref.anchor} subId=$subId');
      } catch (e, st) {
        debugPrint('[shalom] subscribeToFragment ERROR: $e');
        if (!controller.isClosed) controller.addError(e, st);
        return;
      }

      _bindSubscriptionStream(
        subId: subId!,
        controller: controller,
        decoder: decoder,
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

      _bindSubscriptionStream(
        subId: newSubId!,
        controller: controller,
        decoder: decoder,
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
  // Private subscription helper
  // -------------------------------------------------------------------------

  void _bindSubscriptionStream<T>({
    required BigInt subId,
    required StreamController<T> controller,
    required T Function(JsonObject) decoder,
    String? debugName,
  }) {
    rs_runtime
        .listenSubscription(handle: _handle, subscriptionId: subId)
        .listen(
          (payload) {
            if (controller.isClosed) return;
            try {
              final raw = jsonDecode(payload);
              if (raw is Map && raw.containsKey('__error__')) {
                controller.addError(Exception(raw['__error__'] as String));
                return;
              }
              final envelope = _RuntimeEnvelope.tryFromJson(payload);
              if (envelope == null) {
                debugPrint('[shalom] sub: null data payload, skipping');
                return;
              }
              debugPrint('[shalom] result yielded: ${debugName ?? subId}');
              controller.add(decoder(envelope.data));
            } catch (e, st) {
              debugPrint('[shalom] sub decode error: $e');
              controller.addError(e, st);
            }
          },
          onError: (Object e, StackTrace st) {
            debugPrint('[shalom] sub stream error: $e');
            if (!controller.isClosed) controller.addError(e, st);
          },
          onDone: () {
            debugPrint('[shalom] sub stream done');
            if (!controller.isClosed) controller.close();
          },
        );
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
    debugPrint('[shalom] _handleRequestEnvelope: $payload');
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
              unawaited(
                rs_runtime.completeTransport(
                  handle: _handle,
                  requestId: BigInt.from(envelope.id),
                ),
              );
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

  // -------------------------------------------------------------------------
  // Debug / cache inspection
  // -------------------------------------------------------------------------

  /// Returns all keys currently stored in the normalized cache, sorted
  /// alphabetically.
  List<String> getCacheKeys() => rs_runtime.getCacheKeys(handle: _handle);

  /// Returns a pretty-printed JSON string for the cache entry at [key],
  /// or `null` if the key is not present.
  ///
  /// Refs in the cache are serialised as `{"__ref": "<key>"}`.
  String? getCacheEntry(String key) =>
      rs_runtime.getCacheEntry(handle: _handle, key: key);

  /// Returns a map of cache-key → active subscriber count.
  Map<String, int> getSubscriptionCounts() {
    final raw = rs_runtime.getSubscriptionCounts(handle: _handle);
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return decoded.map((k, v) => MapEntry(k, (v as num).toInt()));
  }

  /// Returns info about every active subscription currently watching [key].
  List<rs_runtime.SubscriberInfo> getKeySubscribers(String key) =>
      rs_runtime.getKeySubscribers(handle: _handle, key: key);
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
      throw const FormatException(
        'request envelope request must be a JSON object',
      );
    }
    final query = requestRaw['query'];
    final opName = requestRaw['operation_name'];
    final opTypeRaw = requestRaw['operation_type'];
    if (query is! String || opName is! String || opTypeRaw is! String) {
      throw const FormatException(
        'request envelope has invalid request fields',
      );
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

  /// Returns null when the payload carries a null data field (cache miss — no
  /// data available yet).  Callers must skip emission in that case.
  static _RuntimeEnvelope? tryFromJson(String payload) {
    final decoded = jsonDecode(payload);
    if (decoded is! Map) {
      throw const FormatException('runtime response must be a JSON object');
    }
    if (decoded.containsKey('data')) {
      final dataRaw = decoded['data'];
      if (dataRaw == null) return null; // cache empty — nothing to emit yet
      if (dataRaw is! Map) {
        throw const FormatException(
          'runtime response data must be a JSON object',
        );
      }
      return _RuntimeEnvelope(data: dataRaw.cast<String, dynamic>());
    }
    return _RuntimeEnvelope(data: decoded.cast<String, dynamic>());
  }

  factory _RuntimeEnvelope.fromJson(String payload) =>
      tryFromJson(payload) ??
      (throw const FormatException('runtime response data must be a JSON object'));
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
    final message = error.isEmpty
        ? 'Unknown transport error'
        : error.join('; ');
    return _TransportError(message: message, code: 'LINK_ERROR');
  }
  return _TransportError(message: error.toString(), code: 'LINK_ERROR');
}
