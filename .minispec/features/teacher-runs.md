# Teacher runs

## Goal

The teacher runs the active test from the panel: all cases or a selection, once, N times or every T seconds.

## Context

- Today the teacher runs `watch -n 60 teuton run test` in a terminal (`docs/history.md`).
- Teuton has no loop feature; `--case` and `tt_skip` crash in 3.0.0 (ADR-002).
- Panel config already has `:run: {:every:, :times:, :delay:}`.
- Runs go through the run queue and results store of `teuton-runner`.

## Changes

- Teacher page `/teacher/run`: choose cases (checkboxes; disabled students unchecked and greyed), mode (once / times N / every T, optional end time), start and stop.
- Background scheduler (thread) feeding the run queue with teacher priority; a tick is skipped if the previous pass is still running.
- Show live status: running, last run time, next pass, exit code, captured output, queued student runs.
- History: the list of run directories of the session (time, kind: full / selection / student, cases, average grade); open any run's results. No need for `export preserve: true` in `start.rb`.
- Persist the last used settings in `teuton-panel.yaml`. After a panel restart the loop is not resumed automatically; the teacher page shows the last settings ready to start again.

## Acceptance

- "Every 60 s" keeps running until stopped, with no overlapping passes.
- Running a selection of cases updates only those students in the results store.
- Stopping cancels the schedule and kills a running Teuton process.
- Every run of the session appears in the history and can be opened.
