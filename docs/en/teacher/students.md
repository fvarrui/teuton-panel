---
title: Students
parent: Teacher guide
nav_order: 4
lang: en
permalink: /teacher/students/
---

# Manage students

Use case <span class="uc-id">T4</span>.
{: .fs-3 }

**Students** lists everyone registered in the active test, refreshed every 15 seconds: name, personal code, IP they registered from, time, latest grade and state.

{% include screenshot.html file="teacher-students" alt="Students page" %}

The personal codes are shown only here. If a student forgets their code, look it up and tell them.

## Edit a student

**Edit** opens every value of the student's case. Save to correct a wrong IP, a typo in the name or any other value; the next run uses the new values.

{% include screenshot.html file="teacher-student-edit" alt="Edit a student" %}

The same rules as in registration apply to the values you change (letters, digits, spaces and `. _ - @ : /`), and host fields typed by students cannot point to the panel's computer. Values you keep as they are are always accepted.

## Disable or enable

**Disable** pauses a student (for example, absent today):

- they are left out of every run, by you or by themselves;
- they keep their latest result, shown as *Disabled*;
- they can still open their page and results, but **Run my test** is not offered.

**Enable** brings them back.

## Delete

**Delete** removes the registration (the student's file in `config.d/`). Their code stops working; they can register again.

## Cases without a code

Cases written by hand appear too:

- **In `config.yaml` (`cases:`)**: they are evaluated with the class, but students cannot use them from the student area.
- **Files in `config.d/` without a code**: **Give a code** turns them into normal registrations, so the student can use their personal page.
