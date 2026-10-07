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

**Enunciado** muestra el enunciado que Teuton genera a partir de tu test (`teuton readme`), con las máquinas necesarias, los parámetros y los objetivos de cada grupo. Tiene dos vistas:

- **Texto completo**: toda la salida de `teuton readme`.
- **Como lo ven los alumnos**: lo que leen los alumnos en `/students/readme`. Quita el bloque de la versión de Teuton del principio, lista solo los parámetros que los alumnos escriben al registrarse y omite la nota sobre SSH cuando todas las máquinas del test son `localhost`.

{% include screenshot.html file="teacher-readme" alt="Vista previa del enunciado" %}

- Las contraseñas siempre se ocultan (`******`), aunque las pongas en `config.yaml`.
- Los alumnos solo lo ven si **Leer el enunciado** está activado en [Ajustes]({{ site.baseurl }}/teacher/settings/); la página te indica si está publicado.
- Se vuelve a generar cuando cambian `start.rb` o `config.yaml`.
- Teuton escribe los enunciados en inglés y en español: quien usa el panel en catalán lee el español.
