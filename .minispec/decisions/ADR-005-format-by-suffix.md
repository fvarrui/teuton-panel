# ADR-005: Response format by URL suffix, no SPA

## Decision

Every route renders on the server and chooses its format by URL suffix, like Redmine: no suffix or `.html` → HTML, `.txt` → plain text, `.json` → JSON (`.md` for the raw readme, `.csv` for Moodle). The `Accept` header is ignored. There is no single-page app.

## Motivation

- Students use `curl` from terminal-only machines; plain text (`/students/K7QH/results.txt`) is readable for beginners, JSON is not.
- The suffix is explicit, visible in the URL and easy to type; no headers to remember.
- JSON on the same routes gives a real API for scripts or a future CLI client without a second codebase.
- A SPA would need a JS framework and a build step (against ADR-003) and would break terminal browsers such as lynx (`docs/en/developers/notes/demo.md`).

## Consequences

- Each route has an HTML (ERB) view, a text template and a JSON builder fed by the same data; a route may skip formats that make no sense (e.g. no JSON for forms).
- `curl` without a suffix gets HTML; the student help, the registration answer, the startup banner and projector mode always show the `.txt` form of the commands.
- Route patterns accept an optional suffix (`/students/<code>/run.txt`); an unsupported suffix answers 404.
- Small inline JS may poll `.json` routes (e.g. dashboard auto-refresh) without a build step.
- The teacher chooses in the settings which formats the student area exposes (`:student: :formats:`, any subset of `html`, `txt`, `json`; default all). A request in a disabled format answers 403 with a short plain-text message naming the enabled formats. With no format enabled the whole student area is closed (every `/students` route answers 403). The teacher area always serves every format.
- Format and feature switches combine: a route answers only if both its feature and the requested format are enabled.
- JSON never includes passwords, codes of other students or report `config` sections; same sanitizing as HTML.
