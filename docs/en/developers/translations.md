---
title: Translations
parent: Developers
nav_order: 4
lang: en
permalink: /developers/translations/
---

# Translations
{: .no_toc }

1. TOC
{:toc}

## The panel

Every text the panel shows (web pages, `.txt` answers and JSON messages) comes from `lib/teuton/panel/locales/<lang>.yml`: `en.yml`, `es.yml` and `ca.yml`. Code uses keys, never literal text:

```erb
<h1><%= h t("students.home.title") %></h1>
```

The language of each request comes from `?lang=` (remembered in a cookie), then the browser's `Accept-Language`, then the default language in Settings.

To add a language:

1. Copy `en.yml` to `<code>.yml` and translate every value (keep the keys and the `%{name}` placeholders).
2. Add the code to `Lang::LANGS` and to `Lang::READMES` (the language `teuton readme` should use: Teuton writes statements in `en` and `es`).
3. Add a `langs.<code>` entry to every locale file and the switch link in `views/layout.erb`.
4. Run `bundle exec rake`: `lang_test.rb` fails if any language misses a key.

Use the same words everywhere: the GUI terms per language (case → student, target, run, pass, statement, grade states) are listed in `.minispec/core/glossary.md`.

## This documentation

Pages live in `docs/<lang>/`, with `lang:` and the same `permalink` in every language. Navigation titles (`title`, `parent`) are translated, so `parent` must match the parent's title in the same language. A page missing in a language falls back to English. Add a language to `languages:` in `docs/_config.yml` and retake the screenshots with `bundle exec rake docs:screenshots` after adding it to `LANGS` in `docs/_scripts/screenshots.rb`.
