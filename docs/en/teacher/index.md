---
title: Teacher guide
nav_order: 3
has_children: true
lang: en
permalink: /teacher/
---

# Teacher guide

The teacher area is at `http://localhost:4567/teacher` and only answers your own computer (see [Start the panel]({{ site.baseurl }}/teacher/start/) to open it from another one). Its menu follows a class: **Home**, then **Prepare** (Tests, Registration fields, Statement), **Class** (Students, Run, Results, History), and finally Sessions and Settings. Opening the panel address without a path (`http://localhost:4567/`) on your computer also takes you here.

{% include screenshot.html file="teacher-home" alt="Teacher home: students, runs and the student addresses" caption="The control room: the class summary, how many students there are, whether a run is going on and where students connect." %}

| Page | What you do there | Use cases |
| --- | --- | --- |
| [Home]({{ site.baseurl }}/teacher/start/) | See the state of the class and the student addresses | <span class="uc-id">T1</span> <span class="uc-id">T12</span> |
| [Tests]({{ site.baseurl }}/teacher/tests/) | Choose the active test and check it | <span class="uc-id">T2</span> |
| [Registration fields]({{ site.baseurl }}/teacher/registration/) | Decide what students fill in, with your own labels and help | <span class="uc-id">T3</span> |
| [Students]({{ site.baseurl }}/teacher/students/) | Fix, pause or remove registrations | <span class="uc-id">T4</span> |
| [Run]({{ site.baseurl }}/teacher/runs/) and History | Evaluate the class once, several times or periodically | <span class="uc-id">T5</span> <span class="uc-id">T6</span> |
| [Results]({{ site.baseurl }}/teacher/results/) | Follow the class, use the projector, export to Moodle | <span class="uc-id">T7</span> <span class="uc-id">T8</span> |
| [Statement]({{ site.baseurl }}/teacher/statement/) | Preview what students read | <span class="uc-id">T9</span> |
| [Sessions]({{ site.baseurl }}/teacher/sessions/) | Archive a class and start the next one clean | <span class="uc-id">T10</span> |
| [Settings]({{ site.baseurl }}/teacher/settings/) | Choose what students can do and other options | <span class="uc-id">T11</span> |

## A typical class

1. Before the class, start the panel, activate the test and run **teuton check** to catch mistakes.
2. Project the student address; students register while you explain the challenge.
3. Start a periodic run (for example every 60 seconds) and open the projector mode.
4. Walk around the classroom: the projector tells you who needs help, and students can run their own test whenever they want.
5. At the end, download `moodle.csv` and archive the session.
