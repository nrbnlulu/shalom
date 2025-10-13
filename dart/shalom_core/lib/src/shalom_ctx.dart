import 'dart:async' show StreamController;

import '../shalom_core.dart' show NormelizedCache;
import 'normelized_cache.dart' show NormalizedRecordData, RecordID;

typedef RefStreamType = StreamController<ShalomCtx>;

class RecordSubscriber {
  final RefStreamType streamController;
  final Set<RecordID> subs;
  const RecordSubscriber({required this.streamController, required this.subs});

  void cancel() {
    streamController.close();
  }

  bool isAffectedBy(Set<RecordID> changes) {
    for (final change in changes) {
      if (subs.contains(change)) {
        return true;
      }
    }
    return false;
  }
}

class ShalomCtx {
  final NormelizedCache cache;
  final Map<int, RecordSubscriber> refSubscribers = {};

  ShalomCtx({required this.cache});
  ShalomCtx.withCapacity({int capacity = 1000})
      : cache = NormelizedCache(capacity: capacity);

  RecordID resolveNodeID(String id) {
    return id.split(":").toString();
  }

  RecordSubscriber subscribe(Set<RecordID> records) {
    return subscribeToRefs(records);
  }

  NormalizedRecordData? getCachedRecord(RecordID id) => cache.get(id);

  void insertToCache(RecordID id, NormalizedRecordData data) {
    cache.put(id, data);
  }

  void invalidateRefs(Set<RecordID> updates) {
    for (final subscriber in refSubscribers.values) {
      if (subscriber.isAffectedBy(updates)) {
        subscriber.streamController.add(this);
      }
    }
  }

  RecordSubscriber subscribeToRefs(Set<RecordID> subs) {
    RecordSubscriber? subscriber = null;
    subscriber = RecordSubscriber(
      subs: subs,
      streamController: RefStreamType(
        onCancel: () => refSubscribers.remove(identityHashCode(subscriber)),
      ),
    );
    refSubscribers[identityHashCode(subscriber)] = subscriber;
    return subscriber;
  }
}
