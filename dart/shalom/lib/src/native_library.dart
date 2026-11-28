/// Opens the native `shalom_ffi` library from an explicit path. Browsers load
/// the WebAssembly package instead, so a path has no meaning there.
library;

export 'native_library_io.dart'
    if (dart.library.js_interop) 'native_library_web.dart';
