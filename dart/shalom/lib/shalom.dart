

import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart' show ExternalLibrary;
import 'package:shalom/src/rust/frb_generated.dart' as rs;

import 'src/shalom_core_base.dart';

export 'src/rust/api/simple.dart';
export 'src/rust/frb_generated.dart' show RustLib;
export 'src/runtime_client.dart';

export 'src/shalom_core_base.dart';
export 'src/scalar.dart';

export 'src/transport/http_link.dart'
    show HttpLink, HttpMethod, ShalomHttpTransport;
export 'src/transport/link.dart' show GraphQLLink, ShalomClient, HeadersType;
export 'src/transport/ws_link.dart' show WebSocketLink;
export 'src/transport/ws_transport.dart' show WebSocketTransport, MessageSender;
export 'src/transport/web_socket_transport.dart' show WebSocketPackageTransport;
export 'src/rust/api/ws.dart' show WsSansIo;
export 'src/runtime_cache.dart'
    show RuntimeSubscriptionClient, collectRuntimeRefs;



Future<void> init(String nativeLibPath) async {
    await rs.RustLib.init(
      externalLibrary: ExternalLibrary.open(nativeLibPath),
    );

}