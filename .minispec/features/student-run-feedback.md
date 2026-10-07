# Student run feedback

## Goal

Show a student what is happening while their run waits and finishes, and let them run again from their results.

## Context

- "Run my test" posts to `/students/<code>/run`; the request waits up to `WAIT_SECONDS` (120 s) for the result, with a blank loading page.
- Reloading that page resubmits the POST and asks for another run.
- When the run is queued or will happen in the teacher's next pass ("you will be evaluated at 17:03:25"), the page never updates by itself.
- A finished run opens with "Done! These are your results" in a green box, also for a 30.
- "My results" has only "Back"; to run again the student goes back to their page.

## Changes

- Browser flow (HTML) follows Post/Redirect/Get: the POST queues the request and redirects to `/students/<code>/run` (GET), which shows the state.
- The GET page refreshes itself every few seconds while the state is queued, running or waiting for the next pass, and stops when there is a result.
- Plain `curl` keeps the current behaviour: `GET /students/<code>/run.txt` waits and prints the result (conventions). Only the HTML GET of a pending run shows the state instead of starting another one.
- Finished run: neutral heading ("Your run has finished") and the grade colour from `grade-status-labels`.
- "Run again" button on the run result and on "My results", when student runs are enabled and the run interval allows it.
- Update the student guide and screenshots in en/es/ca.

## Acceptance

- Reloading the waiting page never queues a second run.
- A queued run updates to its result without the student touching anything.
- `curl .../run.txt` behaves as before (usecases run passes).
- Rack::Test covers POST → redirect, GET while pending (refresh present) and GET with result (no refresh).
