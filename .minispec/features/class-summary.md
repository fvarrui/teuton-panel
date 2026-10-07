# Class summary

## Goal

Tell the teacher how the class is doing in one line, on the home, results and projector pages.

## Context

- The teacher home shows how many students are registered and evaluated, and the run status; no grades.
- Results and the projector list each student, but there is no average, no count of who passed, and no list of who was never evaluated.
- `ResultsStore` already has the last result per student.

## Changes

- A small summary from the active students' last results: average grade, how many have 50 or more, how many are complete (100), how many are pending (never evaluated).
- Show it as a strip of four figures on the teacher home (linking to Results), on top of Results, and in the projector header.
- Disabled students are left out of every figure.
- Add the summary to `/teacher/results.json`.
- Update the teacher guide (home, results, projector) and screenshots in en/es/ca.

## Acceptance

- With the sample (`reset.rb`), the figures match the Results table.
- Disabling a student changes the figures after the next refresh.
- Tests cover an empty class (no division by zero, "—" instead of an average).
