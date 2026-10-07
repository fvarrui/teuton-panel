# Settings form

## Goal

Make the settings page clear about what is filled in and quicker to save.

## Context

- `views/teacher/settings.erb`: "Addresses shown to students" and "Other teacher IPs" use `192.168.1.10` as placeholder. On an empty field it looks like a value already saved.
- "Seconds between runs of the same student" has no help; "0" does not say that it means "no limit".
- The page is long and has one "Save" button at the bottom.

## Changes

- Replace IP placeholders with an explicit example in the help text ("For example: 192.168.1.10, 192.168.1.11") and leave the inputs without placeholder.
- Add help under the student run interval: what 0 means and the current default.
- Add a "Save" button at the end of each section (same form, same action).
- After saving, show the confirmation next to the section that was saved, or at the top with a link to it.
- Update the settings guide and screenshot in en/es/ca.

## Acceptance

- An empty IP field looks empty.
- Each section can be saved without scrolling to the bottom.
- Saving keeps every other setting unchanged (Rack::Test).
