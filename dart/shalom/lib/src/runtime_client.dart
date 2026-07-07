import 'dart:async';
import 'dart:convert';

import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart'
    show ExternalLibrary;
import 'package:shalom/shalom.dart';

import 'rust/api/runtime.dart' as rs_runtime;

export 'rust/api/runtime.dart'
    show
        ExecutionPolicyInput,
        ObservedRefInput,
        RuntimeConfigInput,
        ObserverInfo;

// Note: `RetryDelayInput` (the raw FRB type) is intentionally not exported —
// callers use the ergonomic [RetryDelay] wrapper instead.

// ---------------------------------------------------------------------------
// ObservedRefInput helpers (exported so codegen templates can use them via
// `shalom_core.observedRefInputFromJson(...)`)
// ---------------------------------------------------------------------------

/// Deserialise an [ObservedRefInput] from a JSON map produced by the Rust cache.
///
/// The cache serialises refs under `__shalom_observed_ref`, a reserved key that
/// GraphQL user fields cannot use.
rs_runtime.ObservedRefInput observedRefInputFromJson(JsonObject json) {
  final refJson = (json['__shalom_observed_ref'] as JsonObject?) ?? json;
  return rs_runtime.ObservedRefInput(
    observableId: refJson['observable_id'] as String,
    anchor: refJson['anchor'] as String,
  );
}

// ---------------------------------------------------------------------------
// RuntimeConfigInput helpers
// ---------------------------------------------------------------------------

/// Builds a [RuntimeConfigInput] from [Duration]s instead of raw millisecond
/// [BigInt]s.
///
/// - [gcInterval] controls how often the background thread sweeps the
///   normalized cache for unreferenced entries (defaults to 2 seconds).
/// - [retentionGrace] keeps a cache entry alive for a bit after its last
///   subscriber unsubscribes (e.g. during a widget rebuild or screen
///   transition) instead of evicting it on the very next GC sweep. Defaults
///   to `Duration.zero` (no grace period).
/// - [defaultRetryDelay] is the default delay before an operation (query,
///   mutation, or subscription) that failed with a transport error is
///   retried. Individual [ShalomRuntimeClient.request] calls can override
///   this via their `retryDelay` param. Defaults to no auto-retry.
rs_runtime.RuntimeConfigInput runtimeConfig({
  Duration? gcInterval,
  Duration? retentionGrace,
  Duration? defaultRetryDelay,
}) {
  return rs_runtime.RuntimeConfigInput(
    gcIntervalMs: gcInterval != null
        ? BigInt.from(gcInterval.inMilliseconds)
        : null,
    retentionGraceMs: retentionGrace != null
        ? BigInt.from(retentionGrace.inMilliseconds)
        : null,
    defaultRetryDelayMs: defaultRetryDelay != null
        ? BigInt.from(defaultRetryDelay.inMilliseconds)
        : null,
  );
}

/// Per-call override for [ShalomRuntimeClient.request]'s retry-on-transport-error
/// behavior. Defaults to [RetryDelay.inherit], which uses the runtime's
/// globally configured default (see [runtimeConfig]'s `defaultRetryDelay`).
sealed class RetryDelay {
  const RetryDelay();

  /// Use the runtime's globally configured default (which may itself be off).
  const factory RetryDelay.inherit() = _RetryDelayInherit;

  /// Disable auto-retry for this operation, regardless of the global default.
  const factory RetryDelay.disabled() = _RetryDelayDisabled;

  /// Retry after [duration], overriding the global default.
  const factory RetryDelay.after(Duration duration) = _RetryDelayAfter;

  rs_runtime.RetryDelayInput _toInput() => switch (this) {
    _RetryDelayInherit() => const rs_runtime.RetryDelayInput.inherit(),
    _RetryDelayDisabled() => const rs_runtime.RetryDelayInput.disabled(),
    _RetryDelayAfter(:final duration) => rs_runtime.RetryDelayInput.millis(
      BigInt.from(duration.inMilliseconds),
    ),
  };
}

class _RetryDelayInherit extends RetryDelay {
  const _RetryDelayInherit();
}

class _RetryDelayDisabled extends RetryDelay {
  const _RetryDelayDisabled();
}

class _RetryDelayAfter extends RetryDelay {
  final Duration duration;
  const _RetryDelayAfter(this.duration);
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

  /// Create a runtime for [schemaSdl]. Synchronous init only; operational APIs
  /// are async after construction. Call after
  /// [initFlutterRustBridge] has completed.
  ///
  /// Register operations/fragments via [registerOperation] /
  /// [registerFragment] (or the generated `registerShalomDefinitions(client)`).
  ///
  /// Use [runtimeConfig] to build [config] from [Duration]s (e.g. to tune the
  /// GC sweep interval or retention grace period).
  static ShalomRuntimeClient create({
    required String schemaSdl,
    rs_runtime.RuntimeConfigInput? config,
    required GraphQLLink link,
    rs_runtime.LogLevel? logLevel,
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
    rs_runtime.reloadSchema(handle: _handle, schemaSdl: schemaSdl);
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
  /// open a cache subscription. Returns a stream of [GraphQLResponse<T>] values.
  ///
  /// The first emission arrives after the network response is normalised.
  /// Subsequent emissions are triggered by cache writes to any ref touched by
  /// this operation. Cancelling the returned stream unsubscribes immediately.
  ///
  /// The stream emits:
  /// - [GraphQLData<T>] on successful data (may include partial errors)
  /// - [GraphQLError<T>] on GraphQL-level errors
  /// - [LinkExceptionResponse<T>] on transport/network errors
  ///
  /// [retryDelay] controls whether a transport error automatically re-issues
  /// this operation after a delay (the error is still emitted on the stream
  /// either way). Defaults to [RetryDelay.inherit], i.e. the runtime's global
  /// default configured via [runtimeConfig]. Retrying stops as soon as the
  /// returned stream is cancelled.
  ///
  /// [autoRefetch], if set, re-issues this operation on a timer as long as
  /// the returned stream is still listened to — a plain polling refetch,
  /// independent of [retryDelay]'s error handling. Only meaningful for
  /// queries (subscriptions stay open on their own; mutations shouldn't be
  /// repeated on a timer).
  Stream<GraphQLResponse<T>> request<T>({
    required String name,
    Map<String, dynamic>? variables,
    required T Function(JsonObject) decoder,
    rs_runtime.ExecutionPolicyInput executionPolicy =
        rs_runtime.ExecutionPolicyInput.networkFirst,
    RetryDelay retryDelay = const RetryDelay.inherit(),
    Duration? autoRefetch,
  }) {
    final variablesJson = variables == null ? null : jsonEncode(variables);
    BigInt? subId;
    final controller = StreamController<GraphQLResponse<T>>();

    controller.onListen = () {
      Future.microtask(() async {
        try {
          subId = await rs_runtime.request(
            handle: _handle,
            name: name,
            variablesJson: variablesJson,
            executionPolicy: executionPolicy,
            retryDelay: retryDelay._toInput(),
            refetchIntervalMs: autoRefetch != null
                ? BigInt.from(autoRefetch.inMilliseconds)
                : null,
          );
          if (controller.isClosed) {
            if (subId != null) {
              await rs_runtime.unsubscribe(
                handle: _handle,
                subscriptionId: subId!,
              );
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
          if (!controller.isClosed) controller.addError(e, st);
        }
      });
    };

    controller.onCancel = () async {
      final id = subId;
      if (id == null) return;
      await rs_runtime.unsubscribe(handle: _handle, subscriptionId: id);
    };

    return controller.stream;
  }

  // -------------------------------------------------------------------------
  // Mutations
  // -------------------------------------------------------------------------

  /// Fire a pre-registered mutation named [name] and return the normalised
  /// result as a one-shot [Future] wrapped in [GraphQLResponse<T>].
  /// The mutation response is written into the shared entity cache, triggering
  /// reactive updates on any query subscriptions that watch the same entities.
  ///
  /// Auto-retry is disabled by default (mutations have side effects, so
  /// silently re-sending one after a transport error is unsafe unless the
  /// caller opts in explicitly via [retryDelay]).
  Future<GraphQLResponse<T>> mutate<T>({
    required String name,
    Map<String, dynamic>? variables,
    required T Function(JsonObject) decoder,
    RetryDelay retryDelay = const RetryDelay.disabled(),
  }) => request<T>(
    name: name,
    variables: variables,
    decoder: decoder,
    executionPolicy: rs_runtime.ExecutionPolicyInput.networkFirst,
    retryDelay: retryDelay,
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
  Future<void> rollbackOptimistic(BigInt writeId) =>
      rs_runtime.rollbackOptimistic(handle: _handle, writeId: writeId);

  // -------------------------------------------------------------------------
  // Fragment subscription — cache only
  // -------------------------------------------------------------------------

  /// Subscribe to cache updates for a pre-registered fragment at the anchor
  /// identified by [ref].
  ///
  /// Emits the current cached value immediately if available, then re-emits
  /// whenever the underlying cache entries change. Returns a stream of
  /// [GraphQLResponse<T>] carrying either success or error states.
  Stream<GraphQLResponse<T>> subscribeToFragment<T>({
    required rs_runtime.ObservedRefInput ref,
    required T Function(JsonObject) decoder,
  }) {
    BigInt? subId;
    final controller = StreamController<GraphQLResponse<T>>();

    controller.onListen = () {
      Future.microtask(() async {
        try {
          subId = await rs_runtime.observeFragment(
            handle: _handle,
            refInput: ref,
          );
        } catch (e, st) {
          if (!controller.isClosed) controller.addError(e, st);
          return;
        }

        if (controller.isClosed) {
          final id = subId;
          if (id != null) {
            await rs_runtime.unsubscribe(handle: _handle, subscriptionId: id);
          }
          return;
        }

        _bindSubscriptionStream(
          subId: subId!,
          controller: controller,
          decoder: decoder,
        );
      });
    };

    controller.onCancel = () async {
      final id = subId;
      if (id == null) return;
      await rs_runtime.unsubscribe(handle: _handle, subscriptionId: id);
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
  /// Returns a stream of [GraphQLResponse<T>].
  Stream<GraphQLResponse<T>> rebindFragmentSubscription<T>({
    required BigInt subscriptionId,
    required rs_runtime.ObservedRefInput newRef,
    required T Function(JsonObject) decoder,
  }) {
    BigInt? newSubId;
    final controller = StreamController<GraphQLResponse<T>>();

    controller.onListen = () {
      Future.microtask(() async {
        try {
          newSubId = await rs_runtime.rebindSubscription(
            handle: _handle,
            subscriptionId: subscriptionId,
            newRef: newRef,
          );
        } catch (e, st) {
          if (!controller.isClosed) controller.addError(e, st);
          return;
        }

        if (controller.isClosed) {
          final id = newSubId;
          if (id != null) {
            await rs_runtime.unsubscribe(handle: _handle, subscriptionId: id);
          }
          return;
        }

        _bindSubscriptionStream(
          subId: newSubId!,
          controller: controller,
          decoder: decoder,
        );
      });
    };

    controller.onCancel = () async {
      final id = newSubId;
      if (id == null) return;
      await rs_runtime.unsubscribe(handle: _handle, subscriptionId: id);
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
    required StreamController<GraphQLResponse<T>> controller,
    required T Function(JsonObject) decoder,
    String? debugName,
  }) {
    rs_runtime
        .listenSubscription(handle: _handle, subscriptionId: subId)
        .listen(
          (event) {
            if (controller.isClosed) return;
            late GraphQLResponse<T> response;
            try {
              switch (event) {
                case rs_runtime.SubscriptionEvent_Data(
                  dataJson: final dataJson,
                ):
                  final decoded = decoder(jsonDecode(dataJson) as JsonObject);
                  response = GraphQLData<T>(data: decoded);
                case rs_runtime.SubscriptionEvent_GraphQlError(
                  errorsJson: final errorsJson,
                  extensionsJson: final extensionsJson,
                ):
                  response = GraphQLError<T>(
                    errors: (jsonDecode(errorsJson) as List).cast<JsonObject>(),
                    extensions: extensionsJson != null
                        ? (jsonDecode(extensionsJson) as JsonObject)
                        : null,
                  );
                case rs_runtime.SubscriptionEvent_TransportError(
                  code: final code,
                  message: final message,
                  detailsJson: final detailsJson,
                ):
                  response = LinkExceptionResponse<T>([
                    ShalomTransportException(
                      message: message,
                      code: code,
                      details: detailsJson != null
                          ? (jsonDecode(detailsJson) as JsonObject)
                          : null,
                    ),
                  ]);
              }
              controller.add(response);
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
  }

  // -------------------------------------------------------------------------
  // Host link plumbing (internal)
  // -------------------------------------------------------------------------

  void _bindRequests() {
    final stream = rs_runtime.listenRequests(handle: _handle);
    _requestStream = stream.listen(_handleRequestEnvelope, onError: (_) {});
  }

  Future<void> _handleRequestEnvelope(String payload) async {
    if (_disposed) return;
    final envelope = _RequestEnvelope.fromJson(payload);
    final previous = _activeRequests.remove(envelope.id);
    if (previous != null) {
      await previous.cancel();
    }
    final request = Request(
      query: envelope.query,
      variables: envelope.variables,
      opType: envelope.operationType,
      opName: envelope.operationName,
    );

    final subscription = _link
        .request(request: request)
        .listen(
          (response) async => _dispatchResponse(envelope.id, response),
          onError: (error) async => _dispatchTransportError(envelope.id, error),
          onDone: () async {
            _activeRequests.remove(envelope.id);
            await rs_runtime.completeTransport(
              handle: _handle,
              requestId: BigInt.from(envelope.id),
            );
          },
        );
    _activeRequests[envelope.id] = subscription;
  }

  Future<void> _dispatchResponse(
    int requestId,
    GraphQLResponse<JsonObject> response,
  ) async {
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
        await _dispatchTransportError(requestId, response.errors);
    }
  }

  Future<void> _pushResponse(int requestId, Map<String, dynamic> payload) {
    return rs_runtime.pushResponse(
      handle: _handle,
      requestId: BigInt.from(requestId),
      responseJson: jsonEncode(payload),
    );
  }

  Future<void> _dispatchTransportError(int requestId, Object error) {
    final transport = _toTransportError(error);
    return rs_runtime.pushTransportError(
      handle: _handle,
      requestId: BigInt.from(requestId),
      message: transport.message,
      code: transport.code,
      detailsJson: transport.detailsJson,
    );
  }

  // -------------------------------------------------------------------------
  // Cache read / write (Apollo-style cache update API)
  // -------------------------------------------------------------------------

  /// Read the current cache for operation [name] and decode it as [T].
  ///
  /// Returns `null` when the data is absent or incomplete in the cache.
  /// Use inside [CacheProxy.readQuery] or directly when you need a one-shot
  /// cache read without opening a subscription.
  Future<T?> readQuery<T>({
    required String name,
    required T Function(JsonObject) decoder,
    Map<String, dynamic>? variables,
  }) async {
    final variablesJson = variables == null ? null : jsonEncode(variables);
    final raw = await rs_runtime.readQuery(
      handle: _handle,
      name: name,
      variablesJson: variablesJson,
    );
    if (raw == null) return null;
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return decoder(json);
  }

  /// Write [data] to the cache for its generated operation, normalizing it
  /// and notifying any active subscribers.
  ///
  /// This is a permanent write (no rollback).  The typical use-case is inside
  /// a mutation's `executeWithCacheUpdate` callback to keep a cached list in
  /// sync after an add / remove mutation.
  Future<void> writeQuery<T extends OperationInterface>({
    required T data,
    Map<String, dynamic>? variables,
  }) {
    final variablesJson = variables == null ? null : jsonEncode(variables);
    return rs_runtime.writeQuery(
      handle: _handle,
      name: data.operation$Name(),
      dataJson: jsonEncode(data.toJson()),
      variablesJson: variablesJson,
    );
  }

  /// Read an entity from the cache through [fragment_name]'s selection set.
  ///
  /// Returns `null` when the entity is absent or has missing refs.
  Future<T?> readFragment<T>({
    required String fragmentName,
    required String entityKey,
    required T Function(JsonObject) decoder,
  }) async {
    final raw = await rs_runtime.readFragment(
      handle: _handle,
      fragmentName: fragmentName,
      entityKey: entityKey,
    );
    if (raw == null) return null;
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return decoder(json);
  }

  /// Write [data] to the cache, using [FragmentInterface]'s selection set,
  /// notifying all affected subscribers.
  ///
  /// The target entity's cache key is derived from [data]'s `entity$Type()`
  /// and `entity$Id()` (i.e. `'$entity$Type:$entity$Id'`).
  Future<void> writeFragment<T extends FragmentInterface>({required T data}) {
    return rs_runtime.writeFragment(
      handle: _handle,
      fragmentName: data.fragment$Name(),
      entityKey: '${data.entity$Type()}:${data.entity$Id()}',
      dataJson: jsonEncode(data.toJson()),
    );
  }

  // -------------------------------------------------------------------------
  // Debug / cache inspection
  // -------------------------------------------------------------------------

  /// Returns all keys currently stored in the normalized cache, sorted
  /// alphabetically.
  Future<List<String>> getCacheKeys() =>
      rs_runtime.getCacheKeys(handle: _handle);

  /// Returns a pretty-printed JSON string for the cache entry at [key],
  /// or `null` if the key is not present.
  ///
  /// Refs in the cache are serialised as `{"__ref": "<key>"}`.
  Future<String?> getCacheEntry(String key) =>
      rs_runtime.getCacheEntry(handle: _handle, key: key);

  /// Returns a map of cache-key → active observer count.
  Future<Map<String, int>> getObserverCounts() async {
    final raw = await rs_runtime.getObserverCounts(handle: _handle);
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return decoded.map((k, v) => MapEntry(k, (v as num).toInt()));
  }

  /// Returns info about every active observer currently watching [key].
  Future<List<rs_runtime.ObserverInfo>> getKeyObservers(String key) =>
      rs_runtime.getKeyObservers(handle: _handle, key: key);

  /// Returns info about ALL active observers in the runtime.
  Future<List<rs_runtime.ObserverInfo>> getAllObservers() =>
      rs_runtime.getAllObservers(handle: _handle);
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
