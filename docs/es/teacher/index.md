---
title: Guía del profesor
nav_order: 3
has_children: true
lang: es
permalink: /teacher/
---

# Guía del profesor

El área del profesor está en `http://localhost:4567/teacher` y solo responde a tu propio ordenador (en [Arrancar el panel]({{ site.baseurl }}/teacher/start/) se explica cómo abrirla desde otro). Su menú tiene una página por tarea:

{% include screenshot.html file="teacher-home" alt="Inicio del profesor: alumnos, ejecuciones y direcciones de alumnos" caption="La sala de control: cuántos alumnos hay, si hay una ejecución en marcha y dónde se conectan los alumnos." %}

| Página | Qué haces en ella | Casos de uso |
| --- | --- | --- |
| [Inicio]({{ site.baseurl }}/teacher/start/) | Ver el estado de la clase y las direcciones de alumnos | <span class="uc-id">T1</span> <span class="uc-id">T12</span> |
| [Tests]({{ site.baseurl }}/teacher/tests/) | Elegir el test activo y revisarlo | <span class="uc-id">T2</span> |
| [Alta]({{ site.baseurl }}/teacher/registration/) | Decidir qué rellenan los alumnos | <span class="uc-id">T3</span> |
| [Alumnos]({{ site.baseurl }}/teacher/students/) | Corregir, pausar o borrar registros | <span class="uc-id">T4</span> |
| [Ejecutar]({{ site.baseurl }}/teacher/runs/) e Histórico | Evaluar la clase una vez, varias veces o periódicamente | <span class="uc-id">T5</span> <span class="uc-id">T6</span> |
| [Resultados]({{ site.baseurl }}/teacher/results/) | Seguir la clase, usar el proyector, exportar a Moodle | <span class="uc-id">T7</span> <span class="uc-id">T8</span> |
| [Enunciado]({{ site.baseurl }}/teacher/statement/) | Ver lo que leen los alumnos | <span class="uc-id">T9</span> |
| [Sesiones]({{ site.baseurl }}/teacher/sessions/) | Archivar una clase y empezar la siguiente limpia | <span class="uc-id">T10</span> |
| [Ajustes]({{ site.baseurl }}/teacher/settings/) | Elegir qué pueden hacer los alumnos y otras opciones | <span class="uc-id">T11</span> |

## Una clase típica

1. Antes de la clase, arranca el panel, activa el test y ejecuta **teuton check** para detectar errores.
2. Proyecta la dirección de alumnos; los alumnos se registran mientras explicas el reto.
3. Lanza una ejecución periódica (por ejemplo, cada 60 segundos) y abre el modo proyector.
4. Pasea por el aula: el proyector te dice quién necesita ayuda, y los alumnos pueden ejecutar su test cuando quieran.
5. Al terminar, descarga `moodle.csv` y archiva la sesión.
