# Ruby-only skills

## Goal

Every project skill uses only Ruby for its scripts and examples: no Python, shell scripts or Node tools.

## Context

- The user wants the project in pure Ruby, tooling included.
- Skills with non-Ruby code today:
  - `webapp-testing` (anthropics): `scripts/with_server.py` (start the server, wait for the port, run a command, stop) and `examples/*.py` (Playwright for Python: static HTML automation, element discovery, console logging).
  - `diagnosing-bugs` (mattpocock): `scripts/hitl-loop.template.sh` (human-in-the-loop reproduction script in bash).
  - `accessibility` (addyosmani): tells the agent to run `npx lighthouse` and `npm install -g @axe-core/cli`.
  - `security-and-hardening` (addyosmani): mentions package-manager audits for npm and similar; for this project that means `bundle audit` or nothing.
- These are copies inside `.claude/skills/`, pinned in `skills-lock.json`; `npx skills update -p` would bring the originals back.
- Browser automation in Ruby without Node: `ferrum` (Chrome DevTools Protocol, pure Ruby, needs a local Chrome/Edge) or `cuprite` on top of it with Capybara. The Ruby Playwright client needs the Node driver, so it does not qualify.

## Changes

- `webapp-testing`: replace `with_server.py` with `scripts/with_server.rb` (same options: `--server`, `--port`, `--timeout`, command after `--`); rewrite the three examples with `ferrum`; update SKILL.md (Ruby commands, `ferrum` as a development gem in the Gemfile, Chrome/Edge required).
- `diagnosing-bugs`: replace `hitl-loop.template.sh` with `scripts/hitl_loop.template.rb` (same `step` / `capture` helpers, `KEY=VALUE` output); update the SKILL.md references.
- `accessibility`: replace the npm commands with a Ruby path (e.g. a `ferrum` script that loads the page and injects a local copy of axe-core, or a manual checklist only); decide which and update SKILL.md.
- `security-and-hardening`: point dependency audits to Ruby tools (`bundle audit` if the gem is accepted) in a short project note.
- Keep the upstream license files; mark each ported skill as modified in its SKILL.md header.
- Stop `npx skills update` from overwriting the ports: remove the ported skills from `skills-lock.json` (or document that they must not be updated) and say so in `CLAUDE.md`.

## Acceptance

- `find .claude/skills -name "*.py" -o -name "*.sh" -o -name "*.js"` returns nothing.
- No SKILL.md tells the agent to run Python, bash scripts, `npx` or `npm`.
- `ruby .claude/skills/webapp-testing/scripts/with_server.rb --server "ruby teuton-panel up tmp/sandbox" --port 4567 -- ruby <example>.rb` works against the sandbox.
