import 'utils/lru_cache.dart' show LruCache;

/// can be typename:id or `full schema path (with args) similar to json path`
typedef RecordID = String;

class ListOfRefRecord {
  final List<RecordID> refs;
  const ListOfRefRecord(this.refs);
}

/// can be [String] (id) | [ListOfRefRecord] or a [dynamic] data that can't be normalized.
typedef NormalizedRecordData = dynamic;

class NormelizedCache {
  final LruCache<RecordID, NormalizedRecordData> cache;

  NormelizedCache({int capacity = 1000}) : cache = LruCache(capacity: capacity);

  bool containsKey(RecordID id) => cache.containsKey(id);

  NormalizedRecordData? get(RecordID id) => cache.get(id);

  void put(RecordID id, NormalizedRecordData data) => cache.put(id, data);
}
