# Test selection

## Goal

The teacher sees every Teuton test found under the base directory and chooses the single active one.

## Context

- `Projects.all` already finds directories with `start.rb` and exits if there are none.
- `App#/` only prints `Project#to_s` and the raw config.
- Registration, runs and results all refer to one active test at a time.

## Changes

- Teacher page `/teacher/tests`: list tests (name, path, has `config.yaml`, cases in `cases:`, files in `tt_include`, `tt_include_params` present).
- Select the active test; persist it in `teuton-panel.yaml`. With a single test, select it automatically.
- Changing the active test asks for confirmation, stops a running loop, and is reported to students by `/students/<code>/status` ("the test has changed, register again").
- Show `teuton check` output for the selected test to catch script/config errors.
- A test without `config.yaml`: create it with `global:` holding `tt_include: config.d` and `tt_include_params` proposed from `teuton config`, and `cases: []` (no seed case). Write it with a short comment header explaining both keys.

## Acceptance

- With two tests in the base directory, the teacher can switch between them (after confirming) and the choice persists.
- A test without `config.yaml` gets one with `tt_include`, proposed `tt_include_params` and no fake case.
- Student routes refer to the active test only.
