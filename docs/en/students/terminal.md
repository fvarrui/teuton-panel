---
title: From a terminal
parent: Student guide
nav_order: 4
lang: en
permalink: /students/terminal/
---

# Use the panel from a terminal
{: .no_toc }

Use case <span class="uc-id">S10</span>.
{: .fs-3 }

1. TOC
{:toc}

No browser? Every student page also exists as plain text: add `.txt` to the address. Start with the help:

```bash
curl http://192.168.1.10:4567/students.txt
```

```
Teuton Panel - Today's test: linux-files-basics

Commands (replace CODE with your personal code):
  Register:
    curl "http://192.168.1.10:4567/students/register.txt?tt_members=...&tt_moodle_id=...&home=..."
  Your page:
    curl http://192.168.1.10:4567/students/CODE.txt
  Run your test:
    curl http://192.168.1.10:4567/students/CODE/run.txt
  Your results:
    curl http://192.168.1.10:4567/students/CODE/results.txt
  ...
```

## Register

Put every field in the address, between quotes because of the `&`:

```bash
curl "http://192.168.1.10:4567/students/register.txt?tt_members=Ana%20Garcia&tt_moodle_id=ana@example.com&home=ana"
```

```
Your personal code is A2KP
Keep this code: you need it to run the test and see your results.

Your page: http://192.168.1.10:4567/students/A2KP
Run your test:
  curl http://192.168.1.10:4567/students/A2KP/run.txt
```

Write spaces as `%20`. If a field is wrong you get the list of errors instead.

## Run, results, history and status

```bash
curl http://192.168.1.10:4567/students/A2KP/run.txt
```

```
Done! These are your results:
Grade: 100/100
  [OK] Directory docs exists
  [OK] File docs/notes.txt exists
  ...
```

| Command | What you get |
| --- | --- |
| `curl .../students/CODE.txt` | Your name, code, details and latest grade |
| `curl .../students/CODE/run.txt` | Runs your test and prints the grade |
| `curl .../students/CODE/results.txt` | Your latest grade and, if enabled, each target |
| `curl .../students/CODE/history.txt` | Your grade in every run |
| `curl .../students/CODE/status.txt` | Whether the panel reached your machine |
| `curl .../students/readme.md` | The statement, as Markdown |

## JSON

Replace `.txt` with `.json` to get data for scripts:

```bash
curl http://192.168.1.10:4567/students/A2KP/results.json
```

```json
{
  "code": "A2KP",
  "result": {
    "grade": 100.0,
    "finished_at": "2026-10-07 09:40:00 +0100",
    "unique_fault": false,
    "connection": "ok"
  }
}
```

## Language

Text answers use the panel's default language. Add `?lang=en`, `?lang=es` or `?lang=ca` to choose:

```bash
curl "http://192.168.1.10:4567/students/A2KP/results.txt?lang=ca"
```

{: .note }
Your teacher may disable some formats. Without a suffix you always get the web page (HTML), which is hard to read in a terminal: remember the `.txt`.
