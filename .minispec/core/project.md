# Project

## What

`teuton-panel` is a Ruby gem that serves a web frontend for [Teuton](https://github.com/teuton-software/teuton), the infrastructure-testing tool. A teacher starts it on a classroom local network. Teuton runs the tests; the panel drives Teuton and shows its results.

## Two areas

- **Teacher area** — reachable only from `localhost` (the teacher's own machine) and from teacher IPs listed in the panel config. Full control: tests, cases, runs, results, panel settings.
- **Student area** — reachable from the LAN. Only what the teacher enables: registration (which gives a personal code), own run, own results and history, connection status, list of registered students, test readme.
- Every student-area action works from a browser and from `curl` (some students only have a terminal).

## What it does

- Finds Teuton tests (directories with a `start.rb`) under a base directory; without tests it does not start.
- Loads or creates the panel config file, `teuton-panel.yaml`.
- Planned: register students remotely into Teuton's `config.d/` (one file per student).
- Planned: run tests once, N times or periodically; let a student request a run of their own case.
- Planned: show results from Teuton's JSON reports (teacher dashboard for the projector, own grade for each student).
- Planned: publish the test readme (`teuton readme`) to students.

## For whom

- Sysadmin teacher: runs the panel on their machine, projects results in class and decides what students can do.
- Student: registers, checks results and requests their own run from their machine.

## Goal

Let the teacher use Teuton in class without touching the server during the session.

## Teuton version

- Target: `teuton` gem **3.0.0** (latest release, `master`). Not yet declared as a dependency; not installed locally.
- The panel uses Teuton's own functions (CLI) instead of reimplementing them (ADR-002).

## Background

- Supersedes the Java desktop `teuton-panel` v1 (archived as `teuton-software/deprecated-teuton-panel-v1`), `teuton-server`/`teuton-client` (TCP) and the removed `teuton config --server` form. Teuton's `docs/devel/todo.md` §5.1 assigns that work to this gem.
- Reference use case and feature notes: `docs/history.md`, `docs/demo.md`, `docs/todo.md`.
