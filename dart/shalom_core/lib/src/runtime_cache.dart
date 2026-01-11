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
  final raw = data['__used_refs'];
  if (raw is List) {
    for (final entry in raw) {
      if (entry is String) {
        refs.add(entry);
      }
    }
  }
  return refs;
}
