# Glossary

## Teuton

Tool (the `teuton` gem) that runs infrastructure tests against remote machines and produces reports. The panel uses it; it does not reimplement it.

## Test / project

A Teuton directory with a `start.rb` (test definition) and its `config.yaml`. In code, `Project`.

## Active test

The test the teacher is working with in the panel. Runs, registration and results refer to it.

## Case

Each machine or student evaluated within a test: one entry of `cases:` in `config.yaml` or one file in `config.d/`. Teuton numbers cases by position (`case-01`…), so numbers change when files are added.

## Seed case

The first case in `config.yaml` (e.g. `tt_members: TOCHANGE`, `host1_ip: TOCHANGE`). Its keys define the fields a student fills in on registration.

## Panel config

The `teuton-panel.yaml` file with the panel's settings. Not to be confused with Teuton's `config.yaml`.

## Teacher area / student area

The localhost-only part of the panel and the LAN-reachable part (ADR-001).

## `tt_include`

Global key in Teuton's `config.yaml` naming a directory (usually `config.d/`). Each `.yaml`/`.yml`/`.json` file inside is one case, as a flat hash.

## `tt_include_params`

Panel-side rules for registration fields: asked (`AS NAME`, `AS EMAIL`) or filled automatically (`AUTO IP`, the connection's IP). Not a Teuton 3.0.0 feature.

## `tt_source_ip`

The student's IP as seen by the panel, written into their `config.d/` file. Identifies the student.

## Registration (remote config)

A student registering from their own machine (browser or `curl`), which creates their file in `config.d/`.

## Run

Executing the active test with Teuton: once, N times (`times`) or periodically (`every`).

## Resume

Teuton's `var/<test>/resume.json`: grade, members, `moodle_id` and `conn_status` of every case.

## `conn_status`

Per-host connection error of a case in the resume (e.g. `host_unreachable`, `error_authentication_failed`).
