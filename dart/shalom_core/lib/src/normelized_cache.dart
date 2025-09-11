import 'dart:async';
import 'dart:collection';

import 'shalom_core_base.dart';
import 'utils/lru_cache.dart' show LruCache;

/// can be typename:id or `full schema path (with args)`
typedef RecordID = String;
typedef RefStreamType = StreamController<dynamic>;

class RefSubscriber {
  final RefStreamType streamController;
  final Set<RecordID> subscribedRefs;
  const RefSubscriber({
    required this.streamController,
    required this.subscribedRefs,
  });

  void cancel() {
    streamController.close();
  }
}

class TypedObjectRecord {
  final String typeName;
  final String id;
  final Map<String, NormalizedRecordData> data;

  const TypedObjectRecord({
    required this.typeName,
    required this.id,
    required this.data,
  });
}

class RefRecord {
  final RecordID ref;
  const RefRecord(this.ref);
}

class ListOfRefRecord {
  final List<RecordID> refs;
  const ListOfRefRecord(this.refs);
}

/// can be [TypedObjectRecord] | [RefRecord] | [ListOfRefRecord] or [dynamic] data that can't be normelized.
typedef NormalizedRecordData = dynamic;

class NormelizedCache {
  final LruCache<RecordID, NormalizedRecordData> cache;
  final HashMap<int, RefSubscriber> refSubscribers = HashMap();

  NormelizedCache({int capacity = 1000}) : cache = LruCache(capacity: capacity);

  RefSubscriber subscribeToRefs(Set<RecordID> refs) {
    RefSubscriber? subscriber = null;
    subscriber = RefSubscriber(
      subscribedRefs: refs,
      streamController: RefStreamType(
        onCancel: () => refSubscribers.remove(identityHashCode(subscriber)),
      ),
    );
    return subscriber;
  }

  void updateRef(RecordID ref, NormalizedRecordData data) {
    cache.put(ref, data);
    refSubscribers.values.forEach((subscriber) {
      if (subscriber.subscribedRefs.contains(ref)) {
        subscriber.streamController.add(data);
      }
    });
  }
}

/// would be used by generated code to
class ReachableRecordsCtx {
  final Set<RecordID> ids;
  const ReachableRecordsCtx(this.ids);

  bool add(RecordID ref) => ids.add(ref);
}
