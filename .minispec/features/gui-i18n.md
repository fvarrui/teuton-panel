# GUI i18n

## Goal

Every text the panel shows (HTML and plain-text answers) is available in English and Spanish, chosen per request.

## Context

- The audience is mostly Spanish-speaking, but the repo is in English and the panel should serve other teachers too.
- The only page today hard-codes Spanish (`App#/`).
- `teuton readme` supports `--lang=en|es`, the same two languages.

## Changes

- Locale files `lib/teuton/panel/locales/en.yml` and `es.yml`.
- A small `t(key, **vars)` helper available in routes and views; missing keys fall back to English and are logged.
- Language per request: best match of `Accept-Language` among `en`/`es`; otherwise the panel config's `:language:` (default `es`).
- Optional `?lang=xx` override, remembered in a cookie for browsers.
- Pass the chosen language to `teuton readme --lang`.
- A test that fails if `en.yml` and `es.yml` have different keys.

## Acceptance

- A browser set to English sees the panel in English; one set to Spanish sees Spanish.
- `curl` without `Accept-Language` gets the panel config's language.
- No user-facing string is hard-coded in routes or views.
