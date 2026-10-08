# Design

Visual language of the panel. Tokens live in `lib/teuton/panel/public/css/style.css`; use them, don't add new colours or fonts without updating this file.

## Direction

An elegant educational app for adults: warm, lively, motivating, with clear progress cues. Not minimalist or austere, not childish or gamified. Avoid generated-design clichés (cream + terracotta, black + acid green, identical card grids).

## Palette

Taken from the Teuton logo (green shield, grey-green helm, steel tunic), toned down for long reading.

- Ink `--ink #1c1f23` (text, top bar, hero, projector background); soft ink `--ink-soft #5b5760` (secondary text).
- Green `--green #15803d` (primary actions, links, featured cards); dark `#0f6b30`; wash `#e6f4ea`.
- Brand `--brand #03c22c` (Teuton green): accents on ink only (current language, focus ring, prompt, projector URLs). Never under white text (contrast 2.4).
- Sage `--sage #a3b5a8` (helm), dark `#6f8f7a`, wash `#eef2ef`; steel `#646067`.
- Paper `--paper #f4f6f4` (page), card `#ffffff`, line `#dde3de`.
- Meaning (text colour / wash): complete leaf `#17692e / #e3f3e7`, passed sage `#4d6b57 / #eef2ef`, fail coral `#b8392f / #fbe6e3`, pending amber `#8a5a00 / #fcefd2`, connection error plum `#7a3fa0 / #f1e7f8`, disabled slate `#5f6366 / #eceeed`.
- Grades and states share three bands: 100 green "Complete", 50–99 sage "Passed", < 50 coral "Needs work" (`grade_class`, `state_key`): the greener, the better.
- Text on green and on ink is white. Keep 4.5:1 contrast.

## Typography

- Body: Atkinson Hyperlegible 400/700 (+ italic), designed for legibility; 17 px base, line-height 1.55.
- Titles: Bricolage Grotesque 600/800.
- Commands and codes: JetBrains Mono 400.
- All three are OFL woff2 files in `public/fonts/` with their licenses; fallbacks `Segoe UI`, `system-ui`, `Consolas`.
- Sentence case everywhere; no all-caps labels.

## Components

- Logo: three stacked panels (steel, sage, Teuton green) with a white T on the front one. Master `public/img/logo.svg` (also `docs/assets/images/logo/teuton-panel.svg`); PNG only for the favicon fallback and the touch icon. Favicon, top bar, student hero and projector header.
- Top bar (ink): logo, area pill, nav (one current tab, `aria-current`; teacher entries grouped as Prepare · Class · Sessions/Settings with small labels), EN/ES/CA switch.
- Page head: `h1` + muted subtitle, actions on the right.
- Card (`.card`, `.card.featured` with a lagoon top border); `.grid` auto-fit columns.
- Student hero (ink block with a green-wash circle and the logo) and numbered `.steps` (register → run → results: a real sequence).
- Buttons: `.btn` (lagoon), `.secondary` (outline), `.danger` (coral outline), `.small`.
- Forms: label above, 1.5 px border, 10 px radius, sunflower focus ring; errors in coral under the field.
- `.notice` (info, success, warn, error) and `.empty` states with an icon and one helpful sentence.
- `.grade` bar + value; `.badge` with a dot for states; `.score-big` for a student's own grade.
- `.summary`: four class figures (average, passed, complete, not evaluated) on the teacher home, Results and the projector (`.dark`); disabled students are left out.
- `.code-display` (big mono code on green wash, dashed green border) after registration; `pre.cmd` (ink) for curl commands; `pre.log` for Teuton output.
- Icons: inline SVG, 1.8 stroke, `currentColor` (`icon(name)` helper). No icon fonts or CDNs.

## Projector mode

- `?projector=1` on `/teacher/results`: ink background, no top bar, test name and student URLs, tiles (`.tiles`) with name, big grade and state; left border coloured by grade or state.
- Fits ~30 students on a 1080p screen; refreshes every 10 s; no motion.

## Rules

- Nothing from the internet: fonts, icons and CSS are served by the panel (ADR-003).
- A page with a form never reloads itself; its live part goes in an iframe with the bare `frame.erb` layout (e.g. `/teacher/run/status`).
- Auto-refreshing pages use `<meta http-equiv="refresh">`; no entrance or scroll animations. Only the grade bar width and button colours transition, and only without `prefers-reduced-motion`.
- Every student page must still make sense in lynx (plain HTML, labels, no JS needed).
- Teacher pages may add a few lines of inline JavaScript as an optional shortcut (the run picker's select-all box and counter); the page must work the same without it (ADR-003).
- Plain CSS, no framework, no build step.
