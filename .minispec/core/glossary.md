# Glossary

## Teuton

Tool (the `teuton` gem) that runs infrastructure tests against remote machines and produces reports. The panel uses it; it does not reimplement it.

## Test / project

A Teuton directory with a `start.rb` (test definition) and its `config.yaml`. In code, `Project`.

## Active test

The single test the teacher is working with. Registration, runs and results refer to it.

## Case

Each machine or student evaluated within a test: one entry of `cases:` in `config.yaml` or one file in `config.d/`. Teuton numbers cases by position (`case-01`…), so numbers change between runs; the panel identifies students by code.

## Personal code

Short code (e.g. `K7QH`) a student gets on registration; their personal URL is `/students/<code>` (ADR-004). Stored as `tt_panel_code` in their `config.d/<code>.yaml`.

## `tt_panel_disabled`

Panel flag in a student's `config.d/` file: the teacher has disabled them (e.g. absent). The panel leaves them out of every run; Teuton never sees the flag.

## Panel config

The `teuton-panel.yaml` file with the panel's settings. Not to be confused with Teuton's `config.yaml`.

## Data dir

`.teuton-panel/` in the base dir: run directories, results store and archived sessions.

## Teacher area / student area

The localhost (plus allowed IPs) part of the panel and the LAN part (ADR-001).

## `tt_include`

Global key in Teuton's `config.yaml` naming a directory (usually `config.d/`). Each `.yaml`/`.yml`/`.json` file inside is one case, as a flat hash.

## Registration params

`teuton-panel-params.yaml` next to a test's `config.yaml`: the registration fields and how each is filled (`ASK`, `AS NAME`, `AS EMAIL`, `AUTO IP`, fixed value). Called `tt_include_params` in early notes (`docs/`); kept out of `config.yaml` because Teuton 3.0.0 crashes on hash values in `global`.

## `tt_source_ip`

The IP a student registered from. Informative only; identity is the personal code.

## Registration (remote config)

A student registering from any machine (browser or `curl`), which creates their file in `config.d/` and returns their code.

## Run

Executing Teuton on some or all cases of the active test: by the teacher (once, N times, every T seconds) or by a student (own case). Each run has its own run directory.

## Run queue

Orders runs: teacher first, student runs in parallel up to a limit.

## Results store

The panel's record of the latest result of each student, whichever run produced it. Feeds the dashboard, student views and the panel's `moodle.csv`.

## Session

The registrations, results and runs of one class period. "New session" archives them and starts empty.

## `conn_status`

Per-host connection error of a case in Teuton's resume (e.g. `host_unreachable`, `error_authentication_failed`).
