/// The visitor's stored theme choice, 'light' or 'dark', or null to follow
/// the system.
String? readStoredTheme() => null;

void storeTheme(String value) {}

/// Points the page background, `<html data-theme>` and the theme-color
/// meta tag at [paper], so browser chrome and overscroll match the app.
void applyDocumentTheme({required bool dark, required int paper}) {}

/// Fewer than five logical cores: capture the screen at a lower resolution.
bool get isLowEndDevice => false;
