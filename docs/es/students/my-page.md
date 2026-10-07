---
title: Mi página
parent: Guía del alumno
nav_order: 2
lang: es
permalink: /students/my-page/
---

# Mi página: ejecución, resultados, histórico y conexión
{: .no_toc }

Casos de uso <span class="uc-id">S3</span> abrir tu página, <span class="uc-id">S4</span> ejecutar tu test, <span class="uc-id">S5</span> ver tus resultados, <span class="uc-id">S6</span> ver tu histórico, <span class="uc-id">S7</span> comprobar tu conexión.
{: .fs-3 }

1. TOC
{:toc}

## Abrir tu página

En el inicio de alumnos, escribe tu código en **¿Ya estás registrado?** y pulsa **Abrir mi página**, o ve a `/students/<código>`. Después, el navegador recuerda tu código: usa **Mi página** en el menú para volver. En un ordenador compartido, pulsa **¿No eres tú?** junto a tu código para que la siguiente persona no vea tu página.

{% include screenshot.html file="students-personal" alt="Página personal" %}

Tu página muestra tu última nota, enlaces a tu histórico, al estado de tu conexión y al enunciado, la orden `curl` de tu página y tus datos de registro.

## Ejecutar tu test

Pulsa **Ejecutar mi test**. El panel evalúa solo tu máquina; mientras trabaja, la página lo indica y se actualiza sola hasta que llega el resultado (puede tardar unos segundos). Recargar la página nunca lanza otra ejecución.

{% include screenshot.html file="students-run" alt="Resultado de la ejecución de un alumno" %}

A veces la ejecución no empieza, y la página te dice por qué:

| Mensaje | Por qué |
| --- | --- |
| *Espera N segundos antes de volver a ejecutar* | Ejecutaste hace un momento; tu profesor fija el intervalo mínimo. |
| *El profesor está evaluando a toda la clase: se te evaluará en la próxima pasada a las HH:MM* | Tu profesor está ejecutando la clase periódicamente; no hace falta que ejecutes tú. |
| *Tu test ya se está ejecutando* / *está en cola* | Tu petición anterior aún no ha terminado; consulta tus resultados en un momento. |
| *Tu profesor ha pausado tu evaluación por ahora* | Tu profesor te ha desactivado (por ejemplo, porque faltaste). |

{% include screenshot.html file="students-run-next-pass" alt="Petición de ejecución durante la ejecución periódica del profesor" %}

## Tus resultados

**Mis resultados** muestra tu última nota y cuándo se evaluó. Si tu profesor lo ha activado, ves también cada objetivo del test con una marca, para saber qué te falta. **Ejecutar de nuevo** lanza una ejecución nueva desde aquí (o te dice cuántos segundos te quedan por esperar):

{% include screenshot.html file="students-results" alt="Resultados del alumno con cada objetivo" %}

Si tu nota es 0 porque se encontró la misma respuesta en la máquina de otro alumno, la página lo dice.

## Tu histórico

**Mi histórico de notas** lista tu nota en cada ejecución de la sesión, de la más reciente a la más antigua, incluidas las que lanzó tu profesor:

{% include screenshot.html file="students-history" alt="Histórico de notas" %}

## Tu conexión

**Estado de la conexión** te dice si el panel llegó a tu máquina en la última ejecución:

{% include screenshot.html file="students-status" alt="Estado de la conexión" %}

Si no pudo, comprueba que tu máquina está encendida, que su IP es correcta y que SSH acepta tu usuario y contraseña, y vuelve a ejecutar.

## Cuando tu profesor te pausa

Si tu profesor te desactiva, tu página lo dice y desaparece **Ejecutar mi test**; puedes seguir viendo tus resultados y tu histórico.

{% include screenshot.html file="students-disabled" alt="Página personal de un alumno desactivado" %}
