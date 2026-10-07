# Run form by mode

## Goal

Show in the "New run" form only the fields of the chosen mode, and make it clear what happens while a run is active.

## Context

- `views/teacher/run.erb` always shows four fields: times, seconds between runs, every (seconds) and until, whatever the mode ("once", "several times", "every few seconds").
- With "once" selected, three of the four fields do nothing.
- While a loop is active the form and its "Start" button stay available, and "Stop" sits at the top right, far from the status box.

## Changes

- Group the fields by mode: "several times" → times and seconds between runs; "every few seconds" → every and until; "once" → none.
- Show and hide the groups without JavaScript: each mode is a radio followed by its fieldset, shown with the CSS `:checked ~` selector. With CSS off, every field still works.
- While a loop is active: replace the form with a short notice ("A run is in progress") and put "Stop" inside the status box.
- No change to `POST /teacher/run/start` parameters or `Scheduler`.
- Update the teacher "Run the test" guide in en/es/ca and retake its screenshots.

## Acceptance

- With "once" selected, no extra fields are visible.
- Switching mode shows only that mode's fields, without reloading.
- While a loop runs, the teacher cannot start a second one from the form and finds "Stop" next to the status.
- Rack::Test: start and stop still work with the same parameters.
