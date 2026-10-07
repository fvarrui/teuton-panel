---
title: Statement
parent: Student guide
nav_order: 3
lang: en
permalink: /students/statement/
---

# Read the statement

Use case <span class="uc-id">S8</span>.
{: .fs-3 }

**Statement** (or `/students/readme`) shows what you have to do: the machines you need, the values you are asked for and every target of each group, with its weight.

{% include screenshot.html file="students-readme" alt="Test statement" %}

From a terminal, get it as Markdown:

```bash
curl http://192.168.1.10:4567/students/readme.md
```

The statement is written in English or Spanish; in Catalan you get the Spanish one.
