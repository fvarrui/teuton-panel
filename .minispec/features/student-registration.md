# Student registration

## Goal

Students register from any machine (browser or `curl`), get a personal code and a case file in the active test's `config.d/`, usable by Teuton immediately.

## Context

- Teuton 3.0.0 reads `tt_include` natively: each `.yaml` file in that directory is one case (flat hash).
- The removed `teuton config --server` form wrote `tt_include` only on shutdown, accepted only POST and let students type their own IP (`docs/demo.md`).
- `tt_include_params` does not exist in Teuton; the panel implements it.
- Identity is a personal code (ADR-004), not the IP.

## Changes

- Form fields come only from `global.tt_include_params` in `config.yaml` (no seed case in `cases:`). Each key is: free text (asked), `AS NAME` / `AS EMAIL` (asked, labelled and validated), `AUTO IP` (request IP, not asked) or a fixed value (not asked).
- Teacher page `/teacher/registration`: edit `tt_include_params`. If the test has none, propose them from `teuton config` (its `TOCHANGE` keys) for the teacher to adjust.
- Write `tt_include` and `tt_include_params` into `config.yaml` as text: replace or add only those keys under `global:`, keep the rest of the file (comments, order) intact. Create the `tt_include` directory if missing.
- Routes: `GET /students/register` (form), `POST /students/register`, and `GET /students/register.txt?field=value…` (or `.json`) to register from `curl`.
- New registration: generate a code (ADR-004), write `config.d/<code>.yaml` immediately with string keys, `tt_panel_code` and `tt_source_ip`; answer with the code and the personal URL `/students/<code>` in large type (HTML) or plain lines (`.txt`), including the `.txt` commands to use next.
- `POST /students/<code>` (form on the personal page) updates that student's data and says the previous data was replaced.
- The form shows the detected IP and explains that `AUTO IP` fields get it, so register from the evaluated machine (or ask the teacher to fix it).
- Validation: required fields; ignore any `tt_panel_code`, `tt_source_ip` or `tt_*` key sent by the client; reject loopback addresses and the panel's own IPs in host fields (otherwise Teuton would run commands on the teacher's machine).
- Registration is opened and closed only with the `student.register` switch (no schedule).
- Filter `tt_include_params` and `tt_panel_code` wherever Teuton output is shown (readme annex, reports).

## Acceptance

- `curl "http://<panel>/students/register.txt?tt_members=Ana"` creates `config.d/<code>.yaml` and prints the code.
- A `teuton run` right after includes the new case, without restarting the panel, and no fake `TOCHANGE` case is ever evaluated.
- A field marked `AUTO IP` is never asked and always equals the caller's IP.
- Sending `host1_ip=127.0.0.1` is refused.
- Saving `tt_include_params` keeps the comments of `config.yaml`.
- With the switch off, registration is refused.
- `teuton check` and `teuton run` still work with `tt_include_params` in `global`.
