---
title: Resultados
parent: Guía del profesor
nav_order: 6
lang: es
permalink: /teacher/results/
---

# Seguir los resultados
{: .no_toc }

Casos de uso <span class="uc-id">T7</span> seguir los resultados y usar el proyector, <span class="uc-id">T8</span> exportar las notas a Moodle.
{: .fs-3 }

1. TOC
{:toc}

## La tabla de resultados

**Resultados** muestra el último resultado de cada alumno, de mejor a peor nota, y se actualiza cada 10 segundos. Arriba, el **resumen de la clase** da la nota media, cuántos han aprobado (50 o más), cuántos lo tienen completo (100) y cuántos no se han evaluado todavía; los alumnos desactivados no cuentan.

{% include screenshot.html file="teacher-results" alt="Tabla de resultados" %}

| Estado | Significado |
| --- | --- |
| **Completo** | Evaluado, nota 100 |
| **Aprobado** | Evaluado, nota de 50 a 99 |
| **Le falta trabajo** | Evaluado, nota por debajo de 50 |
| **Problema de conexión** | El panel no pudo llegar a la máquina del alumno (apagada, IP equivocada, SSH rechazado) |
| **Copia detectada** | Nota 0 porque la comprobación `unique` de Teuton encontró la misma respuesta en la máquina de otro alumno |
| **Pendiente** | Registrado pero aún sin evaluar |
| **Desactivado** | Pausado por el profesor; conserva su última nota |

La barra de la nota usa los mismos colores que el estado: verde para completo, verde azulado para aprobado y rojo para le falta trabajo.

## Detalle de un alumno

**Detalle** muestra cada objetivo del test: si se ha cumplido, su grupo y su peso, el valor esperado y la salida (pasa el ratón por un objetivo para ver su comando). Úsalo para entender por qué un alumno está atascado. **Anterior** y **Siguiente** recorren los alumnos en el orden de la tabla de resultados.

{% include screenshot.html file="teacher-result-detail" alt="Detalle del resultado de un alumno" %}

## Modo proyector

**Modo proyector** muestra tarjetas grandes con el nombre, la nota y el estado de cada alumno sobre fondo oscuro, junto con la dirección de alumnos y el resumen de la clase, para que toda la clase lo siga desde su sitio. Se actualiza cada 10 segundos y oculta comandos y salidas. **Salir del proyector** vuelve a la tabla.

{% include screenshot.html file="teacher-projector" alt="Modo proyector" %}

## Exportar a Moodle

**Descargar moodle.csv** da un fichero que puedes importar en el libro de calificaciones de Moodle: `MoodleID, TeutonGrade, TeutonFeedback`, una línea por alumno con `tt_moodle_id` (hazlo un campo **Preguntar como correo** en [Campos del alta]({{ site.baseurl }}/teacher/registration/)). Incluye a los alumnos evaluados en cualquier ejecución, no solo en la última completa.
