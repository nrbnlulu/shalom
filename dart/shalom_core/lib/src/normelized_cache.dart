import 'utils/lru_cache.dart' show LruCache;

/// can be typename:id or `full schema path (with args)`
typedef RecordID = String;



class ListOfRefRecord {
  final List<RecordID> refs;
  const ListOfRefRecord(this.refs);
}

/// can be [String] (id) | [ListOfRefRecord] or a [dynamic] data that can't be normelized.
typedef NormalizedRecordData = dynamic;

class RecordSubscriptionDTO {
  final RecordID recordID;
  final  fields;
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


class NormelizedCache {
  final LruCache<RecordID, NormalizedRecordData> cache;

   NormelizedCache({int capacity = 1000})
    : cache = LruCache(capacity: capacity);

  bool containsKey(RecordID id) => cache.containsKey(id);

  NormalizedRecordData? get(RecordID id) => cache.get(id);

  void put(RecordID id, NormalizedRecordData data) => cache.put(id, data);

}

