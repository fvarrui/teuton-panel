# ADR-001: Teacher area on localhost, student area on the LAN

## Decision

The panel listens on all interfaces. Teacher routes only answer loopback requests (`127.0.0.1`, `::1`, `::ffff:127.0.0.1`) plus the IPs the teacher lists in `teuton-panel.yaml` (`:teacher: :allow: [...]`). Student routes are reachable from the LAN and each one can be switched off in the panel config. Students are identified by a personal code (ADR-004).

## Motivation

- The panel usually runs on the teacher's machine in a classroom network; the teacher works on that machine and projects it.
- Some teachers run it on a small server and manage it from their laptop (`docs/en/developers/notes/history.md`); an allow-list of teacher IPs covers that without passwords.
- Students must reach registration, their own run and results from their machines, often only with a terminal (`curl`).
- No login system: classroom LAN plus a teacher allow-list is enough protection and keeps setup at zero.

## Consequences

- Teacher and student routes live under separate prefixes so a single `before` filter guards the teacher area.
- IPs are normalized before comparing (`::ffff:a.b.c.d` → `a.b.c.d`).
- Behind a reverse proxy the source IP is wrong; that setup is not supported.
- Anyone using an allowed IP (or a shell on the panel machine) is treated as the teacher.
