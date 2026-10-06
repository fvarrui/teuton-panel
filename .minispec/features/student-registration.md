# Student registration

## Goal

Students register from their machine (browser or `curl`) and get a case file in the active test's `config.d/`, usable by Teuton immediately.

## Context

- Teuton 3.0.0 reads `tt_include` natively: each `.yaml` file in that directory is one case (flat hash).
- The removed `teuton config --server` form did this, but wrote `tt_include` into `config.yaml` only on shutdown, accepted only POST, and let students type their own IP (`docs/demo.md`).
- `tt_include_params` does not exist in Teuton; the panel implements it.

## Changes

- On start (or when the test is selected), ensure `global.tt_include` exists in `config.yaml` and the directory exists.
- Form fields come from the seed case's keys, minus `tt_source_ip`/`tt_source_file`.
- `tt_include_params` in `config.yaml` `global`, next to `tt_include`: `AS NAME` / `AS EMAIL` → labelled field; `AUTO IP` → filled with `request.ip`, not shown; a fixed value → not asked. Teuton stores it as one more global value; filter it out wherever global values are shown (readme annex).
- Routes: `GET /register` (form), `POST /register`, and `GET /register?field=value…` for `curl`.
- Write `config.d/from_<ip>.yaml` immediately, string keys, with `tt_source_ip`.
- Re-registration from the same IP: overwrite the file and tell the student their previous data was replaced (lets them fix typos without the teacher).
- Validate required fields; reply with a summary (HTML or plain text).
- Switch: `student.register`.

## Acceptance

- `curl "http://<panel>/register?tt_members=Ana"` creates `config.d/from_<ip>.yaml` with `tt_source_ip` set to the caller's IP.
- A `teuton run` right after includes the new case, without restarting the panel.
- A field marked `AUTO IP` is never asked and always equals the caller's IP.
- With the switch off, registration is refused.
- `teuton check` and `teuton run` still work with `tt_include_params` in `global`.
