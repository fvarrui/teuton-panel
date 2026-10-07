---
title: Ejecutar el test
parent: Guía del profesor
nav_order: 5
lang: es
permalink: /teacher/runs/
---

# Ejecutar el test y consultar el histórico
{: .no_toc }

Casos de uso <span class="uc-id">T5</span> ejecutar el test, <span class="uc-id">T6</span> consultar el histórico de ejecuciones.
{: .fs-3 }

1. TOC
{:toc}

## Lanzar una ejecución

En **Ejecutar**, elige un modo, los alumnos que quieres evaluar y pulsa **Empezar**. El formulario solo muestra los campos del modo elegido.

{% include screenshot.html file="teacher-run" alt="Página Ejecutar" %}

| Modo | Campos | Qué pasa |
| --- | --- | --- |
| **Una vez** | — | Una pasada por los alumnos elegidos. |
| **Varias veces** | Cuántas veces, segundos entre ejecuciones | N pasadas, una detrás de otra. |
| **Cada pocos segundos** | Cada (segundos, mínimo 10), hasta (opcional) | Una pasada cada T segundos hasta que pulses **Parar** o llegue la hora de **Hasta**. |

- **Alumnos**: están marcados todos los alumnos activos; desmarca algunos para evaluar solo una selección. Los desactivados no se pueden marcar.
- Nunca empieza una pasada mientras la anterior sigue en marcha.
- Los ajustes que uses se recuerdan para la próxima vez.

## Seguir una ejecución

El recuadro **Estado** se actualiza solo y muestra el modo, el número de pasada, cuándo empieza la siguiente y las ejecuciones de alumnos que esperan en cola. Solo se recarga el recuadro de estado, así que no se pierde nada de lo que escribas en el formulario. Mientras hay una ejecución activa, el formulario se sustituye por un aviso y **Parar** aparece en el recuadro de estado: cancela la programación y detiene el proceso de Teuton en marcha.

{% include screenshot.html file="teacher-run-active" alt="Una ejecución periódica en marcha" %}

Mientras ejecutas la clase periódicamente, a los alumnos que pulsan **Ejecutar mi test** se les dice cuándo los evaluará la próxima pasada, en lugar de lanzar una ejecución propia.

El recuadro **Última ejecución** muestra su hora, tipo, código de salida de Teuton y su salida cuando la hay; si Teuton no generó informes (por ejemplo, por un error en `start.rb`), lo indica.

## Cómo funcionan las ejecuciones

- Cada ejecución (tuya o de un alumno) se evalúa en su propia carpeta, así que una ejecución parcial nunca pisa al resto de la clase.
- El panel guarda **el último resultado de cada alumno**, sea cual sea la ejecución que lo produjo.
- Tus ejecuciones van primero y solas; las de los alumnos comparten un límite de ejecuciones en paralelo (4 por defecto, ver Ajustes).

## Histórico de ejecuciones

**Histórico** lista todas las ejecuciones de la sesión actual: hora, tipo (toda la clase, selección o petición de alumno), número de alumnos y nota media.

{% include screenshot.html file="teacher-runs" alt="Histórico de ejecuciones" %}

**Abrir** muestra las notas de una ejecución y la salida de Teuton.

{% include screenshot.html file="teacher-run-detail" alt="Detalle de una ejecución" %}
