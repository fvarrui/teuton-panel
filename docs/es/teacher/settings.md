---
title: Ajustes
parent: Guía del profesor
nav_order: 9
lang: es
permalink: /teacher/settings/
---

# Ajustes
{: .no_toc }

Caso de uso <span class="uc-id">T11</span>.
{: .fs-3 }

1. TOC
{:toc}

**Ajustes** cambia el comportamiento del panel; cada cambio se guarda al momento en `teuton-panel.yaml`.

{% include screenshot.html file="teacher-settings" alt="Página de ajustes" %}

## Qué pueden hacer los alumnos

| Opción | Cuando está activada |
| --- | --- |
| Registrarse | Los alumnos pueden registrarse y actualizar sus datos |
| Ver quién está registrado | El inicio de alumnos lista a los registrados (solo nombres) |
| Ejecutar su test | Los alumnos pueden ejecutar su propio case |
| Ver su nota | Los alumnos ven su última nota |
| Ver el resultado de cada objetivo | Los alumnos ven también qué objetivos han cumplido (sin comandos ni salidas) |
| Ver su histórico de notas | Los alumnos ven su nota en cada ejecución de la sesión |
| Ver el estado de su conexión | Los alumnos ven si el panel llegó a su máquina |
| Leer el enunciado | Los alumnos pueden leer el enunciado del test |

Una opción desactivada responde *Tu profesor no ha activado esta opción* y desaparece de los menús del alumno.

## Formatos que reciben los alumnos

Elige cualquier combinación de **Páginas web**, **Texto plano** (`.txt`, para `curl`) y **JSON** (`.json`). Una petición en un formato desactivado recibe un mensaje breve con los formatos disponibles. **Sin ningún formato** marcado, la zona de alumnos queda cerrada. Tu área no se ve afectada.

## Otras opciones

- **Segundos entre ejecuciones del mismo alumno**: cuánto espera un alumno antes de volver a ejecutar (30 por defecto; 0 para no limitar).
- **Idioma por defecto**: se usa cuando el navegador pide un idioma que el panel no tiene.
- **Ejecuciones de alumnos a la vez**: cuántas ejecuciones de alumnos pueden ir en paralelo (se aplica al reiniciar el panel).
- **Direcciones que se muestran a los alumnos**: déjalo vacío para mostrar todas las detectadas, o escribe la buena cuando el ordenador tiene adaptadores de más.
- **Otras IPs de profesor**: ordenadores que pueden abrir el área del profesor además de este, separados por comas.

## El fichero de configuración

La configuración está en `teuton-panel.yaml`, en la carpeta con la que arrancaste el panel. También puedes editarlo a mano con el panel parado:

```yaml
:server:
  :bind: 0.0.0.0
  :port: 4567
  :addresses: []           # direcciones que se muestran a los alumnos (vacío = detectadas)
:language: es
:teacher:
  :allow: []               # otras IPs de profesor
:test: linux-files-basics  # test activo
:run:
  :every: 60
  :times: 1
  :delay: 3
:runs:
  :max_parallel: 4
:student:
  :register: true
  :list: true
  :run: true
  :results: true
  :feedback: false
  :history: true
  :status: true
  :readme: true
  :formats: [html, txt, json]
  :run_interval: 30
:datadir: ".teuton-panel"
```
