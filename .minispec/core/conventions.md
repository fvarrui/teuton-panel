# Conventions

- Everything in this repo is written in English: code, identifiers, comments, routes/endpoints, CLI messages, commits, `CLAUDE.md`, `.minispec/` and documentation (including `docs/`).
- The web GUI is multi-language (English and Spanish). Every string the browser or `curl` shows comes from the locale files through a translation helper; never hard-code user-facing text in one language.
- Language per request from `Accept-Language`; fallback to the panel config's default language.
- Teacher routes live under `/teacher/...`; student routes under `/students/...`, with personal routes as `/students/<code>/...` (no query strings to quote in a shell). The full route map is in `architecture.md`.
- Only GET and POST. Actions that change data use POST, except `GET /students/<code>/run`, kept for plain `curl`.
- Response format by URL suffix (ADR-005): none or `.html` → HTML, `.txt` → plain text for `curl`, `.json` → JSON. Commands shown to students always use `.txt`.
- Commits use a type prefix (`feat`, `fix`, `chore`, `refactor`…).
- Ruby files start with `# frozen_string_literal: true` and follow Standard (`bundle exec rake standard`).
- Modules use the compact form `module Teuton::Panel`; this requires `version.rb` to load first.
- Gem-wide constants (`VERSION`, `APPNAME`, `CONFIGFILE`) live in `version.rb`.
- State needed by routes is injected into `App` with `App.set`; no global variables.
- Templates copied to the user live in `lib/teuton/panel/files/`.
- `teuton-panel.yaml` keys are YAML symbols (`:run:`). It is created with defaults when missing, without asking, and saved as soon as a setting changes.
- Registration fields live in `teuton-panel-params.yaml` next to the test's `config.yaml` (never inside `config.d/`, which Teuton reads as cases). The panel writes only `tt_include` into `config.yaml`; Teuton 3.0.0 crashes on hash values in `global` (ADR-002).
- Markdown: one line per paragraph and list item, no horizontal rules between sections.
