import 'dart:collection';

import 'src/normelized_cache.dart';
import 'src/shalom_core_base.dart';

export 'src/shalom_core_base.dart';
export 'src/scalar.dart';
export 'src/normelized_cache.dart'
    show
        NormelizedCache,
        RecordSubscriber,
        RecordUpdateDTO,
        RecordSubscriptionDTO,
        RefStreamType,
        NormalizedRecordData,
        RecordID;

class ShalomCtx {
  final NormelizedCache cache;

    ShalomCtx({ required this.cache });
ShalomCtx.withCapacity({int capacity = 1000}) : cache = NormelizedCache(capacity: capacity);

  RecordID resolveNodeID(String id) {
    return id.split(":").toString();
  }
}

class CacheUpdateContext {
  final ShalomCtx shalomContext;
  final Set<RecordID> dependantRecords = {};

  /// record id and the fields that have changed.
  final Map<RecordID, Set<RecordID>> changedRecords = {};

  void addDependantRecord(RecordID id) {
    dependantRecords.add(id);
  }

  void addChangedRecord(RecordID id, RecordID fieldID) {
    if (!changedRecords.containsKey(id)) {
      changedRecords[id] = {};
    }
    changedRecords[id]!.add(fieldID);
  }

  /// if exist in normalized cache returns the record
  /// otherwise will create an object and return it
  JsonObject getCachedObjectRecord(RecordID id) {
    if (shalomContext.cache.containsKey(id)) {
      return shalomContext.cache.get(id) as JsonObject;
    } else {
      final JsonObject ret = {};
      shalomContext.cache.insertToCache(id, ret);
      return ret;
    }
  }

  void addNormalizedRecord(RecordID id, NormalizedRecordData data) =>
      shalomContext.cache.insertToCache(id, data);

  CacheUpdateContext({required this.shalomContext});
}


JsonObject getOrCreateObject(JsonObject onObject, RecordID field) {
    if (onObject.containsKey(field)) {
      return onObject[field] as JsonObject;
    } else {
      final JsonObject ret = {};
      onObject[field] = ret;
      return ret;
    }
}