---
title: FAQ and troubleshooting
nav_order: 6
lang: en
permalink: /faq/
---

# FAQ and troubleshooting
{: .no_toc }

1. TOC
{:toc}

## Students cannot open the address

- Check that the computer's firewall allows incoming connections on the panel's port (4567 by default).
- Make sure students use one of the addresses shown on the teacher home. If the computer has several network adapters, set the right address in Settings → **Addresses shown to students**.
- Students and teacher must be on the same network.

## "teuton 3.x is required"

The panel needs the `teuton` gem 3.x: `gem install teuton -v "~> 3.0"`.

## "No Teuton tests found"

The directory you started the panel with has no `start.rb` in it or in its subdirectories. Create a test with `teuton new DIRECTORY` or start the panel from the right directory.

## A student always gets 0 with a connection problem

Open their connection status (or the result detail): the machine may be off, its IP may be wrong (fix it in Students → Edit) or SSH may reject the username or password.

## A run shows no reports

Open it in **History** to read Teuton's output; errors in `start.rb` or `config.yaml` show up there. **Tests → Run teuton check** also helps.

## Can I use `tt_skip` or `teuton run --case`?

Not with Teuton 3.0.0: both crash Teuton ([teuton#44](https://github.com/teuton-software/teuton/issues/44)). Use **Disable** in Students or tick only some students in Run; the panel builds its own configuration and never uses them. Also avoid hash values in the `global:` section of `config.yaml`.

## Can students see other students' data or passwords?

No. Students only see names in the registered list, and only their own code, grade and details (passwords masked). Raw Teuton reports are never shown to them.

## Where are things stored?

- `teuton-panel.yaml`: panel settings (base directory).
- `config.d/`: one file per registered student (next to the test's `config.yaml`).
- `teuton-panel-params.yaml`: registration fields (next to `config.yaml`).
- `.teuton-panel/`: runs, results and archived sessions (base directory).

## How do I start a fresh class?

**Sessions → Archive and start a new session**. Nothing is deleted; old sessions can be opened later.
