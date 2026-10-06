# Student list

## Goal

Show who has registered so far, so the teacher (and, if enabled, the class) can see who is still missing; let the teacher fix or remove registrations.

## Context

- While waiting for registrations the teacher only sees files in `config.d/` (`docs/demo.md`).
- The reference classroom shows a `/list` page on the projector, refreshed every few seconds (`docs/history.md`).
- Case files are `config.d/<code>.yaml` with `tt_panel_code` and `tt_source_ip` (ADR-004).

## Changes

- Read cases from `config.yaml` and `config.d/` of the active test.
- Teacher page: members, code, `tt_source_ip`, registration time, last grade; edit or remove a registration. Codes are shown only here (to help a student who forgot theirs).
- Edit form: every field of the student's file, saved immediately with string keys; same validation as registration (no loopback or panel IPs in host fields). The code cannot be edited.
- Enable/disable a student (e.g. absent today): stored as `tt_panel_disabled: true` in their `config.d/` file. Disabled students are left out of every temporary config (never `tt_skip`, which crashes Teuton 3.0.0), so loops and student runs skip them; the list and dashboard show them as "disabled". Cases written by hand in `config.yaml` `cases:` cannot be disabled from the panel.
- Hand-written cases without `tt_panel_code`: shown as "no code"; the teacher can assign one so the student can use their personal routes.
- Student route `GET /students`: student home with links to enabled features (`/students.txt`: plain-text usage help listing the `.txt` commands), plus the list of members (and registration time) when `student.list` is on; never codes, IPs or other fields.
- Auto-refresh in the HTML view; `.txt` and `.json` variants.

## Acceptance

- A new registration appears in the list within the refresh interval.
- The student view never shows codes or fields other than members.
- The teacher can delete a registration and the file disappears from `config.d/`.
- The teacher can fix a student's data and the next run uses the new values.
- A disabled student is not evaluated by the next loop pass and appears as "disabled"; re-enabling brings them back.
