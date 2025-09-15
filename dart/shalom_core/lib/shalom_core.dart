import 'dart:collection';

import 'src/normelized_cache.dart';

export 'src/shalom_core_base.dart';
export 'src/scalar.dart';
export 'src/normelized_cache.dart'
    show NormelizedCache, RefSubscriber, RefUpdate, RecordRef, RefStreamType;

class ShalomCtx {
  final NormelizedCache cache;
  const ShalomCtx({required this.cache});

  RecordID resolveNodeID(String id) {
    return id.split(":").toString();
  }
}

class DeserializationContext {
  final ShalomCtx shalomContext;
  final ReachableRecordsCtx reachableRecordsCtx;

  /// deserialized values should be appended here
  final HashMap<RecordID, NormalizedRecordData> currentCacheObject;
  
  void addReachableRecord(RecordID id) {
    reachableRecordsCtx.add(id);
  }
  
  DeserializationContext({
    required this.shalomContext,
    required this.reachableRecordsCtx,
    required this.currentCacheObject,
  });
  DeserializationContext withNewObject
}
