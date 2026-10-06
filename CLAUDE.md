# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

`teuton-panel` is an early-stage (v0.1.0, "EN DESARROLLO") Ruby gem that adds a web panel on top of [Teuton](https://github.com/teuton-software/teuton), the infrastructure-testing tool used by sysadmin teachers to evaluate students' machines. Teuton itself runs the tests; this gem is the interaction layer around it (listing tests, enabling cases, scheduled runs, student self-registration and self-run via browser or `curl`, publishing results/readme). The planned feature set and routes (`/tests/list`, `/run/once`, `/run/every/N`, `/config`, `/readme`…) are described in [docs/todo.md](docs/todo.md); [docs/demo.md](docs/demo.md) and [docs/history.md](docs/history.md) record the classroom use case that motivates them. Read those before designing new features.

The panel runs on the teacher's machine in a classroom LAN: the teacher area answers only localhost (plus allowed teacher IPs), the student area is reachable from the network and students are identified by a personal code (ADR-001, ADR-004). It targets the `teuton` gem 3.0.0 and always calls it as a subprocess, reading results from its JSON reports (ADR-002); Teuton 3.0.0 has known bugs listed in that ADR. Pending work is in `.minispec/features/`.

## Commands

| Command | Purpose |
| --- | --- |
| `bin/setup` | Install dependencies (`bundle install`) |
| `bundle exec rake` | Default task: tests + Standard lint |
| `bundle exec rake test` | Run the test-unit suite (`test/**/*_test.rb`) |
| `bundle exec ruby -Itest -Ilib test/teuton/panel_test.rb` | Run a single test file |
| `bundle exec ruby -Itest -Ilib test/teuton/panel_test.rb -n "/VERSION/"` | Run tests matching a name |
| `bundle exec rake standard` | Lint (Standard Ruby, `ruby_version: 3.2`) |
| `bundle exec rake standard:fix` | Auto-fix lint offenses |
| `ruby teuton-panel up DIR` | Start the panel on DIR (Sinatra/Puma on `0.0.0.0:4567`) |
| `bin/console` | IRB with the gem loaded |

## Architecture

Flow: `teuton-panel` (executable at repo root, not `exe/`) → `CLI` (Thor, [lib/teuton/panel/cli.rb](lib/teuton/panel/cli.rb)) → `Teuton::Panel.up(basedir)` ([lib/teuton/panel.rb](lib/teuton/panel.rb)) → Sinatra `App`.

- **CLI.** Unknown subcommands fall through `method_missing` to `up`, so `teuton-panel some/dir` equals `teuton-panel up some/dir`. The `new` command calls `Teuton.create`, which does not exist yet.
- **Project discovery.** `Projects.all(basedir)` ([project.rb](lib/teuton/panel/project.rb)) treats every directory containing a `start.rb` (recursively) as a Teuton test project; it exits if none are found, since the panel is pointless without tests.
- **Panel config.** `Config` ([config.rb](lib/teuton/panel/config.rb)) loads `teuton-panel.yaml` from `basedir`; if missing it asks via `tty-prompt` and copies the template from [lib/teuton/panel/files/](lib/teuton/panel/files/teuton-panel.yaml). Keys are YAML symbols (`:run:`).
- **Web app.** `up` injects state into the Sinatra class with `App.set(:panel_projects, ...)` / `App.set(:panel_config, ...)`; routes read it through `settings.panel_*`. `public_folder` points to `lib/teuton/panel/public`, which does not exist yet.
- **Constants.** `VERSION`, `APPNAME` and `CONFIGFILE` live in [version.rb](lib/teuton/panel/version.rb), which is also the only file that defines the `Teuton` module. Other files use the compact `module Teuton::Panel` form, so `version.rb` must be required first (the CLI does this; `lib/teuton/panel.rb` currently requires `app.rb` before it, which breaks `require "teuton/panel"` as used in `test/test_helper.rb`).

Gemspec notes: packaged files are `Dir.glob("lib/**/*.*")`; runtime deps are thor, tty-prompt, sinatra, rackup and puma. The executable does `require "debug"`.

## Known state

- The test suite and gem loading are currently broken; see `.minispec/features/boot-fixes.md`.
- README is still the bundler template.

## Language

Everything in this repo is written in English: code, identifiers, comments, routes/endpoints, CLI messages, commit messages, this file, `.minispec/` (content and headings) and any new documentation. This applies regardless of the language the user chats in. The web GUI is multi-language (English and Spanish, chosen per request from `Accept-Language`): user-facing strings always come from the locale files, never hard-coded in one language.

## Code style

The web app is plain Sinatra, no Rails, kept simple (ADR-003). Write all Ruby the way the Teuton maintainer (dvarrui) does: load the `dvarrui-ruby-style` skill in `.claude/skills/` before writing or reviewing Ruby code.

## MiniSpec (read first)

Before writing any code, read `.minispec/README.md` and follow its reading contract. As a minimum, always read `.minispec/core/project.md`, `.minispec/core/conventions.md` (language rules live there) and `.minispec/core/principles.md`; read the rest of `.minispec/` only on demand (architecture, stack, glossary, the relevant feature or ADR). Keep features small and don't write redundant documentation. When a feature is implemented, promote its permanent knowledge and delete the feature file.
