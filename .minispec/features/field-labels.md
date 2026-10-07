# Field labels and help

## Goal

Let the teacher give each registration field a readable label and a short help, so students and the teacher stop seeing Teuton keys.

## Context

- `teuton-panel-params.yaml` stores `field => mode` (`ASK`, `AS NAME`, `AS EMAIL`, `AUTO IP` or a fixed value). There is nowhere to put a label.
- `field_label` gives fixed labels to `AS NAME` and `AS EMAIL` ("Your name", "Your email"); other asked fields are titled with the capitalised key ("Home").
- Under every field of the registration form and "My data", a hint shows the raw key (`tt_members`, `tt_moodle_id`, `home`).
- The teacher's student edit page lists raw keys (`tt_members`, `host1_ip`, `tt_source_ip`) and lets the teacher change `tt_source_ip`, which the panel sets itself.
- The "Value" column of the fields page is shown for every mode, though only fixed values use it.

## Changes

- Allow an extended form per field in `teuton-panel-params.yaml`: `home: {mode: ASK, label: "Your home folder", help: "As in /home/<name>"}`. The current `field: MODE` form keeps working.
- `Params.load` returns mode, label and help; `Params.save` writes the short form when there is no label or help.
- Fields page: add label and help inputs; disable the fixed-value input unless the mode is "fixed value".
- Registration form and "My data": label from the teacher's text (or the current default); the hint shows the teacher's help, never the key.
- Student edit page: label plus the key in small text; `tt_source_ip` and `tt_panel_code` shown read-only.
- `curl` commands keep using the keys (they are the parameter names).
- Label and help are student-supplied-like text: escape them in HTML; validate with the same character rule as typed values.
- Update the docs (registration fields page) in en/es/ca and retake screenshots.

## Acceptance

- A teacher can set "Your home folder" for `home`; students see that label and help, and never `home`.
- An old `teuton-panel-params.yaml` loads and saves without changes.
- The teacher cannot edit `tt_source_ip` or the code.
- Tests cover loading both forms and saving the short form back.
