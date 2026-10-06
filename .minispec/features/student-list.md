# Student list

## Goal

Show who has registered so far, so the teacher (and, if enabled, the class) can see who is still missing.

## Context

- While waiting for registrations the teacher only sees IP-named files in `config.d/` (`docs/demo.md`).
- The reference classroom shows a `/list` page on the projector, refreshed every few seconds (`docs/history.md`).

## Changes

- Read cases from `config.yaml` and `config.d/` of the active test.
- Teacher page: members, `tt_source_ip`, registration time, file; remove a registration.
- Student route `GET /students`: members and IP only (no other fields); switch `student.list`.
- Auto-refresh in the HTML view; plain-text output for `curl`.

## Acceptance

- A new registration appears in the list within the refresh interval.
- The student view never shows fields other than members and IP.
- The teacher can delete a registration and the file disappears from `config.d/`.
