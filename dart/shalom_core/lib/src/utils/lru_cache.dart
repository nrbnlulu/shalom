import 'dart:collection';

class LruCache<K, V> {
  final int capacity;
  final LinkedHashMap<K, V> _cache;

  LruCache({this.capacity = 100})
    : _cache = LinkedHashMap<K, V>(
        // We can't use a regular HashMap because we need to
        // maintain the insertion order.
        // LinkedHashMap is perfect for this.
        // We can use a Queue to keep track of the most recently used items.
        // When an item is accessed, we can move it to the end of the queue.
      );

  V? get(K key) => _cache[key];

  void put(K key, V value) {
    if (_cache.containsKey(key)) {
      _cache.remove(key);
    } else if (_cache.length >= capacity) {
      _cache.remove(_cache.keys.first);
    }
    _cache[key] = value;
  }

  void clear() {
    _cache.clear();
  }

  bool containsKey(K key) => _cache.containsKey(key);

  int get size => _cache.length;
}
