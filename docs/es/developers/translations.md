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

## Esta documentación

Las páginas están en `docs/<idioma>/`, con `lang:` y la misma `permalink` en todos los idiomas. Los títulos de navegación (`title`, `parent`) se traducen, así que `parent` debe coincidir con el título del padre en el mismo idioma. Una página que falta en un idioma se muestra en inglés. Añade el idioma a `languages:` en `docs/_config.yml` y repite las capturas con `bundle exec rake docs:screenshots` después de añadirlo a `LANGS` en `docs/_scripts/screenshots.rb`.
