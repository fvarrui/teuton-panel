---
title: Inicio
nav_order: 1
lang: es
permalink: /
---

<img class="home-logo" src="{{ site.baseurl }}/assets/images/logo/teuton-panel.svg" alt="teuton-panel" width="180" height="180">

# Teuton Panel

Un panel web para [Teuton](https://github.com/teuton-software/teuton) que el profesor arranca en la red del aula. Los alumnos registran sus máquinas desde el navegador o desde un terminal, el panel ejecuta Teuton para toda la clase o para un alumno, y todos ven los resultados: el profesor en un panel listo para el proyector y cada alumno en su propia página.
{: .fs-5 .fw-300 }

[Primeros pasos]({{ site.baseurl }}/getting-started/){: .btn .btn-primary .mr-2 } [Guía del profesor]({{ site.baseurl }}/teacher/){: .btn .mr-2 } [Guía del alumno]({{ site.baseurl }}/students/){: .btn }

{% include screenshot.html file="teacher-projector" alt="Modo proyector con la nota de cada alumno" caption="Modo proyector: la última nota de cada alumno, actualizada cada 10 segundos." %}

## Qué hace

- **Para el profesor** (solo desde su ordenador): elegir el test, decidir qué rellenan los alumnos al registrarse, gestionar alumnos, ejecutar el test una vez, varias veces o cada pocos segundos, seguir la clase en directo, descargar `moodle.csv` y archivar cada sesión de clase.
- **Para los alumnos** (desde la red del aula): registrarse y obtener un código personal, ejecutar su test cuando estén listos, y ver su nota, su histórico, el estado de su conexión y el enunciado.
- **Navegador o terminal**: todas las páginas de alumno funcionan también con `curl`, en texto plano o JSON.
- **Inglés, español y catalán**, según el idioma del navegador.
- **Sin internet** y sin configurar nada a mano: el panel crea sus ficheros al arrancar por primera vez.

Teuton hace las pruebas; el panel solo lo dirige. Cualquier test de Teuton 3 funciona sin cambios.

## Cómo está organizada esta guía

- [Primeros pasos]({{ site.baseurl }}/getting-started/): instalar el panel y probar el reto de ejemplo.
- [Guía del profesor]({{ site.baseurl }}/teacher/): cada tarea del área del profesor, paso a paso.
- [Guía del alumno]({{ site.baseurl }}/students/): lo que hacen los alumnos, en el navegador y en un terminal.
- [Casos de uso]({{ site.baseurl }}/use-cases/): la lista completa de casos de uso y dónde se explica cada uno.
- [Preguntas frecuentes]({{ site.baseurl }}/faq/): problemas habituales y cómo resolverlos.
- [Desarrolladores]({{ site.baseurl }}/developers/): arquitectura, entorno de desarrollo, pruebas y traducciones.
