# Project

## What

`teuton-panel` is a Ruby gem that serves a web panel on top of [Teuton](https://github.com/teuton-software/teuton), the infrastructure-testing tool. Teuton runs the tests; the panel is the interaction layer around it.

## What it does

- Finds Teuton tests (directories with a `start.rb`) under a base directory; without tests it does not start.
- Loads or creates the panel config file, `teuton-panel.yaml`.
- Serves a web app (Sinatra) to manage tests and their cases.
- Planned: run tests once, N times or periodically.
- Planned: remote student registration (web form or `curl`), list of registered students and results, publishing the test's readme.
- Planned: enable or disable each kind of remote access from the panel itself.

## For whom

- Sysadmin teacher: starts the panel on their server, projects results in class and controls what students can do.
- Student: registers, checks results and requests their own run from a browser or from a terminal without GUI (`curl`).

## Goal

Let the teacher use Teuton in class without touching the server during the session.

## Background

- Replaces an older, obsolete version of `teuton-panel` (v2).
- The reference use case and feature list are in `docs/history.md`, `docs/demo.md` and `docs/todo.md` (in Spanish).
- Some features need changes in `teuton config` (`tt_include`, `tt_include_params`).
