# Skills selection

## Goal

Decide which third-party Claude Code skills to install for this project. **Decision pending** (the user chooses).

## Context

- Searched on 2026-10-06 with `npx skills find` (skills.sh) and checked each SKILL.md on GitHub (installs, stars, content).
- Project needs: Ruby 3.2 gem, plain Sinatra 4 + Puma (ADR-003), test-unit + Rack::Test, Standard; Teuton as a subprocess; LAN-exposed student area receiving untrusted input; projector dashboard; en/es GUI.
- Already available (do not duplicate): built-in `/code-review`, `/security-review`, `/simplify`, `run`; Claude in Chrome for manual browser checks; repo skills `minispec-*`, `dvarrui-ruby-style`; user skill `markdown-writing`.
- No quality skill exists for Ruby + Sinatra + test-unit: Ruby skills are Rails/RSpec oriented, Sinatra skills have ~30 installs.

## Candidates (recommended first)

| Skill | What it does | Why here | Popularity | Priority |
| --- | --- | --- | --- | --- |
| `mattpocock/skills@tdd` | Test-first loop: agree public seams, red-green, anti-patterns. Reads `GLOSSARY.md` and ADRs | Suite is broken; runner, JSON parsing and access control suit test-first with test-unit + Rack::Test | 1M installs, repo 278K★ | High |
| `addyosmani/agent-skills@security-and-hardening` | Treat input as hostile, secrets, authorization checks, external integrations | Student area on the LAN, files written from request data (`config.d/from_<ip>.yaml`), subprocess commands, passwords in Teuton reports | 52.1K installs | High |
| `anthropics/skills@frontend-design` | Distinctive, polished web UI (official) | No views yet; projector dashboard must read from afar; works with plain HTML/CSS | 954K installs, repo 180K★ | Medium-high |
| `mattpocock/skills@diagnosing-bugs` | Phased diagnosis loop for hard bugs; redacts secrets in shown output | Subprocesses, scheduler threads, Teuton 3.0.0 bugs; reports contain passwords | 719K installs | Medium |
| `anthropics/skills@webapp-testing` | Repeatable browser tests of a local web app with Python Playwright (`scripts/with_server.py`) | Dashboard refresh, registration form, language switch. Needs Python (3.14 installed). Partly overlaps Claude in Chrome (ad-hoc only) | 170K installs, official | Medium |
| `addyosmani/web-quality-skills@accessibility` | WCAG 2.2 audit: contrast, keyboard, semantics | Projector contrast/size; student pages also used from terminal browsers (lynx) | 58.7K installs, repo 2.9K★ | Low-medium |
| `vercel-labs/agent-skills@web-design-guidelines` | Reviews UI against design guidelines | Useful but overlaps `frontend-design` | 701K installs | Low |

## Discarded

- `sickn33/agentic-awesome-skills@ruby-pro` (289 installs) and `mindrally/skills@ruby` (706 installs, repo 266★): generic, Rails/RSpec oriented; `ruby-pro` is labelled `risk: critical` in its repo. Superseded by `dvarrui-ruby-style`.
- `geoffjay/claude-plugins@sinatra-security` / `@sinatra-patterns` (~33 installs, repo 8★, last push 2025-11): exact stack but basic content (SQL injection, CRUD routes); `security-and-hardening` covers it better.
- `daymade/claude-code-skills@i18n-expert` (2.5K installs): React/i18next, en-US/zh-CN; our i18n is a small YAML helper (`gui-i18n`).
- `obra/superpowers@test-driven-development` / `systematic-debugging` (241K): duplicate the mattpocock pair; don't install both families.
- `vercel-labs/agent-browser` (964K), `currents-dev/playwright-best-practices-skill` (90K), `microsoft/playwright-cli` (176K): duplicate Claude in Chrome / `webapp-testing`.
- `mattpocock/skills@code-review`, `getsentry/skills@security-review`: duplicate the built-ins.
- Sentry/OpenTelemetry Ruby SDK skills, cloud (Azure/AWS) skills: not applicable to a LAN tool.
- `everyinc/compound-engineering-plugin@andrew-kane-gem-writer`: listed by the search but no longer in its repo.
- Searches with no useful result: `rack`, `erb`, `rubocop`, `htmx`, `changelog`, `readme`, `subprocess`, `ssh`, `yaml config`, `minitest`.

## Changes

- User picks the skills to install (all, some or none).
- Install the chosen ones project-level (`npx skills add <owner/repo@skill>`) or user-level (`-g`):
  - `npx skills add mattpocock/skills@tdd`
  - `npx skills add addyosmani/agent-skills@security-and-hardening`
  - `npx skills add anthropics/skills@frontend-design`
  - `npx skills add mattpocock/skills@diagnosing-bugs`
  - `npx skills add anthropics/skills@webapp-testing`
  - `npx skills add addyosmani/web-quality-skills@accessibility`
- Read each installed SKILL.md and note conflicts with ADR-003 or `dvarrui-ruby-style` (e.g. a skill pushing RSpec or a frontend framework); project rules win.
- Consider project-own skills instead of more third-party ones: `verify` (`bundle exec rake` + start the panel against a sample test) and `teuton-sandbox` (sample Teuton test with `config.d/` and fixture JSON reports).

## Acceptance

- The chosen skills are installed and listed in `CLAUDE.md` (or the decision "none" is recorded).
- This feature file is deleted.
