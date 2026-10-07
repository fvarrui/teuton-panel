---
title: Start the panel
parent: Teacher guide
nav_order: 1
lang: en
permalink: /teacher/start/
---

# Start the panel
{: .no_toc }

Use cases <span class="uc-id">T1</span> start the panel and see where students connect, <span class="uc-id">T12</span> open the teacher area from another computer.
{: .fs-3 }

1. TOC
{:toc}

## Start it

```bash
teuton-panel up PATH/TO/TESTS
```

On the first start the panel:

- checks that Teuton 3 is installed (otherwise it tells you how to install it and stops);
- looks for every Teuton test under the directory (directories with a `start.rb`) and stops if there is none;
- creates `teuton-panel.yaml` with default settings;
- activates the test automatically when there is only one, adding `tt_include: config.d` to its `config.yaml` and proposing the registration fields.

With several tests, choose one in [Tests]({{ site.baseurl }}/teacher/tests/).

## The control room

Open `http://localhost:4567/teacher` (or just `http://localhost:4567/`: on your computer the panel address takes you to the teacher area). The home page shows:

- the active test, with buttons to **Run** and to open the **Projector mode**;
- the **class summary**: average grade, how many passed (50 or more), how many are complete (100) and how many have not been evaluated yet; it links to Results;
- how many students are registered and how many have been evaluated;
- whether a run is going on, the last run and the queue of student runs;
- **where students connect**: one address per network interface, with the `curl` command for students without a browser, and a reminder when students can see who is registered.

{% include screenshot.html file="teacher-home" alt="Teacher home page" %}

{: .tip }
If your computer has extra network adapters (VirtualBox, Docker…), students may see addresses that do not work for them. Set the right one in [Settings]({{ site.baseurl }}/teacher/settings/) → **Addresses shown to students**.

When there is no active test yet, the home page asks you to choose one, and pages that need a test (Students, Run, Results…) show a link to **Tests**.

## Language

The panel follows your browser's language (English, Spanish or Catalan). Change it with the **EN · ES · CA** links in the top bar; the choice is remembered. The default for browsers that ask for another language is set in Settings.

## Open the teacher area from another computer

The teacher area only answers the computer that runs the panel (`localhost` or its own addresses). Any other computer gets *403 This area is only available on the teacher's computer*. If you run the panel on a server and manage it from your laptop:

- add your laptop's IP in [Settings]({{ site.baseurl }}/teacher/settings/) → **Other teacher IPs**; or
- use an SSH tunnel: `ssh -L 4567:localhost:4567 server`, then open `http://localhost:4567/teacher` on your laptop.

## Stop it

Press `Ctrl+C` in the terminal. Running Teuton processes are stopped; registrations, results and run history stay on disk for the next start. A periodic run is not resumed automatically after a restart: the Run page shows the last settings ready to start again.
