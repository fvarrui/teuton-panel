# Architecture

## Flow

```
teuton-panel (executable) → CLI (Thor) → Teuton::Panel.up(basedir) → Projects + Config → App (Sinatra/Puma)
App (teacher area: localhost | student area: LAN) → teuton CLI subprocess → var/<test>/*.json → App views
```

## Key pieces

- `CLI` — subcommands `up`, `new`, `version`. An unknown subcommand is treated as a directory for `up` (`method_missing`).
- `Projects` / `Project` — every directory with a `start.rb` under `basedir` is a Teuton project.
- `Config` — loads `teuton-panel.yaml` from `basedir`; if missing, asks and copies the template from `lib/teuton/panel/files/`.
- `App` — Sinatra app bound to `0.0.0.0:4567`. `up` injects state with `App.set(:panel_projects, ...)` and `App.set(:panel_config, ...)`; routes read it through `settings.panel_*`.
- `version.rb` — `VERSION`, `APPNAME`, `CONFIGFILE`. The only file that defines the `Teuton` module, so it must load before the rest.

## Areas (ADR-001)

- Teacher routes accept only loopback requests (`127.0.0.1`, `::1`); anything else gets 403.
- Student routes are open to the LAN, each one behind an on/off switch in the panel config.
- Students are identified by their source IP (`request.ip`), never by a value they type.

## Teuton integration (ADR-002)

- Teuton is always run as a subprocess (`teuton run|readme|config|check`), with `--no-color`, `--quiet`, `--export=json`, an absolute `--cpath` and a `chdir:` the panel controls.
- Results come from files, not stdout: `var/<test>/resume.json` (index) and `case-NN.json` (detail).
- `teuton readme` and `teuton config` are read from stdout.
- Student registration writes one YAML file per student into the directory named by `tt_include` (usually `config.d/`); Teuton reads them natively.
- Never show raw case reports to students: their `config` section contains every host password.

## Folder map

- `teuton-panel` — executable at the repo root (not in `exe/`).
- `lib/teuton/panel/` — gem code.
- `lib/teuton/panel/files/` — templates copied into the user's directory.
- `lib/teuton/panel/locales/` — GUI texts, `en.yml` and `es.yml` (planned).
- `lib/teuton/panel/public/` — Sinatra static files (does not exist yet).
- `test/` — test-unit tests.
- `docs/` — design notes.
- `private/` — local material, ignored by git.
