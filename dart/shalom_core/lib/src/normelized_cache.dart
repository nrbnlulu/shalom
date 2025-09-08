import 'dart:async';
import 'dart:collection';

import 'shalom_core_base.dart';
import 'utils/lru_cache.dart' show LruCache;

typedef RecordRef = String;

class Entity {
  final RecordRef ref;
  final JsonObject data;
  const Entity({required this.ref, required this.data});
}

class RefUpdate {
  final JsonObject newData;
  final List<String> changedFields;
  const RefUpdate({required this.newData, required this.changedFields});
}
typedef RefStreamType = StreamController<List<RefUpdate>>;

class RefSubscriber {
  final RefStreamType streamController;
  final Set<RecordRef> subscribedRefs;
  const RefSubscriber({required this.streamController, required this.subscribedRefs});
  
  void cancel() {
    streamController.close();
  }
}

class NormelizedCache {
  final LruCache<RecordRef, Entity> cache;
  final HashMap<int, RefSubscriber> refSubscribers = HashMap();

  NormelizedCache({int capacity = 1000}) : cache = LruCache(capacity: capacity);

  RefSubscriber subscribeToRefs(Set<RecordRef> refs) {
    RefSubscriber? subscriber = null;
    subscriber = RefSubscriber(
      subscribedRefs: refs,
      streamController: RefStreamType(
        onCancel: () => refSubscribers.remove(identityHashCode(subscriber)),
      ),
    );
    return subscriber;
  }

  void updateRef(RecordRef ref, RefUpdate data) {
    cache.put(ref, Entity(ref: ref, data: data.newData));
    refSubscribers.values.forEach((subscriber) {
      if (subscriber.subscribedRefs.contains(ref)) {
          /// ATM we only update one ref at a time,
          /// ITF we can implement something similar to a dataloader
        subscriber.streamController.add([data]);
      }
    });
  }
}
