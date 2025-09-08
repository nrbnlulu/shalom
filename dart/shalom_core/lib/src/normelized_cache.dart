import 'dart:async';
import 'dart:collection';

import 'shalom_core_base.dart';
import 'utils/lru_cache.dart' show LruCache;

typedef Ref = String;

class Entity {
  final Ref ref;
  final JsonObject data;
  const Entity({required this.ref, required this.data});
}

class RefUpdated {
  final JsonObject newData;
  final List<String> changedFields;
  const RefUpdated({required this.newData, required this.changedFields});
}

typedef RefSubscriber = StreamController<RefUpdated>;

class NormelizedCache {
  final LruCache<Ref, Entity> cache;
  final HashMap<Ref, HashMap<int, RefSubscriber>> refSubscriber = HashMap();

  NormelizedCache({int capacity = 1000}) : cache = LruCache(capacity: capacity);

  RefSubscriber subscribeToRef(Ref ref) {
    RefSubscriber? controller = null;
    controller = RefSubscriber(
      onCancel: () {
        final selfId = identityHashCode(controller);
        refSubscriber[ref]?.remove(selfId);
      },
    );
    return controller;
  }
}
