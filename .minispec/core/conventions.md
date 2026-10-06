# Conventions

- Everything in this repo is written in English: code, identifiers, comments, routes/endpoints, CLI messages, commits, `CLAUDE.md`, `.minispec/` and new documentation.
- Exception to confirm when it comes up: text shown to students in the browser may be Spanish (the audience is Spanish-speaking).
- Existing notes in `docs/` are in Spanish; leave them as they are unless asked to translate them.
- Commits use a type prefix (`feat`, `fix`, `chore`, `refactor`…).
- Ruby files start with `# frozen_string_literal: true` and follow Standard (`bundle exec rake standard`).
- Modules use the compact form `module Teuton::Panel`; this requires `version.rb` to load first.
- Gem-wide constants (`VERSION`, `APPNAME`, `CONFIGFILE`) live in `version.rb`.
- State needed by routes is injected into `App` with `App.set`; no global variables.
- Templates copied to the user live in `lib/teuton/panel/files/`.
- `teuton-panel.yaml` keys are YAML symbols (`:run:`).
- Markdown: one line per paragraph and list item, no horizontal rules between sections.
