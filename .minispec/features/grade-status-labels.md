# Grade status labels

## Goal

Make the status of a grade say what it means, with one colour rule shared by the badge and the bar.

## Context

- `row_state` (`app/view_helpers.rb`) labels any grade of 50 or more as "Done" ("Hecho", "Fet"), and below 50 as "Needs work".
- `grade_class` colours the bar with another rule: red below 50, yellow below 80, green from 80.
- A 60 shows "Done" in green next to a yellow bar, although 40% of the work is missing. The student run page also opens with "Done! These are your results" in green for any grade.
- Same labels in the students table, results, run detail, projector tiles and `.txt`/`.json` answers.

## Changes

- Rename the statuses: 100 → "Complete"; 50–99 → "Passed"; below 50 → "Needs work". Keep "Pending", "Disabled", "Connection error" and "Copy?" as they are.
- One rule for colours: the badge and the bar use the same three bands (below 50, 50–99, 100), or the badge drops its colour and only the bar carries it. Pick one and record it in `.minispec/core/design.md`.
- JSON keeps a stable machine value (`status: "passed"`); only the label is translated.
- Translate the new labels in `en.yml`, `es.yml` and `ca.yml`.
- Update the docs' status table (teacher results page) in en/es/ca and retake the screenshots.

## Acceptance

- A 60 never shows "Done"/"Complete"; a 100 shows "Complete".
- The badge and the bar of a row never disagree in colour.
- `lang_test.rb` passes; the projector shows the new labels.
