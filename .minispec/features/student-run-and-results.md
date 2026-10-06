# Student run and results

## Goal

A student requests a run of their own case and sees their own result, from a browser or `curl`.

## Context

- `teuton-client`/`teuton-server` did this over raw TCP, one port per student, returning only a grade line.
- The student is identified by IP (ADR-001); their case is the `config.d/` file with that `tt_source_ip`.
- Case reports contain other students' credentials in `config`; never show them raw (ADR-002).

## Changes

- `POST /run` and `GET /run` (for `curl`): run only the caller's case (temporary config with that case), return the grade.
- Rate limit per IP: at most one run in progress and a minimum interval between runs (default 30 s, `:student: :run_interval:` in the panel config).
- `GET /results`: the caller's last grade and, if the teacher allows it, per-target feedback (check and description, no commands or config).
- Switches: `student.run`, `student.results`, `student.feedback`.

## Acceptance

- From a registered student's machine, `curl http://<panel>/run` runs only that case and prints the grade.
- An unregistered IP gets a clear message pointing to registration.
- A student can never see another case's data or any password.
- Two quick consecutive requests from the same IP do not start two runs.
