---
title: Traducciones
parent: Desarrolladores
nav_order: 4
lang: es
permalink: /developers/translations/
---

# Traducciones
{: .no_toc }

1. TOC
{:toc}

## El panel

Todos los textos que muestra el panel (páginas web, respuestas `.txt` y mensajes JSON) salen de `lib/teuton/panel/locales/<idioma>.yml`: `en.yml`, `es.yml` y `ca.yml`. El código usa claves, nunca texto literal:

```erb
<h1><%= h t("students.home.title") %></h1>
```

El idioma de cada petición sale de `?lang=` (que se recuerda en una cookie), después del `Accept-Language` del navegador y, por último, del idioma por defecto de Ajustes.

Para añadir un idioma:

1. Copia `en.yml` como `<código>.yml` y traduce todos los valores (mantén las claves y los marcadores `%{nombre}`).
2. Añade el código a `Lang::LANGS` y a `Lang::READMES` (el idioma que debe usar `teuton readme`: Teuton escribe los enunciados en `en` y `es`).
3. Añade una entrada `langs.<código>` a cada fichero de idioma y el enlace del selector en `views/layout.erb`.
4. Ejecuta `bundle exec rake`: `lang_test.rb` falla si a algún idioma le falta una clave.

Usa las mismas palabras en todas partes: los términos de la interfaz en cada idioma (case → alumno, target → objetivo, run → ejecución, pass → pasada, statement → enunciado, estados de la nota) están en `.minispec/core/glossary.md`.

## Esta documentación

Las páginas están en `docs/<idioma>/`, con `lang:` y la misma `permalink` en todos los idiomas. Los títulos de navegación (`title`, `parent`) se traducen, así que `parent` debe coincidir con el título del padre en el mismo idioma. Una página que falta en un idioma se muestra en inglés. Añade el idioma a `languages:` en `docs/_config.yml` y repite las capturas con `bundle exec rake docs:screenshots` después de añadirlo a `LANGS` en `docs/_scripts/screenshots.rb`.

La búsqueda funciona por idioma: `docs/zzzz-search-data.json` genera un índice por idioma (`/search-data.json`, `/es/search-data.json`, `/ca/search-data.json`; se llama `zzzz-` para que se procese después de las páginas), y `docs/assets/js/just-the-docs.js` (una copia del script del tema, con los cambios marcados `teuton-panel:`) carga el índice del idioma de la página y quita el algoritmo de raíces del inglés en castellano y catalán. Al actualizar Just the Docs, compara esa copia con el script nuevo del tema.
