# Teacher menu by task

## Goal

Order the teacher menu as a class happens, so a new teacher finds each page where they expect it.

## Context

- The teacher menu has ten flat entries: Home, Tests, Students, Run, Results, History, Registration, Statement, Sessions, Settings (`views/layout.erb`).
- "Registration" ("Alta") holds the registration fields, which are set up before students arrive, but it comes after "History"; its Spanish label is easy to mix up with "Students".
- On narrow screens ten entries plus the language switch take two or three lines.

## Changes

- Group the entries: Prepare (Tests, Registration fields, Statement) · Class (Students, Run, Results, History) · Sessions · Settings. Home stays first.
- Rename "Registration" to "Registration fields" ("Campos del alta", "Camps de l'alta"), matching the page title.
- Show groups as labelled clusters with a small separator, still plain links (no dropdowns, no JavaScript).
- Keep every route as it is.
- Update the teacher guide index and screenshots in en/es/ca.

## Acceptance

- The menu reads in the order of a class: prepare, run the class, archive, settings.
- No route changes; every existing link and test keeps working.
- At 1280 px the menu fits in one line with the language switch; at 500 px it wraps cleanly.
