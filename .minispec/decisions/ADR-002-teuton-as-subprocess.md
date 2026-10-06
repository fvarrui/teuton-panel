# ADR-002: Run Teuton 3.0.0 as a subprocess

## Decision

The panel calls the `teuton` CLI as a child process for every operation (`run`, `readme`, `config`, `check`) and reads results from the JSON reports it writes. It never calls `Teuton.run` and the like in-process.

## Motivation

Teuton 3.0.0's Ruby API is not safe to call repeatedly from a long-lived server:

- All state is global (`Project` singleton) and keeps growing between calls; case ids use a class variable.
- `start.rb` is loaded with `require_relative`, so a second `Teuton.run` in the same process does nothing.
- `run`, `check` and `readme` define different top-level DSL methods on `Object`; loading one overwrites the other.
- It calls `exit 1` on many errors, prints to stdout and writes to `var/` relative to `Dir.pwd`.
- `require "teuton"` alone does not load `Teuton::VERSION`, which `run` needs.

## Consequences

- Each run is a separate process: isolated, killable, with its own working directory and stdout capture.
- Options used: `--no-color`, `--quiet`, `--export=json`, absolute `--cpath`, `spawn`/`Open3` with `chdir:`.
- Teuton numbers cases by position and always writes `var/<testname>/case-NN.*`, `resume.*` and `moodle.csv`; a partial run (one student, a selection) would overwrite the class reports. Every run therefore gets its own working directory, and the panel keeps the latest result of each student in its own results store.
- Known Teuton 3.0.0 bugs to work around until fixed upstream:
  - Any skipped case (`tt_skip: true` or `--case=N`) crashes the run before reports are written (`Settings.letter(:skip)`). To run a subset, generate a temporary config with only those cases and pass it with `--cpath`.
  - Errors in `start.rb` are hidden by a broken `Rainbow.new(...)` call; show stderr as-is.
  - CLI argument errors exit with status 0; check the report files, not only the exit code.
  - A hash value in `config.yaml` `global` (e.g. `key: {a: 1}`) crashes the resume TXT export (`BaseFormatter#trim` slices it like a string), so no JSON is written either. Keep `global` values scalar; panel data goes in its own files.
  - `tt_outdir` only moves `resume.*` and `moodle.csv`; case reports always go to `var/<testname>/`.
- Case reports include every config value, passwords included, even with `export feedback: false`; the panel must filter them before showing anything to students.
- The panel declares `teuton ~> 3.0` as a runtime dependency and finds the executable through RubyGems/Bundler.
