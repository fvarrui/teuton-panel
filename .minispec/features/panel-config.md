# Panel config

## Goal

Define and manage `teuton-panel.yaml`: created with useful defaults, editable from the teacher area, saved on change; show students where to connect.

## Context

- Today the template only has `:run: {:every:, :times:, :delay:}`.
- `Config` asks in the terminal (`tty-prompt`) before creating the file and exits if the answer is no.
- `docs/todo.md` lists `panel/new` and `panel/save`; the old prototype only wrote config on shutdown (`docs/demo.md`).
- Students need to know the panel's URL; the teacher machine may have several interfaces (VirtualBox adapters).

## Changes

- Schema: `:server:` (`:bind:`, `:port:`), `:language:` (fallback GUI language, default `es`), `:teacher: :allow:` (extra teacher IPs, default empty), active test, `:run:` (loop settings), `:runs:` (`:max_parallel:`, default 4), `:student:` switches, `:formats:` (`[html, txt, json]` by default) and `:run_interval:`, data dir (default `.teuton-panel/` in the base dir: run directories, results store, archive).
- Create the file with defaults on first start, without asking; print a notice. Drop `tty-prompt` if nothing else uses it.
- `Config#save` writes immediately; never on shutdown only.
- Teacher page to view and change settings, including the student formats (HTML / text / JSON checkboxes) with a clear warning when none is checked: the student area is closed.
- Remove the `teuton-panel new` command (tests are created with `teuton new`).
- Startup banner: app name, version, base dir, active test and one student URL per non-loopback interface (`Socket.ip_address_list`, no external connection) plus the `curl` help command (`curl http://<ip>:<port>/students.txt`); the same on the teacher home and in projector mode.

## Acceptance

- Starting in a directory without `teuton-panel.yaml` creates it and the panel starts.
- Changing a setting from the teacher page is persisted and survives a restart.
- Unknown or missing keys fall back to defaults without crashing.
- The banner lists every LAN URL students can use.
