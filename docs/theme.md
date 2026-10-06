# Theme

Colours live in one place: `AppColors.light` and `AppColors.dark` in
`lib/theme.dart`, a `ThemeExtension`. Widgets read them with
`AppColors.of(context)` and text styles with `AppText.of(context)`; no widget
hard-codes a colour. `web/index.html` repeats the values as CSS variables for
the loading state (`test/theme_test.dart` checks they match).

## Palette

| Token        | Light     | Dark      | Used for                         |
|--------------|-----------|-----------|----------------------------------|
| paper        | `#FFFFFF` | `#171412` | page background, theme-color     |
| surface      | `#FFFFFF` | `#201C19` | cards, panels, outlined buttons  |
| tint         | `#F6F4F1` | `#2A2521` | tags                             |
| ink          | `#1B1916` | `#F3EEE7` | headings, filled buttons         |
| inkSoft      | `#45413A` | `#D3CBC0` | body text                        |
| muted        | `#615B52` | `#ABA296` | labels, dates                    |
| line         | `#E8E6E1` | `#332D29` | card borders                     |
| lineStrong   | `#D6D2CA` | `#4A423B` | hover borders, journey track     |
| accent       | `#A63F25` | `#E8957A` | eyebrows, links, journey route   |
| accentSoft   | `#FBEFEA` | `#38251E` | contact panel, status chips      |
| available    | `#277046` | `#7CC79A` | availability line                |

Dark cards lift with a stronger border and no shadow.

## Contrast (WCAG 2.x)

Lowest ratio for each text colour across paper, surface, tint, accentSoft and
paper under the strongest background symbol (ink at 8%):

| Text      | Light (min) | Dark (min) |
|-----------|-------------|------------|
| ink       | 14.97:1     | 12.53:1    |
| inkSoft   | 8.66:1      | 9.01:1     |
| muted     | 5.73:1      | 5.75:1     |
| accent    | 5.34:1      | 6.21:1     |
| available | 5.13:1      | 7.23:1     |

Filled buttons (paper on ink): 17.54:1 light, 15.89:1 dark. Every pair clears
AA (4.5:1) for body text.

## Choosing a theme

- First visit: follows `prefers-color-scheme`, and keeps following it.
- The toggle stores `light` or `dark` in `localStorage["theme"]`
  (`lib/platform/browser_web.dart`). The inline script at the top of
  `web/index.html` reads the same key before anything paints, so the loader,
  page background and `<meta name="theme-color">` start in the right theme.
- Storage blocked (private mode): the toggle still works for the visit.

## The sunset transition

`lib/ui/theme_transition.dart`. On toggle the page is captured with
`RenderRepaintBoundary.toImageSync` (pixel ratio capped at 2, or 1 when the
browser reports four cores or fewer), shown on top, and the theme switches
underneath in the same frame. A circle then grows from the toggle over 800ms
(easeInOutCubic) with a thin dusk (or dawn) ring on its edge; going dark, the
stars fade in over the last 300ms. The screenshot is disposed when it ends.

Reduced motion, or a failed capture, gets a 250ms crossfade instead. Nothing
plays on first load or when the system theme changes.

Theme changes must not start implicit animations across the page (for
example an `AnimatedContainer` whose colour comes from the theme): the switch
happens under the screenshot, so they are invisible, but dozens of them at
once cost frames during the reveal.
