# Results dashboard

## Goal

A teacher page, suitable for the classroom projector, with the latest results of every case.

## Context

- The reference classroom projects the results table next to a registered-students page (`docs/history.md`).
- Teuton writes `var/<test>/resume.json` (grade, members, `conn_status`, `moodle_id`) and `case-NN.json` (per-target detail).
- Teuton panel v1 (Java) had Cases, Resume and Hall of Fame tabs; a useful checklist.

## Changes

- Teacher page `/teacher/results`: table of cases sorted by grade, with members, IP, grade, connection status, last run time.
- Highlight connection problems (`conn_status`) and low grades.
- Case detail page: per-group targets with check result, command, expected and output.
- Hall of fame / grade distribution.
- Auto-refresh; a large-font projector mode.
- Link to `moodle.csv` for download.

## Acceptance

- After a run, the dashboard shows every case's grade within the refresh interval, without reloading by hand.
- An unreachable student machine is visible as a connection problem, not just grade 0.
- Opening a case shows the result of each target.
