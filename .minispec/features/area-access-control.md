# Area access control

## Goal

Split the app into a localhost-only teacher area and a LAN student area with per-feature switches (ADR-001).

## Context

- `App` has a single `/` route open to everyone on `0.0.0.0:4567`.
- Every later feature adds routes to one of the two areas.

## Changes

- Route prefixes as in `conventions.md`: teacher under `/teacher/...`, student routes at the root.
- `before "/teacher*"` filter: only `127.0.0.1` / `::1`, otherwise 403 with a translated page (`gui-i18n`).
- Student switches in `teuton-panel.yaml` (`:student: {:register:, :list:, :run:, :results:, :feedback:, :readme:}`); a disabled feature answers 403 with a translated message.
- Helper to get the student's identity (`request.ip`).
- Format negotiation: HTML when `Accept` includes `text/html`, plain text otherwise, so every student route is usable from `curl`.
- Make bind address and port configurable in `teuton-panel.yaml`.

## Acceptance

- From another machine, `/teacher` returns 403; from localhost it works.
- Turning off a student switch disables that route immediately (no restart if feasible).
- `curl http://<panel>/…` on a student route returns readable plain text.
- Rack::Test tests cover loopback vs remote IP for both areas.
