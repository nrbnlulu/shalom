import 'dart:async';
import 'dart:convert';

import 'package:shalom/src/shalom_core_base.dart' show JsonObject, GraphQLResponse, Requestable;
import 'package:shalom/src/transport/link.dart' show GraphQLLink;

import 'rust/api/runtime.dart' as rs_runtime;

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
    required core.GraphQLLink link,
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

  Stream<core.GraphQLResponse<T>> requestStream<T>(
    core.Requestable<T> requestable,
  ) async* {
    final meta = requestable.getRequestMeta();
    final req = meta.request;
    try {
      final variablesJson = req.variables.isEmpty
          ? null
          : jsonEncode(req.variables);
      final payload = await rs_runtime.request(
        handle: _handle,
        query: req.query,
        variablesJson: variablesJson,
      );
      final envelope = _RuntimeEnvelope.fromJson(payload);
      yield core.GraphQLData(data: meta.parseFn(envelope.data));
    } on Exception catch (e) {
      yield core.LinkExceptionResponse([e]);
    }
  }

  Future<RuntimeTypedResult<T>> requestTyped<T>({
    required core.Requestable<T> requestable,
  }) async {
    final meta = requestable.getRequestMeta();
    final req = meta.request;
    final variablesJson = req.variables.isEmpty
        ? null
        : jsonEncode(req.variables);
    final payload = await rs_runtime.request(
      handle: _handle,
      query: req.query,
      variablesJson: variablesJson,
    );
    final envelope = _RuntimeEnvelope.fromJson(payload);
    if (envelope.operationId == null) {
      throw FormatException('runtime response missing operation_id');
    }
    final refs = core.collectRuntimeRefs(envelope.data);
    return RuntimeTypedResult(
      data: meta.parseFn(envelope.data),
      rawData: envelope.data,
      operationId: envelope.operationId!,
      refs: refs,
    );
  }

  Stream<T> request<T>({required Requestable<T> requestable}) async* {
    final meta = requestable.getRequestMeta();
    final networkResults = _link.request(
      request: meta.request,
    );
    
    final subId = rs_runtime.initSubscription(
      handle: _handle,
      targetId: meta.request.opName,
      rootRef: null,
    );
    try {
      await for (final res in rs_runtime.subscribe(
        handle: _handle,
        subscriptionId: subId,
      )) {
        final envelope = _RuntimeEnvelope.fromJson(res);
        yield meta.parseFn(envelope.data);
      }
    } finally {
      await rs_runtime.unsubscribe(subscriptionId: subId, handle: _handle);
    }
  }

  @override
  Stream<T> subscribeFragment<T>({
    required String targetId,
    required String rootRef,
    required T Function(JsonObject) fromJson,
    required Iterable<String> refs,
  }) async* {
    final subId = rs_runtime.initSubscription(
      handle: _handle,
      targetId: targetId,
      rootRef: rootRef,
      refs: refs.toList(growable: false),
    );
    try {
      await for (final res in rs_runtime.subscribe(
        handle: _handle,
        subscriptionId: subId,
      )) {
        final envelope = _RuntimeEnvelope.fromJson(res);
        yield fromJson(envelope.data);
      }
    } finally {
      await rs_runtime.unsubscribe(subscriptionId: subId, handle: _handle);
    }
  }

  Future<void> dispose() async {
    if (_disposed) {
      return;
    }
    _disposed = true;
    final stream = _requestStream;
    if (stream != null) {
      // Don't await: the Rust listen_requests task is blocked on its next
      // item and won't acknowledge the cancellation until the channel closes.
      // Fire-and-forget — the FRB runtime will clean up when the handle drops.
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
          onDone: () {
            _activeRequests.remove(envelope.id);
            rs_runtime.completeTransport(
              handle: _handle,
              requestId: BigInt.from(envelope.id),
            );
          },
        );
    _activeRequests[envelope.id] = subscription;
  }

  void _dispatchResponse(
    int requestId,
    core.GraphQLResponse<JsonObject> response,
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
