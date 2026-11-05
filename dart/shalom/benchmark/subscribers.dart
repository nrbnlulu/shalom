import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:shalom/shalom.dart';
import 'package:shalom/src/rust/api/runtime.dart' as runtime;

// Big query + N subscribers, against an empty and a full cache.
//
//   dart compile exe benchmark/subscribers.dart -o /tmp/subscribers-bench
//   /tmp/subscribers-bench <native-lib-path> [results.json]
//
// Results are written in the same `{name, unit, value}` (smaller is better)
// format as the Rust bench so CI can diff them.

const itemCount = 200;
final subscriberCounts = (Platform.environment["BENCH_SUBS"] ?? "100,1000,5000")
    .split(",")
    .map(int.parse)
    .toList();

const schema = '''
  type Query { items: [Item!]! }
  type Item {
    id: ID!, title: String!, description: String!, status: String!,
    tags: [String!]!, owner: Owner!
  }
  type Owner { id: ID!, name: String! }
''';
const query =
    'query Items { items { id title description status tags owner { id name } } }';

final results = <Map<String, Object>>[];

/// A timeout means subscribers never got notified: fail the benchmark loudly.
double ok(double? value) =>
    value ?? (throw StateError('timed out waiting for subscribers'));

void record(String name, String unit, num value) {
  print('${name.padRight(64)} ${value.toStringAsFixed(1).padLeft(14)} $unit');
  results.add({'name': name, 'unit': unit, 'value': value});
}

ShalomJsonValue payload(String titlePrefix) => shalomJsonValue({
  'items': List.generate(
    itemCount,
    (i) => {
      'id': '$i',
      'title': '$titlePrefix $i',
      'description': 'An incident with enough text to exercise decoding. $i',
      'status': 'OPEN',
      'tags': ['operations', 'region-${i % 20}', 'active'],
      'owner': {'id': 'owner-${i % 100}', 'name': 'Owner ${i % 100}'},
    },
  ),
});

/// Tracks data events delivered to all subscribers.
class Subscribers {
  final runtime.RuntimeHandle handle;
  final List<StreamSubscription<runtime.SubscriptionEvent>> streams = [];
  final List<BigInt> ids = [];
  int events = 0;
  Completer<void>? _waiter;
  int _target = 0;

  Subscribers(this.handle);

  Future<void> open(int n) async {
    for (var i = 0; i < n; i++) {
      final id = await runtime.request(
        handle: handle,
        name: 'Items',
        executionPolicy: runtime.ExecutionPolicyInput.cacheFirst,
        retryDelay: const runtime.RetryDelayInput.disabled(),
      );
      ids.add(id);
      streams.add(
        runtime.listenSubscription(handle: handle, subscriptionId: id).listen((
          e,
        ) {
          if (e is runtime.SubscriptionEvent_Data) {
            events++;
            if (events >= _target && _waiter != null && !_waiter!.isCompleted) {
              _waiter!.complete();
            }
          }
        }),
      );
    }
  }

  /// Time until [count] further data events arrived, or null on timeout.
  Future<double?> timeUntil(int count, Future<void> Function() trigger) async {
    _target = events + count;
    _waiter = Completer<void>();
    final watch = Stopwatch()..start();
    await trigger();
    try {
      await _waiter!.future.timeout(
        Duration(
          seconds: int.parse(Platform.environment["BENCH_TIMEOUT"] ?? "120"),
        ),
      );
    } on TimeoutException {
      return null;
    }
    return watch.elapsedMicroseconds * 1000.0;
  }

  Future<void> close() async {
    for (final id in ids) {
      await runtime.unsubscribe(handle: handle, subscriptionId: id);
    }
    for (final s in streams) {
      await s.cancel();
    }
  }
}

runtime.RuntimeHandle newRuntime() {
  final handle = runtime.initRuntime(schemaSdl: schema);
  runtime.registerOperation(handle: handle, document: query);
  // Requests are never answered: only cache writes drive the subscribers.
  runtime.listenRequests(handle: handle).listen((_) {});
  return handle;
}

Future<void> main(List<String> args) async {
  await ShalomRuntimeClient.initFlutterRustBridge(nativeLibPath: args.first);
  final out = args.length > 1 ? args[1] : 'dart-bench-results.json';

  for (final n in subscriberCounts) {
    final label = '$n subscribers, $itemCount-item query';
    final handle = newRuntime();
    final rssBefore = ProcessInfo.currentRss;
    final subs = Subscribers(handle);

    // 1. Empty cache: the first write populates it and notifies everyone.
    await subs.open(n);
    final empty = await subs.timeUntil(
      n,
      () => runtime.writeOperation(
        handle: handle,
        name: 'Items',
        data: payload('Item'),
      ),
    );
    record('dart / empty cache -> filled, $label / time', 'ns', ok(empty));

    // 2. Full cache, identical data: nothing changed, nobody should be notified.
    final before = subs.events;
    final watch = Stopwatch()..start();
    await runtime.writeOperation(
      handle: handle,
      name: 'Items',
      data: payload('Item'),
    );
    final sameWrite = watch.elapsedMicroseconds * 1000.0;
    await Future<void>.delayed(const Duration(milliseconds: 200));
    record(
      'dart / full cache, identical write, $label / time',
      'ns',
      sameWrite,
    );
    record(
      'dart / full cache, identical write, $label / spurious notifications',
      'count',
      subs.events - before,
    );

    // 3. Full cache, changed data: every subscriber is notified.
    final changed = await subs.timeUntil(
      n,
      () => runtime.writeOperation(
        handle: handle,
        name: 'Items',
        data: payload('Updated'),
      ),
    );
    record(
      'dart / full cache, changed write, $label / time',
      'ns',
      ok(changed),
    );

    // 4. Subscribing to an already full cache.
    final late = Subscribers(handle);
    final subscribe = await late.timeUntil(n, () => late.open(n));
    record(
      'dart / subscribe to full cache, $label / time',
      'ns',
      ok(subscribe),
    );

    record(
      'dart / process RSS growth, $label / rss',
      'rss',
      ProcessInfo.currentRss - rssBefore,
    );

    await late.close();
    await subs.close();
    handle.dispose();
  }

  File(out)
      .writeAsStringSync(const JsonEncoder.withIndent('  ').convert(results));
  print('wrote $out');
  RustLib.dispose();
  exit(0);
}
