# Run page reload wipes the form

## Problem

While a run or loop is active, `/teacher/run` reloads itself every 10 seconds. A teacher who is filling in the "New run" form (times, interval, students) loses what they typed.

## Cause

`views/teacher/run.erb` sets `@refresh = 10` when a loop or a queued run is active; the layout turns it into `<meta http-equiv="refresh">`, which reloads the whole page, form included.

## Solution

- Do not reload the page that holds the form.
- Move the live part (status, queue, last run) to a fragment that refreshes on its own: an `<iframe>` pointing to a small status view with its own meta refresh, so no JavaScript or framework is needed (ADR-003).
- Keep `/teacher/run.json` as it is (the screenshots script and tests read it).

## Verification

- With a periodic loop active, typing in the form and waiting 30 seconds keeps the typed values.
- The status box still updates (pass number, queue) without reloading the page.
- Rack::Test: `/teacher/run` has no meta refresh; the status view has one while a loop is active and none when idle.
