---
title: Entorn de desenvolupament
parent: Desenvolupadors
nav_order: 2
lang: ca
permalink: /developers/setup/
---

# Entorn de desenvolupament
{: .no_toc }

1. TOC
{:toc}

## El panell

```bash
git clone https://github.com/fvarrui/teuton-panel
cd teuton-panel
bin/setup                     # bundle install
bundle exec rake              # tests + Standard
ruby teuton-panel up CARPETA  # llançador de desenvolupament (carrega la gemma debug)
```

La gemma és Ruby pur i les seves dependències no necessiten compilador de C, així que s'instal·la a Windows amb RubyInstaller sense MSYS2.

| Ordre | Per a què |
| --- | --- |
| `bundle exec rake` | Tests i lint |
| `bundle exec rake usecases` | Tots els casos d'ús contra l'exemple (uns minuts) |
| `bundle exec rake docs:screenshots` | Repetir les captures de la documentació (necessita Chrome o Edge) |
| `bundle exec rake standard:fix` | Corregir avisos d'estil |
| `gem build teuton-panel.gemspec` | Construir la gemma |

## Dades de prova

- **Sandbox** (`.claude/skills/teuton-sandbox/scripts/create_sandbox.rb`): un test mínim a localhost amb quatre alumnes a `tmp/sandbox`.
- **Repte d'exemple** (`samples/linux-files-basics`): set alumnes amb feina real a `homes/` i un històric inventat. Executa `ruby samples/linux-files-basics/reset.rb` per crear o reiniciar el seu estat de demo.

Tots dos executen Teuton a `localhost`, així que no calen màquines d'alumnes.

## Aquesta documentació

La documentació és un web Jekyll a `docs/` (tema [Just the Docs](https://just-the-docs.com/), idiomes amb [jekyll-polyglot](https://github.com/untra/polyglot)). Té el seu propi `docs/Gemfile`, perquè Jekyll necessita gemmes amb extensions en C que RubyInstaller no compila sense MSYS2.

Construeix-la a Linux o macOS:

```bash
cd docs
bundle install
bundle exec jekyll serve
```

A Windows, amb Docker:

```bash
docker run --rm -p 4000:4000 -v "${PWD}/docs:/site" -w /site ruby:3.3 \
  bash -c "bundle install && bundle exec jekyll serve --host 0.0.0.0"
```

Després obre `http://localhost:4000/teuton-panel/`. GitHub Actions construeix i publica el web en pujar una etiqueta de versió (`v*`), de manera que sempre documenta la darrera versió publicada (`.github/workflows/docs.yml`). Per publicar una correcció entre versions, llança a mà el workflow *Documentation* des de la pestanya Actions o amb `gh workflow run docs.yml`.

Les pàgines són a `docs/en/`, `docs/es/` i `docs/ca/`; una mateixa pàgina té la mateixa `permalink` en tots els idiomes. Les captures són a `docs/assets/images/<idioma>/` i s'inclouen així:

```liquid
{% raw %}{% include screenshot.html file="teacher-home" alt="Inici del professor" %}{% endraw %}
```
