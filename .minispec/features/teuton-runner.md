# Teuton runner

## Goal

Run the `teuton` CLI as a subprocess through a queue, keep each run's reports apart, and maintain the latest result of every student (ADR-002).

## Context

- The panel has no Teuton dependency yet; Teuton 3.0.0 is the target.
- In-process calls are unsafe (ADR-002); results must come from `var/<test>/*.json`.
- Teuton 3.0.0 crashes when any case is skipped, so subsets need a temporary config.
- Teuton numbers cases by position, so a partial run writes `case-01` and a one-case `resume.json` over the class reports.
- Many students may request runs at once while the teacher runs a loop.

## Changes

- Add `teuton ~> 3.0` to the gemspec as a runtime dependency. On start, check that `teuton version` answers 3.x; otherwise print `[ERROR]` and `exit 1`.
- `Teuton::Panel::Runner` wrapping `spawn`/`Open3`:
  - `run(test, cases)` → `teuton run --no-color --quiet --export=json --cpath=<abs temp config> <test>`.
  - `readme(test, lang:)`, `config(test)`, `check(test)` → captured stdout.
- Every run gets its own working directory under the panel's data dir (e.g. `.teuton-panel/runs/<timestamp>-<kind>/`); the temporary config holds exactly the cases to run (built from `config.yaml` cases + `config.d/` files, minus files with `tt_panel_disabled: true`). `tt_panel_disabled` is removed from the temporary config; `tt_panel_code` is kept so each case in the reports can be matched to its student. The class's `var/<test>/` is never written by the panel.
- Results store: after each run, read its `resume.json` and `case-NN.json`, find each case's student by `tt_panel_code` (or `tt_source_file` for hand-written cases) and update that student's latest result (grade, targets, `conn_status`, `unique_fault`, time, run id). Persist it as JSON so it survives restarts. Dashboard and student views read only from the store.
- Class-wide report: after a full run, also copy `moodle.csv` and `resume.json` to a stable place for download; partial runs never replace it.
- Run queue: teacher runs have priority; student runs execute in parallel up to `:runs: :max_parallel:` (default 4). A teacher full run and student runs never overlap (student requests wait or are answered "you will be evaluated in the next pass at HH:MM" while a teacher loop is active).
- Sanitizer for every view: drop `config` and any `*password*` values from reports.
- Capture stdout/stderr of every run for the teacher's output log; on panel shutdown, kill running Teuton processes.
- Run directories are the run history (they replace Teuton's `export preserve: true`); they are kept for the whole session and archived by `class-sessions`.

## Acceptance

- A student run leaves the other students' latest results and the class `moodle.csv` untouched.
- The dashboard shows the latest grade of every student, whichever run produced it.
- With 20 simultaneous student requests, at most `max_parallel` Teuton processes run at once.
- A failing `start.rb` surfaces Teuton's stderr, not a silent empty result.
- Starting without a usable `teuton` 3.x prints a clear error.
- Unit tests cover the command line, the temporary config and the store update from fixture JSON files.
