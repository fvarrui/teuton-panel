# Students table

## Goal

Make the teacher's students table compact, safe to click and easy to scan in a large class.

## Context

- `views/teacher/students.erb` shows name, code, IP, registration, grade, status and three buttons (Edit, Disable, Delete).
- At 1280 px the buttons do not fit: each row takes two lines and "Delete" sits right under "Edit".
- The registration column shows only the time (`%H:%M:%S`), not the day.
- No sorting or filtering; with 30 students the teacher scrolls to find one.

## Changes

- Keep Edit and Disable as buttons; move Delete to the student's edit page (with its confirmation), out of the table.
- Registration column: time for today, `dd/mm HH:MM` for older days (format from the locale).
- Sort by name, grade or registration with links in the column headers (`?sort=grade`), no JavaScript.
- A filter row: "all / pending / needs work / disabled", as links (`?show=pending`).
- Keep the 15-second auto-refresh, preserving `sort` and `show` in the URL.
- Update the teacher students guide and screenshots in en/es/ca.

## Acceptance

- Every row fits in one line at 1280 px.
- Deleting a student needs two steps (open edit page, confirm).
- Sorting and filtering survive the auto-refresh.
- Rack::Test covers sort and filter parameters, including unknown values.
