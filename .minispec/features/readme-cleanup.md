# Cleaner statement for students

## Goal

Show students a statement with the task only, without Teuton's technical header and internal parameters.

## Context

- `teuton readme` output starts with a code line "Date : ... Teuton : 3.0.0", says "NOTE: SSH Service installation is required on every host" even when the host is `localhost`, and lists the test's internal parameters (`host1_password`, `host1_username`...), some of them fixed by the teacher.
- Teuton's Spanish text has a typo ("Parámetros de necesarios").
- The panel already post-processes the text (`Readme.mask` hides passwords; `readme-lists` fixes lists).

## Changes

- Student statement: drop the date/version line; drop the parameters section, or keep only the fields students type at registration (from `teuton-panel-params.yaml`).
- Drop the SSH note when every host of the active test resolves to `localhost` in the registration fields.
- Teacher preview keeps the full text, with a note that students see the cleaned version, and a toggle to preview the student version.
- Report the typo and the SSH note wording to Teuton; do not patch translated text in the panel.
- Update the statement pages of the guide in en/es/ca and retake screenshots.

## Acceptance

- `/students/readme` has no Teuton version line and no internal parameter names.
- `/teacher/readme` shows the full text and can show the student version.
- Passwords stay masked in both.
