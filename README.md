# hasibullah.dev

Portfolio of Hasibullah Hasib, Software Developer. Built with Flutter web and
deployed on Vercel.

Live: https://www.hasibullah.dev/

## Editing content

All copy lives in **`lib/content/portfolio_content.dart`**: profile, journey,
case studies, projects, skills and credentials. It is plain data, so no UI
code needs to change. `docs/facts.md` is the human-readable source of truth
the content must match.

A few things also appear in `web/index.html` (the loading state, meta tags and
structured data), so crawlers and slow connections see real content before
Flutter loads. `test/content_test.dart` fails if the title, location, work
rights or links drift between the two.

To show the CV button, put the redacted PDF at `web/cv/Hasibullah_Hasib_CV.pdf`
and set `cvUrl: 'cv/Hasibullah_Hasib_CV.pdf'` in the profile.

## Structure

```
lib/
  content/      models.dart, portfolio_content.dart   ← edit here
  theme.dart    colours, type scale, button styles
  ui/           page shell, sections, shared widgets
web/            index.html (loading state + SEO), icons, OG image, architecture diagrams
assets/         bundled fonts (Latin subsets) and the StepWise screenshot
scripts/        Vercel install/build (pinned Flutter)
docs/           facts.md, deploy.md
```

## Development

```bash
flutter pub get
flutter run -d chrome
flutter test
flutter build web --release --wasm
```

The Flutter version is pinned in `pubspec.yaml`. See `docs/deploy.md` for the
CI and Vercel pipeline.

## Credits

Fonts: Geist, Geist Mono and Source Serif 4, all under the SIL Open Font
License 1.1. Bundled as Latin subsets.
Icons: LinkedIn, GitHub and LeetCode marks from Simple Icons (CC0).
