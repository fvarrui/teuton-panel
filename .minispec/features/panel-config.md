# Panel config

## Goal

Define and manage `teuton-panel.yaml`: created with useful defaults, editable from the teacher area, saved on change.

## Context

- Today the template only has `:run: {:every:, :times:, :delay:}`.
- `Config` asks in the terminal (`tty-prompt`) before creating the file and exits if the answer is no.
- `docs/todo.md` lists `panel/new` and `panel/save`; the old prototype only wrote config on shutdown (`docs/demo.md`).

## Changes

- Define the schema: server (`:bind:`, `:port:`), `:language:` (fallback GUI language, default `es`), active test, run settings, student switches, reports location (the working directory Teuton runs in; it writes `var/<test>/` there).
- Create the file with defaults on first start, without asking; print a notice. Drop `tty-prompt` if nothing else uses it.
- `Config#save` writes immediately; never on shutdown only.
- Teacher page to view and change settings.
- Remove the `teuton-panel new` command (tests are created with `teuton new`).

## Acceptance

- Starting in a directory without `teuton-panel.yaml` creates it and the panel starts.
- Changing a setting from the teacher page is persisted and survives a restart.
- Unknown or missing keys fall back to defaults without crashing.
