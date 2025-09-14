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
  final void Function(Record) assignToCache;

  DeserializationContext({
    required this.shalomContext,
    required this.reachableRecordsCtx,
    required this.assignToCache,
  });
  
  
}
