# Who-is-registered list: make the default visible

## Goal

Make sure the teacher knows that every student sees the list of registered names, and can turn it off before class.

## Context

- `student.list` defaults to `true` (`config.rb`): the student home shows every registered name, with a connection dot.
- It helps the class see who is missing, but some teachers may not want names shown to the whole class.
- The setting exists ("See who is registered" in Settings), but nothing points to it.

## Changes

- Student home: no change in behaviour.
- Teacher home: when the list is on, a one-line hint under "Where students connect": "Students can see who is registered. Change it in Settings." with a link.
- Settings: short help under "See who is registered" explaining what students see (names only, never codes or IPs).
- Ask the user before changing the default to `false`; if changed, record the reason in `.minispec/core/project.md`.
- Update the settings and FAQ pages in en/es/ca.

## Acceptance

- With the list on, the teacher home shows the hint; with it off, it does not.
- The help text says exactly what students see.
