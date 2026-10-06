# Test selection

## Goal

The teacher sees every Teuton test found under the base directory and chooses the single active one.

## Context

- `Projects.all` already finds directories with `start.rb` and exits if there are none.
- `App#/` only prints `Project#to_s` and the raw config.
- Registration, runs and results all refer to one active test at a time.

## Changes

- Teacher page `/teacher/tests`: list tests (name, path, has `config.yaml`, cases in `cases:`, files in `tt_include`, params file present).
- Select the active test; persist it in `teuton-panel.yaml`. With a single test, select it automatically.
- Changing the active test asks for confirmation, stops a running loop, and is reported to students by `/students/<code>/status` ("the test has changed, register again").
- Show `teuton check` output for the selected test to catch script/config errors.
- A test without `config.yaml`: create it with `global: {tt_include: config.d}` and `cases: []` (no seed case), with a short comment header; create `teuton-panel-params.yaml` proposed from `teuton config`.

## Acceptance

- With two tests in the base directory, the teacher can switch between them (after confirming) and the choice persists.
- A test without `config.yaml` gets one with `tt_include` and no fake case, plus a proposed params file.
- Student routes refer to the active test only.
