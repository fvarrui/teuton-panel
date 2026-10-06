# Architecture

## Flow

```
teuton-panel (executable) → CLI (Thor) → Teuton::Panel.up(basedir) → Projects + Config → App (Sinatra/Puma)
```

## Key pieces

- `CLI` — subcommands `up`, `new`, `version`. An unknown subcommand is treated as a directory for `up` (`method_missing`).
- `Projects` / `Project` — every directory with a `start.rb` under `basedir` is a Teuton project.
- `Config` — loads `teuton-panel.yaml` from `basedir`; if missing, asks and copies the template from `lib/teuton/panel/files/`.
- `App` — Sinatra app on `0.0.0.0:4567`. `up` injects state with `App.set(:panel_projects, ...)` and `App.set(:panel_config, ...)`; routes read it through `settings.panel_*`.
- `version.rb` — `VERSION`, `APPNAME`, `CONFIGFILE`. The only file that defines the `Teuton` module, so it must load before the rest.

## Folder map

- `teuton-panel` — executable at the repo root (not in `exe/`).
- `lib/teuton/panel/` — gem code.
- `lib/teuton/panel/files/` — templates copied into the user's directory.
- `lib/teuton/panel/public/` — Sinatra static files (does not exist yet).
- `test/` — test-unit tests.
- `docs/` — design notes.
- `private/` — local material, ignored by git.
