# Sample: Linux files basics

A ready-to-try challenge for teuton-panel, with seven invented students and an invented class history. No student machines are needed: each student's work lives in `homes/<student>/`, and Teuton checks it on `localhost`.

## Try it

```bash
ruby samples/linux-files-basics/reset.rb       # create the demo state (run it again to reset)
teuton-panel up samples/linux-files-basics     # or, from the source tree: ruby teuton-panel up samples/linux-files-basics
```

Then open `http://localhost:4567/teacher` (Results, History, projector mode) and `http://localhost:4567/students`.

## The challenge

Seven checks on the student's home directory (10 points):

| Check | Weight |
| --- | --- |
| Directory `docs` exists | 1 |
| File `docs/notes.txt` exists | 1 |
| `docs/notes.txt` has exactly 3 lines | 2 |
| `.bashrc` defines the alias `ll` | 2 |
| File `scripts/backup.sh` exists | 1 |
| `backup.sh` starts with `#!/bin/bash` | 1 |
| `backup.sh` creates a tar archive of `docs` | 2 |

## Students

| Code | Student | Work in `homes/` | Grade |
| --- | --- | --- | --- |
| `A2KP` | Ana García | Everything done | 100 |
| `B3MQ` | Luis Pérez | Backup script without shebang | 90 |
| `E6QT` | Lucía Hernández | No `ll` alias | 80 |
| `D5PS` | Diego Santana | No backup script yet | 60 |
| `C4NR` | Marta Ruiz | Two-line notes, no alias, empty script | 30 |
| `F7RU` | Sara Medina | Not started | 0 |
| `G8SV` | Pablo Torres | Everything done, but disabled by the teacher | — |

The invented history has three class runs (09:00, 09:20, 09:40) and one run requested by Marta (09:35), so the history pages show how the class progressed. A real run gives the same final grades, because they come from the files in `homes/`.

## Things to try

- Edit a student's files in `homes/` and run again: their grade changes.
- Register a new student at `/students/register` with an existing home folder (for example `ana`) or a new one (grade 0).
- Run a student's own test: `curl http://localhost:4567/students/C4NR/run.txt`.
- Enable Pablo in **Students** and run the class again.

## Files

- `start.rb`, `config.yaml` — the Teuton test (`config.yaml` includes `config.d/`).
- `teuton-panel-params.yaml` — registration fields (name, email, home folder; `host1_ip` fixed to `localhost`).
- `homes/` — the students' work.
- `reset.rb` — recreates `config.d/`, `teuton-panel.yaml` and `.teuton-panel/` (git-ignored demo state). The test id is the folder name, so the sample also works when copied or renamed.
- `start.rb` checks the typed `home` value (`home_dir`) before putting it into a command: the checks run on the teacher's computer.
