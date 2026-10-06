# Visual design guide

## Goal

Write `.minispec/core/design.md`: the panel's visual language (palette, typography, components, projector rules), before the first real view is built.

## Context

- No views exist yet; every later feature adds ERB views (teacher pages, projector dashboard, student pages, `.txt` answers).
- Direction: an elegant educational app for adults. Warm, lively and motivating, with personality and clear progress cues; not austere or minimalist, and not childish or gamified like a kids' app.
- Design skills installed: `frontend-design` (direction and critique), `web-design-guidelines` (review), `accessibility` (WCAG).
- Constraints: plain CSS, no framework, no CDN (ADR-003); the classroom LAN may have no internet, so fonts are woff2 files served from `public/`; pages must work in lynx; the dashboard is read from the back of a classroom and refreshes every few seconds; GUI in English and Spanish.

## Changes

- Build the direction with `frontend-design` (design plan first: palette, type, layout, principles; then review it against the brief):
  - Palette: a confident, warm palette with real colour (not monochrome), plus semantic colours for pass / fail / pending / disabled / connection error, checked for 4.5:1 contrast on the projector.
  - Typography: one or two OFL families as woff2 in `lib/teuton/panel/public/fonts/` (with their license files), plus a system fallback stack; type scale for normal pages and a larger one for projector mode.
  - Components: page layout and navigation (teacher / student), grade table, student status badge, forms (registration, settings, params editor), notices and errors, empty states, the code display after registration, `<kbd>`-style `curl` commands.
  - Encouraging details: progress and grade visuals that read at a glance, friendly empty states and messages (translated), small moments of delight on student actions (registration done, run finished) without blocking anything.
  - Projector mode: density to fit ~30 students without scrolling, large grade figures, no motion.
- Rules to record in the guide: no external images, fonts or icon CDNs; no scroll-entry or staggered animations on auto-refreshing pages; `prefers-reduced-motion` respected everywhere; icons as inline SVG; plain CSS.
- Write `design.md` (≤ 100 lines) as CSS custom properties plus short rules; add a minimal `public/css/style.css` with those tokens.
- Review a sample page with `web-design-guidelines` and `accessibility`.

## Acceptance

- `design.md` exists, ≤ 100 lines, with tokens, components and projector rules.
- `style.css` defines the tokens; fonts load from `public/` with no network request outside the panel.
- A sample teacher page and the dashboard in projector mode pass a `web-design-guidelines` review and a WCAG contrast check.
