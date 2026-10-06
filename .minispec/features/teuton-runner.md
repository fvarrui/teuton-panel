# Teuton runner

## Goal

One class that runs the `teuton` CLI as a subprocess and returns parsed results, used by every other feature (ADR-002).

## Context

- The panel has no Teuton dependency yet; Teuton 3.0.0 is the target.
- In-process calls are unsafe (ADR-002); results must come from `var/<test>/*.json`.
- Teuton 3.0.0 crashes when any case is skipped, so subsets need a temporary config.

## Changes

- Add `teuton ~> 3.0` to the gemspec as a runtime dependency.
- `Teuton::Panel::Runner` wrapping `Open3`/`spawn`:
  - `run(project, cases: nil)` → `teuton run --no-color --quiet --export=json --cpath=<abs> <project>` with `chdir:` set to the project's directory.
  - `readme(project, lang:)` → stdout of `teuton readme --lang=<lang>`.
  - `config(project)` → stdout of `teuton config` (proposed config, YAML).
  - `check(project)` → stdout of `teuton check`.
- Subset runs: write a temporary config with only the selected cases (main cases + `config.d/` files resolved by the panel), pass it with `--cpath`.
- Parse `resume.json` and `case-NN.json` into plain Ruby objects; a sanitizer that drops `config` and passwords for student views.
- Capture stdout/stderr of every run for the teacher's output log.
- Only one run per test at a time; a second request waits or is rejected.

## Acceptance

- A run against a sample test produces a parsed resume with one grade per case.
- A subset run never passes `--case` nor `tt_skip` to Teuton and still produces reports.
- A failing `start.rb` surfaces Teuton's stderr to the caller, not a silent empty result.
- Unit tests cover the command line built and the JSON parsing (with fixture files).
