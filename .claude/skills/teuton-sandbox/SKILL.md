---
name: teuton-sandbox
description: Create a throwaway sample Teuton test (start.rb, config.yaml with tt_include, teuton-panel-params.yaml, config.d/ with four registered students, one disabled) that runs entirely on localhost, and optionally generate real Teuton JSON reports from it. Use to try or demo teuton-panel without student machines, to get realistic fixture files for tests, or before running the verify skill.
---

# Teuton sandbox

A sample test so the panel can be started and Teuton can run without any student machine: every case targets `localhost`, so Teuton runs the commands locally (cmd.exe on Windows, sh elsewhere) and only needs Ruby.

## Create it

```bash
ruby .claude/skills/teuton-sandbox/scripts/create_sandbox.rb            # tmp/sandbox (git-ignored)
ruby .claude/skills/teuton-sandbox/scripts/create_sandbox.rb some/dir   # elsewhere
```

The script refuses to overwrite an existing directory; remove it first if a fresh one is needed.

## What it contains

```
tmp/sandbox/
└── test-sandbox/
    ├── start.rb        2 targets on host1: "ruby -v" and "2 + 2 == answer"
    ├── config.yaml     global: tt_include: config.d; cases: []
    ├── teuton-panel-params.yaml   registration fields (AS NAME, AS EMAIL, ASK, AUTO IP)
    └── config.d/
        ├── AB3K.yaml   Ana    answer 4 → 100%
        ├── CD4M.yaml   Luis   answer 5 → 33%
        ├── EF5N.yaml   Marta  answer 4 → 100%
        └── GH6P.yaml   Pablo  tt_panel_disabled: true (the panel must skip it)
```

Student files carry `tt_panel_code`, `tt_source_ip`, `tt_moodle_id` and `host1_ip: localhost`, written directly (not through registration, which would reject a loopback host).

## Generate real reports (optional)

Needs the `teuton` gem (3.x). Do not pass `--case`, do not use `tt_skip` and never put a hash in `config.yaml` `global`: all three crash Teuton 3.0.0 (ADR-002). Because Teuton does not know `tt_panel_disabled`, a plain run evaluates Pablo too; that is expected outside the panel.

```bash
cd tmp/sandbox
teuton run --no-color --quiet --export=json test-sandbox
ls var/test-sandbox/     # case-01.json … case-04.json, resume.json, moodle.csv
```

To turn them into test fixtures, copy the files into `test/files/tNN-description/` and keep only what the test needs.

## Use it with the panel

```bash
ruby teuton-panel up tmp/sandbox
```

Then open `http://localhost:4567/teacher` (teacher area) and `http://localhost:4567/students.txt` (student help). What works depends on which features are implemented (`.minispec/features/`).

## Notes

- `tmp/` is in `.gitignore`; never commit the sandbox.
- To exercise connection errors, add a student file with `host1_ip: 192.0.2.1` (TEST-NET, unreachable; Teuton waits ~30 s before reporting `host_unreachable`).
