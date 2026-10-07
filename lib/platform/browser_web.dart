import 'package:web/web.dart' as web;

// Shared with the inline script in web/index.html, which applies the stored
// choice before Flutter starts.
const _key = 'theme';

String? readStoredTheme() {
  try {
    final value = web.window.localStorage.getItem(_key);
    return value == 'light' || value == 'dark' ? value : null;
  } catch (_) {
    // Storage blocked (private mode, disabled cookies): follow the system.
    return null;
  }
}

void storeTheme(String value) {
  try {
    web.window.localStorage.setItem(_key, value);
  } catch (_) {
    // Not remembered across visits, but the switch still works.
  }
}

void applyDocumentTheme({required bool dark, required int paper}) {
  final hex = '#${(paper & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';
  final root = web.document.documentElement as web.HTMLElement?;
  root?.setAttribute('data-theme', dark ? 'dark' : 'light');
  root?.style.backgroundColor = hex;
  web.document.body?.style.backgroundColor = hex;
  web.document
      .querySelector('meta[name="theme-color"]')
      ?.setAttribute('content', hex);
}

bool get isLowEndDevice {
  try {
    final cores = web.window.navigator.hardwareConcurrency;
    return cores > 0 && cores <= 4;
  } catch (_) {
    return false;
  }
}
