---
title: Enunciat
parent: Guia de l'alumne
nav_order: 3
lang: ca
permalink: /students/statement/
---

# Llegir l'enunciat

Cas d'ús <span class="uc-id">S8</span>.
{: .fs-3 }

**Enunciat** (o `/students/readme`) mostra el que has de fer: les màquines que necessites, els valors que se't demanen i tots els objectius de cada grup, amb el seu pes.

{% include screenshot.html file="students-readme" alt="Enunciat del test" %}

Des d'un terminal, obtén-lo en Markdown:

```bash
curl http://192.168.1.10:4567/students/readme.md
```

L'enunciat està escrit en anglès o en castellà; en català es mostra el castellà.
