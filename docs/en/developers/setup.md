---
title: Development setup
parent: Developers
nav_order: 2
lang: en
permalink: /developers/setup/
---

# Development setup
{: .no_toc }

1. TOC
{:toc}

## The panel

```bash
git clone https://github.com/fvarrui/teuton-panel
cd teuton-panel
bin/setup                       # bundle install
bundle exec rake                # tests + Standard
ruby teuton-panel up DIRECTORY  # development launcher (loads the debug gem)
```

The gem is pure Ruby and its dependencies need no C compiler, so it installs on Windows with RubyInstaller without MSYS2.

| Command | Purpose |
| --- | --- |
| `bundle exec rake` | Tests and lint |
| `bundle exec rake usecases` | Every use case against the sample (a few minutes) |
| `bundle exec rake docs:screenshots` | Retake the documentation screenshots (needs Chrome or Edge) |
| `bundle exec rake standard:fix` | Fix lint offenses |
| `gem build teuton-panel.gemspec` | Build the gem |

## Test data

- **Sandbox** (`.claude/skills/teuton-sandbox/scripts/create_sandbox.rb`): a minimal localhost test with four students in `tmp/sandbox`.
- **Sample challenge** (`samples/linux-files-basics`): seven students with real work in `homes/` and an invented history. Run `ruby samples/linux-files-basics/reset.rb` to create or reset its demo state.

Both run Teuton on `localhost`, so no student machines are needed.

## This documentation

The documentation is a Jekyll site in `docs/` (theme [Just the Docs](https://just-the-docs.com/), languages with [jekyll-polyglot](https://github.com/untra/polyglot)). It has its own `docs/Gemfile`, because Jekyll needs gems with C extensions that RubyInstaller cannot build without MSYS2.

Build it on Linux or macOS:

```bash
cd docs
bundle install
bundle exec jekyll serve
```

On Windows, use Docker:

```bash
docker run --rm -p 4000:4000 -v "${PWD}/docs:/site" -w /site ruby:3.3 \
  bash -c "bundle install && bundle exec jekyll serve --host 0.0.0.0"
```

Then open `http://localhost:4000/teuton-panel/`. GitHub Actions builds and publishes the site when a version tag (`v*`) is pushed, so it always documents the latest release (`.github/workflows/docs.yml`). To publish a fix between releases, run the *Documentation* workflow by hand from the Actions tab or with `gh workflow run docs.yml`.

Pages live in `docs/en/`, `docs/es/` and `docs/ca/`; the same page has the same `permalink` in every language. Screenshots are in `docs/assets/images/<lang>/` and are included with:

```liquid
{% raw %}{% include screenshot.html file="teacher-home" alt="Teacher home" %}{% endraw %}
```
