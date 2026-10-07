# Two menu tabs marked as current

## Problem

- Student area: "Home" is marked as current on every student page, together with the real one (Register, Statement, personal pages).
- Teacher area: on `/teacher/runs` and `/teacher/runs/<id>`, both "Run" and "History" are marked.

## Cause

`nav_link` (`app/view_helpers.rb`) marks a tab when the request path starts with the tab's path. Only `/teacher` is excluded from the prefix match, so `/students` matches every student route, and `/teacher/run` matches `/teacher/runs`.

## Solution

- Match a tab when the path is equal to it or starts with it followed by `/` (`/teacher/run` must not match `/teacher/runs`).
- Treat both area homes (`/teacher`, `/students`) as exact matches only.
- Personal pages (`/students/<code>/...`) mark no tab until `student-code-memory` adds "My page".
- Add `aria-current="page"` to the current link.

## Verification

- Rack::Test: on `/teacher/runs` only "History" has the `current` class; on `/teacher/run` only "Run"; on `/students/register` only "Register"; on `/students` only "Home".
- Visual check of the teacher and student menus.
