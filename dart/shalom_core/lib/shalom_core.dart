import 'src/normelized_cache.dart';
import 'src/shalom_core_base.dart';
import 'src/shalom_ctx.dart' show ShalomCtx;

export 'src/shalom_core_base.dart';
export 'src/scalar.dart';
export 'src/normelized_cache.dart'
    show
        NormelizedCache,
        NormalizedRecordData,
        NormalizedObjectRecord,
        ListOfRefRecord,
        RecordID;

export 'src/shalom_ctx.dart' show RecordSubscriber, RefStreamType, ShalomCtx;
export 'src/transport/http_link.dart'
    show HttpLink, HttpMethod, ShalomHttpTransport;
export 'src/transport/link.dart' show GraphQLLink, ShalomClient;
export 'src/transport/ws_link.dart' show WebSocketLink;
export 'src/transport/ws_transport.dart' show WebSocketTransport, MessageSender;
export 'src/transport/ws_messages.dart'
    show
        WsMessage,
        ConnectionInitMessage,
        ConnectionAckMessage,
        PingMessage,
        PongMessage,
        SubscribeMessage,
        SubscribePayload,
        NextMessage,
        ErrorMessage,
        CompleteMessage,
        WsCloseCodes,
        parseWsMessage,
        parseWsMessageFromJson;

class CacheUpdateContext {
  final ShalomCtx shalomContext;

  /// full json path / normalized id
  final Set<RecordID> dependantRecords = {};

  /// full json path / normalized id
  final Set<RecordID> changedRecords = {};
  CacheUpdateContext({required this.shalomContext});

  void addDependantRecords(Set<RecordID> ids) {
    dependantRecords.addAll(ids);
  }

  void addDependantRecord(RecordID id) {
    dependantRecords.add(id);
  }

  void addChangedRecord(RecordID id) {
    changedRecords.add(id);
  }

  /// if exist in normalized cache returns the record
  /// otherwise will create an object and return it
  JsonObject getOrCreateCachedObjectRecord(RecordID id) {
    if (shalomContext.cache.containsKey(id)) {
      return shalomContext.getCachedRecord(id) as JsonObject;
    } else {
      final JsonObject ret = {};
      shalomContext.insertToCache(id, ret);
      return ret;
    }
  }

  void addNormalizedRecord(RecordID id, NormalizedRecordData data) =>
      shalomContext.cache.put(id, data);
}

JsonObject getOrCreateObject(JsonObject onObject, RecordID field) {
  if (onObject.containsKey(field) && onObject[field] != null) {
    return onObject[field] as JsonObject;
  } else {
    final JsonObject ret = {};
    onObject[field] = ret;
    return ret;
  }
}
