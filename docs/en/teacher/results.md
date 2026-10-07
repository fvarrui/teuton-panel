---
title: Results
parent: Teacher guide
nav_order: 6
lang: en
permalink: /teacher/results/
---

# Follow the results
{: .no_toc }

Use cases <span class="uc-id">T7</span> follow the results and use the projector, <span class="uc-id">T8</span> export the grades to Moodle.
{: .fs-3 }

1. TOC
{:toc}

## The results table

**Results** shows the latest result of every student, best grades first, refreshed every 10 seconds.

{% include screenshot.html file="teacher-results" alt="Results table" %}

| State | Meaning |
| --- | --- |
| **Done** | Evaluated, grade 50 or more |
| **Needs work** | Evaluated, grade below 50 |
| **Connection problem** | The panel could not reach the student's machine (off, wrong IP, SSH rejected) |
| **Copy detected** | Grade 0 because Teuton's `unique` check found the same answer in another student's machine |
| **Pending** | Registered but not evaluated yet |
| **Disabled** | Paused by the teacher; keeps their latest result |

## Detail of a student

**Detail** shows each target of the test: whether it passed, its weight, and the command, expected value and output. Use it to understand why a student is stuck.

{% include screenshot.html file="teacher-result-detail" alt="Result detail of a student" %}

## Projector mode

**Projector mode** shows big tiles with every student's name, grade and state on a dark background, plus the student address, so the whole class can follow from their seats. It refreshes every 10 seconds and hides commands and outputs. Use **Exit projector** to go back.

{% include screenshot.html file="teacher-projector" alt="Projector mode" %}

## Export to Moodle

**Download moodle.csv** gives a file you can import in Moodle's grade book: `MoodleID, TeutonGrade, TeutonFeedback`, one line per student with a `tt_moodle_id` (make it an **Ask as email** field in [Registration]({{ site.baseurl }}/teacher/registration/)). It includes students evaluated in any run, not only the last full run.
