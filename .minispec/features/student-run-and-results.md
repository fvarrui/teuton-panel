# Student run and results

## Goal

A student requests a run of their own case and sees their own results, history and connection status, from a browser or `curl`, using their personal code.

## Context

- `teuton-client`/`teuton-server` did this over raw TCP, one port per student, returning only a grade line.
- Identity is the personal code (ADR-004), carried in the path: `/students/<code>/...`.
- Results come from the panel's results store (`teuton-runner`), never from raw Teuton reports.

## Changes

- `GET /students/<code>`: personal page with name, latest grade, connection status, links and their own registration data (every field of their file except `tt_panel_*`; fields whose name contains `password` shown as `******`). The update form leaves a password unchanged when its field is left empty.
- Disabled students (`tt_panel_disabled`): personal page, results and history still work; `/run` answers "disabled by the teacher" and nothing is queued.
- `POST /students/<code>/run` and `GET /students/<code>/run` (for `curl`): queue a run of only that student's case; answer with the grade when done, or "queued / will be evaluated in the next pass at HH:MM" if a teacher loop is active.
- Rate limit per code and per IP: at most one run in progress and a minimum interval (default 30 s, `:student: :run_interval:`).
- `GET /students/<code>/results`: latest grade, time, and, if `student.feedback` is on, per-target check and description (no commands, output or config). Show why a grade is 0 when `unique_fault` is set.
- `GET /students/<code>/history`: grade per past run of the session, from the run directories (find the case by `tt_panel_code` in each report).
- `GET /students/<code>/status`: connection result of the last run (`conn_status`: ok, host unreachable, authentication failed…) with a translated hint, and whether the active test changed since registration. No live probe.
- Empty states: registered but never evaluated, unknown code (404 pointing to `/students/register`).
- Every route answers HTML, `.txt` and `.json` (ADR-005).
- Switches: `student.run`, `student.results`, `student.feedback`, `student.history`, `student.status`.

## Acceptance

- `curl http://<panel>/students/K7QH/run.txt` runs only that case and prints the grade; other students' results are unchanged.
- An unknown code gets a clear message pointing to registration.
- `curl http://<panel>/students/K7QH/history.txt` lists the grades by run time.
- After a run where the student's SSH password was wrong, `/students/<code>/status` says authentication failed.
- A student can never see another student's data, any code but their own, or any password.
- Two quick requests with the same code do not start two runs.
- `curl http://<panel>/students/K7QH.txt` shows the student's own registration data with passwords masked.
- A disabled student's `/run` is refused while `/results` still works.
