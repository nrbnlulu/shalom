import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart'
    show ExternalLibrary;

/// `null` lets `flutter_rust_bridge` locate the library bundled with the app.
ExternalLibrary? openNativeLibrary(String? path) =>
    path != null ? ExternalLibrary.open(path) : null;
