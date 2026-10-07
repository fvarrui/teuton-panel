---
title: Desde un terminal
parent: Guía del alumno
nav_order: 4
lang: es
permalink: /students/terminal/
---

# Usar el panel desde un terminal
{: .no_toc }

Caso de uso <span class="uc-id">S10</span>.
{: .fs-3 }

1. TOC
{:toc}

¿Sin navegador? Todas las páginas de alumno existen también en texto plano: añade `.txt` a la dirección. Empieza por la ayuda (`curl http://192.168.1.10:4567/` sin ruta también la imprime):

```bash
curl "http://192.168.1.10:4567/students.txt?lang=es"
```

```
Teuton Panel - Test de hoy: linux-files-basics

Órdenes (cambia CODE por tu código personal):
  Registrarte:
    curl "http://192.168.1.10:4567/students/register.txt?tt_members=...&tt_moodle_id=...&home=..."
  Tu página:
    curl http://192.168.1.10:4567/students/CODE.txt
  Ejecutar tu test:
    curl http://192.168.1.10:4567/students/CODE/run.txt
  Tus resultados:
    curl http://192.168.1.10:4567/students/CODE/results.txt
  ...
```

## Registrarse

Pon todos los campos en la dirección, entre comillas por los `&`:

```bash
curl "http://192.168.1.10:4567/students/register.txt?tt_members=Ana%20Garcia&tt_moodle_id=ana@example.com&home=ana&lang=es"
```

```
Tu código personal es A2KP
Guarda este código: lo necesitas para ejecutar el test y ver tus resultados.

Tu página: http://192.168.1.10:4567/students/A2KP
Ejecutar tu test:
  curl http://192.168.1.10:4567/students/A2KP/run.txt
```

Escribe los espacios como `%20`. Si algún campo está mal, recibes la lista de errores.

## Ejecución, resultados, histórico y estado

```bash
curl "http://192.168.1.10:4567/students/A2KP/run.txt?lang=es"
```

```
Tu ejecución ha terminado. Estos son tus resultados:
Nota: 100/100
  [OK] Directory docs exists
  [OK] File docs/notes.txt exists
  ...
```

| Orden | Qué obtienes |
| --- | --- |
| `curl .../students/CODE.txt` | Tu nombre, código, datos y última nota |
| `curl .../students/CODE/run.txt` | Ejecuta tu test e imprime la nota |
| `curl .../students/CODE/results.txt` | Tu última nota y, si está activado, cada objetivo |
| `curl .../students/CODE/history.txt` | Tu nota en cada ejecución |
| `curl .../students/CODE/status.txt` | Si el panel llegó a tu máquina |
| `curl .../students/readme.md` | El enunciado, en Markdown |

## JSON

Cambia `.txt` por `.json` para obtener datos para scripts:

```bash
curl http://192.168.1.10:4567/students/A2KP/results.json
```

```json
{
  "code": "A2KP",
  "result": {
    "grade": 100.0,
    "finished_at": "2026-10-07 09:40:00 +0100",
    "unique_fault": false,
    "connection": "ok"
  }
}
```

## Idioma

Las respuestas en texto usan el idioma por defecto del panel. Añade `?lang=en`, `?lang=es` o `?lang=ca` para elegirlo:

```bash
curl "http://192.168.1.10:4567/students/A2KP/results.txt?lang=ca"
```

{: .note }
Tu profesor puede desactivar algunos formatos. Sin sufijo siempre recibes la página web (HTML), que se lee mal en un terminal: acuérdate del `.txt`.
