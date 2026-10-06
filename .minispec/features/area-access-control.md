# Area access control

## Goal

Split the app into a teacher area (localhost plus allowed teacher IPs) and a LAN student area with per-feature switches (ADR-001, ADR-004).

## Context

- `App` has a single `/` route open to everyone on `0.0.0.0:4567`.
- Every later feature adds routes to one of the two areas.

## Changes

- Route map as in `architecture.md`: teacher under `/teacher/...`, students under `/students/...`; `/` redirects to `/students`.
- `before "/teacher*"` filter: allow loopback and the IPs in `:teacher: :allow:` of `teuton-panel.yaml`; otherwise 403 with a translated page (`gui-i18n`). Normalize IPs first (`::ffff:a.b.c.d` → `a.b.c.d`).
- Student switches in `teuton-panel.yaml` (`:student: {:register:, :list:, :run:, :results:, :feedback:, :history:, :status:, :readme:}`); a disabled feature answers 403 with a translated message.
- Code routes matched with the code pattern plus optional action and suffix (e.g. `%r{/students/([A-HJ-KM-NP-Z2-9]{4,6})(?:/(run|results|history|status))?(?:\.(html|txt|json))?}`); a helper loads the student by code (404 if unknown) and reads the request IP.
- Format by suffix (ADR-005): helper that reads an optional `.html|.txt|.json` suffix and renders the matching view; unsupported suffix → 404.
- `before "/students*"` filter: if the requested format is not in `:student: :formats:`, answer 403 with a plain-text message listing the enabled formats; if the list is empty, the student area is closed (403 "student area closed" for every route). Teacher routes are not affected.
- Escape every student-supplied value in HTML views.
- Make bind address and port configurable in `teuton-panel.yaml`.

## Acceptance

- From another machine, `/teacher` returns 403; from localhost or an allowed IP it works.
- Turning off a student switch disables that route immediately (no restart if feasible).
- With formats `[txt]` only, `/students/K7QH/results` (HTML) answers 403 naming `.txt`, and `/students/K7QH/results.txt` works; with no formats, every student route answers 403.
- `curl http://<panel>/students.txt` (and every student route with `.txt`) returns readable plain text; `.json` returns JSON.
- Rack::Test tests cover loopback, an allowed IP and a remote IP for both areas.
