---
title: Class sessions
parent: Teacher guide
nav_order: 8
lang: en
permalink: /teacher/sessions/
---

# Class sessions

Use case <span class="uc-id">T10</span>.
{: .fs-3 }

Registrations, results and run history stay on disk between restarts. When a class ends (another day, another group), start a new session so the next class starts clean.

## Archive the current session

On **Sessions**, type an optional name (for example *ASIR 1 - Group A*) and press **Archive and start a new session**. After confirming:

- registrations (`config.d/` files), results and runs move to an archive folder named by date and time;
- the student list and the results are empty, and the old personal codes stop working;
- nothing is deleted.

You cannot archive while a run is active: stop it first.

{% include screenshot.html file="teacher-sessions" alt="Class sessions" %}

## Consult an archived session

**Open** shows the students of an archived session with their codes and grades; the `moodle.csv` button downloads that session's grades.

{% include screenshot.html file="teacher-session" alt="An archived session" %}

Archived sessions are stored in `.teuton-panel/archive/<test>/<date>/` in the base directory.
