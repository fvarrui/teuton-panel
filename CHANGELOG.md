## [0.3.1] - 2026-10-08

- [ADD] teuton-panel logo: three stacked panels in Teuton's colours with a white T. In the panel's top bar, student home, projector header and favicon (SVG, with PNG fallbacks), and in the documentation and the README.
- [UPDATE] Panel and documentation palette taken from the Teuton logo: charcoal ink, deep green actions, Teuton green accents and sage greys. "Passed" grades are sage and "Complete" green.
- [DOC] Install instructions use the `.gem` attached to the GitHub release (teuton-panel is not on RubyGems yet).
- [DOC] Documentation with the panel's look, Mermaid diagrams of the architecture flow, and search in the page's language.

## [0.3.0] - 2026-10-07

Usability review of the teacher and student areas.

- [FEATURE] `/` takes each visitor to the right place: the teacher to `/teacher`, browsers to `/students`, `curl` to the plain-text help (`/.txt` and `/.json` too).
- [FEATURE] Teacher menu grouped by task: Home, Prepare (Tests, Registration fields, Statement), Class (Students, Run, Results, History), Sessions, Settings.
- [FEATURE] Labels and help for registration fields (`field: {mode:, label:, help:}` in `teuton-panel-params.yaml`); students never see the keys; `tt_source_ip` is read-only for the teacher.
- [FEATURE] Grade states Complete (100), Passed (50–99) and Needs work (< 50), with the same colours in badges and bars; JSON rows carry a `status` value.
- [FEATURE] Class summary (average, passed, complete, not evaluated) on the teacher home, Results and the projector; also in `/teacher.json`.
- [FEATURE] Students table: one line per student, sorting and filters, registration day for older registrations; Delete moved to the edit page.
- [FEATURE] Result detail with Previous/Next; the shortened command moves to a tooltip.
- [FEATURE] Run form shows only the fields of the chosen mode; while a loop runs, Stop sits in the status box.
- [FEATURE] The browser remembers the student's code: My page in the menu, code filled in on the home, Not you? to forget it.
- [FEATURE] Student runs in the browser show their progress and never run twice on reload (Post/Redirect/Get); Run again button; neutral finished message.
- [FEATURE] Cleaner statement for students (no Teuton version block, only typed parameters, no SSH note on local hosts); the teacher can preview both versions.
- [UPDATE] Settings: a Save button per section, no IP placeholders that look like values, help for the run interval and the registered list; the teacher home reminds when students can see who is registered.
- [FIX] Only one menu tab is marked as current.
- [FIX] Statement lists, header block and HOST1 link render correctly.
- [FIX] The run page no longer reloads while the teacher fills in the form (live status in an iframe).
- [FIX] Spanish and Catalan teacher pages without English or Teuton jargon.
- [DOC] Guides, FAQ and screenshots updated in English, Spanish and Catalan.

## [0.2.0] - 2026-10-07

- [FEATURE] Catalan GUI (`ca`), chosen from `Accept-Language`, `?lang=ca` or the default language; the test statement falls back to Spanish because `teuton readme` only writes English and Spanish.
- [FEATURE] Settings: addresses shown to students (`:server: :addresses:`), for when the detected IPs are not the ones students should use.
- [UPDATE] Quieter run logs: Teuton runs without Ruby warnings, and an empty log is no longer shown.
- [UPDATE] Compact navigation bar.
- [DOC] Documentation site in English, Spanish and Catalan with teacher and student guides, every use case, FAQ, developer section and screenshots: https://fvarrui.github.io/teuton-panel/
- [ADD] `rake docs:screenshots` retakes the documentation screenshots.

## [0.1.1] - 2026-10-07

- [FIX] Validate values typed by students (and edited by the teacher): letters, digits, spaces and `. _ - @ : /`, 100 characters at most; typed values reach the test's commands.
- [FIX] Teacher home no longer fails without an active test; a missing active test is forgotten at startup and a single test is selected again.
- [FIX] The teacher can edit students whose host is a fixed value such as `localhost`.
- [FIX] Find tests from Windows paths with backslashes and when the base dir is the test itself.
- [ADD] `samples/linux-files-basics`: demo challenge with invented students and history (`reset.rb`).
- [ADD] `rake usecases`: every use case run against the sample.
- [DOC] README warning about typed values in test commands.

## [0.1.0] - 2026-10-07

- [FEATURE] Web panel on Sinatra/WEBrick: teacher area (localhost, own IPs, allow-list) and student area (LAN).
- [FEATURE] Student registration with personal codes into Teuton's `config.d/`; fields in `teuton-panel-params.yaml`.
- [FEATURE] Teacher runs once, N times or periodically; student runs of their own case through a run queue.
- [FEATURE] Results store, dashboard with projector mode, `moodle.csv`, run history and class sessions.
- [FEATURE] Formats by URL suffix (`.txt`, `.json`), switchable per feature and per format.
- [FEATURE] English and Spanish GUI; offline fonts and plain CSS.
- [FEATURE] Test statement from `teuton readme`, without passwords.
- [FIX] Gem loading order, packaging (`bin/teuton-panel`) and tests.
- [UPDATE] Depend on `teuton ~> 3.0`, `kramdown` and `webrick`; drop `puma` and `tty-prompt`.
