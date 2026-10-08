# Documentation search only finds English pages

## Problem

- On the documentation site, the search box finds English pages only, also on `/es/` and `/ca/`: searching "ejecución" or "execució" finds nothing, and results always link to English pages.
- The built index `_site/assets/js/search-data.json` has 126 entries, none of them under `/es/` or `/ca/`.

## Cause

- Just the Docs builds its search index from `assets/js/search-data.json` (a Liquid template in the theme) and `assets/js/just-the-docs.js` fetches `{{ "assets/js/search-data.json" | relative_url }}`.
- `docs/_config.yml` has `exclude_from_localization: ["assets"]` (images and fonts are shared by every language). jekyll-polyglot adds those paths to `exclude` for the non-default languages, so both files are built only in the English pass: the index holds English pages, and every language fetches that one file.
- The theme's lunr pipeline uses the English stemmer and stop words, which would also spoil Spanish and Catalan results once their pages are indexed.

## Solution

- Keep `exclude_from_localization: ["assets"]` for images and fonts.
- Build one index per language outside `assets/`: a page `docs/search-data.json` (adapted from the theme's `zzzz-search-data.json`) with a permalink outside `assets/` (for example `/search-data.json`) that only lists pages whose `lang` is `site.active_lang`. Polyglot then writes `/search-data.json`, `/es/search-data.json` and `/ca/search-data.json`.
- Make the search fetch the index of the page's language: override the theme's `assets/js/just-the-docs.js` in `docs/` so `initSearch` takes the language from the page (`/es/`, `/ca/` prefix after the base URL, or `<html lang>` if the layout sets it per language) and requests `<baseurl>/<lang>/search-data.json` (no prefix for English). Keep the rest of the file as in the theme (Just the Docs 0.12).
- Result links must stay in the page's language: check the `url` values in each index (polyglot may or may not relativize them in JSON); add the language prefix in the template if needed.
- For `es` and `ca`, remove the English stemmer and stop-word filter from the lunr pipeline through the theme's hook `_includes/lunr/custom-index.js` (Spanish and Catalan words then match by prefix, which the search already does with its trailing wildcard).
- Note the solution in `docs/en|es|ca/developers/translations.md` ("This documentation") and in `.minispec/core/architecture.md` (docs line).

## Verification

- After `jekyll build`, `_site/search-data.json`, `_site/es/search-data.json` and `_site/ca/search-data.json` exist, and each one only holds pages of its language.
- On `/es/`, searching "ejecución" lists Spanish pages and every result opens a `/es/` page; on `/ca/`, "execució" lists Catalan pages; on `/`, "run" lists English pages.
- Searching a word that only exists in another language returns nothing (no mixed results).
- Checked in a headless browser against the local build (`tmp/serve_docs.rb`), then on GitHub Pages after publishing.
