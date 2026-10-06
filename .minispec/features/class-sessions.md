# Class sessions

## Goal

The teacher starts a clean session (another day or group) and can still consult previous ones.

## Context

- Registrations (`config.d/*.yaml`), the results store and run directories persist across restarts.
- Without a reset, yesterday's students and results stay in today's lists.

## Changes

- Teacher action "New session" (with confirmation): move the active test's `config.d/` files, the results store and the session's run directories into an archive folder named by date and time (e.g. `.teuton-panel/archive/<test>/20261006-0930/`); leave everything empty.
- A running loop must be stopped first.
- Teacher page to list archived sessions and open their student list, results and `moodle.csv` (read-only).
- Optional session label typed by the teacher (e.g. "ASIR1 group A").

## Acceptance

- After "New session", the student list and dashboard are empty and old codes no longer work.
- An archived session can be opened and its `moodle.csv` downloaded.
- Nothing is deleted: every archived file is still on disk.
