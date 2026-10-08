# Student picker for runs

## Goal

Let the teacher choose who to evaluate from a table with each student's grade and state, with filters for the usual groups, instead of a bare list of names.

## Context

- `views/teacher/run.erb` lists every case as a checkbox with the name only: enabled students checked, disabled ones greyed out.
- The teacher cannot see grades, states or connection problems there; picking "only those who need work" means unticking students one by one.
- The run form shares a two-column grid with the status iframe, so a table does not fit.
- The students page already has state-based filters and sorting (`sort_and_filter`, `STUDENT_FILTERS`, `state_key`, `short_time`, `grade_bar`, `state_badge`).
- `POST /teacher/run/start` takes `keys[]`; all enabled keys mean a whole-class run (`full`), fewer a `selection`.

## Changes

- Layout: the status box goes on top (full width, compact); the "New run" form below takes the full width: mode and its fields, then the student table, then "Start" (also repeated above the table when there are many rows).
- Student table: checkbox, name, grade bar, state badge, last evaluated (`short_time`). Disabled students at the end, greyed, without checkbox.
- Filters as links (`?show=`): All · Pending · Needs work · Passed (not complete) · Connection problem. A filter shows only those students, all checked; "Start" evaluates exactly the checked rows. Unknown values fall back to All. Filter labels come from the state labels.
- Sorting by name or grade with links in the headers (`?sort=`), keeping `show`.
- Progressive enhancement with a few lines of inline JavaScript (ADR-003: only where really needed): a header checkbox to tick or untick every visible row, and a live "N selected" counter next to "Start". Without JavaScript the page works the same, minus those two shortcuts.
- Empty filter result: a short message and no "Start" button.
- Reuse the students page helpers; extend the filter list for runs (`passed`, `connection`) without changing the students page.
- No change to `POST /teacher/run/start`, the scheduler or the queue; settings already remembered (mode, times, every) keep working.
- Translate new strings in `en.yml`, `es.yml` and `ca.yml`; update the "Run the test" guide (en/es/ca) and retake the run screenshots.

## Acceptance

- The run page shows a table with grade and state for every student.
- `/teacher/run?show=needs_work` lists only students below 50, all checked, and "Start" queues a `selection` run with exactly their keys.
- With every enabled student checked, the run is still `full`.
- Disabled students cannot be selected.
- With JavaScript on, the header checkbox ticks and unticks all visible rows and the counter follows; with JavaScript off, the form still submits the ticked rows.
- Rack::Test covers each filter, unknown filter and sort values, and the keys sent for a filtered start.
