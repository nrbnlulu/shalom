import 'dart:async';
import 'dart:collection';

import 'shalom_core_base.dart';
import 'utils/lru_cache.dart' show LruCache;

/// can be typename:id or `full schema path (with args)`
typedef RecordID = String;
typedef RefStreamType = StreamController<NormelizedCache>;

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

class RecordRef {
  final RecordID ref;
  const RecordRef(this.ref);
}

class ListOfRefRecord {
  final List<RecordID> refs;
  const ListOfRefRecord(this.refs);
}

/// can be [TypedObjectRecord] | [RecordRef] | [ListOfRefRecord] or a [dynamic] data that can't be normelized.
typedef NormalizedRecordData = dynamic;

class RecordSubscriptionDTO {
  final RecordID recordID;
  final Set<RecordID> fields;
  const RecordSubscriptionDTO({required this.recordID, required this.fields});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! RecordSubscriptionDTO) return false;
    return recordID == other.recordID && fields == other.fields;
  }

  @override
  int get hashCode => recordID.hashCode ^ fields.hashCode;
}

class RecordUpdateDTO {
  final Set<RecordID> updatedFields;
  final RecordID onRecord;
  const RecordUpdateDTO({required this.updatedFields, required this.onRecord});
}

class NormelizedCache {
  final LruCache<RecordID, NormalizedRecordData> cache;
  final Map<int, RecordSubscriber> refSubscribers = {};

   NormelizedCache({int capacity = 1000})
    : cache = LruCache(capacity: capacity);

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

  bool containsKey(RecordID id) => cache.containsKey(id);

  NormalizedRecordData get(RecordID id) => cache.get(id);

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
}
