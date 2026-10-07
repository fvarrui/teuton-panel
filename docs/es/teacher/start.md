---
title: Arrancar el panel
parent: Guía del profesor
nav_order: 1
lang: es
permalink: /teacher/start/
---

# Arrancar el panel
{: .no_toc }

Casos de uso <span class="uc-id">T1</span> arrancar el panel y ver dónde se conectan los alumnos, <span class="uc-id">T12</span> abrir el área del profesor desde otro ordenador.
{: .fs-3 }

1. TOC
{:toc}

## Arrancarlo

```bash
teuton-panel up RUTA/A/LOS/TESTS
```

La primera vez, el panel:

- comprueba que Teuton 3 está instalado (si no, te dice cómo instalarlo y se detiene);
- busca todos los tests de Teuton de la carpeta (carpetas con un `start.rb`) y se detiene si no hay ninguno;
- crea `teuton-panel.yaml` con la configuración por defecto;
- activa el test automáticamente cuando solo hay uno: añade `tt_include: config.d` a su `config.yaml` y propone los campos del alta.

Si hay varios tests, elige uno en [Tests]({{ site.baseurl }}/teacher/tests/).

## La sala de control

Abre `http://localhost:4567/teacher` (o simplemente `http://localhost:4567/`: en tu ordenador, la dirección del panel te lleva al área del profesor). La página de inicio muestra:

- el test activo, con botones para **Ejecutar** y para abrir el **Modo proyector**;
- el **resumen de la clase**: nota media, cuántos han aprobado (50 o más), cuántos lo tienen completo (100) y cuántos no se han evaluado todavía; enlaza con Resultados;
- cuántos alumnos hay registrados y cuántos se han evaluado;
- si hay una ejecución en marcha, la última ejecución y la cola de ejecuciones de alumnos;
- **dónde se conectan los alumnos**: una dirección por interfaz de red, con la orden `curl` para alumnos sin navegador, y un recordatorio cuando los alumnos pueden ver quién está registrado.

{% include screenshot.html file="teacher-home" alt="Página de inicio del profesor" %}

{: .tip }
Si tu ordenador tiene adaptadores de red de más (VirtualBox, Docker…), los alumnos pueden ver direcciones que no les sirven. Indica la buena en [Ajustes]({{ site.baseurl }}/teacher/settings/) → **Direcciones que se muestran a los alumnos**.

Cuando todavía no hay test activo, la página de inicio te pide que elijas uno, y las páginas que necesitan un test (Alumnos, Ejecutar, Resultados…) muestran un enlace a **Tests**.

## Idioma

El panel sigue el idioma de tu navegador (inglés, español o catalán). Cámbialo con los enlaces **EN · ES · CA** de la barra superior; la elección se recuerda. El idioma por defecto para navegadores que piden otro se fija en Ajustes.

## Abrir el área del profesor desde otro ordenador

El área del profesor solo responde al ordenador donde corre el panel (`localhost` o sus propias direcciones). Cualquier otro recibe *403 Esta zona solo está disponible en el ordenador del profesor*. Si arrancas el panel en un servidor y lo manejas desde tu portátil:

- añade la IP de tu portátil en [Ajustes]({{ site.baseurl }}/teacher/settings/) → **Otras IPs de profesor**; o
- usa un túnel SSH: `ssh -L 4567:localhost:4567 servidor` y abre `http://localhost:4567/teacher` en tu portátil.

## Pararlo

Pulsa `Ctrl+C` en el terminal. Se paran los procesos de Teuton en marcha; los registros, los resultados y el histórico quedan en disco para el siguiente arranque. Una ejecución periódica no se reanuda sola tras reiniciar: la página Ejecutar muestra los últimos ajustes listos para volver a empezar.
