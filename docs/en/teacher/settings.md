---
title: Settings
parent: Teacher guide
nav_order: 9
lang: en
permalink: /teacher/settings/
---

# Settings
{: .no_toc }

Use case <span class="uc-id">T11</span>.
{: .fs-3 }

1. TOC
{:toc}

**Settings** changes the panel's behaviour; every change is saved at once in `teuton-panel.yaml`.

{% include screenshot.html file="teacher-settings" alt="Settings page" %}

## What students can do

| Option | When enabled |
| --- | --- |
| Register | Students can register and update their data |
| See who is registered | The student home lists registered students (names only) |
| Run their test | Students can run their own case |
| See their grade | Students see their latest grade |
| See each target's result | Students also see which targets passed (no commands or outputs) |
| See their grade history | Students see their grade in every run of the session |
| See their connection status | Students see whether the panel reached their machine |
| Read the statement | Students can read the test statement |

A disabled option answers *Your teacher has not enabled this option* and disappears from the student menus.

## Formats students get

Choose any combination of **Web pages**, **Plain text** (`.txt`, for `curl`) and **JSON** (`.json`). A request in a disabled format gets a short message naming the enabled ones. With **no format** checked, the student area is closed. Your area is not affected.

## Other options

- **Seconds between runs of the same student**: how long a student waits before running again (30 by default; 0 for no limit).
- **Default language**: used when the browser asks for a language the panel does not have.
- **Student runs at the same time**: how many student runs can go in parallel (applies after restarting the panel).
- **Addresses shown to students**: leave it empty to show every detected address, or write the right one when the computer has extra adapters.
- **Other teacher IPs**: computers that can open the teacher area besides this one, separated by commas.

## The settings file

Settings live in `teuton-panel.yaml`, in the directory you started the panel with. You can also edit it by hand while the panel is stopped:

```yaml
:server:
  :bind: 0.0.0.0
  :port: 4567
  :addresses: []           # addresses shown to students (empty = detected)
:language: es
:teacher:
  :allow: []               # other teacher IPs
:test: linux-files-basics  # active test
:run:
  :every: 60
  :times: 1
  :delay: 3
:runs:
  :max_parallel: 4
:student:
  :register: true
  :list: true
  :run: true
  :results: true
  :feedback: false
  :history: true
  :status: true
  :readme: true
  :formats: [html, txt, json]
  :run_interval: 30
:datadir: ".teuton-panel"
```
