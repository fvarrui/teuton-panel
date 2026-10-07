---
title: Developers
nav_order: 7
has_children: true
lang: en
permalink: /developers/
---

# Developers

teuton-panel is a small Ruby gem: a Thor CLI and a Sinatra application served by WEBrick, which drives the `teuton` command and reads its JSON reports. Everything is plain Ruby: no database, no JavaScript build, no compiler needed.

- [Architecture]({{ site.baseurl }}/developers/architecture/): how the pieces fit together.
- [Development setup]({{ site.baseurl }}/developers/setup/): run it from the source code, the sample and this documentation.
- [Testing]({{ site.baseurl }}/developers/testing/): unit and web tests, the use-case run and the screenshots.
- [Translations]({{ site.baseurl }}/developers/translations/): the GUI and documentation languages.
- [Contributing]({{ site.baseurl }}/developers/contributing/): code style, specs and pull requests.
- [Design notes]({{ site.baseurl }}/developers/notes/): the original notes that started the project.

Design decisions and specs live in the repository's `.minispec/` directory (`core/` for permanent knowledge, `decisions/` for ADRs).
