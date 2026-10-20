import 'dart:convert';

import 'package:shalom/shalom.dart';
import 'package:shalom/src/rust/api/runtime.dart' as runtime;
import 'package:shalom/src/rust/api/ws.dart' as ws;

// Run against a release native library, preferably as a compiled Dart executable.
// Pass the absolute library path as the first argument.
Future<void> main(List<String> args) async {
  await ShalomRuntimeClient.initFlutterRustBridge(nativeLibPath: args.single);
  for (final count in [1000, 4000, 10000]) {
    final handle = runtime.initRuntime(
      schemaSdl: '''
        type Query { items: [Item!]! }
        type Item {
          id: ID!, title: String!, description: String!, status: String!,
          timestamp: String!, tags: [String!]!, owner: Owner!
        }
        type Owner { id: ID!, name: String! }
      ''',
    );
    runtime.registerOperation(
      handle: handle,
      document: '''
        query Items {
          items { id title description status timestamp tags owner { id name } }
        }
      ''',
    );
    final value = shalomJsonValue({
      'items': List.generate(
        count,
        (i) => {
          'id': '$i',
          'title': 'Item $i – שלום',
          'description':
              'An incident with enough text to exercise string decoding. $i',
          'status': 'OPEN',
          'timestamp': '2026-10-20T12:00:00.000Z',
          'tags': ['operations', 'region-${i % 20}', 'active'],
          'owner': {'id': 'owner-${i % 100}', 'name': 'Owner ${i % 100}'},
        },
      ),
    });
    final writes = <int>[];
    final encodes = <int>[];
    final reads = <int>[];
    for (var iteration = 0; iteration < 8; iteration++) {
      final watch = Stopwatch()..start();
      final pending = runtime.writeOperation(
        handle: handle,
        name: 'Items',
        data: value,
      );
      final encodeMicros = watch.elapsedMicroseconds;
      await pending;
      final writeMicros = watch.elapsedMicroseconds;
      watch.reset();
      final result = await runtime.readOperation(handle: handle, name: 'Items');
      final readMicros = watch.elapsedMicroseconds;
      if (result!.field('items')!.listValue.length != count) {
        throw StateError('Incomplete result');
      }
      if (iteration >= 3) {
        encodes.add(encodeMicros);
        writes.add(writeMicros);
        reads.add(readMicros);
      }
    }
    String median(List<int> values) {
      values.sort();
      return (values[values.length ~/ 2] / 1000).toStringAsFixed(2);
    }

    print(
      '$count items: encode=${median(encodes)} ms, '
      'write=${median(writes)} ms, read=${median(reads)} ms',
    );
    final socket = ws.createWsSansIo();
    ws.wsOnMessage(sansio: socket, raw: '{"type":"connection_ack"}');
    ws.wsSubscribeFrame(
      sansio: socket,
      opId: 'bench',
      query: 'query Items { items { id } }',
    );
    final frame = jsonEncode({
      'id': 'bench',
      'type': 'next',
      'payload': {'data': value.toJsonValue()},
    });
    // No pending runtime request: the payload is dropped after handoff. This
    // measures protocol parsing and bridge transfer, excluding normalization.
    final handoffs = <int>[];
    final synchronous = <int>[];
    for (var iteration = 0; iteration < 8; iteration++) {
      final watch = Stopwatch()..start();
      final event =
          ws.wsOnMessage(sansio: socket, raw: frame).single
              as ws.WsLinkEvent_OperationResponse;
      final pending = runtime.pushBufferedResponse(
        handle: handle,
        requestId: BigInt.zero,
        response: event.response,
      );
      final syncMicros = watch.elapsedMicroseconds;
      await pending;
      if (iteration >= 3) {
        handoffs.add(watch.elapsedMicroseconds);
        synchronous.add(syncMicros);
      }
    }
    print(
      '  WS buffered: handoff=${median(handoffs)} ms, '
      'synchronous=${median(synchronous)} ms',
    );
    socket.dispose();
    handle.dispose();
  }
  RustLib.dispose();
}
