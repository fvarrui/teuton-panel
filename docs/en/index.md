---
title: Home
nav_order: 1
lang: en
permalink: /
---

# Teuton Panel

A web panel for [Teuton](https://github.com/teuton-software/teuton) that a teacher runs on the classroom network. Students register their machines from a browser or a terminal, the panel runs Teuton for the whole class or for one student, and everybody sees the results: the teacher on a dashboard ready for the projector, each student on their own page.
{: .fs-5 .fw-300 }

[Get started]({{ site.baseurl }}/getting-started/){: .btn .btn-primary .mr-2 } [Teacher guide]({{ site.baseurl }}/teacher/){: .btn .mr-2 } [Student guide]({{ site.baseurl }}/students/){: .btn }

{% include screenshot.html file="teacher-projector" alt="Projector mode with the grade of every student" caption="Projector mode: the latest grade of every student, refreshed every 10 seconds." %}

## What it does

- **For the teacher** (only from the teacher's computer): choose the test, decide what students fill in when they register, manage students, run the test once, several times or every few seconds, follow the class live, download `moodle.csv` and archive each class session.
- **For students** (from the classroom network): register and get a personal code, run their own test whenever they are ready, and see their grade, history, connection status and the test statement.
- **Browser or terminal**: every student page also works with `curl`, as plain text or JSON.
- **English, Spanish and Catalan**, chosen from the browser's language.
- **No internet needed** and nothing to configure by hand: the panel creates its files on the first start.

Teuton does the testing; the panel only drives it. Any Teuton 3 test works without changes.

## How this guide is organised

- [Getting started]({{ site.baseurl }}/getting-started/): install the panel and try the sample challenge.
- [Teacher guide]({{ site.baseurl }}/teacher/): every task in the teacher area, step by step.
- [Student guide]({{ site.baseurl }}/students/): what students do, in the browser and in a terminal.
- [Use cases]({{ site.baseurl }}/use-cases/): the complete list of use cases and where each one is explained.
- [FAQ and troubleshooting]({{ site.baseurl }}/faq/): common problems and their fixes.
- [Developers]({{ site.baseurl }}/developers/): architecture, development setup, tests and translations.
