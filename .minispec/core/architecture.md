# Architecture

## Flow

```
teuton-panel (executable) → CLI (Thor) → Teuton::Panel.up(basedir) → Projects + Config → App (Sinatra/Puma)
App (teacher area | student area) → run queue → teuton CLI subprocess (own run dir) → JSON reports → results store → views
```

## Key pieces

- `CLI` — subcommands `up` and `version`. An unknown subcommand is treated as a directory for `up` (`method_missing`).
- `Projects` / `Project` — every directory with a `start.rb` under `basedir` is a Teuton project.
- `Config` — loads `teuton-panel.yaml` from `basedir`; created with defaults when missing.
- `App` — Sinatra app bound to `0.0.0.0:4567`. `up` injects state with `App.set(...)`; routes read it through `settings.panel_*`.
- `Runner`, run queue, results store — run Teuton and keep the latest result per student (planned, `teuton-runner`).
- `version.rb` — `VERSION`, `APPNAME`, `CONFIGFILE`. The only file that defines the `Teuton` module, so it must load before the rest.

## Areas (ADR-001, ADR-004)

- Teacher routes accept loopback requests and the IPs listed in `:teacher: :allow:`; anything else gets 403.
- Student routes are open to the LAN, each one behind an on/off switch in the panel config; the teacher also chooses which formats (HTML, text, JSON) students get, and none closes the student area (ADR-005).
- Students are identified by a personal code given at registration, carried in the URL (`/students/<code>/...`), not by IP.

## Routes

Student area (LAN; switch in brackets). `<code>` matches the personal code pattern only.

- `GET /` → redirect to `/students`.
- `GET /students` — home and members list [list]; `/students.txt` is the usage help for `curl`.
- `GET|POST /students/register` — registration form / submit; GET with params registers from `curl` [register].
- `GET /students/readme` — test statement [readme].
- `GET /students/<code>` — personal page; `POST` updates own registration data [register].
- `GET|POST /students/<code>/run` — run own case [run].
- `GET /students/<code>/results` — latest grade and feedback [results, feedback].
- `GET /students/<code>/history` — grades per run of the session [history].
- `GET /students/<code>/status` — connection result of the last run [status].

Teacher area (localhost + allowed IPs). POST for every change.

- `/teacher` — home: active test, student URLs, run status.
- `/teacher/tests`, `POST /teacher/tests/select` — tests, `teuton check`, active test.
- `/teacher/registration` — `tt_include_params` editor.
- `/teacher/students`, `/teacher/students/<code>`, `POST .../<code>`, `POST .../<code>/delete`, `POST /teacher/students/new` — registrations.
- `/teacher/run`, `POST /teacher/run/start`, `POST /teacher/run/stop`; `/teacher/runs`, `/teacher/runs/<id>` — runs and history.
- `/teacher/results` (`?projector=1`), `/teacher/results/<code>`, `/teacher/moodle.csv` — results.
- `/teacher/readme` — readme preview.
- `/teacher/settings` — panel config.
- `/teacher/sessions`, `POST /teacher/sessions/new`, `/teacher/sessions/<id>` — class sessions.

Format by suffix (ADR-005): none/`.html` → HTML, `.txt` → plain text, `.json` → JSON (`readme.md`, `moodle.csv`). Any route: `?lang=en|es`. Static files from `public/` (`/css/style.css`). Disabled feature or teacher route from outside → 403; unknown route or code → 404 (translated).

## Teuton integration (ADR-002)

- Teuton is always run as a subprocess (`teuton run|readme|config|check`), with `--no-color`, `--quiet`, `--export=json` and an absolute `--cpath` to a temporary config holding exactly the cases to run.
- Every run has its own working directory under the data dir (`.teuton-panel/runs/`), so partial runs never overwrite other results. Run directories are the run history.
- A queue serializes work: teacher runs first, student runs in parallel up to `:runs: :max_parallel:`.
- After each run the panel updates its results store (latest result per student, keyed by `tt_panel_code`). Dashboard, student views and the panel's `moodle.csv` read from the store.
- Registration writes one YAML file per student (`config.d/<code>.yaml`) into the `tt_include` directory; Teuton reads them natively. Form fields come from `tt_include_params`.
- Writes to the teacher's `config.yaml` touch only `tt_include` and `tt_include_params`, as text, keeping comments.
- Never show raw case reports: their `config` section contains every host password.

## Folder map

- `teuton-panel` — executable at the repo root (not in `exe/`).
- `lib/teuton/panel/` — gem code; `views/` (ERB), `public/` (CSS), `locales/` (`en.yml`, `es.yml`), `files/` (templates copied to the user) — planned except `files/`.
- `test/` — test-unit tests.
- `docs/` — design notes.
- In the user's base dir: `teuton-panel.yaml` and the data dir `.teuton-panel/` (runs, results store, archive).
