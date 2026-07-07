import 'package:test/test.dart';

import '__graphql__/StreamableSystemFrag.shalom.dart';

void main() {
  test(
      'concrete type does not inherit sibling-only fields from an interface '
      'fragment spread through a concrete-type fragment', () {
    // OnvifCamera does not have `vendor` (it is Nvr-only, selected via
    // `... on Nvr` inside HasConnectionInfoFrag) so decoding valid
    // OnvifCamera data must succeed without it.
    final data = StreamableSystemFrag.fromJson({
      '__typename': 'OnvifCamera',
      'id': 'onvif-1',
      'connectionInfo': {'hostname': 'localhost'},
    });

    final onvif = data as StreamableSystemFrag__OnvifCamera;
    expect(onvif.id, 'onvif-1');
    expect(onvif.connectionInfo.hostname, 'localhost');
  });

  test('Nvr still gets vendor from the interface fragment type condition', () {
    final data = StreamableSystemFrag.fromJson({
      '__typename': 'Nvr',
      'id': 'nvr-1',
      'connectionInfo': {'hostname': 'localhost'},
      'vendor': 'MILESIGHT',
    });

    final nvr = data as StreamableSystemFrag__Nvr;
    expect(nvr.id, 'nvr-1');
    expect(nvr.connectionInfo.hostname, 'localhost');
    expect(nvr.vendor.name, 'MILESIGHT');
  });
}
