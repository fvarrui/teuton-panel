# Test selection

## Goal

The teacher sees every Teuton test found under the base directory and chooses the active one.

## Context

- `Projects.all` already finds directories with `start.rb` and exits if there are none.
- `App#/` only prints `Project#to_s` and the raw config.
- Registration, runs and results all need an active test.

## Changes

- Teacher page `/teacher/tests`: list tests (name, path, has `config.yaml`, number of cases, `tt_include` present).
- Select the active test; persist it in `teuton-panel.yaml`. With a single test, select it automatically.
- Show `teuton check` output for the selected test to catch script/config errors.
- Use `teuton config` to propose a `config.yaml` when the test has none, and create it with `global: {tt_include: config.d}` plus a seed case.

## Acceptance

- With two tests in the base directory, the teacher can switch between them and the choice persists.
- A test without `config.yaml` gets one created that includes `tt_include: config.d` and a seed case.
- Student routes refer to the active test only.
