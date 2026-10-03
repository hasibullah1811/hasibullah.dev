# Build and deploy

## How it works

```
push / PR ──► GitHub Actions (.github/workflows/ci.yml)
          │     format check → analyze → test → wasm build      (status check only)
          │
          └─► Vercel (Git integration, project md-hasibullah-hasibs-projects/hasibullah-dev)
                install: scripts/vercel-install.sh   clone pinned Flutter, pub get
                build:   scripts/vercel-build.sh     analyze → test → flutter build web --wasm
                output:  build/web
                any branch → preview deploy; main → production (www.hasibullah.dev)
```

- **The Flutter version is pinned in one place:** `pubspec.yaml` → `environment: flutter:`.
  CI reads it with `flutter-version-file`, and the Vercel scripts read it with `sed`.
  To upgrade Flutter, change that one line.
- **Build settings live in `vercel.json`**, which overrides whatever the Vercel
  dashboard says, so the pipeline is versioned with the code.
- **A failing test or lint now stops the Vercel deploy.** The scripts run
  `flutter analyze` and `flutter test` before building.
- **Headers:** COOP `same-origin` and COEP `credentialless` make the page
  cross-origin isolated, so the skwasm renderer can use multiple threads. This works
  because the site loads nothing cross-origin (fonts and images are bundled).
  **If you ever embed a third-party script, iframe or image, check it still loads.**
- There is no catch-all rewrite: the site is one page, so unknown paths return a real 404.

## What it was before (audited 2026-10-03)

- There was no CI, and the build command existed only in the Vercel dashboard (not in git).
- Tests did not run on deploy: commit `8d813bb` deployed successfully although
  `flutter test` failed at that commit.
- Flutter was unpinned. Production was built with 3.47.2 while local was 3.47.4.
- `vercel.json` only had an SPA catch-all, so missing files returned the homepage with a 200 status.

## Known follow-ups (dashboard, not code)

- `hasibullah.dev` 307-redirects to `www.hasibullah.dev`. Make it a permanent (308)
  redirect in Vercel → Domains. The canonical URL is `https://www.hasibullah.dev/`.
- Optional: add branch protection on `main` requiring the `CI / check` status.
- The original resume (with phone number and Gmail address) is still in git history
  (`772d8ee`, `08e446b`, `ec2dbd9`) and in old Vercel deployment URLs. Removing it from
  history needs a force-push to a public repo, so that decision is yours.

## Local commands

```bash
flutter test                                  # content + layout tests
flutter run -d chrome                         # dev
flutter build web --release --wasm            # what Vercel builds
FLUTTER_DIR="$(dirname "$(dirname "$(which flutter)")")" bash scripts/vercel-build.sh
```
