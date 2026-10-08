---
title: Running the test
parent: Teacher guide
nav_order: 5
lang: en
permalink: /teacher/runs/
---

# Run the test and review the history
{: .no_toc }

Use cases <span class="uc-id">T5</span> run the test, <span class="uc-id">T6</span> review the run history.
{: .fs-3 }

1. TOC
{:toc}

## Start a run

On **Run**, choose a mode, the students to evaluate and press **Start**. The form only shows the fields of the chosen mode.

{% include screenshot.html file="teacher-run" alt="Run page" %}

| Mode | Fields | What happens |
| --- | --- | --- |
| **Once** | — | One pass over the chosen students. |
| **Several times** | How many times, seconds between runs | N passes, one after another. |
| **Every few seconds** | Every (seconds, minimum 10), until (optional) | A pass every T seconds until you press **Stop** or the time in **Until** is reached. |

- **Students**: a table with each student's grade, state and when they were last evaluated. Every enabled student is ticked; untick some to evaluate only a selection. Disabled students appear greyed at the end and cannot be ticked.
- **Show** filters the table and ticks only those students: *All*, *Pending* (not evaluated yet), *Needs work*, *Passed* (50 to 99) or *Connection problem*. **Start** evaluates exactly the ticked rows, so "Needs work" + **Start** evaluates only the students who are behind.
- Click **Student** or **Grade** in the header to sort. The box in the header ticks or unticks every row shown, and the counter next to **Start** says how many are selected (both need JavaScript; without it, tick the rows one by one).
- A new pass never starts while the previous one is still running.
- The settings you use are remembered for the next time.

## Follow a run

The **Status** box updates by itself and shows the mode, the pass number, when the next pass starts and the student runs waiting in the queue. Only the status box reloads, so nothing you type in the form is lost. While a run is active, the form is replaced by a notice and **Stop** appears in the status box: it cancels the schedule and kills the Teuton process that is running.

{% include screenshot.html file="teacher-run-active" alt="A periodic run in progress" %}

While you run the class periodically, students who press **Run my test** are told when the next pass will evaluate them, instead of starting a run of their own.

The **Last run** box shows its time, kind, Teuton's exit code and its output when there is any; if Teuton produced no reports (for example, an error in `start.rb`), it says so.

## How runs work

- Each run (yours or a student's) is evaluated in its own directory, so a partial run never overwrites the rest of the class.
- The panel keeps the **latest result of each student**, whichever run produced it.
- Your runs go first and alone; student runs share a limit of parallel runs (4 by default, see Settings).

## Run history

**History** lists every run of the current session: time, kind (whole class, selection or student request), number of students and average grade.

{% include screenshot.html file="teacher-runs" alt="Run history" %}

**Open** shows a run's grades and Teuton's output.

{% include screenshot.html file="teacher-run-detail" alt="Run detail" %}
