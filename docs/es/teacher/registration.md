---
title: Campos del alta
parent: Guía del profesor
nav_order: 3
lang: es
permalink: /teacher/registration/
---

# Campos del alta

Caso de uso <span class="uc-id">T3</span>.
{: .fs-3 }

**Alta** decide qué rellenan los alumnos al registrarse. Cada fila es un valor del case del alumno en Teuton (las claves que tu `start.rb` lee con `get(...)` y la configuración de las máquinas) y la forma de obtenerlo.

{% include screenshot.html file="teacher-registration" alt="Editor de los campos del alta" %}

| Modo | Qué pasa |
| --- | --- |
| **Preguntar como nombre** (`AS NAME`) | Se pregunta al alumno con la etiqueta "Tu nombre". Úsalo para `tt_members`. |
| **Preguntar como correo** (`AS EMAIL`) | Se pregunta y se comprueba que sea un correo. Úsalo para `tt_moodle_id` y tendrás `moodle.csv`. |
| **Preguntar** (`ASK`) | Se pregunta como texto libre. |
| **Automático: IP del alumno** (`AUTO IP`) | No se pregunta: la IP de la máquina desde la que se registra el alumno. |
| **Valor fijo** | No se pregunta: el mismo valor para todos (por ejemplo, un usuario común o `localhost`). |

- Para añadir un campo, rellena la última fila vacía y pulsa **Guardar**.
- Para quitar uno, marca **Quitar** y pulsa **Guardar**.
- **Proponer desde teuton config** sustituye los campos por una propuesta hecha a partir de tu test: todos los valores que necesita, `tt_members` como nombre, `tt_moodle_id` como correo y las IPs de las máquinas como automáticas.

Los campos se guardan en `teuton-panel-params.yaml`, junto al `config.yaml` del test, así que viajan con él.

{: .warning }
`AUTO IP` solo acierta si los alumnos se registran desde la máquina que se va a evaluar. Si se registran desde otro ordenador (por ejemplo, el navegador del anfitrión cuando la máquina evaluada es una VM), haz que el campo sea **Preguntar**, o corrige la IP en [Alumnos]({{ site.baseurl }}/teacher/students/).

## Qué pueden escribir los alumnos

Para proteger los comandos que ejecuta tu test, los valores escritos solo admiten letras (con tildes), números, espacios y `. _ - @ : /`, hasta 100 caracteres. Las contraseñas solo tienen el límite de longitud. Los campos de máquina nunca aceptan las direcciones del propio panel, así que un alumno no puede apuntar Teuton a tu ordenador.

{: .important }
Los valores escritos acaban dentro de los comandos de tu test (`run "... #{get(:home)} ..."`). Si una máquina de tu test es `localhost`, esos comandos se ejecutan en **tu** ordenador: comprueba los valores escritos en `start.rb` antes de usarlos, como hace el ejemplo con `home_dir`.
