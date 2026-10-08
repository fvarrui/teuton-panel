---
title: Traduccions
parent: Desenvolupadors
nav_order: 4
lang: ca
permalink: /developers/translations/
---

# Traduccions
{: .no_toc }

1. TOC
{:toc}

## El panell

Tots els textos que mostra el panell (pàgines web, respostes `.txt` i missatges JSON) surten de `lib/teuton/panel/locales/<idioma>.yml`: `en.yml`, `es.yml` i `ca.yml`. El codi fa servir claus, mai text literal:

```erb
<h1><%= h t("students.home.title") %></h1>
```

L'idioma de cada petició surt de `?lang=` (que es recorda en una galeta), després de l'`Accept-Language` del navegador i, finalment, de l'idioma per defecte de Configuració.

Per afegir un idioma:

1. Copia `en.yml` com a `<codi>.yml` i tradueix tots els valors (mantén les claus i els marcadors `%{nom}`).
2. Afegeix el codi a `Lang::LANGS` i a `Lang::READMES` (l'idioma que ha de fer servir `teuton readme`: Teuton escriu els enunciats en `en` i `es`).
3. Afegeix una entrada `langs.<codi>` a cada fitxer d'idioma i l'enllaç del selector a `views/layout.erb`.
4. Executa `bundle exec rake`: `lang_test.rb` falla si a algun idioma li falta una clau.

Fes servir les mateixes paraules a tot arreu: els termes de la interfície per idioma (case → alumne, objectiu, execució, passada, enunciat, estats de la nota) són a `.minispec/core/glossary.md`.

## Aquesta documentació

Les pàgines són a `docs/<idioma>/`, amb `lang:` i la mateixa `permalink` en tots els idiomes. Els títols de navegació (`title`, `parent`) es tradueixen, així que `parent` ha de coincidir amb el títol del pare en el mateix idioma. Una pàgina que falta en un idioma es mostra en anglès. Afegeix l'idioma a `languages:` a `docs/_config.yml` i repeteix les captures amb `bundle exec rake docs:screenshots` després d'afegir-lo a `LANGS` a `docs/_scripts/screenshots.rb`.

La cerca funciona per idioma: `docs/zzzz-search-data.json` genera un índex per idioma (`/search-data.json`, `/es/search-data.json`, `/ca/search-data.json`; es diu `zzzz-` perquè es processi després de les pàgines), i `docs/assets/js/just-the-docs.js` (una còpia de l'script del tema, amb els canvis marcats `teuton-panel:`) carrega l'índex de l'idioma de la pàgina i treu l'algorisme d'arrels de l'anglès en castellà i català. En actualitzar Just the Docs, compara aquesta còpia amb l'script nou del tema.
