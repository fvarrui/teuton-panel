# Conventions

- Everything in this repo is written in English: code, identifiers, comments, routes/endpoints, CLI messages, commits, `CLAUDE.md`, `.minispec/` and documentation (including `docs/`).
- The web GUI is multi-language (English and Spanish). Every string the browser or `curl` shows comes from the locale files through a translation helper; never hard-code user-facing text in one language.
- Language per request from `Accept-Language`; fallback to the panel config's default language.
- Teacher routes live under `/teacher/...` (localhost-only). Student routes live at the root (`/register`, `/students`, `/run`, `/results`, `/readme`) so they are short to type with `curl`.
- Student routes answer HTML when `Accept` includes `text/html`, plain text otherwise (`curl`).
- Commits use a type prefix (`feat`, `fix`, `chore`, `refactor`…).
- Ruby files start with `# frozen_string_literal: true` and follow Standard (`bundle exec rake standard`).
- Modules use the compact form `module Teuton::Panel`; this requires `version.rb` to load first.
- Gem-wide constants (`VERSION`, `APPNAME`, `CONFIGFILE`) live in `version.rb`.
- State needed by routes is injected into `App` with `App.set`; no global variables.
- Templates copied to the user live in `lib/teuton/panel/files/`.
- `teuton-panel.yaml` keys are YAML symbols (`:run:`). It is created with defaults when missing, without asking, and saved as soon as a setting changes.
- Registration parameters (`tt_include_params`) live in the test's `config.yaml` `global` section, next to `tt_include`.
- Markdown: one line per paragraph and list item, no horizontal rules between sections.
