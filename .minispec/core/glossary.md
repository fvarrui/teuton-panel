# Glossary

## Teuton

Tool (the `teuton` gem) that runs infrastructure tests against remote machines and produces reports. The panel uses it; it does not reimplement it.

## Test / project

A Teuton directory with a `start.rb` (test definition) and its `config.yaml`. In code, `Project`.

## Case

Each machine or student evaluated within a test, defined in `config.yaml`. Can be disabled with `tt_skip: true`.

## Panel config

The `teuton-panel.yaml` file with the panel's settings (e.g. `:run:` with `:every:`, `:times:`, `:delay:`). Not to be confused with Teuton's `config.yaml`.

## `tt_include`

Key in Teuton's `config.yaml` that includes the cases from a directory (usually `config.d/`), one file per student.

## `tt_include_params`

Parameters asked from the student on registration (`AS NAME`, `AS EMAIL`) or filled in automatically (`AUTO IP`, the connection's IP).

## Remote config

A student registering from their own machine (web form or `curl`), which creates their file in `config.d/`.

## Run

Executing a test with Teuton: once, N times (`times`) or periodically (`every`).
