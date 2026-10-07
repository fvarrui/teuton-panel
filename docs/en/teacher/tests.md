---
title: Tests
parent: Teacher guide
nav_order: 2
lang: en
permalink: /teacher/tests/
---

# Choose and check the test

Use case <span class="uc-id">T2</span>.
{: .fs-3 }

**Tests** lists every Teuton test found under the directory you started the panel with: name, path, fixed cases in `config.yaml` and registered students.

{% include screenshot.html file="teacher-tests" alt="Tests page with the teuton check output" %}

## Activate a test

Press **Activate** next to a test. The panel asks for confirmation, because changing the test:

- stops any run in progress;
- makes registration, runs and results refer to the new test.

When a test is activated the panel prepares it for registration:

- it adds `tt_include: config.d` to `config.yaml` as text, keeping your comments (or creates `config.yaml` if there is none);
- it creates the `config.d/` directory, where each registered student gets a file;
- it proposes the registration fields from `teuton config` if the test has no `teuton-panel-params.yaml` yet.

{: .note }
Students registered for one test belong to that test: when you activate another one, their codes stop working until you go back.

## Check a test

Press **Run teuton check** to see Teuton's own report on `start.rb` and `config.yaml`: groups, targets, hosts and parameters. Do it before the class to catch mistakes in the test.
