## [Unreleased]

- [FEATURE] Web panel on Sinatra/WEBrick: teacher area (localhost, own IPs, allow-list) and student area (LAN).
- [FEATURE] Student registration with personal codes into Teuton's `config.d/`; fields in `teuton-panel-params.yaml`.
- [FEATURE] Teacher runs once, N times or periodically; student runs of their own case through a run queue.
- [FEATURE] Results store, dashboard with projector mode, `moodle.csv`, run history and class sessions.
- [FEATURE] Formats by URL suffix (`.txt`, `.json`), switchable per feature and per format.
- [FEATURE] English and Spanish GUI; offline fonts and plain CSS.
- [FEATURE] Test statement from `teuton readme`, without passwords.
- [FIX] Gem loading order, packaging (`bin/teuton-panel`) and tests.
- [UPDATE] Depend on `teuton ~> 3.0`, `kramdown` and `webrick`; drop `puma` and `tty-prompt`.

## [0.1.0] - 2026-06-02

- Initial release
