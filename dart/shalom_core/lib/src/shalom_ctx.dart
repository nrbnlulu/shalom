import 'dart:async' show StreamController;

import '../shalom_core.dart' show NormelizedCache;
import 'normelized_cache.dart' show NormalizedRecordData, RecordID, RecordSubscriptionDTO;

typedef RefStreamType = StreamController<ShalomCtx>;

class RecordUpdateDTO {
  final Set<RecordID> updatedFields;
  final RecordID onRecord;
  const RecordUpdateDTO({required this.updatedFields, required this.onRecord});
}

class RecordSubscriber {
  final RefStreamType streamController;
  final Set<RecordSubscriptionDTO> subs;
  const RecordSubscriber({required this.streamController, required this.subs});

  void cancel() {
    streamController.close();
  }

  bool isAffectedBy(RecordUpdateDTO update) {
    for (final sub in subs) {
      if (sub.fields.any((f) => update.updatedFields.contains(f))) {
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

  RecordSubscriber subscribe(Map<RecordID, Set<RecordID>> request) {
    return subscribeToRefs(
      request.entries
          .map((e) => RecordSubscriptionDTO(recordID: e.key, fields: e.value))
          .toSet(),
    );
  }

  NormalizedRecordData? getCachedRecord(RecordID id) => cache.get(id);
  
  void insertToCache(RecordID id, NormalizedRecordData data) {
    cache.put(id, data);
  }


  void invalidateRefs(Iterable<RecordUpdateDTO> updates) {
    for (final subscriber in refSubscribers.values) {
      for (final update in updates) {
        if (subscriber.isAffectedBy(update)) {
          subscriber.streamController.add(this);
          break;
        }
      }
    }
  }
  
  
  RecordSubscriber subscribeToRefs(Set<RecordSubscriptionDTO> subs) {
    RecordSubscriber? subscriber = null;
    subscriber = RecordSubscriber(
      subs: subs,
      streamController: RefStreamType(
        onCancel: () => refSubscribers.remove(identityHashCode(subscriber)),
      ),
    );
    return subscriber;
  }

}
