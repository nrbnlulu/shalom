import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ferry_cache/ferry_cache.dart';
import 'package:ferry_exec/ferry_exec.dart';
import 'package:gql/language.dart';
import 'package:gql_exec/gql_exec.dart';
import 'package:shalom/shalom.dart';
import 'package:shalom/src/rust/api/runtime.dart' as runtime;

// Shalom vs Ferry normalized cache benchmark.
//
//   dart compile exe bin/bench.dart -o /tmp/ferry-vs-shalom
//   /tmp/ferry-vs-shalom <libshalom_ffi.so> [results.json]
//
// Both clients get the same schema, query and payload. Network is excluded:
// only cache write / read / watch behaviour is measured.

const schema = '''
  type Query { items: [Item!]! }
  type Item {
    id: ID!, title: String!, description: String!, status: String!,
    timestamp: String!, tags: [String!]!, owner: Owner!
  }
  type Owner { id: ID!, name: String! }
''';
const query = '''
  query Items {
    items { id title description status timestamp tags owner { id name } }
  }
''';

// Ferry needs tens of seconds per write at 10k items, so large sizes get fewer
// samples.
int warmup = 3;
int iterations = 11;
final sizes = (Platform.environment['BENCH_SIZES'] ?? '1000,4000,10000')
    .split(',')
    .map(int.parse)
    .toList();
final subscriberCounts = (Platform.environment['BENCH_SUBS'] ?? '10,50,100')
    .split(',')
    .map(int.parse)
    .toList();
const subscriberItems = 200;

final results = <Map<String, Object>>[];

Map<String, dynamic> payload(int count, String titlePrefix) => {
  '__typename': 'Query',
  'items': List.generate(
    count,
    (i) => {
      '__typename': 'Item',
      'id': '$i',
      'title': '$titlePrefix $i',
      'description': 'An incident with enough text to exercise decoding. $i',
      'status': 'OPEN',
      'timestamp': '2026-10-20T12:00:00.000Z',
      'tags': ['operations', 'region-${i % 20}', 'active'],
      'owner': {
        '__typename': 'Owner',
        'id': 'owner-${i % 100}',
        'name': 'Owner ${i % 100}',
      },
    },
  ),
};

double medianMs(List<double> values) {
  final sorted = [...values]..sort();
  return sorted[sorted.length ~/ 2];
}

double median(List<int> micros) =>
    medianMs([for (final m in micros) m / 1000]);

void record(String name, double value, {String unit = 'ms'}) {
  print('${name.padRight(58)} ${value.toStringAsFixed(2).padLeft(10)} $unit');
  results.add({'name': name, 'unit': unit, 'value': value});
}

/// Runs [body] and returns the median elapsed time in ms. [setup] is untimed.
Future<double> measure(
  Future<void> Function() setup,
  Future<void> Function() body,
) async {
  final samples = <int>[];
  for (var i = 0; i < warmup + iterations; i++) {
    await setup();
    final watch = Stopwatch()..start();
    await body();
    if (i >= warmup) samples.add(watch.elapsedMicroseconds);
  }
  return median(samples);
}

// ---------------------------------------------------------------- Ferry

JsonOperationRequest ferryRequest() => JsonOperationRequest(
  operation: Operation(document: parseString(query), operationName: 'Items'),
  vars: const {},
  fetchPolicy: FetchPolicy.CacheFirst,
);

// ---------------------------------------------------------------- Shalom

runtime.RuntimeHandle shalomRuntime() {
  final handle = runtime.initRuntime(schemaSdl: schema);
  runtime.registerOperation(handle: handle, document: query);
  // Requests are never answered: only cache writes are measured.
  runtime.listenRequests(handle: handle).listen((_) {});
  return handle;
}

/// Like a mounted `@Query` widget: unobserved data is garbage collected by the
/// runtime's background sweep, so a realistic cache always has an observer.
Future<runtime.RuntimeHandle> observedShalomRuntime() async {
  final handle = shalomRuntime();
  final id = await runtime.request(
    handle: handle,
    name: 'Items',
    executionPolicy: runtime.ExecutionPolicyInput.cacheFirst,
    retryDelay: const runtime.RetryDelayInput.disabled(),
  );
  runtime.listenSubscription(handle: handle, subscriptionId: id).listen((_) {});
  return handle;
}

Future<void> shalomWrite(runtime.RuntimeHandle h, ShalomJsonValue data) =>
    runtime.writeOperation(handle: h, name: 'Items', data: data);

Future<void> sizeBenchmarks() async {
  for (final count in sizes) {
    final data = payload(count, 'Item');
    final shalomData = shalomJsonValue(data);
    final label = '$count items';
    warmup = count >= 10000 ? 1 : 3;
    iterations = count >= 10000 ? 3 : 11;

    // Ferry
    var cache = Cache();
    final request = ferryRequest();
    record(
      'ferry   / write, empty cache, $label',
      await measure(() async => cache = Cache(), () async {
        cache.writeQuery(request, data);
      }),
    );
    cache = Cache()..writeQuery(request, data);
    record(
      'ferry   / write, identical data, $label',
      await measure(() async {}, () async {
        cache.writeQuery(request, data);
      }),
    );
    record(
      'ferry   / read, full cache, $label',
      await measure(() async {}, () async {
        final result = cache.readQuery(request);
        if ((result!['items'] as List).length != count) throw StateError('x');
      }),
    );

    // Shalom
    var handle = await observedShalomRuntime();
    record(
      'shalom  / write, empty cache, $label',
      await measure(
        () async {
          handle.dispose();
          handle = await observedShalomRuntime();
        },
        () => shalomWrite(handle, shalomData),
      ),
    );
    record(
      'shalom  / write, identical data, $label',
      await measure(() async {}, () => shalomWrite(handle, shalomData)),
    );
    record(
      'shalom  / read, full cache, $label',
      await measure(() async {}, () async {
        final r = await runtime.readOperation(handle: handle, name: 'Items');
        if (r!.field('items')!.listValue.length != count) {
          throw StateError('x');
        }
      }),
    );
    handle.dispose();
    cache.store.clear();
  }
}

// Watchers: N watchers of one query. Every watcher tracks the title of the
// first item it last saw, so completion means "all N have the expected data"
// regardless of duplicate or coalesced emissions.

class Watchers {
  final String Function() label;
  final List<String?> latest;
  String _expected = '';
  Completer<void>? _done;

  Watchers(int n, this.label) : latest = List.filled(n, null);

  void onTitle(int watcher, String title) {
    latest[watcher] = title;
    if (_done != null && !_done!.isCompleted && latest.every(_matches)) {
      _done!.complete();
    }
  }

  bool _matches(String? title) => title == _expected;

  /// Time in ms until every watcher saw [expected], after running [trigger].
  Future<double> until(String expected, Future<void> Function() trigger) async {
    _expected = expected;
    _done = Completer<void>();
    final watch = Stopwatch()..start();
    await trigger();
    if (!latest.every(_matches)) {
      await _done!.future.timeout(
        const Duration(seconds: 60),
        onTimeout: () => throw StateError(
          '${label()}: ${latest.where(_matches).length}/${latest.length} '
          'watchers saw "$expected"',
        ),
      );
    }
    return watch.elapsedMicroseconds / 1000;
  }
}

Future<void> subscriberBenchmarks() async {
  final data = payload(subscriberItems, 'Item');
  final changed = payload(subscriberItems, 'Updated');
  final shalomChanged = shalomJsonValue(changed);
  final shalomData = shalomJsonValue(data);

  for (final n in subscriberCounts) {
    final label = '$n watchers, $subscriberItems-item query';

    // Ferry
    {
      final cache = Cache()..writeQuery(ferryRequest(), data);
      final watchers = Watchers(n, () => 'ferry $label');
      final subs = <StreamSubscription>[];
      final rssBefore = ProcessInfo.currentRss;
      record(
        'ferry   / subscribe to full cache, $label',
        await watchers.until('Item 0', () async {
          for (var i = 0; i < n; i++) {
            subs.add(
              cache.watchQuery(ferryRequest()).listen((d) {
                watchers.onTitle(i, (d!['items'] as List).first['title']);
              }),
            );
          }
        }),
      );
      // Let watchers attach to the store; Ferry misses writes that land
      // right after its first emission.
      await Future<void>.delayed(const Duration(milliseconds: 200));
      final samples = <double>[];
      for (var i = 0; i < 5; i++) {
        final title = i.isEven ? 'Updated 0' : 'Item 0';
        samples.add(
          await watchers.until(
            title,
            () async => cache.writeQuery(
              ferryRequest(),
              i.isEven ? changed : data,
            ),
          ),
        );
      }
      record('ferry   / changed write, $label', medianMs(samples));
      record(
        'ferry   / RSS growth, $label',
        (ProcessInfo.currentRss - rssBefore) / (1 << 20),
        unit: 'MiB',
      );
      for (final s in subs) {
        await s.cancel();
      }
    }

    // Shalom
    {
      final handle = shalomRuntime();
      await shalomWrite(handle, shalomData);
      final watchers = Watchers(n, () => 'shalom $label');
      final ids = <BigInt>[];
      final subs = <StreamSubscription>[];
      final rssBefore = ProcessInfo.currentRss;
      record(
        'shalom  / subscribe to full cache, $label',
        await watchers.until('Item 0', () async {
          for (var i = 0; i < n; i++) {
            final id = await runtime.request(
              handle: handle,
              name: 'Items',
              executionPolicy: runtime.ExecutionPolicyInput.cacheFirst,
              retryDelay: const runtime.RetryDelayInput.disabled(),
            );
            ids.add(id);
            subs.add(
              runtime
                  .listenSubscription(handle: handle, subscriptionId: id)
                  .listen((e) {
                    if (e is runtime.SubscriptionEvent_Data) {
                      watchers.onTitle(
                        i,
                        e.data
                            .field('items')!
                            .listValue
                            .first
                            .field('title')!
                            .stringValue,
                      );
                    }
                  }),
            );
          }
        }),
      );
      // Let watchers attach to the store; Ferry misses writes that land
      // right after its first emission.
      await Future<void>.delayed(const Duration(milliseconds: 200));
      final samples = <double>[];
      for (var i = 0; i < 5; i++) {
        final title = i.isEven ? 'Updated 0' : 'Item 0';
        samples.add(
          await watchers.until(
            title,
            () => shalomWrite(handle, i.isEven ? shalomChanged : shalomData),
          ),
        );
      }
      record('shalom  / changed write, $label', medianMs(samples));
      record(
        'shalom  / RSS growth, $label',
        (ProcessInfo.currentRss - rssBefore) / (1 << 20),
        unit: 'MiB',
      );
      for (final id in ids) {
        await runtime.unsubscribe(handle: handle, subscriptionId: id);
      }
      for (final s in subs) {
        await s.cancel();
      }
      handle.dispose();
    }
  }
}

Future<void> main(List<String> args) async {
  await ShalomRuntimeClient.initFlutterRustBridge(nativeLibPath: args.first);
  final out = args.length > 1 ? args[1] : 'results.json';
  if (Platform.environment['BENCH_SKIP_SIZES'] == null) await sizeBenchmarks();
  await subscriberBenchmarks();
  File(out).writeAsStringSync(
    const JsonEncoder.withIndent('  ').convert(results),
  );
  print('wrote $out');
  exit(0);
}
