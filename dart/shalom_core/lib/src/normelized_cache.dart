import 'utils/lru_cache.dart' show LruCache;

/// can be typename:id or `full schema path (with args) similar to json path`
typedef RecordID = String;

class ListOfRefRecord {
  final List<RecordID> refs;
  const ListOfRefRecord(this.refs);
}

class NormalizedRecordObject {
  final String typename;
  final String id;
  const NormalizedRecordObject({required this.typename, required this.id});

  @override
  int get hashCode => Object.hash(typename, id);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NormalizedRecordObject &&
          runtimeType == other.runtimeType &&
          typename == other.typename &&
          id == other.id;

  @override
  String toString() => '$typename:$id';
}

/// can be [NormalizedRecordObject] (id) | [ListOfRefRecord] or a [dynamic] data that can't be normalized.
typedef NormalizedRecordData = dynamic;

class NormelizedCache {
  final LruCache<RecordID, NormalizedRecordData> cache;

  NormelizedCache({int capacity = 1000}) : cache = LruCache(capacity: capacity);

  bool containsKey(RecordID id) => cache.containsKey(id);

  NormalizedRecordData? get(RecordID id) => cache.get(id);

  void put(RecordID id, NormalizedRecordData data) => cache.put(id, data);
}
