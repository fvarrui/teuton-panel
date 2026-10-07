---
title: Sesiones de clase
parent: Guía del profesor
nav_order: 8
lang: es
permalink: /teacher/sessions/
---

# Sesiones de clase

Caso de uso <span class="uc-id">T10</span>.
{: .fs-3 }

Los registros, los resultados y el histórico de ejecuciones se conservan entre arranques. Cuando termina una clase (otro día, otro grupo), empieza una sesión nueva para que la siguiente clase empiece limpia.

## Archivar la sesión actual

En **Sesiones**, escribe un nombre opcional (por ejemplo, *ASIR 1 - Grupo A*) y pulsa **Archivar y empezar una sesión nueva**. Tras confirmar:

- los registros (ficheros de `config.d/`), los resultados y las ejecuciones pasan a una carpeta de archivo con la fecha y la hora;
- la lista de alumnos y los resultados quedan vacíos, y los códigos personales antiguos dejan de funcionar;
- no se borra nada.

No se puede archivar mientras hay una ejecución activa: párala antes.

{% include screenshot.html file="teacher-sessions" alt="Sesiones de clase" %}

## Consultar una sesión archivada

**Abrir** muestra los alumnos de una sesión archivada con sus códigos y notas; el botón `moodle.csv` descarga las notas de esa sesión.

{% include screenshot.html file="teacher-session" alt="Una sesión archivada" %}

Las sesiones archivadas se guardan en `.teuton-panel/archive/<test>/<fecha>/` dentro de la carpeta base.
