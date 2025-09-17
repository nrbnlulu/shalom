import 'src/normelized_cache.dart';
import 'src/shalom_core_base.dart';
import 'src/shalom_ctx.dart' show ShalomCtx;

export 'src/shalom_core_base.dart';
export 'src/scalar.dart';
export 'src/normelized_cache.dart'
    show NormelizedCache, RecordSubscriptionDTO, NormalizedRecordData, RecordID;

export 'src/shalom_ctx.dart'
    show RecordSubscriber, RecordUpdateDTO, RefStreamType, ShalomCtx;

class CacheUpdateContext {
  final ShalomCtx shalomContext;
  final Map<RecordID, Set<RecordID>> dependantRecords = {};

  /// record id and the fields that have changed.
  final Map<RecordID, Set<RecordID>> changedRecords = {};

  void upsertDependantRecord(RecordID id, Set<RecordID> dependants) {
    if (dependantRecords.containsKey(id)) {
      dependantRecords[id]!.addAll(dependants);
    } else {
      dependantRecords[id] = dependants;
    }
  }

  void addChangedRecord(RecordID id, RecordID fieldID) {
    if (!changedRecords.containsKey(id)) {
      changedRecords[id] = {};
    }
    changedRecords[id]!.add(fieldID);
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
