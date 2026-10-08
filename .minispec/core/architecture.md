# Architecture

## Flow

```
bin/teuton-panel → CLI (Thor) → Teuton::Panel.up(basedir) → check teuton 3.x, Projects, Config, RunQueue, Scheduler → App (Sinatra/WEBrick)
App (teacher area | student area) → RunQueue → Runner: teuton subprocess in its own run dir → JSON reports → ResultsStore → views
```

## Key pieces (`lib/teuton/panel/`)

- `cli.rb` — `up` and `version`; an unknown subcommand is a directory for `up`.
- `panel.rb` — facade `up`: check teuton, find tests, load config, `select_test` (forget an active test that no longer exists, auto-select a single test), wire App settings, banner, kill runs at exit. Every teacher page must work with no active test (only test-specific pages answer 409 with a link to Tests).
- `config.rb` — `teuton-panel.yaml` (defaults deep-merged, saved on every change, `datapath`).
- `project.rb` — `Project` (a test) and `Projects.all`; `teuton_config.rb` reads `config.yaml` and adds `tt_include` as text.
- `params.rb` — registration fields file; `registration.rb` builds and validates a student's case values.
- `students.rb` — `config.d/<code>.yaml` registry: codes, create, update, disable, delete.
- `workspace.rb` — paths of a test inside the data dir; `runner.rb` — temp config, teuton subprocess, report parsing; `run_queue.rb` — teacher first and alone, students in parallel; `results_store.rb` — latest result per student, `moodle.csv`; `scheduler.rb` — once / times / every; `history.rb` — run summaries; `sessions.rb` — archive; `readme.rb` — masked `teuton readme`, tidied for Kramdown (fences, lists, `#required-hosts` id); students get `student_markdown` (no version block, only the parameters they type, no SSH note when every host is local); `/teacher/readme?view=students` previews it.
- `lang.rb` + `locales/` — translations; `network.rb` — IP normalize, loopback, own IPs.
- `app.rb` — Sinatra core: settings, helpers (`t`, `format!`, `respond`, `feature!`), area filters, errors; `app/teacher_routes.rb`, `app/student_routes.rb`, `app/view_helpers.rb` reopen `App`.
- `views/` (HTML ERB with `layout.erb`), `views/txt/` (plain-text ERB), `public/` (CSS and OFL fonts).

## Areas (ADR-001, ADR-004, ADR-005)

- Teacher routes accept loopback, this machine's own IPs and the IPs in `:teacher: :allow:`; anything else gets 403.
- Student routes are open to the LAN, each behind an on/off switch; the teacher chooses the formats students get (none closes the area).
- Students are identified by a personal code in the URL (`/students/<code>/...`), not by IP.
- The app runs in Sinatra's `production` environment: no host-name check (students may use the machine's name) and no stack traces.

## Routes

Student area (switch in brackets): `GET /` → `/teacher` for teacher addresses, `/students` for browsers, the `.txt` help for curl (`/.txt`, `/.json` too); redirects carry a one-line text body; `/students` [list] (`.txt` = curl help); `/students/register` GET/POST [register]; `/students/go?code=`; `/students/forget` (clears the `code` cookie); `/students/readme` (`.md`) [readme]; `/students/<code>` GET/POST [register]; `/students/<code>/run` GET/POST [run]; `/students/<code>/results` [results, feedback]; `/students/<code>/history` [history]; `/students/<code>/status` [status].

Teacher area (POST for every change): `/teacher`; `/teacher/tests` + `POST select`; `/teacher/registration`; `/teacher/students` (`?sort=name|grade|registered`, `?show=pending|needs_work|disabled`), `/<code>` (edit and delete), `POST /<code>`, `/<code>/disable`, `/<code>/delete`, `POST /assign`; `/teacher/run` (`?show=pending|needs_work|passed|connection`, `?sort=name|grade`: student picker; `/status`: live part in an iframe) + `POST start|stop`; `/teacher/runs`, `/<id>`; `/teacher/results` (`?projector=1`), `/<key>`; `/teacher/moodle.csv`; `/teacher/readme`; `/teacher/settings`; `/teacher/sessions`, `POST new`, `/<id>`, `/<id>/moodle.csv`.

Format by suffix: none/`.html` → HTML, `.txt` → text, `.json` → JSON (teacher routes: HTML and JSON only). Any route: `?lang=en|es` (remembered in a cookie). Disabled feature or format → 403; unknown route or code → 404 (translated).

## Teuton integration (ADR-002)

- `Runner.command` is `[RbConfig.ruby, Gem.bin_path("teuton", "teuton")]` (works on Windows without `.bat`).
- Each run: `<datadir>/tests/<slug>/runs/<id>/` with a temp `config.yaml` (global scalars + exactly the cases to run, each tagged `tt_panel_key`), `output.log`, Teuton's `var/` and a `summary.json`. Run dirs are the history.
- `tt_panel_key` is the student's code, `cfg-N` for hand-written `cases:` or `file-<name>` for code-less files; the store and history match reports by it.
- Disabled students and `tt_panel_disabled` never reach Teuton; `--case` and `tt_skip` are never used.
- Readme, config proposal and check come from `teuton readme|config|check` stdout.

## Folder map

- `bin/teuton-panel` — installed executable; `teuton-panel` at the repo root — development launcher (`require "debug"`).
- `lib/teuton/panel/` — gem code (see above).
- `test/` — test-unit tests; `runner_test.rb` and `app_test.rb` run the real teuton on the `teuton-sandbox` test.
- `samples/linux-files-basics/` — demo challenge with invented students and history (`reset.rb`); `test/usecases/run.rb` (`rake usecases`) runs every use case against it.
- `docs/` — documentation site (Jekyll + Just the Docs + jekyll-polyglot, its own Gemfile; builds on Linux or Docker, not on RubyInstaller): pages in `en/`, `es/`, `ca/` with shared permalinks, screenshots in `assets/images/<lang>/` taken by `docs/_scripts/screenshots.rb`. Same look as the panel (its OFL fonts in `assets/fonts/`, palette and brand in `_sass/` and `_includes/title.html`, logo and favicon in `assets/images/logo/`); Mermaid diagrams (```mermaid) are rendered in the browser from jsDelivr by `_includes/components/mermaid.html`, one id per diagram. Search is per language: `zzzz-search-data.json` builds `/<lang>/search-data.json` and the theme script copy in `assets/js/just-the-docs.js` loads the page language's index. Published to GitHub Pages on version tags (`v*`) or by hand, so it documents the latest release, not `main`. The `github-pages` environment must allow the `v*` tag rule (besides `main`).
- In the user's base dir: `teuton-panel.yaml`; next to each test `teuton-panel-params.yaml` and `config.d/`; data dir `.teuton-panel/` (`tests/<slug>/runs`, `results.json`, `archive/`).
