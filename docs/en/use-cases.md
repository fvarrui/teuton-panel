---
title: Use cases
nav_order: 5
lang: en
permalink: /use-cases/
---

# Use cases
{: .no_toc }

Every use case of teuton-panel and where it is explained. All of them are checked automatically against the sample challenge with `rake usecases` (see [Testing]({{ site.baseurl }}/developers/testing/)).

1. TOC
{:toc}

## Teacher

| Id | Use case | Guide |
| --- | --- | --- |
| <span class="uc-id">T1</span> | Start the panel and see where students connect | [Start the panel]({{ site.baseurl }}/teacher/start/) |
| <span class="uc-id">T2</span> | Choose the active test and check it with `teuton check` | [Tests]({{ site.baseurl }}/teacher/tests/) |
| <span class="uc-id">T3</span> | Define the registration fields (asked, automatic IP, fixed values) | [Registration fields]({{ site.baseurl }}/teacher/registration/) |
| <span class="uc-id">T4</span> | Manage students: edit, disable, enable, delete, give a code | [Students]({{ site.baseurl }}/teacher/students/) |
| <span class="uc-id">T5</span> | Run the test once, several times or every T seconds, for everyone or a selection, until a time; stop it | [Running the test]({{ site.baseurl }}/teacher/runs/) |
| <span class="uc-id">T6</span> | Review the run history and the detail of each run | [Running the test]({{ site.baseurl }}/teacher/runs/#run-history) |
| <span class="uc-id">T7</span> | Follow the results, see a student's detail, use the projector mode | [Results]({{ site.baseurl }}/teacher/results/) |
| <span class="uc-id">T8</span> | Export the grades to Moodle (`moodle.csv`) | [Results]({{ site.baseurl }}/teacher/results/#export-to-moodle) |
| <span class="uc-id">T9</span> | Preview the statement students read | [Statement]({{ site.baseurl }}/teacher/statement/) |
| <span class="uc-id">T10</span> | Archive a class session and consult archived ones | [Class sessions]({{ site.baseurl }}/teacher/sessions/) |
| <span class="uc-id">T11</span> | Configure the panel: student features and formats, run interval, language, addresses, teacher IPs | [Settings]({{ site.baseurl }}/teacher/settings/) |
| <span class="uc-id">T12</span> | Open the teacher area from another computer | [Start the panel]({{ site.baseurl }}/teacher/start/#open-the-teacher-area-from-another-computer) |

## Student

| Id | Use case | Guide |
| --- | --- | --- |
| <span class="uc-id">S1</span> | Register (browser or terminal) and get a personal code | [Registering]({{ site.baseurl }}/students/register/) |
| <span class="uc-id">S2</span> | Fix my registration data | [Registering]({{ site.baseurl }}/students/register/#fix-your-data) |
| <span class="uc-id">S3</span> | Open my page with my code | [My page]({{ site.baseurl }}/students/my-page/) |
| <span class="uc-id">S4</span> | Run my own test | [My page]({{ site.baseurl }}/students/my-page/#run-your-test) |
| <span class="uc-id">S5</span> | See my latest grade and, if enabled, each target | [My page]({{ site.baseurl }}/students/my-page/#your-results) |
| <span class="uc-id">S6</span> | See my grade history | [My page]({{ site.baseurl }}/students/my-page/#your-history) |
| <span class="uc-id">S7</span> | Check whether the panel reaches my machine | [My page]({{ site.baseurl }}/students/my-page/#your-connection) |
| <span class="uc-id">S8</span> | Read the test statement | [Statement]({{ site.baseurl }}/students/statement/) |
| <span class="uc-id">S9</span> | See who is registered | [Registering]({{ site.baseurl }}/students/register/#who-is-registered) |
| <span class="uc-id">S10</span> | Do everything from a terminal, as text or JSON | [From a terminal]({{ site.baseurl }}/students/terminal/) |

## Situations and what the panel does

| Situation | What happens |
| --- | --- |
| A student arrives late | They register and are included in the next run, without restarting anything. |
| A student registers from the wrong machine (`AUTO IP`) | The wrong IP is stored; the teacher fixes it in Students → Edit, or the field is made "Ask". |
| A student forgets their code | The teacher looks it up in Students. |
| A student registers twice | They get two codes; the teacher deletes the extra registration. |
| A student is absent | The teacher disables them: they are skipped in every run and keep their latest result. |
| A student runs again too soon | They are told how many seconds to wait. |
| The teacher is running the class periodically | Students who press Run are told when the next pass will evaluate them. |
| A student's machine is off or SSH rejects the credentials | The result shows a connection problem; the student sees it in Connection status. |
| Two students hand in the same answer | Teuton's `unique` check sets grade 0 and the panel says why. |
| A student types quotes or symbols in a field | The value is refused with an explanation; nothing reaches Teuton. |
| A student opens an unknown code | They are told the code is unknown and pointed to registration. |
| The teacher disables a feature or a format | That page answers "not enabled" or names the formats available. |
| The teacher closes the student area | Every student page answers that the area is closed. |
| Someone opens the teacher area from another computer | 403, unless their IP is in the teacher list. |
| There are several tests and none is active | The teacher home asks to choose a test. |
| The active test folder is renamed or moved | The panel forgets it at startup and selects the only test if there is one. |
| The teacher changes the active test | Runs stop; registrations of the old test are kept for when it is active again. |
| A new class starts | The teacher archives the session and starts empty. |
