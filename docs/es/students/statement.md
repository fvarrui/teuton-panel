---
title: Enunciado
parent: Guía del alumno
nav_order: 3
lang: es
permalink: /students/statement/
---

# Leer el enunciado

Caso de uso <span class="uc-id">S8</span>.
{: .fs-3 }

**Enunciado** (o `/students/readme`) muestra lo que tienes que hacer: las máquinas que necesitas, los valores que escribes al registrarte y todos los objetivos de cada grupo, con su peso.

{% include screenshot.html file="students-readme" alt="Enunciado del test" %}

Desde un terminal, obtenlo en Markdown:

```bash
curl http://192.168.1.10:4567/students/readme.md
```

El enunciado está escrito en inglés o en español; en catalán se muestra el español.
