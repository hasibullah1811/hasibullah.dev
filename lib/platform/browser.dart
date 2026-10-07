// The few browser APIs the app touches directly. Off the web (tests, and any
// future native build) these fall back to doing nothing.
export 'browser_stub.dart' if (dart.library.js_interop) 'browser_web.dart';
