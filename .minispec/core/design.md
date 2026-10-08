# Design

Visual language of the panel. Tokens live in `lib/teuton/panel/public/css/style.css`; use them, don't add new colours or fonts without updating this file.

## Direction

An elegant educational app for adults: warm, lively, motivating, with clear progress cues. Not minimalist or austere, not childish or gamified. Avoid generated-design clichés (cream + terracotta, black + acid green, identical card grids).

## Palette

- Ink `--ink #1f2a44` (text, top bar, projector background); soft ink `--ink-soft #4a5571` (secondary text).
- Lagoon `--lagoon #0f7c80` (primary actions, hero); dark `#0b5f62`; wash `#e3f2f1`.
- Sunflower `--sun #f2b33d` (accent, focus ring, code display); wash `#fdf1d8`.
- Paper `--paper #f4f6fa` (page), card `#ffffff`, line `#dde3ec`.
- Meaning (text colour / wash): pass leaf `#237a47 / #e2f3e8`, fail coral `#b8392f / #fbe6e3`, pending amber `#8a5a00 / #fcefd2`, connection error plum `#7a3fa0 / #f1e7f8`, disabled slate `#5b6578 / #eceff4`.
- Grades and states share three bands: 100 leaf "Complete", 50–99 lagoon "Passed", < 50 coral "Needs work" (`grade_class`, `state_key`). Sunflower is never a grade colour, so it cannot be read as "pending" (amber).
- Text on lagoon is white; text on sunflower is ink. Keep 4.5:1 contrast.

## Typography

- Body: Atkinson Hyperlegible 400/700 (+ italic), designed for legibility; 17 px base, line-height 1.55.
- Titles: Bricolage Grotesque 600/800.
- Commands and codes: JetBrains Mono 400.
- All three are OFL woff2 files in `public/fonts/` with their licenses; fallbacks `Segoe UI`, `system-ui`, `Consolas`.
- Sentence case everywhere; no all-caps labels.

## Components

- Logo: the Teuton knight stepping out of a browser window (variation of the Teuton logo, made with Codex from it). Master `public/img/logo.svg` (traced from the PNG; also `docs/assets/images/logo/teuton-panel.svg`), PNG only for the favicon fallback and the touch icon. Favicon, top bar (on a white plate with a sunflower ring), student hero and projector header.
- Top bar (ink): logo, area pill, nav (one current tab, `aria-current`; teacher entries grouped as Prepare · Class · Sessions/Settings with small labels), EN/ES/CA switch.
- Page head: `h1` + muted subtitle, actions on the right.
- Card (`.card`, `.card.featured` with a lagoon top border); `.grid` auto-fit columns.
- Student hero (lagoon block with a sunflower circle and the logo) and numbered `.steps` (register → run → results: a real sequence).
- Buttons: `.btn` (lagoon), `.secondary` (outline), `.danger` (coral outline), `.small`.
- Forms: label above, 1.5 px border, 10 px radius, sunflower focus ring; errors in coral under the field.
- `.notice` (info, success, warn, error) and `.empty` states with an icon and one helpful sentence.
- `.grade` bar + value; `.badge` with a dot for states; `.score-big` for a student's own grade.
- `.summary`: four class figures (average, passed, complete, not evaluated) on the teacher home, Results and the projector (`.dark`); disabled students are left out.
- `.code-display` (big mono code on sunflower wash) after registration; `pre.cmd` (ink) for curl commands; `pre.log` for Teuton output.
- Icons: inline SVG, 1.8 stroke, `currentColor` (`icon(name)` helper). No icon fonts or CDNs.

## Projector mode

- `?projector=1` on `/teacher/results`: ink background, no top bar, test name and student URLs, tiles (`.tiles`) with name, big grade and state; left border coloured by grade or state.
- Fits ~30 students on a 1080p screen; refreshes every 10 s; no motion.

## Rules

- Nothing from the internet: fonts, icons and CSS are served by the panel (ADR-003).
- A page with a form never reloads itself; its live part goes in an iframe with the bare `frame.erb` layout (e.g. `/teacher/run/status`).
- Auto-refreshing pages use `<meta http-equiv="refresh">`; no entrance or scroll animations. Only the grade bar width and button colours transition, and only without `prefers-reduced-motion`.
- Every student page must still make sense in lynx (plain HTML, labels, no JS needed).
- Plain CSS, no framework, no build step.
