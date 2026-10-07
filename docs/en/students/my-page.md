---
title: My page
parent: Student guide
nav_order: 2
lang: en
permalink: /students/my-page/
---

# My page: run, results, history and connection
{: .no_toc }

Use cases <span class="uc-id">S3</span> open your page, <span class="uc-id">S4</span> run your test, <span class="uc-id">S5</span> see your results, <span class="uc-id">S6</span> see your history, <span class="uc-id">S7</span> check your connection.
{: .fs-3 }

1. TOC
{:toc}

## Open your page

On the student home, type your code under **Already registered?** and press **Open my page**, or go to `/students/<code>`.

{% include screenshot.html file="students-personal" alt="Personal page" %}

Your page shows your latest grade, links to your history, connection status and the statement, the `curl` command for your page, and your registration details.

## Run your test

Press **Run my test**. The panel evaluates only your machine and shows the result when it finishes (it may take a few seconds):

{% include screenshot.html file="students-run" alt="Result of a student's run" %}

Sometimes the run does not start, and the page tells you why:

| Message | Why |
| --- | --- |
| *Wait N seconds before running again* | You ran a moment ago; your teacher sets the minimum interval. |
| *The teacher is evaluating the whole class: you will be evaluated in the next pass at HH:MM* | Your teacher is running the class periodically; you do not need to run yourself. |
| *Your test is already running* / *is queued* | Your previous request has not finished yet; check your results in a moment. |
| *Your teacher has paused your evaluation for now* | Your teacher disabled you (for example, you were absent). |

{% include screenshot.html file="students-run-next-pass" alt="Run request during the teacher's periodic run" %}

## Your results

**My results** shows your latest grade and when it was evaluated. If your teacher enabled it, you also see each target of the test with a tick or a cross, so you know what is still missing:

{% include screenshot.html file="students-results" alt="Student results with each target" %}

If your grade is 0 because the same answer was found in another student's machine, the page says so.

## Your history

**My grade history** lists your grade in every run of the class session, newest first, including the ones your teacher ran:

{% include screenshot.html file="students-history" alt="Grade history" %}

## Your connection

**Connection status** tells you whether the panel reached your machine in the last run:

{% include screenshot.html file="students-status" alt="Connection status" %}

If it could not, check that your machine is on, its IP is right and SSH accepts your username and password, then run again.

## When your teacher pauses you

If your teacher disables you, your page says so and **Run my test** disappears; you can still see your results and history.

{% include screenshot.html file="students-disabled" alt="Personal page of a disabled student" %}
