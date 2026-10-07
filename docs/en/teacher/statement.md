---
title: Statement
parent: Teacher guide
nav_order: 7
lang: en
permalink: /teacher/statement/
---

# Preview the statement

Use case <span class="uc-id">T9</span>.
{: .fs-3 }

**Statement** shows exactly what students read at `/students/readme`: the statement Teuton generates from your test (`teuton readme`), with the required hosts, parameters and the targets of each group.

{% include screenshot.html file="teacher-readme" alt="Statement preview" %}

- Passwords are always hidden (`******`), even if you set them in `config.yaml`.
- Students only see it if **Read the statement** is enabled in [Settings]({{ site.baseurl }}/teacher/settings/); the page tells you whether it is published.
- It is regenerated when `start.rb` or `config.yaml` change.
- Teuton writes statements in English and Spanish: students using the panel in Catalan read the Spanish one.
