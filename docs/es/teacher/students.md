---
title: Alumnos
parent: Guía del profesor
nav_order: 4
lang: es
permalink: /teacher/students/
---

# Gestionar alumnos

Caso de uso <span class="uc-id">T4</span>.
{: .fs-3 }

**Alumnos** lista a todos los registrados en el test activo y se actualiza cada 15 segundos: nombre, código personal, IP desde la que se registró, hora, última nota y estado.

{% include screenshot.html file="teacher-students" alt="Página de alumnos" %}

Los códigos personales solo se muestran aquí. Si un alumno olvida su código, búscalo y díselo.

## Editar a un alumno

**Editar** abre todos los valores del case del alumno. Guarda para corregir una IP equivocada, una errata en el nombre o cualquier otro valor; la siguiente ejecución usa los valores nuevos.

{% include screenshot.html file="teacher-student-edit" alt="Editar a un alumno" %}

A los valores que cambias se les aplican las mismas reglas que en el alta (letras, números, espacios y `. _ - @ : /`), y los campos de máquina que escriben los alumnos no pueden apuntar al ordenador del panel. Los valores que dejas como estaban siempre se aceptan.

## Desactivar o activar

**Desactivar** pausa a un alumno (por ejemplo, porque hoy no ha venido):

- queda fuera de todas las ejecuciones, tuyas o suyas;
- conserva su última nota, que aparece como *Desactivado*;
- puede seguir abriendo su página y sus resultados, pero no se le ofrece **Ejecutar mi test**.

**Activar** lo devuelve a la clase.

## Borrar

**Borrar** elimina el registro (el fichero del alumno en `config.d/`). Su código deja de funcionar; puede volver a registrarse.

## Cases sin código

También aparecen los cases escritos a mano:

- **En `config.yaml` (`cases:`)**: se evalúan con la clase, pero los alumnos no pueden usarlos desde su área.
- **Ficheros de `config.d/` sin código**: **Dar un código** los convierte en registros normales, para que el alumno pueda usar su página personal.
