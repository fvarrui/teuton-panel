---
title: Contributing
parent: Developers
nav_order: 5
lang: en
permalink: /developers/contributing/
---

# Contributing

- **Language**: code, comments, commits and specs are in English; user-facing text lives in the locale files (English, Spanish and Catalan).
- **Code style**: Ruby written the way the Teuton maintainer writes it (small procedural classes, `require_relative`, guard clauses, `puts`/`warn` and `exit 1` for CLI errors), checked with Standard. The rules are in `.claude/skills/dvarrui-ruby-style/`.
- **Specs**: the project uses MiniSpec. Read `.minispec/README.md` first; permanent knowledge is in `.minispec/core/`, decisions in `.minispec/decisions/`, work in progress in `.minispec/features/` (deleted when done).
- **Simplicity**: plain Sinatra, no new dependency without a reason, nothing that needs a C compiler, pure Ruby tooling.
- **Security**: values typed by students reach the commands of Teuton tests; keep `Registration.value_error` strict and never show raw reports to students.
- **Before a pull request**: `bundle exec rake`, `bundle exec rake usecases` and, after visual changes, `bundle exec rake docs:screenshots`.
- **Commits**: short, lower-case, with a type prefix (`feat:`, `fix:`, `docs:`, `chore:`, `refactor:`).

Pull requests are welcome at [dvarrui/teuton-panel](https://github.com/dvarrui/teuton-panel).
