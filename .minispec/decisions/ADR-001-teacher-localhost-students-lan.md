# ADR-001: Teacher area on localhost, student area on the LAN

## Decision

The panel listens on all interfaces, but teacher routes only answer loopback requests (`127.0.0.1`, `::1`). Student routes are reachable from the LAN and each one can be switched off in the panel config. Students are identified by their source IP.

## Motivation

- The panel runs on the teacher's machine in a classroom network; the teacher works on that machine and projects it.
- Students must reach registration, their own run and results from their machines, often only with a terminal (`curl`).
- No login system: the classroom LAN plus loopback-only teacher routes is enough protection and keeps setup at zero.
- Using the source IP avoids students mistyping their own IP (problem seen with the old config server, `docs/demo.md`).

## Consequences

- Teacher and student routes live under separate prefixes so a single `before` filter can guard the teacher area.
- Behind a reverse proxy or NAT the source IP is wrong; that setup is not supported.
- Two students behind the same IP cannot be told apart; registration from an already registered IP overwrites (or must be confirmed by the teacher).
- A teacher who wants to manage the panel from another machine has to use SSH port forwarding.
