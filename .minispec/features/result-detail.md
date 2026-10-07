# Result detail

## Goal

Make the teacher's result detail useful at a glance and quick to go through student by student.

## Context

- `views/teacher/result_detail.erb` shows each target with command, expected and output.
- The "Command" column shows Teuton's shortened command (`ruby -e "..."`), the same for every row: it takes space and tells nothing.
- To see the next student the teacher goes back to Results and opens another row.

## Changes

- Drop the "Command" column; show the full command in a `title` tooltip on the target name when Teuton exports it.
- Add "Previous" and "Next" links, following the order of the Results page.
- Keep "Back" to Results.
- Update the teacher results guide and screenshot in en/es/ca.

## Acceptance

- The table has target, expected and output only.
- "Next" on the last student and "Previous" on the first are hidden.
- Rack::Test: the links point to the neighbouring students' detail pages.
