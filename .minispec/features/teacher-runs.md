# Teacher runs

## Goal

The teacher runs the active test from the panel: all cases or a selection, once, N times or every T seconds.

## Context

- Today the teacher runs `watch -n 60 teuton run test` in a terminal (`docs/history.md`).
- Teuton has no loop feature; `--case` and `tt_skip` crash in 3.0.0 (ADR-002).
- Panel config already has `:run: {:every:, :times:, :delay:}`.

## Changes

- Teacher page `/teacher/run`: choose cases (checkboxes), mode (once / times N / every T, optional end time), start and stop.
- Background scheduler (thread) using the Teuton runner; one run at a time per test.
- Show live status: running, last run time, next run, exit code, captured output.
- History relies on Teuton's `export preserve: true` in `start.rb`, which copies each run's reports into `var/<test>/YYYYMMDD-HHMMSS/`. The panel lists those folders and can open past results; if the active test's `start.rb` lacks `preserve: true`, the teacher page says so.
- Persist the last used settings in `teuton-panel.yaml`.

## Acceptance

- "Every 60 s" keeps running until stopped, with no overlapping runs.
- Running a selection of cases produces reports for those cases only.
- Stopping cancels the schedule and kills a running Teuton process.
- With `export preserve: true`, every run appears in the history and can be opened.
