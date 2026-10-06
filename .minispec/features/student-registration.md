# Student registration

## Goal

Students register from any machine (browser or `curl`), get a personal code and a case file in the active test's `config.d/`, usable by Teuton immediately.

## Context

- Teuton 3.0.0 reads `tt_include` natively: each `.yaml` file in that directory is one case (flat hash).
- The removed `teuton config --server` form wrote `tt_include` only on shutdown, accepted only POST and let students type their own IP (`docs/demo.md`).
- Teuton has no registration fields concept (`tt_include_params` in `docs/` was only an idea); the panel implements it with its own params file.
- Identity is a personal code (ADR-004), not the IP.

## Changes

- Form fields come only from `teuton-panel-params.yaml` next to `config.yaml` (no seed case in `cases:`). Each key maps to `ASK` (free text), `AS NAME` / `AS EMAIL` (asked, labelled and validated), `AUTO IP` (request IP, not asked) or any other value (fixed, not asked).
- Teacher page `/teacher/registration`: edit the params file. If the test has none, propose it from `teuton config` (its `TOCHANGE` keys) for the teacher to adjust.
- Ensure `tt_include` in `config.yaml` as text: add only that key under `global:` if missing, keep the rest of the file (comments, order) intact. Create the `tt_include` directory if missing. Never put the params (or any hash) in `config.yaml` (ADR-002).
- Routes: `GET /students/register` (form), `POST /students/register`, and `GET /students/register.txt?field=value…` (or `.json`) to register from `curl`.
- New registration: generate a code (ADR-004), write `config.d/<code>.yaml` immediately with string keys, `tt_panel_code` and `tt_source_ip`; answer with the code and the personal URL `/students/<code>` in large type (HTML) or plain lines (`.txt`), including the `.txt` commands to use next.
- `POST /students/<code>` (form on the personal page) updates that student's data and says the previous data was replaced.
- The form shows the detected IP and explains that `AUTO IP` fields get it, so register from the evaluated machine (or ask the teacher to fix it).
- Validation: required fields; ignore any `tt_panel_code`, `tt_source_ip` or `tt_*` key sent by the client; reject loopback addresses and the panel's own IPs in host fields (otherwise Teuton would run commands on the teacher's machine).
- Registration is opened and closed only with the `student.register` switch (no schedule).
- Filter `tt_panel_code` wherever Teuton output is shown to students.

## Acceptance

- `curl "http://<panel>/students/register.txt?tt_members=Ana"` creates `config.d/<code>.yaml` and prints the code.
- A `teuton run` right after includes the new case, without restarting the panel, and no fake `TOCHANGE` case is ever evaluated.
- A field marked `AUTO IP` is never asked and always equals the caller's IP.
- Sending `host1_ip=127.0.0.1` is refused.
- Adding `tt_include` keeps the comments of `config.yaml`.
- With the switch off, registration is refused.
- A manual `teuton run` of the test still works after the panel has prepared it.
