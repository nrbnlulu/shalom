import 'dart:async';

import 'shalom_core_base.dart' show JsonObject;

abstract class FromCache<T> {
  const FromCache();

  /// Global identifier used by the runtime to resolve operations/fragments.
  String get subscriberGlobalID;

  T fromCache(JsonObject data);
}

abstract class RuntimeSubscriptionClient {
  Stream<JsonObject> subscribeToRefs({
    required String targetId,
    required Iterable<String> refs,
    String? rootRef,
  });
}

Set<String> collectRuntimeRefs(JsonObject data) {
  final refs = <String>{};
  _collectRefs(data, refs);
  return refs;
}

void _collectRefs(Object? value, Set<String> refs) {
  if (value is Map<String, dynamic>) {
    final refMeta = value['__ref'];
    if (refMeta is Map) {
      final id = refMeta['id'];
      if (id is String) {
        refs.add(id);
      }
      final path = refMeta['path'];
      if (path is String) {
        refs.add(path);
      }
    }

    for (final entry in value.entries) {
      final key = entry.key;
      final entryValue = entry.value;
      if (key == '__ref') {
        continue;
      }
      if (key.startsWith('__ref_')) {
        if (entryValue is String) {
          refs.add(entryValue);
        }
        continue;
      }

      _collectRefs(entryValue, refs);
    }
    return;
  }

  if (value is List) {
    for (final item in value) {
      _collectRefs(item, refs);
    }
  }
}
