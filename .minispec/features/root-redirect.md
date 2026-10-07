# Root path by area

## Goal

Make `/` take each visitor to the right place: the teacher to the teacher area, students to the student area, and `curl` users to the plain-text help.

## Context

- `GET /` always answers `302` to `/students` (`app.rb`), with an empty body.
- The teacher who opens `http://localhost:4567/` lands on the student home, which has no link to the teacher area; they must remember `/teacher` from the startup banner.
- `curl http://<ip>:4567/` without `-L` prints nothing; with `-L` it prints the HTML home, not the `.txt` help.
- `/.txt` answers a 404 in HTML.
- When the student area is closed (no format enabled), `/` leads everybody, the teacher included, to a 403 "student area closed".

## Changes

- `GET /` from a teacher address (localhost, own IPs, allow-list: same check as the `/teacher` filter) → redirect to `/teacher`.
- `GET /` from anyone else → redirect to `/students`, as now.
- `GET /` from a client that does not ask for HTML (`Accept` without `text/html`, as `curl` sends) → answer the `/students.txt` help directly with `200`, or the closed-area message if the area is closed.
- `GET /.txt` and `/.json` → same content as `/students.txt` and `/students.json`.
- Redirect bodies include a one-line translated text with the target URL, so `curl` without `-L` shows something useful.
- Update the route map in `.minispec/core/architecture.md` and the docs (getting started, FAQ) in en/es/ca.

## Acceptance

- From localhost, `/` opens the teacher home.
- From another IP, `/` opens the student home.
- `curl http://<ip>:4567/` prints the plain-text student help.
- With the student area closed, the teacher still reaches `/teacher` from `/`.
- Rack::Test covers the four cases (teacher, student, curl, closed area).
