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
