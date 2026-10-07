---
title: Enunciado
parent: Guía del profesor
nav_order: 7
lang: es
permalink: /teacher/statement/
---

# Ver el enunciado

Caso de uso <span class="uc-id">T9</span>.
{: .fs-3 }

**Enunciado** muestra exactamente lo que leen los alumnos en `/students/readme`: el enunciado que Teuton genera a partir de tu test (`teuton readme`), con las máquinas necesarias, los parámetros y los objetivos de cada grupo.

{% include screenshot.html file="teacher-readme" alt="Vista previa del enunciado" %}

- Las contraseñas siempre se ocultan (`******`), aunque las pongas en `config.yaml`.
- Los alumnos solo lo ven si **Leer el enunciado** está activado en [Ajustes]({{ site.baseurl }}/teacher/settings/); la página te indica si está publicado.
- Se vuelve a generar cuando cambian `start.rb` o `config.yaml`.
- Teuton escribe los enunciados en inglés y en español: quien usa el panel en catalán lee el español.
