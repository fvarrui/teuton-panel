---
name: verify
description: Verify teuton-panel before finishing a change or committing - install gems if needed, run `bundle exec rake` (test-unit + Standard), and, when the change touches the CLI or the web app, start the panel against the teuton-sandbox test and check the affected routes with curl. Reports real output; never claims success without running. Use after implementing a feature or fix, before a commit, or when the user asks to check that everything works.
---

# Verify

Run every step that applies, in order, and report what actually happened (pass/fail plus the relevant output). Stop at the first failure that blocks the next step, show it, and fix it if it belongs to the current task.

## 1. Dependencies

```bash
bundle check || bundle install
```

If `bundle install` fails (network, native extensions), report it and stop.

## 2. Tests and lint

```bash
bundle exec rake            # default task: test + standard
```

- On failures, rerun only the failing file to read it clearly: `bundle exec ruby -Itest -Ilib test/<path>_test.rb`.
- Lint offenses: `bundle exec rake standard:fix`, then review the diff (the fixer can change behavior in rare cases) and rerun `bundle exec rake`.
- Known state: until `.minispec/features/boot-fixes.md` is done, the suite fails at load time (`NameError` from the require order) and has a placeholder failing test. Say so instead of hiding it.

## 3. Smoke test (only if the change touches `lib/teuton/panel/cli.rb`, `app.rb`, views, routes or startup)

1. Make sure the sandbox exists (`teuton-sandbox` skill): `ruby .claude/skills/teuton-sandbox/scripts/create_sandbox.rb` if `tmp/sandbox` is missing.
2. Start the panel in the background (Bash tool with `run_in_background: true`): `ruby teuton-panel up tmp/sandbox`.
3. Wait until the port answers (poll `curl -s -o /dev/null -w "%{http_code}" http://localhost:4567/` a few times; give up after ~20 s and show the panel's output).
4. Check the routes the change affects, plus these basics once they exist (see the route map in `.minispec/core/architecture.md`):

```bash
curl -s -o /dev/null -w "%{http_code}\n" http://localhost:4567/teacher        # 200 from localhost
curl -s http://localhost:4567/students.txt                                     # plain-text help
curl -s -o /dev/null -w "%{http_code}\n" http://localhost:4567/students/ZZZZ   # 404 unknown code
```

   For teacher-only behavior from "another machine", prefer Rack::Test with a non-loopback `REMOTE_ADDR` over network tricks.
5. Stop the panel (kill the background task) and make sure no `teuton` child process is left running.

For browser-level checks (layout, auto-refresh, forms) use the `webapp-testing` skill or Claude in Chrome.

## 4. Report

- One line per step: passed / failed / skipped (and why it was skipped).
- For failures: the command, the relevant lines of output, and whether it was fixed.
- Never write "all good" if any step was skipped or failed.
