---
title: Registration fields
parent: Teacher guide
nav_order: 3
lang: en
permalink: /teacher/registration/
---

# Registration fields

Use case <span class="uc-id">T3</span>.
{: .fs-3 }

**Registration fields** decides what students fill in when they register. Each row is a value of the student's case in Teuton (the keys your `start.rb` reads with `get(...)` and the host settings), and how it gets its value.

{% include screenshot.html file="teacher-registration" alt="Registration fields editor" %}

| Mode | What happens |
| --- | --- |
| **Ask as name** (`AS NAME`) | Asked to the student, labelled "Your name". Use it for `tt_members`. |
| **Ask as email** (`AS EMAIL`) | Asked and checked as an email. Use it for `tt_moodle_id` to get `moodle.csv`. |
| **Ask** (`ASK`) | Asked as free text. |
| **Automatic: student's IP** (`AUTO IP`) | Not asked: the IP of the machine the student registers from. |
| **Fixed value** | Not asked: the same value for everybody (for example a common username, or `localhost`). |

- **Fixed value** is only used with the *Fixed value* mode; the column is dimmed for the other modes.
- **Label for students** and **Help for students** replace the field name in the registration form and in *My details* (for example `home` → label *Your home folder*, help *The name of your folder in homes/*). Without a label, name and email fields say *Your name* and *Your email*, and the rest show the field name made readable. Students never see the raw keys.
- To add a field, fill in the empty last row and press **Save**.
- To remove one, tick **Remove** and press **Save**.
- **Propose from teuton config** replaces the fields with a proposal made from your test: every value the test needs, `tt_members` as name, `tt_moodle_id` as email and host IPs as automatic.

The fields are stored in `teuton-panel-params.yaml`, next to the test's `config.yaml`, so they travel with the test. A field with a label or help is written as `home: {mode: "ASK", label: "Your home folder", help: "..."}`; the short form `home: "ASK"` keeps working.

Labels and help follow the same character rule as typed values (see below); the page tells you which field to fix.

{: .warning }
`AUTO IP` is right only when students register from the machine that will be evaluated. If they register from another computer (for example a browser on the host while the target is a virtual machine), make the field **Ask** instead, or fix the IP in [Students]({{ site.baseurl }}/teacher/students/).

## What students may type

To protect the commands your test runs, typed values accept only letters (with accents), digits, spaces and `. _ - @ : /`, up to 100 characters. Passwords only have the length limit. Host fields never accept the panel's own addresses, so a student cannot point Teuton at your computer.

{: .important }
Typed values end up inside the commands of your test (`run "... #{get(:home)} ..."`). If a host of your test is `localhost`, those commands run on **your** computer: check typed values in `start.rb` before using them, as the sample does with `home_dir`.
