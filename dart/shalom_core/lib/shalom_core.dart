import 'dart:collection';

import 'src/normelized_cache.dart';

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
  const ShalomCtx({required this.cache});

  RecordID resolveNodeID(String id) {
    return id.split(":").toString();
  }
}

class CacheUpdateContext {
  final ShalomCtx shalomContext;
  final ReachableRecordsCtx reachableRecordsCtx;

  /// deserialized values should be appended here
  final HashMap<RecordID, NormalizedRecordData> currentNormalizedRecord;
  final RecordID currentRecordID;
  
  void addReachableRecord(RecordID id) {
    reachableRecordsCtx.add(id);
  }
  
  void addNormalizedRecord(RecordID id, NormalizedRecordData data) => shalomContext.cache.insertToCache(id, data);

  CacheUpdateContext({
    required this.shalomContext,
    required this.reachableRecordsCtx,
    required this.currentNormalizedRecord,
    required this.currentRecordID,
  });
}
