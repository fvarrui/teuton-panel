---
title: Preguntas frecuentes
nav_order: 6
lang: es
permalink: /faq/
---

# Preguntas frecuentes y problemas
{: .no_toc }

1. TOC
{:toc}

## Los alumnos no pueden abrir la dirección

- Comprueba que el cortafuegos del ordenador permite conexiones entrantes en el puerto del panel (4567 por defecto).
- Asegúrate de que los alumnos usan una de las direcciones del inicio del profesor. Si el ordenador tiene varios adaptadores de red, indica la buena en Ajustes → **Direcciones que se muestran a los alumnos**.
- Alumnos y profesor deben estar en la misma red.

## "teuton 3.x is required"

El panel necesita la gema `teuton` 3.x: `gem install teuton -v "~> 3.0"`.

## "No Teuton tests found"

La carpeta con la que arrancaste el panel no tiene ningún `start.rb`, ni en ella ni en sus subcarpetas. Crea un test con `teuton new CARPETA` o arranca el panel desde la carpeta correcta.

## Un alumno siempre saca 0 con un problema de conexión

Abre su estado de conexión (o el detalle del resultado): la máquina puede estar apagada, su IP puede estar mal (corrígela en Alumnos → Editar) o SSH puede rechazar el usuario o la contraseña.

## Una ejecución no muestra informes

Ábrela en **Histórico** para leer la salida de Teuton; ahí aparecen los errores de `start.rb` o `config.yaml`. **Tests → Ejecutar teuton check** también ayuda.

## ¿Puedo usar `tt_skip` o `teuton run --case`?

No con Teuton 3.0.0: los dos hacen fallar a Teuton ([teuton#44](https://github.com/teuton-software/teuton/issues/44)). Usa **Desactivar** en Alumnos o marca solo algunos alumnos en Ejecutar; el panel construye su propia configuración y nunca los usa. Evita también los valores que sean tablas (hash) en la sección `global:` de `config.yaml`.

## ¿Pueden los alumnos ver datos de otros alumnos o contraseñas?

No. Los alumnos solo ven nombres en la lista de registrados, y solo su propio código, nota y datos (con las contraseñas ocultas). Nunca se les muestran los informes de Teuton en bruto.

## ¿Dónde se guarda todo?

- `teuton-panel.yaml`: configuración del panel (carpeta base).
- `config.d/`: un fichero por alumno registrado (junto al `config.yaml` del test).
- `teuton-panel-params.yaml`: campos del alta (junto a `config.yaml`).
- `.teuton-panel/`: ejecuciones, resultados y sesiones archivadas (carpeta base).

## ¿Qué abre la dirección del panel sin ruta?

Depende de quién pregunte. En el ordenador del profesor (o desde una IP de profesor permitida), `http://<panel>:4567/` abre el área del profesor. El navegador de un alumno abre el inicio de alumnos, y `curl` imprime la ayuda en texto plano, igual que `/students.txt`.

## ¿Cómo empiezo una clase nueva?

**Sesiones → Archivar y empezar una sesión nueva**. No se borra nada; las sesiones anteriores se pueden abrir más tarde.
