import 'dart:async';
import 'dart:convert';

import 'package:shalom_core/shalom_core.dart' as core;

import 'rust/api/runtime.dart' as frb;

class ShalomRuntimeClient implements core.RuntimeSubscriptionClient {
  final frb.RuntimeHandle _handle;
  final core.GraphQLLink _link;
  final Map<int, StreamSubscription<core.GraphQLResponse<core.JsonObject>>>
  _activeRequests = {};
  StreamSubscription<String>? _requestStream;
  bool _disposed = false;

  ShalomRuntimeClient._(this._handle, this._link);

  static Future<ShalomRuntimeClient> init({
    required String schemaSdl,
    required List<String> fragmentSdls,
    Map<String, dynamic>? config,
    required core.GraphQLLink link,
  }) async {
    final configJson = config == null ? null : jsonEncode(config);
    final handle = await frb.initRuntime(
      schemaSdl: schemaSdl,
      fragmentSdls: fragmentSdls,
      configJson: configJson,
    );
    final client = ShalomRuntimeClient._(handle, link);
    client._bindRequests();
    return client;
  }

  Future<RuntimeRequestResult> request({
    required String query,
    Map<String, dynamic>? variables,
  }) async {
    final variablesJson = variables == null ? null : jsonEncode(variables);
    final payload = await frb.request(
      handle: _handle,
      query: query,
      variablesJson: variablesJson,
    );
    final envelope = _RuntimeEnvelope.fromJson(payload);
    final operationId = envelope.operationId;
    if (operationId == null) {
      throw FormatException('runtime response missing operation_id');
    }
    return RuntimeRequestResult(data: envelope.data, operationId: operationId);
  }

  Future<RuntimeTypedResult<T>> requestTyped<T>({
    required String query,
    Map<String, dynamic>? variables,
    required core.FromCache<T> fromCache,
  }) async {
    final result = await request(query: query, variables: variables);
    final parsed = fromCache.fromCache(result.data);
    final refs = core.collectRuntimeRefs(result.data);
    return RuntimeTypedResult(
      data: parsed,
      rawData: result.data,
      operationId: result.operationId,
      refs: refs,
    );
  }

  Stream<Map<String, dynamic>> subscribe({
    required String operationId,
    required List<String> refs,
  }) async* {
    final subscriptionId = await frb.subscribe(
      handle: _handle,
      targetId: operationId,
      rootRef: null,
      refs: refs,
    );
    final updates = frb.listenUpdates(
      handle: _handle,
      subscriptionId: subscriptionId,
    );
    await for (final payload in updates) {
      final envelope = _RuntimeEnvelope.fromJson(payload);
      yield envelope.data;
    }
  }

  Stream<Map<String, dynamic>> subscribeFragment({
    required String fragmentName,
    required String rootRef,
    required List<String> refs,
  }) async* {
    final subscriptionId = await frb.subscribe(
      handle: _handle,
      targetId: fragmentName,
      rootRef: rootRef,
      refs: refs,
    );
    final updates = frb.listenUpdates(
      handle: _handle,
      subscriptionId: subscriptionId,
    );
    await for (final payload in updates) {
      final envelope = _RuntimeEnvelope.fromJson(payload);
      yield envelope.data;
    }
  }

  @override
  Stream<core.JsonObject> subscribeToRefs({
    required String targetId,
    required Iterable<String> refs,
    String? rootRef,
  }) {
    if (rootRef == null) {
      return subscribe(
        operationId: targetId,
        refs: refs.toList(growable: false),
      );
    }
    return subscribeFragment(
      fragmentName: targetId,
      rootRef: rootRef,
      refs: refs.toList(growable: false),
    );
  }

  Stream<T> subscribeTyped<T>({
    required core.FromCache<T> fromCache,
    required Iterable<String> refs,
    String? rootRef,
  }) async* {
    final updates = rootRef == null
        ? subscribe(
            operationId: fromCache.subscriberGlobalID,
            refs: refs.toList(growable: false),
          )
        : subscribeFragment(
            fragmentName: fromCache.subscriberGlobalID,
            rootRef: rootRef,
            refs: refs.toList(growable: false),
          );
    await for (final payload in updates) {
      yield fromCache.fromCache(payload);
    }
  }

  Future<void> dispose() async {
    if (_disposed) {
      return;
    }
    _disposed = true;
    final stream = _requestStream;
    if (stream != null) {
      await stream.cancel();
    }
    final subs = _activeRequests.values.toList(growable: false);
    _activeRequests.clear();
    for (final sub in subs) {
      await sub.cancel();
    }
  }

  void _bindRequests() {
    final stream = frb.listenRequests(handle: _handle);
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
    final request = core.Request(
      query: envelope.query,
      variables: envelope.variables,
      opType: envelope.operationType,
      opName: envelope.operationName,
    );
    final subscription = _link
        .request(request: request)
        .listen(
          (response) => _dispatchResponse(envelope.id, response),
          onError: (error) => _dispatchTransportError(envelope.id, error),
          onDone: () => _activeRequests.remove(envelope.id),
        );
    _activeRequests[envelope.id] = subscription;
  }

  void _dispatchResponse(
    int requestId,
    core.GraphQLResponse<core.JsonObject> response,
  ) {
    switch (response) {
      case core.GraphQLData():
        final payload = <String, dynamic>{'data': response.data};
        if (response.errors != null) {
          payload['errors'] = response.errors;
        }
        if (response.extensions != null) {
          payload['extensions'] = response.extensions;
        }
        unawaited(_pushResponse(requestId, payload));
      case core.GraphQLError():
        final payload = <String, dynamic>{'errors': response.errors};
        if (response.extensions != null) {
          payload['extensions'] = response.extensions;
        }
        unawaited(_pushResponse(requestId, payload));
      case core.LinkExceptionResponse():
        _dispatchTransportError(requestId, response.errors);
    }
  }

  Future<void> _pushResponse(int requestId, Map<String, dynamic> payload) {
    return frb.pushResponse(
      handle: _handle,
      requestId: BigInt.from(requestId),
      responseJson: jsonEncode(payload),
    );
  }

  void _dispatchTransportError(int requestId, Object error) {
    final transport = _toTransportError(error);
    unawaited(
      frb.pushTransportError(
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
  final core.OperationType operationType;

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

  static core.OperationType _parseOperationType(String raw) {
    switch (raw) {
      case 'Query':
        return core.OperationType.Query;
      case 'Mutation':
        return core.OperationType.Mutation;
      case 'Subscription':
        return core.OperationType.Subscription;
      default:
        throw FormatException('unknown operation type: $raw');
    }
  }
}

class RuntimeRequestResult {
  final Map<String, dynamic> data;
  final String operationId;

  const RuntimeRequestResult({required this.data, required this.operationId});

  Set<String> collectRefs() => core.collectRuntimeRefs(data);
}

class RuntimeTypedResult<T> {
  final T data;
  final Map<String, dynamic> rawData;
  final String operationId;
  final Set<String> refs;

  const RuntimeTypedResult({
    required this.data,
    required this.rawData,
    required this.operationId,
    required this.refs,
  });
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
  if (error is core.ShalomTransportException) {
    return _TransportError(
      message: error.message,
      code: error.code,
      detailsJson: error.details == null ? null : jsonEncode(error.details),
    );
  }
  if (error is List<Exception>) {
    if (error.isNotEmpty) {
      final first = error.first;
      if (first is core.ShalomTransportException) {
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
