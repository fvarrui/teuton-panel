# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

`teuton-panel` is a Ruby gem that serves a web panel for [Teuton](https://github.com/teuton-software/teuton), the infrastructure-testing tool used by sysadmin teachers to evaluate students' machines. A teacher starts it on a classroom LAN: the teacher area answers only the teacher's machine (plus allowed IPs), the student area is reachable from the network and students are identified by a personal code (ADR-001, ADR-004). Teuton runs the tests; the panel always calls the `teuton` 3.x command as a subprocess and reads its JSON reports (ADR-002, which also lists Teuton 3.0.0 bugs to work around). User documentation is in `README.md`; the classroom use case that motivates it is in `docs/`.

## Commands

| Command | Purpose |
| --- | --- |
| `bin/setup` | Install dependencies (`bundle install`) |
| `bundle exec rake` | Default task: tests + Standard lint (a minute or two: some tests run the real `teuton`) |
| `bundle exec rake test` | Run the test-unit suite (`test/**/*_test.rb`) |
| `bundle exec ruby -Itest -Ilib test/teuton/panel/app_test.rb` | Run a single test file |
| `bundle exec ruby -Itest -Ilib test/teuton/panel/app_test.rb -n "/register/"` | Run tests matching a name |
| `bundle exec rake standard` | Lint (Standard Ruby, `ruby_version: 3.2`) |
| `bundle exec rake standard:fix` | Auto-fix lint offenses |
| `ruby .claude/skills/teuton-sandbox/scripts/create_sandbox.rb` | Sample localhost test in `tmp/sandbox` |
| `ruby teuton-panel up tmp/sandbox` | Start the panel from the source tree (WEBrick on `0.0.0.0:4567`) |
| `gem build teuton-panel.gemspec` | Build the gem (installed executable: `bin/teuton-panel`) |
| `bin/console` | IRB with the gem loaded |

## Architecture

The code map, route list and Teuton integration details are in `.minispec/core/architecture.md`; the visual language in `.minispec/core/design.md`. In short: `bin/teuton-panel` → `CLI` (Thor) → `Teuton::Panel.up` (checks teuton, finds tests, loads `teuton-panel.yaml`, wires `RunQueue`/`Scheduler` into `App` settings) → Sinatra `App` (`app.rb` core plus `app/teacher_routes.rb`, `app/student_routes.rb`, `app/view_helpers.rb`). Runs go through `RunQueue` → `Runner` (own run directory, temp config, JSON reports) → `ResultsStore`. Views are ERB in `views/` (HTML) and `views/txt/` (plain text for `curl`); format is chosen by URL suffix (ADR-005).

Gotchas: in ERB views use full constant names (`Teuton::Panel::Params`); route patterns use `(.:format)?`; `views/txt/` renders with trim mode `-`; the app runs in Sinatra's `production` environment on purpose (no host check, no stack traces); Git Bash rewrites URL-like arguments starting with `/` (use PowerShell or `MSYS_NO_PATHCONV=1` when passing paths such as `/teacher` to Ruby scripts).

## Language

Everything in this repo is written in English: code, identifiers, comments, routes/endpoints, CLI messages, commit messages, this file, `.minispec/` (content and headings) and any new documentation. This applies regardless of the language the user chats in. The web GUI is multi-language (English and Spanish, chosen per request from `Accept-Language`): user-facing strings always come from the locale files, never hard-coded in one language.

## Code style

The web app is plain Sinatra, no Rails, kept simple (ADR-003). Write all Ruby the way the Teuton maintainer (dvarrui) does: load the `dvarrui-ruby-style` skill in `.claude/skills/` before writing or reviewing Ruby code.

## Project skills

All in `.claude/skills/` and versioned. Unmodified third-party ones (`tdd`, `frontend-design`, `web-design-guidelines`) are pinned in `skills-lock.json`; `diagnosing-bugs`, `accessibility` and `security-and-hardening` were adapted to pure Ruby / Bundler and removed from the lock so `npx skills update` never overwrites them.

- Own: `dvarrui-ruby-style` (how to write Ruby here), `verify` (rake + smoke test before finishing), `teuton-sandbox` (sample localhost Teuton test and real JSON reports), `minispec-*` (specs workflow).
- Third-party: `tdd` (mattpocock), `security-and-hardening` (addyosmani, adapted), `frontend-design` (anthropics), `diagnosing-bugs` (mattpocock, script ported to Ruby), `accessibility` (addyosmani, adapted: DevTools instead of Node tools), `web-design-guidelines` (vercel, UI review; fetches its rules from GitHub).
- Everything in the project is pure Ruby, tooling included: no Python, shell scripts or Node tools in code or skills. Browser checks: Rack::Test for behaviour, Claude in Chrome for visual review.

Project rules win over third-party skills: tests are test-unit (not jest/RSpec); no login, sessions, HTTPS or password hashing by design (ADR-001, ADR-004); no frontend framework, CDN or build step (ADR-003); ask before installing global tools they suggest (e.g. `npm install -g`); no external images, fonts or icon CDNs and no scroll/stagger animations on auto-refreshing pages. Visual direction: elegant educational app for adults, warm and lively, not minimalist (see `.minispec/core/design.md`).

## MiniSpec (read first)

Before writing any code, read `.minispec/README.md` and follow its reading contract. As a minimum, always read `.minispec/core/project.md`, `.minispec/core/conventions.md` (language rules live there) and `.minispec/core/principles.md`; read the rest of `.minispec/` only on demand (architecture, stack, glossary, the relevant feature or ADR). Keep features small and don't write redundant documentation. When a feature is implemented, promote its permanent knowledge and delete the feature file.
