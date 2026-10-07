---
title: Entorno de desarrollo
parent: Desarrolladores
nav_order: 2
lang: es
permalink: /developers/setup/
---

# Entorno de desarrollo
{: .no_toc }

1. TOC
{:toc}

## El panel

```bash
git clone https://github.com/fvarrui/teuton-panel
cd teuton-panel
bin/setup                     # bundle install
bundle exec rake              # tests + Standard
ruby teuton-panel up CARPETA  # lanzador de desarrollo (carga la gema debug)
```

La gema es Ruby puro y sus dependencias no necesitan compilador de C, así que se instala en Windows con RubyInstaller sin MSYS2.

| Orden | Para qué |
| --- | --- |
| `bundle exec rake` | Tests y lint |
| `bundle exec rake usecases` | Todos los casos de uso contra el ejemplo (unos minutos) |
| `bundle exec rake docs:screenshots` | Repetir las capturas de la documentación (necesita Chrome o Edge) |
| `bundle exec rake standard:fix` | Corregir avisos de estilo |
| `gem build teuton-panel.gemspec` | Construir la gema |

## Datos de prueba

- **Sandbox** (`.claude/skills/teuton-sandbox/scripts/create_sandbox.rb`): un test mínimo en localhost con cuatro alumnos en `tmp/sandbox`.
- **Reto de ejemplo** (`samples/linux-files-basics`): siete alumnos con trabajo real en `homes/` y un histórico inventado. Ejecuta `ruby samples/linux-files-basics/reset.rb` para crear o reiniciar su estado de demo.

Los dos ejecutan Teuton en `localhost`, así que no hacen falta máquinas de alumnos.

## Esta documentación

La documentación es una web Jekyll en `docs/` (tema [Just the Docs](https://just-the-docs.com/), idiomas con [jekyll-polyglot](https://github.com/untra/polyglot)). Tiene su propio `docs/Gemfile`, porque Jekyll necesita gemas con extensiones en C que RubyInstaller no compila sin MSYS2.

Constrúyela en Linux o macOS:

```bash
cd docs
bundle install
bundle exec jekyll serve
```

En Windows, con Docker:

```bash
docker run --rm -p 4000:4000 -v "${PWD}/docs:/site" -w /site ruby:3.3 \
  bash -c "bundle install && bundle exec jekyll serve --host 0.0.0.0"
```

Después abre `http://localhost:4000/teuton-panel/`. GitHub Actions construye y publica la web al subir una etiqueta de versión (`v*`), así que siempre documenta la última versión publicada (`.github/workflows/docs.yml`). Para publicar una corrección entre versiones, lanza a mano el workflow *Documentation* desde la pestaña Actions o con `gh workflow run docs.yml`.

Las páginas están en `docs/en/`, `docs/es/` y `docs/ca/`; una misma página tiene la misma `permalink` en todos los idiomas. Las capturas están en `docs/assets/images/<idioma>/` y se incluyen así:

```liquid
{% raw %}{% include screenshot.html file="teacher-home" alt="Inicio del profesor" %}{% endraw %}
```
