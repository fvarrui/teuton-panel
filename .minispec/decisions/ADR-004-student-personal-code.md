# ADR-004: Students are identified by a personal code

## Decision

On registration each student gets a short personal code (e.g. `K7QH`). Routes that act on "my" data carry it in the path: `/students/<code>`, `/students/<code>/run`, `/results`, `/history`, `/status`. The personal URL can be bookmarked; no cookie is needed, though the browser may keep the code in a `code` cookie as a shortcut. The source IP is recorded (`tt_source_ip`) but is no longer the identity. This supersedes the "identified by source IP" part of ADR-001.

## Motivation

- The machine a student uses to talk to the panel is often not the evaluated machine (browser on the host, target in a VM), so the IP is a poor identity.
- VMs behind NAT share the host's IP; DHCP changes IPs between sessions; both broke IP-based identity.
- A code works from any machine, including `curl` from a terminal-only server.

## Consequences

- The code is stored in the student's `config.d/` file as `tt_panel_code` (survives teacher edits; lets the panel find the student in past reports). It is removed from every view and from `teuton readme`.
- Codes: 4–6 uppercase characters from an unambiguous alphabet (no `0/O/1/I/L`), unique within the active test. Routes match codes by that pattern, so fixed routes such as `/students/register` and `/students/readme` never collide.
- No query string to quote in a shell: `curl http://<panel>/students/K7QH/run.txt`.
- An unknown code answers 404 pointing to `/students/register`.
- Case files are named by code: `config.d/<code>.yaml`.
- Re-registration with the code updates that student's file; without a code it is a new registration (the teacher removes duplicates).
- A student who forgets the code asks the teacher, who sees every code in the teacher area. The panel never reveals a code to the student area.
- `AUTO IP` still fills host fields with the request IP, so the registration form says which IP was detected and that registering from the evaluated machine fills it correctly.
- Rate limits apply per code and per IP.
- The code is a convenience, not strong authentication; acceptable inside a classroom LAN.
- Opening a personal page or registering in a browser stores the code in a `code` cookie (one year, HttpOnly): the student menu then shows "My page" and the home fills in the code. It gives no more access than the URL; "Not you?" (`/students/forget`) clears it, and an unknown code in the cookie is cleared. `curl` never gets it.
