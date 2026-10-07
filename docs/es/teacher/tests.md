---
title: Tests
parent: Guía del profesor
nav_order: 2
lang: es
permalink: /teacher/tests/
---

# Elegir y revisar el test

Caso de uso <span class="uc-id">T2</span>.
{: .fs-3 }

**Tests** muestra todos los tests de Teuton encontrados en la carpeta con la que arrancaste el panel: nombre, ruta, cases fijos de `config.yaml` y alumnos registrados.

{% include screenshot.html file="teacher-tests" alt="Página de tests con la salida de teuton check" %}

## Activar un test

Pulsa **Activar** junto a un test. El panel pide confirmación, porque cambiar de test:

- para cualquier ejecución en marcha;
- hace que el alta, las ejecuciones y los resultados pasen a referirse al nuevo test.

Al activar un test, el panel lo prepara para el alta:

- añade `tt_include: config.d` a `config.yaml` como texto, conservando tus comentarios (o crea `config.yaml` si no existe);
- crea la carpeta `config.d/`, donde cada alumno registrado tiene un fichero;
- propone los campos del alta a partir de `teuton config` si el test aún no tiene `teuton-panel-params.yaml`.

{: .note }
Los alumnos registrados en un test pertenecen a ese test: al activar otro, sus códigos dejan de funcionar hasta que vuelvas al primero.

## Revisar un test

Pulsa **Ejecutar teuton check** para ver el informe del propio Teuton sobre `start.rb` y `config.yaml`: grupos, objetivos, máquinas y parámetros. Hazlo antes de la clase para detectar errores en el test.
